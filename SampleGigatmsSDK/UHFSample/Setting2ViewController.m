//
//  Setting2ViewController.m
//  UHFSample
//
//  Created by Gianni on 2019/4/12.
//  Copyright © 2019 Gianni. All rights reserved.
//
#import "MBProgressHUD.h"
#import "Setting2ViewController.h"
#import "DevDetailTabBarViewController.h"
#import "DevConnStatusViewController.h"
#import <UHFSDK/TS100.h>

@interface Setting2ViewController () <IUHFDeviceListener>

@end

@implementation Setting2ViewController
{
    
    UHFDevice* passDev;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    [passDev setListener:self];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


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

- (IBAction)actReadFrequency:(id)sender {
    [passDev getFrequency:true];
}

- (IBAction)actWriteFrequency:(id)sender {
    NSString* strFrequency = self.textView.text;
    NSArray* strDataArray = [strFrequency componentsSeparatedByString:@","];
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i < [strDataArray count]; i++) {
        [array addObject:[NSNumber numberWithDouble:[[strDataArray objectAtIndex:i]doubleValue]]];
    }
    [passDev setFrequency:false List:array];
    
}

- (IBAction)actReadTest:(id)sender {
//    passDev cmdgetf
    
    TS100* ts100 = passDev;
//    [ts100 cmdGetFilter:true];
//    [ts100 cmdGetPostDataDelimiter:true];
//    [ts100 cmdGetMemoryBankSelection:true];
//    [ts100 cmdGetEventType:true];
//    [ts100 cmdGetOutputInterface:true];
}

- (IBAction)actWrite:(id)sender {
}



-(void)didGeneralSuccess:(NSString*)strCMDName{
    NSLog(@"UI didGeneralSuccess strCMDName = %@",strCMDName);
    [self showToast:strCMDName message:@"Success"];
}
-(void)didGeneralERROR:(NSString*)strCMDName ErrMessage:(NSString*)strErrorMessage{
    [self showToast:@"ERROR" message:strErrorMessage];
}
- (void)didGetFirmwareVersion:(NSString *)fwVer {
    
}


-(void)didGetRfPower:(int)rfPower{
    
}
-(void)didGetRfSensitivity:(RfSensitivityLevel)rfSensitivity{
    
}
-(void)didGetTriggerType:(TriggerType)triggerType{
    
}

-(void)didDiscoverTagInfo:(GNPTagInfo*)taginfo{
}
-(void)didTagRemoved:(GNPTagInfo*)taginfo{
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        [self.textView resignFirstResponder];
    }
}
- (void)didGetFrequencyList:(NSArray *)frequencys{
    NSString* strFrequency = @"";
    for (int i = 0 ; i < [frequencys count]; i++) {
        double num = [[frequencys objectAtIndex:i]doubleValue];
        strFrequency = [NSString stringWithFormat:@"%@%0.2f, ", strFrequency, num];
    }
    strFrequency = [strFrequency substringWithRange:NSMakeRange(0, [strFrequency length]-2)];
    [self.textView setText:strFrequency];
}

-(void)showToast:(NSString*)title message:(NSString*)message {
    NSMutableString* allMesg = [NSMutableString stringWithString:title];
    [allMesg appendString:@" "];
    [allMesg appendString:message];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = allMesg;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:3];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.textView resignFirstResponder];
    return true;
}

- (void)didGetFilter:(TagDataEncodeType)tagDataEncodeTypes {
    NSLog(@"Setting2ViewController didGetFilter tagDataEncodeTypes = %d",tagDataEncodeTypes);
}
-(void)didGetPostDataDelimiter:(PostDataDelimiter) postDataDelimiter{
    NSLog(@"Setting2ViewController didGetPostDataDelimiter postDataDelimiter = %d",postDataDelimiter);
}
-(void)didGetMemoryBankSelection:(MemoryBankSelection) memoryBankSelection{
    NSLog(@"Setting2ViewController didGetMemoryBankSelection MemoryBankSelection = %d",memoryBankSelection);
}
-(void)didGetEventType:(EventType) eventType{
    NSLog(@"Setting2ViewController didGetEventType EventType = %d",eventType);
}
-(void)didGetOutputInterfaces:(int) settingValue {
    KeyboardSimulation keyboardSimulation = settingValue & 0x07;
    OutputInterface outputInterfaces = settingValue & 0xF8;
    NSLog(@"Setting2ViewController didGetOutputInterfaces keyboardSimulation = %d",keyboardSimulation);
    NSLog(@"Setting2ViewController didGetOutputInterfaces outputInterfaces = %d",outputInterfaces);
}

@end
