//
//  ReadWriteTagViewController.m
//  UHFSample
//
//  Created by Gianni on 2019/4/12.
//  Copyright © 2019 Gianni. All rights reserved.
//

#import "MBProgressHUD.h"
#import "ReadWriteTagViewController.h"
#import "DevDetailTabBarViewController.h"
#import "DevConnStatusViewController.h"

@interface ReadWriteTagViewController () <IUHFDeviceListener, UITextFieldDelegate>

@end

@implementation ReadWriteTagViewController
{
 
    UHFDevice* passDev;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.edtEPCHexString setDelegate:self];
    [self.edtAccessPWD setDelegate:self];
}
- (void)viewWillAppear:(BOOL)animated {
    [passDev setListener:self];
}


- (IBAction)actReadEPC:(id)sender {
    [passDev cmdReadEPC:self.edtAccessPWD.text];
}

- (IBAction)actWriteEPC:(id)sender {
    
    NSData* bEPC  = [GLog CreateDataWithHexString:self.edtEPCHexString.text];
    [passDev writeEpc:self.edtAccessPWD.text EPCData:bEPC];
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
    [self showToast:@"" message:@"Success"];
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

- (void)didReadTag:(NSData *)data {
    [self.edtEPCHexString setText:[GLog CreateHexStringWithData:data]];
}

-(void)didDiscoverTagInfo:(GNPTagInfo*)taginfo{
}
-(void)didTagRemoved:(GNPTagInfo*)taginfo{
    
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        [self.edtEPCHexString resignFirstResponder];
        [self.edtAccessPWD resignFirstResponder];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)showToast:(NSString*)title message:(NSString*)message {
    
    NSMutableString* allMesg = [NSMutableString stringWithString:title];
    [allMesg appendString:@" "];
    if (message) {
        [allMesg appendString:message];
    }
    
    
    NSLog(@"allMesg = %@",allMesg);
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = allMesg;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:3];
}


- (void)didDiscoverTagInfoEx:(GNPDecodedTagData *)decodedTagData {
    
}
@end
