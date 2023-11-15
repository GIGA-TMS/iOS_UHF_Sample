//
//  NewSetting2ViewController.m
//  UHFSample
//
//  Created by JangJack on 2020/8/22.
//  Copyright © 2020 Gianni. All rights reserved.
//

#import "NewSettingViewController.h"
#import "TagItemTableViewCell.h"
#import <UHFSDK/GNPTagInfo.h>
#import <UHFSDK/TS100.h>
#import <UHFSDK/TS100A.h>
#import <UHFSDK/TS800.h>
#import <UHFSDK/UR0250.h>
#import "DevDetailTabBarViewController.h"
#import "NewDevConnStatusViewController.h"
#import "MBProgressHUD.h"

@interface NewSettingViewController () <UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,IUHFDeviceListener>

@property (weak, nonatomic) IBOutlet UISlider *sliderDeviceID;
@property (weak, nonatomic) IBOutlet UILabel *labDeviceID;
@property (weak, nonatomic) IBOutlet UISlider *sliderRFPower;
@property (weak, nonatomic) IBOutlet UILabel *labRFPower;
@property (weak, nonatomic) IBOutlet UISlider *sliderRFSensitivity;
@property (weak, nonatomic) IBOutlet UILabel *labRFSensitivity;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerRxDecode;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerSession;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerTarget;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerLinkFrequency;
@property (weak, nonatomic) IBOutlet UISlider *sliderQ;
@property (weak, nonatomic) IBOutlet UILabel *labQ;
@property (weak, nonatomic) IBOutlet UITextField *textFieldFrequency;
@property (weak, nonatomic) IBOutlet UISlider *sliderTagPresentedRepeatInterval;
@property (weak, nonatomic) IBOutlet UILabel *labTagPresentedRepeatInterval;
@property (weak, nonatomic) IBOutlet UISlider *sliderTagRemovedThreshold;
@property (weak, nonatomic) IBOutlet UILabel *labTagRemovedThreshold;
@property (weak, nonatomic) IBOutlet UISlider *sliderInventoryRoundInterval;
@property (weak, nonatomic) IBOutlet UILabel *labInventoryRoundInterval;


@property (strong, nonatomic) IBOutlet UIView *customView;

@end

@implementation NewSettingViewController {
    NSMutableArray* allTagItems;
    UHFDevice* passDev;
    NewDevConnStatusViewController* childViewController;
    
    NSArray *rxDecode;
    NSArray *session;
    NSArray *target;
    NSArray *linkFrequency;
    
    BOOL keyboardIsUp;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (passDev) {
        [passDev setListener:self];
        
        
        
    }
    allTagItems = [[NSMutableArray alloc]init];
    [childViewController clearLog];
    
    rxDecode = @[@"FM0", @"MILLER_2", @"MILLER_4", @"MILLER_8"];
    session = @[@"S0", @"S1", @"S2", @"S3", @"SL"];
    target = @[@"A", @"B", @"A_B"];
    linkFrequency = @[@"LF_40KHz", @"LF_80KHz", @"LF_160KHz", @"LF_213_POINT_3KHz", @"LF_256KHz", @"LF_320KHz", @"LF_640KHz"];
    
    self.pickerRxDecode.dataSource = self;
    self.pickerRxDecode.delegate = self;
    [self.pickerRxDecode setTag:1];
    [self.pickerRxDecode selectRow:0 inComponent:0 animated:true];
    
    self.pickerSession.dataSource = self;
    self.pickerSession.delegate = self;
    [self.pickerSession setTag:2];
    [self.pickerSession selectRow:0 inComponent:0 animated:true];
    
    self.pickerTarget.dataSource = self;
    self.pickerTarget.delegate = self;
    [self.pickerTarget setTag:3];
    [self.pickerTarget selectRow:0 inComponent:0 animated:true];
    
    self.pickerLinkFrequency.dataSource = self;
    self.pickerLinkFrequency.delegate = self;
    [self.pickerLinkFrequency setTag:4];
    [self.pickerLinkFrequency selectRow:0 inComponent:0 animated:true];

    keyboardIsUp = false;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [passDev setListener:self];
}


-(void)viewDidDisappear:(BOOL)animated {
//    [passDev setListener:nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"NewDevConnStatusView"]) {
        
        DevDetailTabBarViewController* ctrler = (DevDetailTabBarViewController*)self.tabBarController;
        passDev = [ctrler getUHFDevice];
        
        
        
        childViewController = (NewDevConnStatusViewController *) [segue destinationViewController];
        [childViewController setUHFDevice:passDev];
    }
}

#pragma mark - Data Picker

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSInteger iCount;
    switch (pickerView.tag) {
        case 1: {
            iCount = rxDecode.count;
        }
            break;

        case 2: {
            iCount = session.count;
        }
            break;

        case 3: {
            iCount = target.count;
        }
            break;

        case 4: {
            iCount = linkFrequency.count;
        }
            break;

        default: {
            iCount = 0;
        }
            break;
    }
    
    return iCount;
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *strValue;
    switch (pickerView.tag) {
        case 1: {
            strValue = rxDecode[row];
        }
            break;
            
        case 2: {
            strValue = session[row];
        }
            break;
                
        case 3: {
            strValue = target[row];
        }
            break;
                    
        case 4: {
            strValue = linkFrequency[row];
        }
            break;

        default: {
            strValue = @"";
        }
            break;
    }
    
    return strValue;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *pickerLabel = (UILabel *)view;
    
    if (!pickerLabel) {
        pickerLabel = [[UILabel alloc] init];
        
        pickerLabel.textAlignment = NSTextAlignmentCenter;
    }
    NSString *strValue = @"";
    switch (pickerView.tag) {
        case 1: {
            strValue = rxDecode[row];
        }
            break;
            
        case 2: {
            strValue = session[row];
        }
            break;
                
        case 3: {
            strValue = target[row];
        }
            break;
                    
        case 4: {
            strValue = linkFrequency[row];
        }
            break;

        default: {
            strValue = @"";
        }
            break;
    }
    [pickerLabel setText:strValue];
    
    return pickerLabel;
}

#pragma mark - Keyboard Handler

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

-(void)keyboardWillShow:(NSNotification *) notification {
    if (keyboardIsUp == false) {
        [UIView animateWithDuration:0.25 animations: ^{
            self->keyboardIsUp = true;
            CGRect newFrame = [self->_customView frame];
            newFrame.origin.y -= 240;
            [self->_customView setFrame:newFrame];
        }completion:^(BOOL finished) {

        }];
    }
}

-(void)keyboardWillBeHidden:(NSNotification *) notification {
    if (keyboardIsUp == true) {
        [UIView animateWithDuration:0.25 animations: ^{
            self->keyboardIsUp = false;
            CGRect newFrame = [self->_customView frame];
            newFrame.origin.y += 240;
            [self->_customView setFrame:newFrame];
        }completion:^(BOOL finished) {

        }];
    }
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

- (IBAction)actGetDeviceID:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            [self->passDev getDeviceID:false];
        }
    }
}

- (IBAction)actSetDeviceID:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            [self->passDev setDeviceID:false DeviceID:round(255 * [self->_sliderDeviceID value]) / 255];
        }
    }
}

- (IBAction)actDeviceIDChanged:(id)sender {
    UISlider *slider = (UISlider *) sender;
    int final = round(255 * slider.value) / 255;
    
    self->_labDeviceID.text = [NSString stringWithFormat:@"%d", final];
}

- (IBAction)actGetRFPower:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            [self->passDev getRfPower:false];
        }
    }
}

- (IBAction)actSetRFPower:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            [self->passDev setRfPower:false RFPower:round(100 * [self->_sliderRFPower value]) / 100];
        }
    }
}

- (IBAction)actRFPowerChanged:(id)sender {
    UISlider *slider = (UISlider *) sender;
    int final = round(100 * slider.value) / 100;
    
    self->_labRFPower.text = [NSString stringWithFormat:@"%d", final];
}

- (IBAction)actGetRFSensitivity:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            [self->passDev getRfSensitivity:false];
        }
    }
}

- (IBAction)actSetRFSensitivity:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            RfSensitivityLevel rfSensitivity;
            int value = round(100 * self->_sliderRFSensitivity.value) / 100;
            switch (value) {
                case 1: {
                    rfSensitivity = LEVEL_1_LOWEST;
                }
                    break;
                
                case 2: {
                    rfSensitivity = LEVEL_2;
                }
                    break;
                
                case 3: {
                    rfSensitivity = LEVEL_3;
                }
                    break;

                case 4: {
                    rfSensitivity = LEVEL_4;
                }
                    break;
                
                case 5: {
                    rfSensitivity = LEVEL_5;
                }
                    break;
                
                case 6: {
                    rfSensitivity = LEVEL_6;
                }
                    break;
                
                case 7: {
                    rfSensitivity = LEVEL_7;
                }
                    break;
                
                case 8: {
                    rfSensitivity = LEVEL_8;
                }
                    break;
                
                case 9: {
                    rfSensitivity = LEVEL_9;
                }
                    break;

                case 10: {
                    rfSensitivity = LEVEL_10;
                }
                    break;
                
                case 11: {
                    rfSensitivity = LEVEL_11;
                }
                    break;
                
                case 12: {
                    rfSensitivity = LEVEL_12;
                }
                    break;
                
                case 13: {
                    rfSensitivity = LEVEL_13;
                }
                    break;
                
                case 14: {
                    rfSensitivity = LEVEL_14_HIGHEST;
                }
                    break;

                default: {
                    rfSensitivity = LEVEL_1_LOWEST;
                }
                    break;
            }
            [self->passDev setRfSensitivity:false RfSensitivityLevel:rfSensitivity];
        }
    }
}

- (IBAction)actRFSensitivityChanged:(id)sender {
    UISlider *slider = (UISlider *) sender;
    int final = round(100 * slider.value) / 100;
    
    self->_labRFSensitivity.text = [NSString stringWithFormat:@"%d", final];
}

- (IBAction)actGetRxDecode:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            [self->passDev getRxDecode:false];
        }
    }
}

- (IBAction)actSetRxDecode:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            RxDecodeType rxDecode = FM0;
            switch ([self.pickerRxDecode selectedRowInComponent:0]) {
                case 0: {
                    rxDecode = FM0;
                }
                    break;
                    
                case 1: {
                    rxDecode = MILLER_2;
                }
                    break;
                    
                case 2: {
                    rxDecode = MILLER_4;
                }
                    break;
                    
                case 3: {
                    rxDecode = MILLER_8;
                }
                    break;
                    
                default: {
                    rxDecode = FM0;
                }
                    break;
            }
            [self->passDev setRxDecode:false RxDecodeType:rxDecode];
        }
    }
}

- (IBAction)actGetSessionAndTarget:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            [self->passDev getSessionAndTarget:false];
        }
    }
}

- (IBAction)actSetSessionAndTarget:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            Session session = S0;
            switch ([self.pickerSession selectedRowInComponent:0]) {
                case 0: {
                    session = S0;
                }
                    break;
                    
                case 1: {
                    session = S1;
                }
                    break;
                    
                case 2: {
                    session = S2;
                }
                    break;
                    
                case 3: {
                    session = S3;
                }
                    break;
                    
                case 4: {
                    session = Session_SL;
                }
                    break;

                default: {
                   session = S0;
               }
                    break;
            }
            
            Target target = A;
            switch ([self.pickerTarget selectedRowInComponent:0]) {
                case 0: {
                    target = A;
                }
                    break;
                    
                case 1: {
                    target = B;
                }
                    break;
                    
                case 2: {
                    target = A_B;
                }
                    break;

                default: {
                   target = A;
               }
                    break;
            }
            [self->passDev setSessionAndTarget:false Session:session Target:target];
        }
    }
}

- (IBAction)actGetLinkFrequency:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            [self->passDev getLinkFrequency:false];
        }
    }
}

- (IBAction)actSetLinkFrequency:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            LinkFrequency linkFrequency = LF_40KHZ;
            switch ([self.pickerLinkFrequency selectedRowInComponent:0]) {
                case 0: {
                    linkFrequency = LF_40KHZ;
                }
                    break;
                    
                case 1: {
                    linkFrequency = LF_80KHZ;
                }
                    break;
                    
                case 2: {
                    linkFrequency = LF_160KHZ;
                }
                    break;
                    
                case 3: {
                    linkFrequency = LF_213_POINT_3KHZ;
                }
                    break;
                    
                case 4: {
                    linkFrequency = LF_256KHZ;
                }
                    break;
                    
                case 5: {
                    linkFrequency = LF_320KHZ;
                }
                    break;
                    
                case 6: {
                    linkFrequency = LF_640KHZ;
                }
                    break;
                    
                default: {
                    linkFrequency = LF_40KHZ;
                    
                }
                    break;
            }
            [self->passDev setLinkFrequency:false LinkFrequency:linkFrequency];
        }
    }
}

- (IBAction)actGetQ:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            [self->passDev getQValue:false];
        }
    }
}

- (IBAction)actSetQ:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            [self->passDev setQValue:false QValue:round(100 * [self->_sliderQ value]) / 100];
        }
    }
}

- (IBAction)actQChanged:(id)sender {
    UISlider *slider = (UISlider *) sender;
    int final = round(100 * slider.value) / 100;
    
    self->_labQ.text = [NSString stringWithFormat:@"%d", final];
}

- (IBAction)actGetFrequency:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            [self->passDev getFrequency:false];
        }
    }
}

- (IBAction)actSetFrequency:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            NSArray *strArray = [self.textFieldFrequency.text componentsSeparatedByString:@","];
            [self->passDev setFrequency:false List:strArray];
        }
    }
}

- (IBAction)actGetTagPresentedRepeatInterval:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            if ([self->passDev isMemberOfClass:[TS100 class]]) {
                TS100 *ts100 = (TS100 *) self->passDev;
                
                [ts100 getTagPresentedRepeatInterval:false];
            } else if ([self->passDev isMemberOfClass:[TS100A class]]) {
                TS100A *ts100a = (TS100A *) self->passDev;
                
                [ts100a getTagPresentedRepeatInterval:false];
            } else if ([self->passDev isMemberOfClass:[TS800 class]]) {
                TS800 *ts800 = (TS800 *) self->passDev;
                
                [ts800 getTagPresentedRepeatInterval:false];
            } else if ([self->passDev isMemberOfClass:[UR0250 class]]) {
                UR0250 *ur0250 = (UR0250 *) self->passDev;
                
                [ur0250 getTagPresentedRepeatInterval:false];
            }
        }
    }
}

- (IBAction)actSetTagPresentedRepeatInterval:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            if ([self->passDev isMemberOfClass:[TS100 class]]) {
                TS100 *ts100 = (TS100 *) self->passDev;
                
                [ts100 setTagPresentedRepeatInterval:false Time:round(100 * [self->_sliderTagPresentedRepeatInterval value]) / 100];
            } else if ([self->passDev isMemberOfClass:[TS100A class]]) {
                TS100A *ts100a = (TS100A *) self->passDev;
                
                [ts100a setTagPresentedRepeatInterval:false Time:round(100 * [self->_sliderTagPresentedRepeatInterval value]) / 100];
            } else if ([self->passDev isMemberOfClass:[TS800 class]]) {
                TS800 *ts800 = (TS800 *) self->passDev;
                
                [ts800 setTagPresentedRepeatInterval:false Time:round(100 * [self->_sliderTagPresentedRepeatInterval value]) / 100];
            } else if ([self->passDev isMemberOfClass:[UR0250 class]]) {
                UR0250 *ur0250 = (UR0250 *) self->passDev;
                
                [ur0250 setTagPresentedRepeatInterval:false Time:round(100 * [self->_sliderTagPresentedRepeatInterval value]) / 100];
            }
        }
    }
}

- (IBAction)actTagPresentedRepeatIntervalChanged:(id)sender {
    UISlider *slider = (UISlider *) sender;
    int final = round(100 * slider.value) / 100;
    
    self->_labTagPresentedRepeatInterval.text = [NSString stringWithFormat:@"%d", final];
}

- (IBAction)actGetTagRemovedThreshold:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            [self->passDev getTagRemovedThreshold:false];
        }
    }
}

- (IBAction)actSetTagRemovedThreshold:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            [self->passDev setTagRemovedThreshold:false Round:round(100 * [self->_sliderTagRemovedThreshold value]) / 100];
        }
    }
}

- (IBAction)actTagRemovedThresholdChanged:(id)sender {
    UISlider *slider = (UISlider *) sender;
    int final = round(100 * slider.value) / 100;
    
    self->_labTagRemovedThreshold.text = [NSString stringWithFormat:@"%d", final];
}

- (IBAction)actGetInventoryRoundInterval:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            [self->passDev getInventoryRoundInterval:false];
        }
    }
}

- (IBAction)actSetInventoryRoundInterval:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            [self->passDev setInventoryRoundInterval:false InventoryRoundInterval:round(100 * [self->_sliderInventoryRoundInterval value]) / 100];
        }
    }
}

- (IBAction)actIntentoryRoundIntervalChanged:(id)sender {
    UISlider *slider = (UISlider *) sender;
    int final = round(100 * slider.value) / 100;
    
    self->_labInventoryRoundInterval.text = [NSString stringWithFormat:@"%d", final];
}

- (IBAction)actGetFirlwareVersion:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            [passDev getFirmwareVersion];
        }
    }
}

#pragma mark - UHF API Callback

-(void)didGetDeviceID:(Byte)deviceID{
    [childViewController addLog:[NSString stringWithFormat:@"didGetDeviceID = %d",deviceID]];
    self->_labDeviceID.text = [NSString stringWithFormat:@"%d",deviceID];
    self->_sliderDeviceID.value = deviceID;
}

-(void)didGetRfPower:(int)rfPower{
    [childViewController addLog:[NSString stringWithFormat:@"didGetRfPower = %d",rfPower]];
    self->_labRFPower.text = [NSString stringWithFormat:@"%d",rfPower];
    self->_sliderRFPower.value = rfPower;
}

-(void)didGetRfSensitivity:(RfSensitivityLevel)rfSensitivity{
    //[childViewController addLog:[NSString stringWithFormat:@"didGetRfSensitivity = %d",rfSensitivity]];
    int value = 1;
    switch (rfSensitivity) {
        case LEVEL_1_LOWEST: {
            value = 1;
        }
            break;
            
        case LEVEL_2: {
            value = 2;
        }
            break;
        
        case LEVEL_3: {
            value = 3;
        }
            break;
            
        case LEVEL_4: {
            value = 4;
        }
            break;
        
        case LEVEL_5: {
            value = 5;
        }
            break;
            
        case LEVEL_6: {
            value = 6;
        }
            break;
        
        case LEVEL_7: {
            value = 7;
        }
            break;
            
        case LEVEL_8: {
            value = 8;
        }
            break;
            
        case LEVEL_9: {
            value = 9;
        }
            break;
        
        case LEVEL_10: {
            value = 10;
        }
            break;
            
        case LEVEL_11: {
            value = 11;
        }
            break;
        
        case LEVEL_12: {
            value = 12;
        }
            break;
            
        case LEVEL_13: {
            value = 13;
        }
            break;
        
        case LEVEL_14_HIGHEST: {
            value = 14;
        }
            break;

        default:
            break;
    }
    [childViewController addLog:[NSString stringWithFormat:@"didGetRfSensitivity = %d",value]];
    self->_labRFSensitivity.text = [NSString stringWithFormat:@"%d",value];
    self->_sliderRFSensitivity.value = value;
}

-(void)didGetRxDecode:(int)rxDecode{
    //[childViewController addLog:[NSString stringWithFormat:@"didGetRxDecode = %d",rxDecode]];
    NSString* rxDecodeString = @"";
    switch (rxDecode) {
        case FM0: {
            [self.pickerRxDecode selectRow:0 inComponent:0 animated:true];
            rxDecodeString = @"FM0";
        }
            break;
            
        case MILLER_2: {
            [self.pickerRxDecode selectRow:1 inComponent:0 animated:true];
            rxDecodeString = @"MILLER_2";
        }
            break;
            
        case MILLER_4: {
            [self.pickerRxDecode selectRow:2 inComponent:0 animated:true];
            rxDecodeString = @"MILLER_4";
        }
            break;
            
        case MILLER_8: {
            [self.pickerRxDecode selectRow:3 inComponent:0 animated:true];
            rxDecodeString = @"MILLER_8";
        }
            break;

        default:{
            [self.pickerRxDecode selectRow:0 inComponent:0 animated:true];
            rxDecodeString = @"FM0";
        }
            break;
    }
    [childViewController addLog:[NSString stringWithFormat:@"didGetRxDecode = %@",rxDecodeString]];
}

-(void)didGetSessionAnd:(Session)session Target:(Target) target{
    //[childViewController addLog:[NSString stringWithFormat:@"didGetSessionAnd, session = %d, target = %d", session, target]];
    NSString* sessionString = @"";
    switch (session) {
        case S0: {
            [self.pickerSession selectRow:0 inComponent:0 animated:true];
            sessionString = @"S0";
        }
            break;
            
        case S1: {
            [self.pickerSession selectRow:1 inComponent:0 animated:true];
            sessionString = @"S1";
        }
            break;
            
        case S2: {
            [self.pickerSession selectRow:2 inComponent:0 animated:true];
            sessionString = @"S2";
        }
            break;
            
        case S3: {
            [self.pickerSession selectRow:3 inComponent:0 animated:true];
            sessionString = @"S3";
        }
            break;
        
        case Session_SL: {
            [self.pickerSession selectRow:4 inComponent:0 animated:true];
            sessionString = @"SL";
        }
            break;

        default: {
               [self.pickerSession selectRow:0 inComponent:0 animated:true];
            sessionString = @"S0";
           }
            break;
    }
    
    NSString* targetString = @"";
    switch (target) {
        case 0: {
            [self.pickerTarget selectRow:0 inComponent:0 animated:true];
            targetString = @"A";
        }
            break;
        
        case 1: {
            [self.pickerTarget selectRow:1 inComponent:0 animated:true];
            targetString = @"B";
        }
            break;
            
        case 2: {
            [self.pickerTarget selectRow:2 inComponent:0 animated:true];
            targetString = @"A_B";
        }
            break;

        default: {
           [self.pickerTarget selectRow:0 inComponent:0 animated:true];
            targetString = @"A";
       }
            break;
    }
    
    [childViewController addLog:[NSString stringWithFormat:@"didGetSessionAnd, session = %@, target = %@", sessionString, targetString]];
}

-(void)didGetLinkFrequency:(int)linkFrequency{
    //[childViewController addLog:[NSString stringWithFormat:@"didGetLinkFrequency = %d", linkFrequency]];
    NSString* linkFrequencyString = @"";
    switch (linkFrequency) {
        case LF_40KHZ: {
            [self.pickerLinkFrequency selectRow:0 inComponent:0 animated:true];
            linkFrequencyString = @"LF_40KHZ";
        }
            break;
            
        case LF_80KHZ: {
            [self.pickerLinkFrequency selectRow:1 inComponent:0 animated:true];
            linkFrequencyString = @"LF_80KHZ";
        }
            break;
            
        case LF_160KHZ: {
            [self.pickerLinkFrequency selectRow:2 inComponent:0 animated:true];
            linkFrequencyString = @"LF_160KHZ";
        }
            break;
            
        case LF_213_POINT_3KHZ: {
            [self.pickerLinkFrequency selectRow:3 inComponent:0 animated:true];
            linkFrequencyString = @"LF_213_POINT_3KHZ";
        }
            break;
        
        case LF_256KHZ: {
            [self.pickerLinkFrequency selectRow:4 inComponent:0 animated:true];
            linkFrequencyString = @"LF_256KHZ";
        }
            break;
        
        case LF_320KHZ: {
            [self.pickerLinkFrequency selectRow:5 inComponent:0 animated:true];
            linkFrequencyString = @"LF_320KHZ";
        }
            break;
        
        case LF_640KHZ: {
            [self.pickerLinkFrequency selectRow:6 inComponent:0 animated:true];
            linkFrequencyString = @"LF_640KHZ";
        }
            break;

        default: {
            [self.pickerLinkFrequency selectRow:0 inComponent:0 animated:true];
            linkFrequencyString = @"LF_40KHZ";
        }
            break;
    }
    [childViewController addLog:[NSString stringWithFormat:@"didGetLinkFrequency = %@", linkFrequencyString]];
}

-(void)didGetQValue:(Byte) qValue{
    [childViewController addLog:[NSString stringWithFormat:@"didGetQValue = %d",qValue]];
    self->_labQ.text = [NSString stringWithFormat:@"%d",qValue];
    self->_sliderQ.value = qValue;
}

- (void)didGetFrequencyList:(NSArray *)frequencys {
    [childViewController addLog:[NSString stringWithFormat:@"didGetFrequencyList = %@",frequencys]];
    NSString* strFrequency = @"";
    for (int i = 0 ; i < [frequencys count]; i++) {
        double num = [[frequencys objectAtIndex:i]doubleValue];
        if (i == ([frequencys count] - 1)) {
            strFrequency = [NSString stringWithFormat:@"%@%0.2f", strFrequency, num];
        } else {
            strFrequency = [NSString stringWithFormat:@"%@%0.2f, ", strFrequency, num];
        }
    }
    
    self->_textFieldFrequency.text = strFrequency;
}

-(void)didGetTagPresentedRepeatInterval:(int)interval {
    [childViewController addLog:[NSString stringWithFormat:@"didGetTagPresentedRepeatInterval = %d",interval]];
    self->_labTagPresentedRepeatInterval.text = [NSString stringWithFormat:@"%d",interval];
    self->_sliderTagPresentedRepeatInterval.value = interval;
}

-(void)didGetTagRemovedThreshold:(int)missingInventoryThreshold{
    [childViewController addLog:[NSString stringWithFormat:@"didGetTagRemovedThreshold = %d",missingInventoryThreshold]];
    self->_labTagRemovedThreshold.text = [NSString stringWithFormat:@"%d",missingInventoryThreshold];
    self->_sliderTagRemovedThreshold.value = missingInventoryThreshold;
}

-(void)didGetInventoryRoundInterval:(int)tenMilliSeconds{
    [childViewController addLog:[NSString stringWithFormat:@"didGetInventoryRoundInterval = %d",tenMilliSeconds]];
    self->_labInventoryRoundInterval.text = [NSString stringWithFormat:@"%d",tenMilliSeconds];
    self->_sliderInventoryRoundInterval.value = tenMilliSeconds;
}

-(void)didGetFirmwareVersion:(NSString *)fwVer {
    [childViewController addLog:[NSString stringWithFormat:@"didGetFirmwareVersion, fwVer = %@",fwVer]];
    [passDev getDevInfo].devROMVersion = fwVer;
    [childViewController reloadData];
}

-(void)didGetBleRomVersion:(NSString *)romVersion{
    [childViewController addLog:[NSString stringWithFormat:@"didGetBleRomVersion, romVersion = %@",romVersion]];
}

- (void)didGetBLEFirmwareVersion:(NSString *)fwVer {
    [childViewController addLog:[NSString stringWithFormat:@"didGetBLEFirmwareVersion, fwVer= %@",fwVer]];
    [passDev getDevInfo]._bleDevInfo.devROMVersion = fwVer;
    [childViewController reloadData];
}

- (void)didGetWiFiMacAddress:(NSString *)wifiMacAddress {
    [childViewController addLog:[NSString stringWithFormat:@"didGetWiFiMacAddress, wifiMacAddress = %@",wifiMacAddress]];
    [childViewController reloadData];
}

-(void)didDiscoverTagInfo:(GNPTagInfo*)taginfo{
    if (self->passDev != nil && self->passDev.getDevInfo.currentConnStatus == DevConnected) {
        [self->passDev stopInventory];
    }
//    NSString *string = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@",
//    [NSString stringWithFormat:@"didDiscoverTagInfo, taginfo.TagNumber = %d",taginfo.TagNumber],
//    [NSString stringWithFormat:@"didDiscoverTagInfo, taginfo.RSSI = %02X",taginfo.RSSI],
//    [NSString stringWithFormat:@"didDiscoverTagInfo, taginfo.Frequency = %f",[taginfo getFrequency]],
//    [NSString stringWithFormat:@"didDiscoverTagInfo, taginfo.EPCHexString = %@",taginfo.EPCHexString],
//    [taginfo.TIDHexString isEqual: @""] ? @"" : [NSString stringWithFormat:@"didDiscoverTagInfo, taginfo.TIDHexString = %@",taginfo.TIDHexString]];
//    [childViewController displayLog:string];
//    [childViewController addLog:[NSString stringWithFormat:@"didDiscoverTagInfo, taginfo.TagNumber = %d",taginfo.TagNumber]];
//    [childViewController addLog:[NSString stringWithFormat:@"didDiscoverTagInfo, taginfo.RSSI = %02X",taginfo.RSSI]];
//    [childViewController addLog:[NSString stringWithFormat:@"didDiscoverTagInfo, taginfo.Frequency = %f",[taginfo getFrequency]]];
////    [childViewController addLog:[NSString stringWithFormat:@"didDiscoverTagInfo, taginfo.EPC = %@",taginfo.EPC]];
//    [childViewController addLog:[NSString stringWithFormat:@"didDiscoverTagInfo, taginfo.EPCHexString = %@",taginfo.EPCHexString]];
////    [childViewController addLog:[NSString stringWithFormat:@"didDiscoverTagInfo, taginfo.TID = %@",taginfo.TID]];
//    [childViewController addLog:[NSString stringWithFormat:@"didDiscoverTagInfo, taginfo.TIDHexString = %@",taginfo.TIDHexString]];
}

- (void)didDiscoverTagInfoEx:(GNPDecodedTagData *)decodedTagData{
//    NSString *string = [NSString stringWithFormat:@"%@\n%@\n%@\n%@",
//    [NSString stringWithFormat:@"didDiscoverTagInfoEx, decodedTagData.TID = %@",decodedTagData.TID],
//    [NSString stringWithFormat:@"didDiscoverTagInfoEx, decodedTagData.TagSerialNumber = %@",decodedTagData.TagSerialNumber],
//    [NSString stringWithFormat:@"didDiscoverTagInfoEx, decodedTagData.DeviceSerialNumber = %@",decodedTagData.DeviceSerialNumber],
//    [NSString stringWithFormat:@"didDiscoverTagInfoEx, decodedTagData.DecodedDataList = %@",decodedTagData.DecodedDataList]];
//    [childViewController displayLog:string];
//    [childViewController addLog:[NSString stringWithFormat:@"didDiscoverTagInfoEx, decodedTagData.TID = %@",decodedTagData.TID]];
//    [childViewController addLog:[NSString stringWithFormat:@"didDiscoverTagInfoEx, decodedTagData.TagSerialNumber = %@",decodedTagData.TagSerialNumber]];
//    [childViewController addLog:[NSString stringWithFormat:@"didDiscoverTagInfoEx, decodedTagData.DeviceSerialNumber = %@",decodedTagData.DeviceSerialNumber]];
//    [childViewController addLog:[NSString stringWithFormat:@"didDiscoverTagInfoEx, decodedTagData.DecodedDataList = %@",decodedTagData.DecodedDataList]];
}

-(void)didTagRemoved:(GNPTagInfo *)taginfo {
//    NSString *string = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@",
//    [NSString stringWithFormat:@"didTagRemoved, taginfo.TagNumber = %d",taginfo.TagNumber],
//    [NSString stringWithFormat:@"didTagRemoved, taginfo.RSSI = %02X",taginfo.RSSI],
//    [NSString stringWithFormat:@"didTagRemoved, taginfo.Frequency = %f",[taginfo getFrequency]],
//    [NSString stringWithFormat:@"didTagRemoved, taginfo.EPCHexString = %@",taginfo.EPCHexString],
//    [NSString stringWithFormat:@"didTagRemoved, taginfo.TIDHexString = %@",taginfo.TIDHexString]];
//    [childViewController displayLog:string];
//    [childViewController addLog:[NSString stringWithFormat:@"didTagRemoved, taginfo.TagNumber = %d",taginfo.TagNumber]];
//    [childViewController addLog:[NSString stringWithFormat:@"didTagRemoved, taginfo.RSSI = %02X",taginfo.RSSI]];
//    [childViewController addLog:[NSString stringWithFormat:@"didTagRemoved, taginfo.Frequency = %f",[taginfo getFrequency]]];
////    [childViewController addLog:[NSString stringWithFormat:@"didTagRemoved, taginfo.EPC = %@",taginfo.EPC]];
//    [childViewController addLog:[NSString stringWithFormat:@"didTagRemoved, taginfo.EPCHexString = %@",taginfo.EPCHexString]];
////    [childViewController addLog:[NSString stringWithFormat:@"didTagRemoved, taginfo.TID = %@",taginfo.TID]];
//    [childViewController addLog:[NSString stringWithFormat:@"didTagRemoved, taginfo.TIDHexString = %@",taginfo.TIDHexString]];
}

-(void)didGeneralSuccess:(NSString *)strCMDName {
    [childViewController addLog:[NSString stringWithFormat:@"didGeneralSuccess = %@",strCMDName]];
}

-(void)didGeneralERROR:(NSString *)strCMDName ErrMessage:(NSString *)strErrorMessage {
    [childViewController addLog:[NSString stringWithFormat:@"didGeneralERROR strCMDName = %@, strErrorMessage = %@", strCMDName, strErrorMessage]];
}

-(void)didGeneralTimeout:(NSString *)strCMDName ErrMessage:(NSString *)strErrorMessage Data:(NSData *)data {
    [childViewController addLog:[NSString stringWithFormat:@"didGeneralTimeout strCMDName = %@, strErrorMessage = %@, data = %@", strCMDName, strErrorMessage, data]];
}

@end
