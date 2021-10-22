//
//  Setting1ViewController.m
//  UHFSample
//
//  Created by Gianni on 2019/4/12.
//  Copyright © 2019 Gianni. All rights reserved.
//

#import "MBProgressHUD.h"
#import "Setting1ViewController.h"
#import "DevDetailTabBarViewController.h"
#import "DevConnStatusViewController.h"

#import <UHFSDK/TS100.h>

@interface Setting1ViewController ()<UIPickerViewDelegate,UIPickerViewDataSource, IUHFDeviceListener, UITextFieldDelegate>
{
    NSArray *_pickDataTrigger;
    NSArray *_pickDataTargetA;
    NSArray *_pickDataSession;
    NSArray *_pickDataTargetSL;
    NSArray *_pickDataBOM;
    NSArray *_pickDataCtrlB;
    NSArray *_pickDataTagRemovedEventThreshold;
}

@end

@implementation Setting1ViewController
{
    
    UHFDevice* passDev;
    int repeatTime;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _pickDataTrigger = @[@"Software", @"Digital Input", @"Sensor", @"Sensor And Digital Input"];
    
    _pickDataTargetA = @[@"A", @"B", @"A-B"];
    _pickDataTargetSL = @[@"deSL", @"SL", @"SL-deSL"];
    _pickDataSession = @[@"S0", @"S1", @"S2", @"S3", @"SL"];
    _pickDataBOM = @[@"Off", @"Once", @"Repeat"];
    _pickDataCtrlB = @[@"Success", @"Failure", @"Disable", @"Auto"];
    
    _pickDataTagRemovedEventThreshold = @[@"HIGHEST", @"MEDIUM", @"LOWEST"];
    self.pickerTriggerType.dataSource = self;
    self.pickerTriggerType.delegate = self;
    [self.pickerTriggerType setTag:1];
    
    self.pickerTarget.dataSource = self;
    self.pickerTarget.delegate = self;
    [self.pickerTarget setTag:2];
    
    self.pickerSession.dataSource = self;
    self.pickerSession.delegate = self;
    [self.pickerSession setTag:3];
    
    self.pickerBuzzerOperMode.dataSource = self;
    self.pickerBuzzerOperMode.delegate = self;
    [self.pickerBuzzerOperMode setTag:4];
    
    self.pickerCtrlBuzzer.dataSource = self;
    self.pickerCtrlBuzzer.delegate = self;
    [self.pickerCtrlBuzzer setTag:5];
    
    NSLog(@"Setting1ViewController getFirmwareVersion");
    [passDev getFirmwareVersion];
}
- (void)viewWillAppear:(BOOL)animated {
    [passDev setListener:self];
}
#pragma mark - test 4 3 RFPower slider
- (IBAction)actReadRFPower:(id)sender {
    [passDev getRfPower:false];
}
- (IBAction)actWriteRFPower:(id)sender {
    int iRFPower = [self.sliderRFPower value];
    [passDev setRfPower:false RFPower:(Byte)iRFPower];
}
#pragma mark - test 2 1 Sensitivity slider
- (IBAction)actReadSensitivity:(id)sender {
    [passDev getRfSensitivity:false];
}

- (IBAction)actWriteSensitivity:(id)sender {
    int level = [self.sliderSensitivity value];
    NSLog(@"UI cmdSetSensitivity level = %d",level);
    RfSensitivityLevel setLevel;
    switch (level) {
        case 1:
            setLevel = LEVEL_1_LOWEST;
            break;
        case 2:
            setLevel = LEVEL_2;
            break;
        case 3:
            setLevel = LEVEL_3;
            break;
        case 4:
            setLevel = LEVEL_4;
            break;
        case 5:
            setLevel = LEVEL_5;
            break;
        case 6:
            setLevel = LEVEL_6;
            break;
        case 7:
            setLevel = LEVEL_7;
            break;
        case 8:
            setLevel = LEVEL_8;
            break;
        case 9:
            setLevel = LEVEL_9;
            break;
        case 10:
            setLevel = LEVEL_10;
            break;
        case 11:
            setLevel = LEVEL_11;
            break;
        case 12:
            setLevel = LEVEL_12;
            break;
        case 13:
            setLevel = LEVEL_13;
            break;
        case 14:
            setLevel = LEVEL_14_HIGHEST;
            break;
            
        default:
            setLevel = LEVEL_14_HIGHEST;
            break;
    }
    NSLog(@"UI cmdSetSensitivity setLevel = %d",setLevel);
    [passDev setRfSensitivity:false RfSensitivityLevel:setLevel];
    
}
#pragma mark - TriggerType
- (IBAction)actReadTriggerType:(id)sender {
    [passDev cmdGetTriggerType:false];
}

- (IBAction)actWriteTriggerType:(id)sender {
    NSInteger row = [self.pickerTriggerType selectedRowInComponent:0];
    TriggerType setTrigger = 0;
    switch (row) {
        case 0:
        {
            setTrigger = Command;
        }
            break;
        case 1:
        {
            setTrigger = DigitalInput;
        }
            break;
        case 2:
        {
            setTrigger = Sensor;
        }
            break;
        case 3:
        {
            setTrigger = SensorAndDigitalInput;
        }
            break;
    }
    [passDev cmdSetTriggerType:false TriggerType:setTrigger];
    
}
#pragma mark - ControlBuzzer
- (IBAction)actCtrlBuzzer:(id)sender {
    int mode = (int)[self.pickerCtrlBuzzer selectedRowInComponent:0];
    BuzzerAction buzzerAct;
    switch (mode) {
        case 0:
        {
            buzzerAct = BA_Success;
        }
            break;
        case 1:
        {
            buzzerAct = BA_Failure;
        }
            break;
        case 2:
        {
            buzzerAct = BA_Disable;
        }
            break;
        case 3:
        {
            buzzerAct = BA_Auto;
        }
            break;
            
        default:
            buzzerAct = BA_Success;
            break;
    }
    [passDev controlBuzzer:buzzerAct];
}

#pragma mark - Q slider
- (IBAction)actReadQ:(id)sender {
    [passDev getQValue:false];
}

- (IBAction)actWriteQ:(id)sender {
    
    int iQ = [self.sliderQ value];
    NSLog(@"iQ = %d",iQ);
    [passDev setQValue:false QValue:(Byte)iQ];
}

#pragma mark - TargetAndSession
- (IBAction)actReadTargetAndSession:(id)sender {
    [passDev getSessionAndTarget:false];
}

- (IBAction)actWriteTargetAndSession:(id)sender {
    [passDev setSessionAndTarget:false Session:(Byte)[self.pickerSession selectedRowInComponent:0] Target:(Byte)[self.pickerTarget selectedRowInComponent:0]];
}
#pragma mark - test 6 5 BuzzerOperationMode
- (IBAction)actReadBOM:(id)sender {
//    [passDev getBuzzerOperationMode:false];
}
- (IBAction)actWriteBOM:(id)sender {
    NSInteger iBOM = [self.pickerBuzzerOperMode selectedRowInComponent:0];
    BuzzerOperationMode bom;
    switch (iBOM) {
        case 0:
            bom = BOM_Off;
            break;
            
        case 1:
            bom = BOM_Once;
            break;
            
        case 2:
            bom = BOM_Repeat;
            break;
            
        default:
            bom = BOM_Off;
            break;
    }
        
    [passDev cmdSet:false BuzzerOperationMode:bom];
}


- (IBAction)sliderRFPower:(id)sender {
    
}

#pragma mark - TagPresentedEventThreshold
- (IBAction)actReadTagPresentedEventThreshold:(id)sender {
    // [passDev getTagPresentRepeatInterval:true];
        
    if ([passDev isMemberOfClass:[TS100 class]]) {
        TS100 *ts100 = (TS100 *) passDev;
        
        [ts100 getTagPresentedRepeatInterval:true];
    }
    //    [passDev cmdGetTagPresentedEventThreshold:true];
}
- (IBAction)actWriteTagPresentedEventThreshold:(id)sender {
    NSString *bTimeNum = self.txtTagPresentedEventThreshold.text;
    NSInteger iTimeNum = [bTimeNum integerValue];
    if (255 > iTimeNum && iTimeNum >= 0) {
        // [passDev setTagPresentRepeatInterval:false Time:(int)iTimeNum];
        
        if ([passDev isMemberOfClass:[TS100 class]]) {
            TS100 *ts100 = (TS100 *) passDev;
            
            [ts100 setTagPresentedRepeatInterval:false Time:(int)iTimeNum];
        }
    }else {
        [self showToast:@"Error" message:@"Error parameter"];
    }
    
}
#pragma mark - TagRemoveedEventThreshold
- (IBAction)actReadTagRemoveedEventThreshold:(id)sender {
    [passDev getTagRemovedThreshold:false];
}

- (IBAction)actSetTagRemovedEventThreshold:(id)sender {
    NSString *bTimeNum = self.txtTagRemovedEventThreshold.text;
    NSInteger iTimeNum = [bTimeNum integerValue];
    if (255 > iTimeNum && iTimeNum >= 0) {
        [passDev setTagRemovedThreshold:false Round:iTimeNum];
    }else {
        [self showToast:@"Error" message:@"Error parameter"];
    }
}


- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSInteger iCount;
    switch (pickerView.tag) {
        case 1:
            iCount = _pickDataTrigger.count;
            break;
            
        case 2:
            if ([self.pickerSession selectedRowInComponent:0] == 4) {
                iCount = _pickDataTargetSL.count;
            }else {
                iCount = _pickDataTargetA.count;
            }
            break;
        case 3:
            iCount = _pickDataSession.count;
            break;
        case 4:
            iCount = _pickDataBOM.count;
            break;
            
        case 5:
            iCount = _pickDataCtrlB.count;
            break;
        case 6:
            iCount = _pickDataTagRemovedEventThreshold.count;
            break;
            
        default:
            iCount = 0;
            break;
    }
    return iCount;
}

- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    
}

- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection {
    
}

- (void)preferredContentSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
    
}

//- (CGSize)sizeForChildContentContainer:(nonnull id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize {
//
//}

- (void)systemLayoutFittingSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
    
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
    
}

- (void)willTransitionToTraitCollection:(nonnull UITraitCollection *)newCollection withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
    
}

- (void)didUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context withAnimationCoordinator:(nonnull UIFocusAnimationCoordinator *)coordinator {
    
}

- (void)setNeedsFocusUpdate {
    
}
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    NSString *strValue;
    switch (pickerView.tag) {
        case 1:
            strValue = _pickDataTrigger[row];
            break;
        case 2:
            NSLog(@"[self.pickerSession selectedRowInComponent:0] = %ld",(long)[self.pickerSession selectedRowInComponent:0]);
            if ([self.pickerSession selectedRowInComponent:0] == 4) {
                strValue = _pickDataTargetSL[row];
            }else {
                strValue = _pickDataTargetA[row];
            }
            break;
        case 3:
            strValue = _pickDataSession[row];
            
            break;
        case 4:
            strValue = _pickDataBOM[row];
            break;
        case 5:
            strValue = _pickDataCtrlB[row];
            break;
        case 6:
            strValue = _pickDataTagRemovedEventThreshold[row];
            break;
            
        default:
            strValue = @"";
            break;
    }
    return strValue;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    switch (pickerView.tag) {
        case 2:
        {
        }
            break;
        case 3:
        {
            [self.pickerTarget reloadAllComponents];
        }
            break;
        default:
        {
            
        }
            break;
    }
    
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"DevConnStatusView"]) {
        
        DevDetailTabBarViewController* ctrler = (DevDetailTabBarViewController*)self.tabBarController;
        passDev = [ctrler getUHFDevice];
        [passDev setListener:self];
        
        
        DevConnStatusViewController* childViewController = (DevConnStatusViewController *) [segue destinationViewController];
        [childViewController setUHFDevice:passDev];
    }
}


-(void)didGeneralSuccess:(NSString*)strCMDName{
    NSLog(@"UI didGeneralSuccess strCMDName = %@",strCMDName);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showToast:strCMDName message:@"Success"];
    });
    
}
-(void)didGeneralERROR:(NSString*)strCMDName ErrMessage:(NSString*)strErrorMessage{
    [self showToast:@"ERROR" message:strErrorMessage];
}
- (void)didGetFirmwareVersion:(NSString *)fwVer {
    NSLog(@"UI didDeviceInformation fwVer = %@",fwVer);
}

-(void)didGetRfPower:(int)rfPower{
    NSLog(@"UI didGetRfPower rfPower = %d",rfPower);
    [self showToast:@"didGetRfPower" message:@""];
    [self.sliderRFPower setValue:rfPower];
}
-(void)didGetRfSensitivity:(RfSensitivityLevel)rfSensitivity{
    NSLog(@"UI didGetRfSensitivity rfSensitivity = %d",rfSensitivity);
    float level = 0;
    switch (rfSensitivity) {
        case LEVEL_14_HIGHEST:
        {
            level = 14;
        }
            break;
        case LEVEL_13:
        {
            level = 13;
        }
            break;
        case LEVEL_12:
        {
            level = 12;
        }
            break;
        case LEVEL_11:
        {
            level = 11;
        }
            break;
        case LEVEL_10:
        {
            level = 10;
        }
            break;
        case LEVEL_9:
        {
            level = 9;
        }
            break;
        case LEVEL_8:
        {
            level = 8;
        }
            break;
        case LEVEL_7:
        {
            level = 7;
        }
            break;
        case LEVEL_6:
        {
            level = 6;
        }
            break;
        case LEVEL_5:
        {
            level = 5;
        }
            break;
        case LEVEL_4:
        {
            level = 4;
        }
            break;
        case LEVEL_3:
        {
            level = 3;
        }
            break;
        case LEVEL_2:
        {
            level = 2;
        }
            break;
        case LEVEL_1_LOWEST:
        {
            level = 1;
        }
            break;
            
        default:
            break;
    }
    [self.sliderSensitivity setValue:level];
    [self showToast:@"didGetRfSensitivity" message:@""];
}
-(void)didGetTriggerType:(TriggerType)triggerType{
    [self showToast:@"didGetTriggerType" message:@""];
    int pickRow = 0;
    BOOL isCommand = ((triggerType | 0x01) == 0x01)?true:false;
    switch (triggerType) {
        case Command:
        {
            pickRow = 0;
        }
            break;
        case DigitalInput:
        {
            pickRow = 1;
        }
            break;
        case Sensor:
        {
            pickRow = 2;
        }
            break;
        case SensorAndDigitalInput:
        {
            pickRow = 3;
        }
            break;
            
        default:
            pickRow = 0;
            break;
    }
    if (isCommand) {
        pickRow = 0;
    }
    [self.pickerTriggerType selectRow:pickRow inComponent:0 animated:YES];
}

-(void)didDiscoverTagInfo:(GNPTagInfo*)taginfo{
}
-(void)didTagRemoved:(GNPTagInfo*)taginfo{
    
}

-(void)didGetSessionAnd:(Session)session Target:(Target) target{
    [self showToast:@"didGetSessionAndTarget" message:@""];
    [self.pickerSession selectRow:session inComponent:0 animated:YES];
    [self.pickerTarget selectRow:target inComponent:0 animated:YES];
    [self.pickerTarget reloadAllComponents];
}
-(void)didGetQValue:(Byte) qValue{
    NSLog(@"UI didGetQValue iqValue = %d",qValue);
    [self showToast:@"didGetQValue" message:@""];
    [self.sliderQ setValue:qValue];
}

-(void)didGetBuzzerOperationMode:(BuzzerOperationMode) bom{
    NSLog(@"UI didGetBuzzerOperationMode bom = %d",bom);
    
    NSInteger iBOM;
    switch (bom) {
            
        case BOM_Off:
            iBOM = 0;
            break;
            
        case BOM_Once:
            iBOM = 1;
            break;
            
        case BOM_Repeat:
            iBOM = 2;
            break;
            
        default:
            iBOM = 0;
            break;
    }
    [self.pickerBuzzerOperMode selectRow:iBOM inComponent:0 animated:YES];
    
    [self showToast:@"didGetBuzzerOperationMode" message:@""];
}

- (void)didGetTagPresentedRepeatInterval:(int)time {
    [self showToast:@"didGetTagPresentedRepeatInterval" message:@""];
    NSString* sTimeNum = [[NSString alloc] initWithFormat:@"%d", (int)(time)];
    self.txtTagPresentedEventThreshold.text = sTimeNum;
}

- (void)didGetTagRemoveThreshold:(int)missingInventoryThreshold {
    [self showToast:@"didGetTagRemoveThreshold" message:@""];
    NSString* sTimeNum = [[NSString alloc] initWithFormat:@"%d", (int)(missingInventoryThreshold)];
    self.txtTagRemovedEventThreshold.text = sTimeNum;
}


-(void)showToast:(NSString*)title message:(NSString*)message {
    NSMutableString* allMesg = [NSMutableString stringWithString:title];
    [allMesg appendString:@" "];
    [allMesg appendString:message];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = allMesg;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:1];
}




- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        [self.txtTagPresentedEventThreshold resignFirstResponder];
        [self.txtTagRemovedEventThreshold resignFirstResponder];
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.txtTagPresentedEventThreshold resignFirstResponder];
    [self.txtTagRemovedEventThreshold resignFirstResponder];
    return true;
}








@end
