//
//  NewAdvancedViewController.m
//  UHFSample
//
//  Created by JangJack on 2020/8/22.
//  Copyright © 2020 Gianni. All rights reserved.
//

#import "NewAdvancedViewController.h"
#import "TagItemTableViewCell.h"
#import <UHFSDK/GNPTagInfo.h>
#import <UHFSDK/TS100.h>
#import <UHFSDK/TS800.h>
#import <UHFSDK/UR0250.h>
#import <UHFSDK/BaseTagEvent.h>
#import "DevDetailTabBarViewController.h"
#import "NewDevConnStatusViewController.h"
#import "MBProgressHUD.h"

@interface NewAdvancedViewController () <UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,IUHFDeviceListener>

@property (weak, nonatomic) IBOutlet UITextField *textfieldBLEDeviceName;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerBuzzerAdapterOperation;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerControlBuzzerAdapter;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerOutputInterfaceTypes;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerKeyboardTypes;
@property (weak, nonatomic) IBOutlet UISwitch *switchHID_N_VCOM;
@property (weak, nonatomic) IBOutlet UILabel *labHID_N_VCOM;
@property (weak, nonatomic) IBOutlet UISwitch *switchBLE;
@property (weak, nonatomic) IBOutlet UILabel *labBLE;
@property (weak, nonatomic) IBOutlet UISwitch *switchTCP_CLIENT;
@property (weak, nonatomic) IBOutlet UILabel *labTCP_CLIENT;
@property (weak, nonatomic) IBOutlet UISwitch *switchTCP_SERVER;
@property (weak, nonatomic) IBOutlet UILabel *labTCP_SERVER;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerEventType;
@property (weak, nonatomic) IBOutlet UIStackView *stackREMOVE_EVENT;
@property (weak, nonatomic) IBOutlet UISwitch *switchREMOVE_EVENT;
@property (weak, nonatomic) IBOutlet UIStackView *stackTID_BANK;
@property (weak, nonatomic) IBOutlet UILabel *labREMOVE_EVENT;
@property (weak, nonatomic) IBOutlet UISwitch *switchTID_BANK;
@property (weak, nonatomic) IBOutlet UILabel *labTID_BANK;
@property (weak, nonatomic) IBOutlet UISwitch *switchUDC;
@property (weak, nonatomic) IBOutlet UILabel *labUDC;
@property (weak, nonatomic) IBOutlet UISwitch *switchSGTIN_96_EAS;
@property (weak, nonatomic) IBOutlet UILabel *labSGTIN_96_EAS;
@property (weak, nonatomic) IBOutlet UISwitch *switchSGTIN_96;
@property (weak, nonatomic) IBOutlet UILabel *labSGTIN_96;
@property (weak, nonatomic) IBOutlet UISwitch *switchRAW_DATA;
@property (weak, nonatomic) IBOutlet UILabel *labRAW_DATA;
@property (weak, nonatomic) IBOutlet UISwitch *switchADI;
@property (weak, nonatomic) IBOutlet UILabel *labADI;
@property (weak, nonatomic) IBOutlet UISwitch *switchCR;
@property (weak, nonatomic) IBOutlet UILabel *labCR;
@property (weak, nonatomic) IBOutlet UISwitch *switchLF;
@property (weak, nonatomic) IBOutlet UILabel *labLF;
@property (weak, nonatomic) IBOutlet UISwitch *switchTAB;
@property (weak, nonatomic) IBOutlet UILabel *labTAB;
@property (weak, nonatomic) IBOutlet UISwitch *switchPC;
@property (weak, nonatomic) IBOutlet UILabel *labPC;
@property (weak, nonatomic) IBOutlet UISwitch *switchEPC;
@property (weak, nonatomic) IBOutlet UILabel *labEPC;
@property (weak, nonatomic) IBOutlet UISwitch *switchTID;
@property (weak, nonatomic) IBOutlet UILabel *labTID;
@property (weak, nonatomic) IBOutlet UISwitch *switchEPC_ASCII;
@property (weak, nonatomic) IBOutlet UILabel *labEPC_ASCII;
@property (weak, nonatomic) IBOutlet UISlider *sliderRemoteHostConnectionTime;
@property (weak, nonatomic) IBOutlet UILabel *labRemoteHostConnectionTimeout;
@property (weak, nonatomic) IBOutlet UITextField *textFieldRemoteHostIP;
@property (weak, nonatomic) IBOutlet UITextField *textFieldRemoteHostPort;
@property (weak, nonatomic) IBOutlet UITextField *textFieldSSIDForWiFiSettings_1;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPasswordForWiFiSettings_1;
@property (weak, nonatomic) IBOutlet UITextField *textFieldSSIDForWiFiSettings_2;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPasswordForWiFiSettings_2;
@property (weak, nonatomic) IBOutlet UITextField *textFieldIPForWiFiSettings_2;
@property (weak, nonatomic) IBOutlet UITextField *textFieldGatewayForWiFiSettings_2;
@property (weak, nonatomic) IBOutlet UITextField *textFieldSubnetMaskForWiFiSettings_2;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerBarcodeReadFormat;
@property (weak, nonatomic) IBOutlet UITextField *textFieldFieldSeparator;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPrefix;
@property (weak, nonatomic) IBOutlet UITextField *textFieldSuffix;
@property (weak, nonatomic) IBOutlet UITextField *textFieldDeactivateEPCPrefix;
@property (weak, nonatomic) IBOutlet UITextField *textFieldReactivateEPCPrefix;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerTagProtection;
@property (weak, nonatomic) IBOutlet UITextField *textFieldTagProtectionAccessPassword;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerUsbInterface;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerOutputFormat;

@property (strong, nonatomic) IBOutlet UIView *customView;

@end

@implementation NewAdvancedViewController {
    NSMutableArray* allTagItems;
    UHFDevice* passDev;
    NewDevConnStatusViewController* childViewController;
    
    NSArray *buzzerAdapterOperation;
    NSArray *controlBuzzerAdapter;
    NSArray *outputInterfaceTypes;
    NSArray *keyboardTypes;
    NSArray *eventType;
    NSArray *barcodeReadFormat;
    NSArray *tagProtection;
    NSArray *usbInterface;
    NSArray *outputFormat;
    
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
    
    buzzerAdapterOperation = @[@"OFF", @"ONCE", @"REPEAT"];
    controlBuzzerAdapter = @[@"SUCCESS", @"FAILURE", @"DISABLE", @"AUTO"];
    outputInterfaceTypes = @[@"AUTO", @"NOT_AUTO"];
    keyboardTypes = @[@"DISABLE", @"HID_KEYBOARD", @"BLE_KEYBOARD"];
    if ([self->passDev isMemberOfClass:[TS100 class]]) {
        eventType = @[@"TAG_PRESENTED_EVENT", @"TAG_PRESENTED_EVENT_EX"];
    } else if ([self->passDev isMemberOfClass:[TS800 class]]) {
        eventType = @[@"TAG_PRESENTED_EVENT"];
    } else if ([self->passDev isMemberOfClass:[UR0250 class]]) {
        eventType = @[@"TAG_PRESENTED_EVENT", @"TAG_PRESENTED_EVENT_EX"];
    }
    barcodeReadFormat = @[@"GTIN_14", @"GTIN_13", @"GTIN_12", @"GTIN_8"];
    tagProtection = @[@"SPECIFIED_PASSWORD", @"DYNAMIC_PASSWORD", @"DISABLE"];
    usbInterface = @[@"VIRTUAL_COMM_PORT", @"HID"];
    outputFormat = @[@"DISABLE", @"AI_BARCODE_SN"];
    
    self.pickerBuzzerAdapterOperation.dataSource = self;
    self.pickerBuzzerAdapterOperation.delegate = self;
    [self.pickerBuzzerAdapterOperation setTag:1];
    [self.pickerBuzzerAdapterOperation selectRow:0 inComponent:0 animated:true];
    
    self.pickerControlBuzzerAdapter.dataSource = self;
    self.pickerControlBuzzerAdapter.delegate = self;
    [self.pickerControlBuzzerAdapter setTag:2];
    [self.pickerControlBuzzerAdapter selectRow:0 inComponent:0 animated:true];
    
    self.pickerKeyboardTypes.dataSource = self;
    self.pickerKeyboardTypes.delegate = self;
    [self.pickerKeyboardTypes setTag:3];
    [self.pickerKeyboardTypes selectRow:0 inComponent:0 animated:true];
    
    self.pickerEventType.dataSource = self;
    self.pickerEventType.delegate = self;
    [self.pickerEventType setTag:4];
    [self.pickerEventType selectRow:0 inComponent:0 animated:true];
    
    self.pickerBarcodeReadFormat.dataSource = self;
    self.pickerBarcodeReadFormat.delegate = self;
    [self.pickerBarcodeReadFormat setTag:5];
    [self.pickerBarcodeReadFormat selectRow:0 inComponent:0 animated:true];
    
    self.pickerOutputInterfaceTypes.dataSource = self;
    self.pickerOutputInterfaceTypes.delegate = self;
    [self.pickerOutputInterfaceTypes setTag:6];
    [self.pickerOutputInterfaceTypes selectRow:0 inComponent:0 animated:true];
    
    self.pickerTagProtection.dataSource = self;
    self.pickerTagProtection.delegate = self;
    [self.pickerTagProtection setTag:7];
    [self.pickerTagProtection selectRow:0 inComponent:0 animated:true];
    
    self.pickerUsbInterface.dataSource = self;
    self.pickerUsbInterface.delegate = self;
    [self.pickerUsbInterface setTag:8];
    [self.pickerUsbInterface selectRow:0 inComponent:0 animated:true];
    
    self.pickerOutputFormat.dataSource = self;
    self.pickerOutputFormat.delegate = self;
    [self.pickerOutputFormat setTag:9];
    [self.pickerOutputFormat selectRow:0 inComponent:0 animated:true];

    keyboardIsUp = false;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    [self pickerView:self.pickerOutputInterfaceTypes didSelectRow:0 inComponent:0];
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
            iCount = buzzerAdapterOperation.count;
        }
            break;

        case 2: {
            iCount = controlBuzzerAdapter.count;
        }
            break;

        case 3: {
            iCount = keyboardTypes.count;
        }
            break;

        case 4: {
            iCount = eventType.count;
        }
            break;

        case 5: {
            iCount = barcodeReadFormat.count;
        }
            break;

        case 6: {
            iCount = outputInterfaceTypes.count;
        }
            break;

        case 7: {
            iCount = tagProtection.count;
        }
            break;

        case 8: {
            iCount = usbInterface.count;
        }
            break;

        case 9: {
            iCount = outputFormat.count;
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
            strValue = buzzerAdapterOperation[row];
        }
            break;
            
        case 2: {
            strValue = controlBuzzerAdapter[row];
        }
            break;
                
        case 3: {
            strValue = keyboardTypes[row];
        }
            break;
                    
        case 4: {
            strValue = eventType[row];
        }
            break;
                    
        case 5: {
            strValue = barcodeReadFormat[row];
        }
            break;
            
        case 6: {
            strValue = outputInterfaceTypes[row];
        }
            break;
            
        case 7: {
            strValue = tagProtection[row];
        }
            break;
            
        case 8: {
            strValue = usbInterface[row];
        }
            break;
            
        case 9: {
            strValue = outputFormat[row];
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
    switch (pickerView.tag) {
        case 4: {
            if (row == 0) {
                [self.stackREMOVE_EVENT setHidden:false];
                [self.stackTID_BANK setHidden:false];
            } else {
                [self.stackREMOVE_EVENT setHidden:true];
                [self.stackTID_BANK setHidden:true];
            }
        }
            break;
            
        case 6: {
            if (row == 0) {
                [self.pickerKeyboardTypes setHidden:true];
                [self.switchTCP_CLIENT setHidden:true];
                [self.labTCP_CLIENT setHidden:true];
                [self.switchTCP_SERVER setHidden:true];
                [self.labTCP_SERVER setHidden:true];
                [self.switchBLE setHidden:true];
                [self.labBLE setHidden:true];
                [self.switchHID_N_VCOM setHidden:true];
                [self.labHID_N_VCOM setHidden:true];
            } else {
                [self.pickerKeyboardTypes setHidden:false];
                [self.switchTCP_CLIENT setHidden:false];
                [self.labTCP_CLIENT setHidden:false];
                [self.switchTCP_SERVER setHidden:false];
                [self.labTCP_SERVER setHidden:false];
                [self.switchBLE setHidden:false];
                [self.labBLE setHidden:false];
                [self.switchHID_N_VCOM setHidden:false];
                [self.labHID_N_VCOM setHidden:false];
            }
        }
            break;
            
        default:
            break;
    }
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
            strValue = buzzerAdapterOperation[row];
        }
            break;
            
        case 2: {
            strValue = controlBuzzerAdapter[row];
        }
            break;
                
        case 3: {
            strValue = keyboardTypes[row];
        }
            break;
                    
        case 4: {
            strValue = eventType[row];
        }
            break;
                    
        case 5: {
            strValue = barcodeReadFormat[row];
        }
            break;

        case 6: {
            strValue = outputInterfaceTypes[row];
        }
            break;

        case 7: {
            strValue = tagProtection[row];
        }
            break;

        case 8: {
            strValue = usbInterface[row];
        }
            break;

        case 9: {
            strValue = outputFormat[row];
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

- (IBAction)actGetBLEDeviceName:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            if ([self->passDev isMemberOfClass:[TS100 class]]) {
                TS100 *ts100 = (TS100 *) self->passDev;
                
                [ts100 getBleDeviceName];
            } else if ([self->passDev isMemberOfClass:[TS800 class]]) {
                TS800 *ts800 = (TS800 *) self->passDev;
                
                [ts800 getBleDeviceName];
            } else if ([self->passDev isMemberOfClass:[UR0250 class]]) {
                UR0250 *ur0250 = (UR0250 *) self->passDev;
                
                [ur0250 getBleDeviceName];
            }
        }
    }
}

- (IBAction)actSetBLEDeviceName:(id)sender {
    NSString *deviceName = self->_textfieldBLEDeviceName.text;
    
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            if ([self->passDev isMemberOfClass:[TS100 class]]) {
                TS100 *ts100 = (TS100 *) self->passDev;
                
                [ts100 setBleDeviceName:deviceName];
            } else if ([self->passDev isMemberOfClass:[TS800 class]]) {
                TS800 *ts800 = (TS800 *) self->passDev;
                
                [ts800 setBleDeviceName:deviceName];
            } else if ([self->passDev isMemberOfClass:[UR0250 class]]) {
                UR0250 *ur0250 = (UR0250 *) self->passDev;
                
                [ur0250 setBleDeviceName:deviceName];
            }
        }
    }
}

- (IBAction)actGetBuzzerAdaapterOperation:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            if ([self->passDev isMemberOfClass:[TS100 class]]) {
                TS100 *ts100 = (TS100 *) self->passDev;
                
                [ts100 getBuzzerOperationMode:false];
            } else if ([self->passDev isMemberOfClass:[TS800 class]]) {
                TS800 *ts800 = (TS800 *) self->passDev;
                
                [ts800 getBuzzerOperationMode:false];
            }
        }
    }
}

- (IBAction)actSetBuzzerAdapterOperation:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            BuzzerOperationMode buzzerOperationMode;
            switch ([self.pickerBuzzerAdapterOperation selectedRowInComponent:0]) {
                case 0: {
                    buzzerOperationMode = BOM_Off;
                }
                    break;
                
                case 1: {
                    buzzerOperationMode = BOM_Once;
                }
                    break;
                    
                case 2: {
                    buzzerOperationMode = BOM_Repeat;
                }
                    break;

                default: {
                    buzzerOperationMode = BOM_Off;
                    
                }
                    break;
            }
            if ([self->passDev isMemberOfClass:[TS100 class]]) {
                TS100 *ts100 = (TS100 *) self->passDev;
                
                [ts100 setBuzzerOperationMode:false BuzzerOperationMode:buzzerOperationMode];
            } else if ([self->passDev isMemberOfClass:[TS800 class]]) {
                TS800 *ts800 = (TS800 *) self->passDev;
                
                [ts800 setBuzzerOperationMode:false BuzzerOperationMode:buzzerOperationMode];
            }
        }
    }
}

- (IBAction)actControlBuzzerAdapter:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            BuzzerAction buzzerAction;
            switch ([self.pickerControlBuzzerAdapter selectedRowInComponent:0]) {
                case 0: {
                    buzzerAction = BA_Success;
                }
                    break;
                
                case 1: {
                    buzzerAction = BA_Failure;
                }
                    break;
                    
                case 2: {
                    buzzerAction = BA_Disable;
                }
                    break;
                    
                case 3: {
                    buzzerAction = BA_Auto;
                }
                    break;

                default: {
                    buzzerAction = BA_Success;
                    
                }
                    break;
            }
            if ([self->passDev isMemberOfClass:[TS100 class]]) {
                TS100 *ts100 = (TS100 *) self->passDev;
                
                [ts100 controlBuzzer:buzzerAction];
            } else if ([self->passDev isMemberOfClass:[TS800 class]]) {
                TS800 *ts800 = (TS800 *) self->passDev;
                
                [ts800 controlBuzzer:buzzerAction];
            }
        }
    }
}

- (IBAction)actGetOutputInterfaces:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            if ([self->passDev isMemberOfClass:[TS100 class]]) {
                TS100 *ts100 = (TS100 *) self->passDev;
                
                [ts100 getOutputInterfaces:false];
            }
        }
    }
}

- (IBAction)actSetOutputInterfaces:(id)sender {
    KeyboardSimulation keyboardSimulation = KS_DISABLE;
//    OutputInterface outputInterfaces = 0x00;
    NSMutableSet *outputInterfaces = [[NSMutableSet alloc] init];
    
    if ([self.pickerOutputInterfaceTypes selectedRowInComponent:0] == 0) {
        [outputInterfaces addObject:@(OI_Default_1_0)];
    } else {
        switch ([self.pickerKeyboardTypes selectedRowInComponent:0]) {
            case 0: {
                keyboardSimulation = KS_DISABLE;
            }
                break;
            
            case 1: {
                keyboardSimulation = KS_HID_KEYBOARD;
            }
                break;
                
            case 2: {
                keyboardSimulation = KS_BLE_KEYBOARD;
            }
                break;

            default: {
                keyboardSimulation = KS_DISABLE;
                
            }
                break;
        }
        
        if ([self.switchHID_N_VCOM isOn]) {
            [outputInterfaces addObject:@(OI_HID_N_VCOM)];
        }
        
        if ([self.switchBLE isOn]) {
            [outputInterfaces addObject:@(OI_BLE)];
        }
        
        if ([self.switchTCP_CLIENT isOn]) {
            [outputInterfaces addObject:@(OI_TCP_CLIENT)];
        }
        
        if ([self.switchTCP_SERVER isOn]) {
            [outputInterfaces addObject:@(OI_TCP_SERVER)];
        }
    }

    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            if ([self->passDev isMemberOfClass:[TS100 class]]) {
                TS100 *ts100 = (TS100 *) self->passDev;
                
                [ts100 setOutputInterfaces:false KeyboardSimulation:keyboardSimulation OutputInterface:outputInterfaces];
            }
        }
    }
}

- (IBAction)actGetEventType:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            if ([self->passDev isMemberOfClass:[TS100 class]]) {
                TS100 *ts100 = (TS100 *) self->passDev;
                
                [ts100 getEventType:false];
            } else if ([self->passDev isMemberOfClass:[TS800 class]]) {
                TS800 *ts800 = (TS800 *) self->passDev;
                
                [ts800 getEventType:false];
            } else if ([self->passDev isMemberOfClass:[UR0250 class]]) {
                UR0250 *ur0250 = (UR0250 *) self->passDev;
                
                [ur0250 getEventType:false];
            }
        }
    }
}

- (IBAction)actSetEventType:(id)sender {
    BaseTagEvent *baseTagEvent = [[BaseTagEvent alloc] init];
    
    switch ([self.pickerEventType selectedRowInComponent:0]) {
        case 0: {
            [baseTagEvent addEventType:ET_TagPresented];
            [baseTagEvent setTagRemovePresented:[self.switchREMOVE_EVENT isOn]];
            [baseTagEvent setTidBank:[self.switchTID_BANK isOn]];
        }
            break;
        
        case 1: {
            [baseTagEvent addEventType:ET_TagPresentedEx];
        }
            break;

        default: {
            [baseTagEvent addEventType:ET_TagPresented];
            [baseTagEvent setTagRemovePresented:[self.switchREMOVE_EVENT isOn]];
            [baseTagEvent setTidBank:[self.switchTID_BANK isOn]];
        }
            break;
    }
    
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            if ([self->passDev isMemberOfClass:[TS100 class]]) {
                TS100 *ts100 = (TS100 *) self->passDev;
                
                [ts100 setEventType:false EventType:baseTagEvent];
            } else if ([self->passDev isMemberOfClass:[TS800 class]]) {
                TS800 *ts800 = (TS800 *) self->passDev;
                
                [ts800 setEventType:false EventType:baseTagEvent];
            } else if ([self->passDev isMemberOfClass:[UR0250 class]]) {
                UR0250 *ur0250 = (UR0250 *) self->passDev;
                
                [ur0250 setEventType:false EventType:baseTagEvent];
            }
        }
    }
}

- (IBAction)actGetFilter:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            if ([self->passDev isMemberOfClass:[TS100 class]]) {
                TS100 *ts100 = (TS100 *) self->passDev;
                
                [ts100 getFilter:false];
            }
        }
    }
}

- (IBAction)actSetFilter:(id)sender {
//    TagDataEncodeType tagDataEncodeTypes = 0x00;
    NSMutableSet *tagDataEncodeTypes = [[NSMutableSet alloc] init];
    
    if ([self.switchUDC isOn]) {
//        tagDataEncodeTypes = tagDataEncodeTypes | TDE_UDC;
        [tagDataEncodeTypes addObject:@(TDE_UDC)];
    }
    
    if ([self.switchSGTIN_96_EAS isOn]) {
//        tagDataEncodeTypes = tagDataEncodeTypes | TDE_SGTIN_96_EAS;
        [tagDataEncodeTypes addObject:@(TDE_SGTIN_96_EAS)];
    }
    
    if ([self.switchSGTIN_96 isOn]) {
//        tagDataEncodeTypes = tagDataEncodeTypes | TDE_SGTIN_96;
        [tagDataEncodeTypes addObject:@(TDE_SGTIN_96)];
    }
    
    if ([self.switchRAW_DATA isOn]) {
//        tagDataEncodeTypes = tagDataEncodeTypes | TDE_RAW_DATA;
        [tagDataEncodeTypes addObject:@(TDE_RAW_DATA)];
    }
    
    if ([self.switchADI isOn]) {
//        tagDataEncodeTypes = tagDataEncodeTypes | TDE_ADI;
        [tagDataEncodeTypes addObject:@(TDE_ADI)];
    }

    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            if ([self->passDev isMemberOfClass:[TS100 class]]) {
                TS100 *ts100 = (TS100 *) self->passDev;
                
                [ts100 setFilter:false TagDataEncodeType:tagDataEncodeTypes];
            }
        }
    }
}

- (IBAction)actGetPostDataDelimiter:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            if ([self->passDev isMemberOfClass:[TS100 class]]) {
                TS100 *ts100 = (TS100 *) self->passDev;
                
                [ts100 getPostDataDelimiter:false];
            }
        }
    }
}

- (IBAction)actSetPostDataDelimiter:(id)sender {
//    PostDataDelimiter postDataDelimiter = 0x00;
    NSMutableSet *postDataDelimiter = [[NSMutableSet alloc] init];
    
    if ([self.switchCR isOn]) {
//        postDataDelimiter = postDataDelimiter | PDD_CARRIAGE;
        [postDataDelimiter addObject:@(PDD_CARRIAGE)];
    }
    
    if ([self.switchLF isOn]) {
//        postDataDelimiter = postDataDelimiter | PDD_LINE;
        [postDataDelimiter addObject:@(PDD_LINE)];
    }
    
    if ([self.switchTAB isOn]) {
//        postDataDelimiter = postDataDelimiter | PDD_TAB;
        [postDataDelimiter addObject:@(PDD_TAB)];
    }
    
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            if ([self->passDev isMemberOfClass:[TS100 class]]) {
                TS100 *ts100 = (TS100 *) self->passDev;
                
                [ts100 setPostDataDelimiter:false PostDataDelimiter:postDataDelimiter];
            }
        }
    }
}

- (IBAction)actGetMemorySelection:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            if ([self->passDev isMemberOfClass:[TS100 class]]) {
                TS100 *ts100 = (TS100 *) self->passDev;
                
                [ts100 getTagMemorySelection:false];
            }
        }
    }
}

- (IBAction)actSetMemroySelection:(id)sender {
//    TagMemorySelection tagMemorySelection = 0x00;
    NSMutableSet *tagMemorySelection = [[NSMutableSet alloc] init];
    
    if ([self.switchPC isOn]) {
//        tagMemorySelection = tagMemorySelection | TM_PC;
        [tagMemorySelection addObject:@(TM_PC)];
    }
    
    if ([self.switchEPC isOn]) {
//        tagMemorySelection = tagMemorySelection | TM_EPC;
        [tagMemorySelection addObject:@(TM_EPC)];
    }
    
    if ([self.switchTID isOn]) {
//        tagMemorySelection = tagMemorySelection | TM_TID;
        [tagMemorySelection addObject:@(TM_TID)];
    }

    if ([self.switchEPC_ASCII isOn]) {
//        tagMemorySelection = tagMemorySelection | TM_EPC_ASCII;
        if ([self.switchPC isOn] || [self.switchEPC isOn] || [self.switchTID isOn]) {
            [childViewController addLog:@"Unsupported Parameter: EPC_ASCII couldn't set with others"];
            return;
        } else {
            [tagMemorySelection addObject:@(TM_EPC_ASCII)];
        }
    }
    
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            if ([self->passDev isMemberOfClass:[TS100 class]]) {
                TS100 *ts100 = (TS100 *) self->passDev;
                
                [ts100 setTagMemorySelection:false TagMemory:tagMemorySelection];
            }
        }
    }
}

- (IBAction)actGetRemoteHost:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            if ([self->passDev isMemberOfClass:[TS100 class]]) {
                TS100 *ts100 = (TS100 *) self->passDev;
                
                [ts100 getRemoteHost];
            } else if ([self->passDev isMemberOfClass:[TS800 class]]) {
                TS800 *ts800 = (TS800 *) self->passDev;
                
                [ts800 getRemoteHost];
            } else if ([self->passDev isMemberOfClass:[UR0250 class]]) {
                UR0250 *ur0250 = (UR0250 *) self->passDev;
                
                [ur0250 getRemoteHost];
            }
        }
    }
}

- (IBAction)actSetRemoteHost:(id)sender {
    NSString *ipAddress = self.textFieldRemoteHostIP.text;
    int port = [self.textFieldRemoteHostPort.text intValue];
    int connectionTimeout = round(100 * self.sliderRemoteHostConnectionTime.value) / 100;
    InetAddress *inetAddress = [[InetAddress alloc] init:ipAddress];
    InetSocketAddress *inetSocketAddress = [[InetSocketAddress alloc] init:inetAddress Port:port];

    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            if ([self->passDev isMemberOfClass:[TS100 class]]) {
                TS100 *ts100 = (TS100 *) self->passDev;
                
                [ts100 setRemoteHost:connectionTimeout InetSocketAddress:inetSocketAddress];
            } else if ([self->passDev isMemberOfClass:[TS800 class]]) {
                TS800 *ts800 = (TS800 *) self->passDev;
                
                [ts800 setRemoteHost:connectionTimeout InetSocketAddress:inetSocketAddress];
            } else if ([self->passDev isMemberOfClass:[UR0250 class]]) {
                UR0250 *ur0250 = (UR0250 *) self->passDev;
                
                [ur0250 setRemoteHost:connectionTimeout InetSocketAddress:inetSocketAddress];
            }
        }
    }
}

- (IBAction)actRemoteHostConnectionChanged:(id)sender {
    UISlider *slider = (UISlider *) sender;
    int final = round(100 * slider.value) / 100;
    
    self->_labRemoteHostConnectionTimeout.text = [NSString stringWithFormat:@"%d", final];
}

- (IBAction)actSetWiFiSettings_1:(id)sender {
    NSString *ssid = self->_textFieldSSIDForWiFiSettings_1.text;
    NSString *password = self->_textFieldPasswordForWiFiSettings_1.text;
    
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            if ([self->passDev isMemberOfClass:[TS100 class]]) {
                TS100 *ts100 = (TS100 *) self->passDev;
                
                [ts100 setWifiSettings:ssid PWD:password];
            } else if ([self->passDev isMemberOfClass:[TS800 class]]) {
                TS800 *ts800 = (TS800 *) self->passDev;
                
                [ts800 setWifiSettings:ssid PWD:password];
            } else if ([self->passDev isMemberOfClass:[UR0250 class]]) {
                UR0250 *ur0250 = (UR0250 *) self->passDev;
                
                [ur0250 setWifiSettings:ssid PWD:password];
            }
        }
    }
}

- (IBAction)actSetWiFiSettings_2:(id)sender {
    NSString *ssid = self->_textFieldSSIDForWiFiSettings_2.text;
    NSString *password = self->_textFieldPasswordForWiFiSettings_2.text;
    NSString *ip = self->_textFieldIPForWiFiSettings_2.text;
    NSString *gateway = self->_textFieldGatewayForWiFiSettings_2.text;
    NSString *subnetMask = self->_textFieldSubnetMaskForWiFiSettings_2.text;
    
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            if ([self->passDev isMemberOfClass:[TS100 class]]) {
                TS100 *ts100 = (TS100 *) self->passDev;
                
                [ts100 setWifiSettings:ssid PWD:password IP:ip Gateway:gateway SubNetMask:subnetMask];
            } else if ([self->passDev isMemberOfClass:[TS800 class]]) {
                TS800 *ts800 = (TS800 *) self->passDev;
                
                [ts800 setWifiSettings:ssid PWD:password IP:ip Gateway:gateway SubNetMask:subnetMask];
            } else if ([self->passDev isMemberOfClass:[UR0250 class]]) {
                UR0250 *ur0250 = (UR0250 *) self->passDev;
                
                [ur0250 setWifiSettings:ssid PWD:password IP:ip Gateway:gateway SubNetMask:subnetMask];
            }
        }
    }
}

- (IBAction)actGetWiFiMacAddress:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            if ([self->passDev isMemberOfClass:[TS100 class]]) {
                TS100 *ts100 = (TS100 *) self->passDev;
                
                [ts100 getWiFiMacAddress];
            } else if ([self->passDev isMemberOfClass:[TS800 class]]) {
                TS800 *ts800 = (TS800 *) self->passDev;
                
                [ts800 getWiFiMacAddress];
            } else if ([self->passDev isMemberOfClass:[UR0250 class]]) {
                UR0250 *ur0250 = (UR0250 *) self->passDev;
                
                [ur0250 getWiFiMacAddress];
            }
        }
    }
}

- (IBAction)actGetBarcodeReadFormat:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            if ([self->passDev isMemberOfClass:[TS100 class]]) {
                TS100 *ts100 = (TS100 *) self->passDev;
                
                [ts100 getBarcodeReadFormat:false];
            }
        }
    }
}

- (IBAction)actSetBarcodeReadFormat:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            BarcodeFormat barcodeFormat;
            switch ([self.pickerBarcodeReadFormat selectedRowInComponent:0]) {
                case 0: {
                    barcodeFormat = GTIN_14;
                }
                    break;
                
                case 1: {
                    barcodeFormat = GTIN_13;
                }
                    break;
                    
                case 2: {
                    barcodeFormat = GTIN_12;
                }
                    break;
                    
                case 3: {
                    barcodeFormat = GTIN_8;
                }
                    break;

                default: {
                    barcodeFormat = GTIN_14;
                    
                }
                    break;
            }
            if ([self->passDev isMemberOfClass:[TS100 class]]) {
                TS100 *ts100 = (TS100 *) self->passDev;
                
                [ts100 setBarcodeReadFormat:false BarcodeFormat:barcodeFormat];
            }
        }
    }
}

- (IBAction)actGetFieldSeparator:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            if ([self->passDev isMemberOfClass:[TS100 class]]) {
                TS100 *ts100 = (TS100 *) self->passDev;
                
                [ts100 getFieldSeparator:false];
            }
        }
    }
}

- (IBAction)actSetFieldSeparator:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            NSString *string = [self->_textFieldFieldSeparator.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if ([string length] == 0) {
                string = @",";
            }
            else if ([string length] != 1) {
                [childViewController addLog:@"Parameter Fix Length Should be: 1"];
            }
            NSData *separator = [string dataUsingEncoding:NSUTF8StringEncoding];
//            NSData *separator = [TS100 dataFromHexString:string];
            NSMutableData *data = [NSMutableData dataWithCapacity:1];
            char byteChars = [string characterAtIndex:0];
            [data appendBytes:&byteChars length:1];
            
            [childViewController addLog:[NSString stringWithFormat:@"actSetFieldSeparator, separator = %@, %@",separator, data]];
            if ([self->passDev isMemberOfClass:[TS100 class]]) {
                TS100 *ts100 = (TS100 *) self->passDev;

                [ts100 setFieldSeparator:false FieldSeparator:separator];
            }
        }
    }
}

- (IBAction)actGetPrefix:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            if ([self->passDev isMemberOfClass:[TS100 class]]) {
                TS100 *ts100 = (TS100 *) self->passDev;
                
                [ts100 getPrefix:false];
            }
        }
    }
}

- (IBAction)actSetPrefix:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            NSString *string = [self->_textFieldPrefix.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if ([string length] != 16) {
                [childViewController addLog:@"Parameter Fix Length Should be: 16"];
            }
            NSData *prefixes = [string dataUsingEncoding:NSUTF8StringEncoding];
            
            [childViewController addLog:[NSString stringWithFormat:@"actSetPrefix, prefixes = %@",prefixes]];
            if ([self->passDev isMemberOfClass:[TS100 class]]) {
                TS100 *ts100 = (TS100 *) self->passDev;

                [ts100 setPrefix:false Prefix:prefixes];
            }
        }
    }
}

- (IBAction)actGetSuffix:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            if ([self->passDev isMemberOfClass:[TS100 class]]) {
                TS100 *ts100 = (TS100 *) self->passDev;
                
                [ts100 getSuffix:false];
            }
        }
    }
}

- (IBAction)actSetSuffix:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            NSString *string = [self->_textFieldSuffix.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if ([string length] != 16) {
                [childViewController addLog:@"Parameter Fix Length Should be: 16"];
            }
            NSData *suffixes = [string dataUsingEncoding:NSUTF8StringEncoding];
            
            [childViewController addLog:[NSString stringWithFormat:@"actSetSuffix, suffixes = %@",suffixes]];
            if ([self->passDev isMemberOfClass:[TS100 class]]) {
                TS100 *ts100 = (TS100 *) self->passDev;

                [ts100 setSuffix:false Suffix:suffixes];
            }
        }
    }
}

- (IBAction)actGetDeactivateEPCPrefix:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            if ([self->passDev isMemberOfClass:[TS100 class]]) {
                TS100 *ts100 = (TS100 *) self->passDev;
                
                [ts100 getDeactivateEpcPrefix:false];
            }
        }
    }
}

- (IBAction)actSetDeactivateEPCPrefix:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            NSData* prefixes  = [GLog CreateDataWithHexString:self->_textFieldDeactivateEPCPrefix.text];
            if ([self->passDev isMemberOfClass:[TS100 class]]) {
                TS100 *ts100 = (TS100 *) self->passDev;
                
                [ts100 setDeactivateEpcPrefix:false Prefix:prefixes];
            }
        }
    }
}

- (IBAction)actGetReactivateEPCPrefix:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            if ([self->passDev isMemberOfClass:[TS100 class]]) {
                TS100 *ts100 = (TS100 *) self->passDev;
                
                [ts100 getReactivateEpcPrefix:false];
            }
        }
    }
}

- (IBAction)actSetReactivateEPCPrefix:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            NSData* prefixes  = [GLog CreateDataWithHexString:self->_textFieldReactivateEPCPrefix.text];
            if ([self->passDev isMemberOfClass:[TS100 class]]) {
                TS100 *ts100 = (TS100 *) self->passDev;
                
                [ts100 setReactivateEpcPrefix:false Prefix:prefixes];
            }
        }
    }
}

- (IBAction)actGetTagProtection:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            if ([self->passDev isMemberOfClass:[TS100 class]]) {
                TS100 *ts100 = (TS100 *) self->passDev;
                
                [ts100 getTagProtection:false];
            }
        }
    }
}

- (IBAction)actSetTagProtection:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            TagProtection tagProtection;
            switch ([self.pickerTagProtection selectedRowInComponent:0]) {
                case 0: {
                    tagProtection = TP_Specified_Password;
                }
                    break;
                
                case 1: {
                    tagProtection = TP_Dynamic_Password;
                }
                    break;
                    
                case 2: {
                    tagProtection = TP_Disabled;
                }
                    break;

                default: {
                    tagProtection = TP_Specified_Password;
                    
                }
                    break;
            }
            if ([self->passDev isMemberOfClass:[TS100 class]]) {
                TS100 *ts100 = (TS100 *) self->passDev;
                
                [ts100 setTagProtection:false TagProtection:tagProtection];

            }
        }
    }
}

- (IBAction)actGetTagProtectionAccessPassword:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            if ([self->passDev isMemberOfClass:[TS100 class]]) {
                TS100 *ts100 = (TS100 *) self->passDev;
                
                [ts100 getTagProtectionAccessPassword];
            }
        }
    }
}

- (IBAction)actSetTagProtectionAccessPassword:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            NSData* accessPassword  = [GLog CreateDataWithHexString:self->_textFieldTagProtectionAccessPassword.text];
            if ([self->passDev isMemberOfClass:[TS100 class]]) {
                TS100 *ts100 = (TS100 *) self->passDev;
                
                [ts100 setTagProtectionAccessPassword:accessPassword];
            }
        }
    }
}

- (IBAction)actGetUsbInterface:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            if ([self->passDev isMemberOfClass:[TS100 class]]) {
                TS100 *ts100 = (TS100 *) self->passDev;
                
                [ts100 getUsbInterface:false];
            }
        }
    }
}

- (IBAction)actSetUsbInterface:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            UsbInterface usbInterface;
            switch ([self.pickerUsbInterface selectedRowInComponent:0]) {
                case 0: {
                    usbInterface = UI_VIRTUAL_COMPORT;
                }
                    break;
                
                case 1: {
                    usbInterface = UI_HID;
                }
                    break;

                default: {
                    usbInterface = UI_VIRTUAL_COMPORT;
                    
                }
                    break;
            }
            if ([self->passDev isMemberOfClass:[TS100 class]]) {
                TS100 *ts100 = (TS100 *) self->passDev;
                
                [ts100 setUsbInterface:false UsbInterface:usbInterface];
            }
        }
    }
}

- (IBAction)actGetOutputFormat:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            if ([self->passDev isMemberOfClass:[TS100 class]]) {
                TS100 *ts100 = (TS100 *) self->passDev;
                
                [ts100 getOutputFormat:false];
            }
        }
    }
}

- (IBAction)actSetOutputFormat:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            OutputFormat outputFormat;
            switch ([self.pickerOutputFormat selectedRowInComponent:0]) {
                case 0: {
                    outputFormat = OF_DISABLED;
                }
                    break;
                
                case 1: {
                    outputFormat = OF_AI_BARCODE_SERIAL_NUMBER;
                }
                    break;

                default: {
                    outputFormat = OF_DISABLED;
                    
                }
                    break;
            }
            if ([self->passDev isMemberOfClass:[TS100 class]]) {
                TS100 *ts100 = (TS100 *) self->passDev;
                
                [ts100 setOutputFormat:false OutputFormat:outputFormat];
            }
        }
    }
}

#pragma mark - UHF API Callback

-(void)didGetBleDeviceName:(NSString *)devName{
    [childViewController addLog:[NSString stringWithFormat:@"didGetBleDeviceName, devName = %@",devName]];
    self->_textfieldBLEDeviceName.text = devName;
}

-(void)didGetBuzzerOperationMode:(BuzzerOperationMode) bom {
    [childViewController addLog:[NSString stringWithFormat:@"didGetBuzzerOperationMode, bom = %d",bom]];
    
    switch (bom) {
        case BOM_Off: {
            [self.pickerBuzzerAdapterOperation selectRow:0 inComponent:0 animated:true];
        }
            break;
            
        case BOM_Once: {
            [self.pickerBuzzerAdapterOperation selectRow:1 inComponent:0 animated:true];
        }
            break;
            
        case BOM_Repeat: {
            [self.pickerBuzzerAdapterOperation selectRow:2 inComponent:0 animated:true];
        }
            break;

        default:
            break;
    }
}

-(void)didGetOutputInterfaces:(int) settingValue {
    [childViewController addLog:[NSString stringWithFormat:@"didGetOutputInterfaces, settingValue = %d",settingValue]];
    
    if ((settingValue & 0xFF) == 0xFF) {
        [self.pickerOutputInterfaceTypes selectRow:0 inComponent:0 animated:true];
        [self pickerView:self.pickerOutputInterfaceTypes didSelectRow:0 inComponent:0];
    } else {
        [self.pickerOutputInterfaceTypes selectRow:1 inComponent:0 animated:true];
        [self pickerView:self.pickerOutputInterfaceTypes didSelectRow:1 inComponent:0];
        KeyboardSimulation keyboardSimulation = settingValue & 0x07;
        OutputInterface outputInterfaces = settingValue & 0xF8;

        if ((keyboardSimulation & 0x06) == 0x06) {
            [self.pickerKeyboardTypes selectRow:0 inComponent:0 animated:true];
        } else if ((keyboardSimulation & KS_HID_KEYBOARD) == KS_HID_KEYBOARD) {
            [self.pickerKeyboardTypes selectRow:1 inComponent:0 animated:true];
        } else if ((keyboardSimulation & KS_BLE_KEYBOARD) == KS_BLE_KEYBOARD) {
            [self.pickerKeyboardTypes selectRow:2 inComponent:0 animated:true];
        }

        [self.switchHID_N_VCOM setOn:(outputInterfaces & OI_HID_N_VCOM) == OI_HID_N_VCOM];
        [self.switchBLE setOn:(outputInterfaces & OI_BLE) == OI_BLE];
        [self.switchTCP_CLIENT setOn:(outputInterfaces & OI_TCP_CLIENT) == OI_TCP_CLIENT];
        [self.switchTCP_SERVER setOn:(outputInterfaces & OI_TCP_SERVER) == OI_TCP_SERVER];
    }
}

-(void)didGetEventType:(EventType) eventType{
    [childViewController addLog:[NSString stringWithFormat:@"didGetEventType, eventType = %d",eventType]];
    
    if (eventType == ET_TagPresentedEx) {
        [self.pickerEventType selectRow:1 inComponent:0 animated:true];
        [self.stackREMOVE_EVENT setHidden:true];
        [self.stackTID_BANK setHidden:true];
    } else {
        [self.pickerEventType selectRow:0 inComponent:0 animated:true];
        [self.stackREMOVE_EVENT setHidden:false];
        [self.stackTID_BANK setHidden:false];
        
        [self.switchREMOVE_EVENT setOn:false];
        [self.switchTID_BANK setOn:false];

        if (eventType == (ET_TagPresented | 0x01)) {
            [self.switchREMOVE_EVENT setOn:false];
            [self.switchTID_BANK setOn:false];
        } else if (eventType == ET_TagPresented) {
            [self.switchREMOVE_EVENT setOn:false];
            [self.switchTID_BANK setOn:true];
        } else if (eventType == (ET_TagPresentedWithRemoved | 0x01)) {
                [self.switchREMOVE_EVENT setOn:true];
                [self.switchTID_BANK setOn:false];
        } else if (eventType == ET_TagPresentedWithRemoved) {
            [self.switchREMOVE_EVENT setOn:true];
            [self.switchTID_BANK setOn:true];
        }
    }
}

- (void)didGetFilter:(TagDataEncodeType)tagDataEncodeTypes{
    [childViewController addLog:[NSString stringWithFormat:@"didGetFilter, tagDataEncodeTypes = %d",tagDataEncodeTypes]];
    
    if ((tagDataEncodeTypes & TDE_UDC) == TDE_UDC) {
        [self.switchUDC setOn:true];
    } else {
        [self.switchUDC setOn:false];
    }
    
    if ((tagDataEncodeTypes & TDE_SGTIN_96_EAS) == TDE_SGTIN_96_EAS) {
        [self.switchSGTIN_96_EAS setOn:true];
    } else {
        [self.switchSGTIN_96_EAS setOn:false];
    }
    
    if ((tagDataEncodeTypes & TDE_SGTIN_96) == TDE_SGTIN_96) {
        [self.switchSGTIN_96 setOn:true];
    } else {
        [self.switchSGTIN_96 setOn:false];
    }
    
    if ((tagDataEncodeTypes & TDE_RAW_DATA) == TDE_RAW_DATA) {
        [self.switchRAW_DATA setOn:true];
    } else {
        [self.switchRAW_DATA setOn:false];
    }
    
    if ((tagDataEncodeTypes & TDE_ADI) == TDE_ADI) {
        [self.switchADI setOn:true];
    } else {
        [self.switchADI setOn:false];
    }
}

-(void)didGetPostDataDelimiter:(PostDataDelimiter)postDataDelimiter MemoryBankSelection:(MemoryBankSelection)memoryBankSelection{
    [childViewController addLog:[NSString stringWithFormat:@"didGetPostDataDelimiter, postDataDelimiter = %d, memoryBankSelection = %d",postDataDelimiter, memoryBankSelection]];
    
    if ((postDataDelimiter & PDD_CARRIAGE) == PDD_CARRIAGE) {
        [self.switchCR setOn:true];
    } else {
        [self.switchCR setOn:false];
    }
    
    if ((postDataDelimiter & PDD_LINE) == PDD_LINE) {
        [self.switchLF setOn:true];
    } else {
        [self.switchLF setOn:false];
    }
    
    if ((postDataDelimiter & PDD_TAB) == PDD_TAB) {
        [self.switchTAB setOn:true];
    } else {
        [self.switchTAB setOn:false];
    }
}

-(void)didGetTagMemorySelection:(TagMemorySelection)tagMemorySelection{
    [childViewController addLog:[NSString stringWithFormat:@"didGetTagMemorySelection, tagMemorySelection = %d",tagMemorySelection]];
    
    if ((tagMemorySelection & TM_PC) == TM_PC) {
        [self.switchPC setOn:true];
    } else {
        [self.switchPC setOn:false];
    }
    
    if ((tagMemorySelection & TM_EPC) == TM_EPC) {
        [self.switchEPC setOn:true];
    } else {
        [self.switchEPC setOn:false];
    }
    
    if ((tagMemorySelection & TM_TID) == TM_TID) {
        [self.switchTID setOn:true];
    } else {
        [self.switchTID setOn:false];
    }
    
    if ((tagMemorySelection & TM_EPC_ASCII) == TM_EPC_ASCII) {
        [self.switchEPC_ASCII setOn:true];
    } else {
        [self.switchEPC_ASCII setOn:false];
    }
}

-(void)didGetRemoteHost:(int)connectTime InetSocketAddress:(InetSocketAddress *)inetSocketAddress {
    [childViewController addLog:[NSString stringWithFormat:@"didGetRemoteHost, connectTime = %d, address = %@, port = %d", connectTime, [[inetSocketAddress getHost] getHostAddress], [inetSocketAddress getPort]]];
    
    [self.sliderRemoteHostConnectionTime setValue:connectTime];
    [self.labRemoteHostConnectionTimeout setText:[NSString stringWithFormat:@"%d",connectTime]];
    [self.textFieldRemoteHostIP setText:[[inetSocketAddress getHost] getHostAddress]];
    [self.textFieldRemoteHostPort setText:[NSString stringWithFormat:@"%d",[inetSocketAddress getPort]]];
}

-(void)didGetWiFiMacAddress:(NSString *)wifiMacAddress{
    [childViewController addLog:[NSString stringWithFormat:@"didGetWiFiMacAddress, wifiMacAddress = %@",wifiMacAddress]];
}

-(void)didGetBarcodeReadFormat:(BarcodeFormat) barcodeFormat{
    [childViewController addLog:[NSString stringWithFormat:@"didGetBarcodeReadFormat, barcodeFormat = %d",barcodeFormat]];
    
    switch (barcodeFormat) {
        case GTIN_14: {
            [self.pickerBarcodeReadFormat selectRow:0 inComponent:0 animated:true];
        }
            break;
            
        case GTIN_13: {
            [self.pickerBarcodeReadFormat selectRow:1 inComponent:0 animated:true];
        }
            break;
            
        case GTIN_12: {
            [self.pickerBarcodeReadFormat selectRow:2 inComponent:0 animated:true];
        }
            break;
                
        case GTIN_8: {
            [self.pickerBarcodeReadFormat selectRow:3 inComponent:0 animated:true];
        }
            break;

        default:
            break;
    }
}

-(void)didGetFieldSeparator:(Byte) separator {
    [childViewController addLog:[NSString stringWithFormat:@"didGetFieldSeparator, separator = %@(0x%02x)", [NSString stringWithFormat:@"%c", separator], separator]];
    
//    self.textFieldFieldSeparator.text = [NSString stringWithFormat:@"%02x", separator];
    self.textFieldFieldSeparator.text = [NSString stringWithFormat:@"%c", separator];
}

- (void)didGetPrefix:(NSData * )prefixes {
    NSString *string = [[NSString alloc] initWithData:prefixes encoding:NSUTF8StringEncoding];
    [childViewController addLog:[NSString stringWithFormat:@"didGetPrefix, prefixes = %@",string]];
    
    self.textFieldPrefix.text = [NSString stringWithFormat:@"%@",string];
}

- (void)didGetSuffix:(NSData * )suffixes {
    NSString *string = [[NSString alloc] initWithData:suffixes encoding:NSUTF8StringEncoding];
    [childViewController addLog:[NSString stringWithFormat:@"didGetSuffix, suffixes = %@",string]];
    
    self.textFieldSuffix.text = [NSString stringWithFormat:@"%@",string];
}

- (void)didGetDeactivateEpcPrefix:(NSData *)prefixes {
    [childViewController addLog:[NSString stringWithFormat:@"didGetDeactivateEpcPrefix, prefixes = 0x%@",[GLog CreateHexStringWithData:prefixes]]];
    
    self.textFieldDeactivateEPCPrefix.text = [NSString stringWithFormat:@"%@",[GLog CreateHexStringWithData:prefixes]];
}

- (void)didGetReactivateEpcPrefix:(NSData *)prefixes {
    [childViewController addLog:[NSString stringWithFormat:@"didGetReactivateEpcPrefix, prefixes = 0x%@",[GLog CreateHexStringWithData:prefixes]]];
    
    self.textFieldReactivateEPCPrefix.text = [NSString stringWithFormat:@"%@",[GLog CreateHexStringWithData:prefixes]];
}

- (void)didGetTagProtection:(TagProtection)tagProtection {
    [childViewController addLog:[NSString stringWithFormat:@"didGetTagProtection, tagProtection = %d",tagProtection]];
    
    switch (tagProtection) {
        case TP_Specified_Password: {
            [self.pickerTagProtection selectRow:0 inComponent:0 animated:true];
        }
            break;
            
        case TP_Dynamic_Password: {
            [self.pickerTagProtection selectRow:1 inComponent:0 animated:true];
        }
            break;
            
        case TP_Disabled: {
            [self.pickerTagProtection selectRow:2 inComponent:0 animated:true];
        }
            break;

        default:
            break;
    }
}

-(void)didGetTagProtectionAccessPassword:(NSString *)accessPassword {
    [childViewController addLog:[NSString stringWithFormat:@"didGetTagProtectionAccessPassword, accessPassword = 0x%@",accessPassword]];
    
    self.textFieldTagProtectionAccessPassword.text = accessPassword;
}

-(void)didGetUsbInterface:(UsbInterface)usbInterface {
    [childViewController addLog:[NSString stringWithFormat:@"UsbInterface, usbInterface = %d",usbInterface]];
    
    switch (usbInterface) {
        case UI_VIRTUAL_COMPORT: {
            [self.pickerUsbInterface selectRow:0 inComponent:0 animated:true];
        }
            break;
            
        case UI_HID: {
            [self.pickerUsbInterface selectRow:1 inComponent:0 animated:true];
        }
            break;
            
        default:
            break;
    }
}

-(void)didGetOutputFormat:(OutputFormat)outputFormat {
    [childViewController addLog:[NSString stringWithFormat:@"didGetOutputFormat, outputFormat = %d",outputFormat]];
    
    switch (outputFormat) {
        case OF_DISABLED: {
            [self.pickerOutputFormat selectRow:0 inComponent:0 animated:true];
        }
            break;
            
        case OF_AI_BARCODE_SERIAL_NUMBER: {
            [self.pickerOutputFormat selectRow:1 inComponent:0 animated:true];
        }
            break;
            
        default:
            break;
    }
}

-(void)didGetFirmwareVersion:(NSString *)fwVer {
    [childViewController addLog:[NSString stringWithFormat:@"didGetFirmwareVersion = %@",fwVer]];
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

-(void)didDiscoverTagInfo:(GNPTagInfo*)taginfo{
    NSString *string = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@",
    [NSString stringWithFormat:@"didDiscoverTagInfo, taginfo.TagNumber = %d",taginfo.TagNumber],
    [NSString stringWithFormat:@"didDiscoverTagInfo, taginfo.RSSI = %02X",taginfo.RSSI],
    [NSString stringWithFormat:@"didDiscoverTagInfo, taginfo.Frequency = %f",[taginfo getFrequency]],
    [NSString stringWithFormat:@"didDiscoverTagInfo, taginfo.EPCHexString = %@",taginfo.EPCHexString],
    [NSString stringWithFormat:@"didDiscoverTagInfo, taginfo.TIDHexString = %@",taginfo.TIDHexString]];
    [childViewController displayLog:string];
//    [childViewController addLog:[NSString stringWithFormat:@"didDiscoverTagInfo, taginfo.TagNumber = %d",taginfo.TagNumber]];
//    [childViewController addLog:[NSString stringWithFormat:@"didDiscoverTagInfo, taginfo.RSSI = %02X",taginfo.RSSI]];
//    [childViewController addLog:[NSString stringWithFormat:@"didDiscoverTagInfo, taginfo.Frequency = %f",[taginfo getFrequency]]];
////    [childViewController addLog:[NSString stringWithFormat:@"didDiscoverTagInfo, taginfo.EPC = %@",taginfo.EPC]];
//    [childViewController addLog:[NSString stringWithFormat:@"didDiscoverTagInfo, taginfo.EPCHexString = %@",taginfo.EPCHexString]];
////    [childViewController addLog:[NSString stringWithFormat:@"didDiscoverTagInfo, taginfo.TID = %@",taginfo.TID]];
//    [childViewController addLog:[NSString stringWithFormat:@"didDiscoverTagInfo, taginfo.TIDHexString = %@",taginfo.TIDHexString]];
}

- (void)didDiscoverTagInfoEx:(GNPDecodedTagData *)decodedTagData{
    NSString *string = [NSString stringWithFormat:@"%@\n%@\n%@\n%@",
    [NSString stringWithFormat:@"didDiscoverTagInfoEx, decodedTagData.TID = %@",decodedTagData.TID],
    [NSString stringWithFormat:@"didDiscoverTagInfoEx, decodedTagData.TagSerialNumber = %@",decodedTagData.TagSerialNumber],
    [NSString stringWithFormat:@"didDiscoverTagInfoEx, decodedTagData.DeviceSerialNumber = %@",decodedTagData.DeviceSerialNumber],
    [NSString stringWithFormat:@"didDiscoverTagInfoEx, decodedTagData.DecodedDataList = %@",decodedTagData.DecodedDataList]];
    [childViewController displayLog:string];
//    [childViewController addLog:[NSString stringWithFormat:@"didDiscoverTagInfoEx, decodedTagData.TID = %@",decodedTagData.TID]];
//    [childViewController addLog:[NSString stringWithFormat:@"didDiscoverTagInfoEx, decodedTagData.TagSerialNumber = %@",decodedTagData.TagSerialNumber]];
//    [childViewController addLog:[NSString stringWithFormat:@"didDiscoverTagInfoEx, decodedTagData.DeviceSerialNumber = %@",decodedTagData.DeviceSerialNumber]];
//    [childViewController addLog:[NSString stringWithFormat:@"didDiscoverTagInfoEx, decodedTagData.DecodedDataList = %@",decodedTagData.DecodedDataList]];
}

-(void)didTagRemoved:(GNPTagInfo *)taginfo {
    NSString *string = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@",
    [NSString stringWithFormat:@"didTagRemoved, taginfo.TagNumber = %d",taginfo.TagNumber],
    [NSString stringWithFormat:@"didTagRemoved, taginfo.RSSI = %02X",taginfo.RSSI],
    [NSString stringWithFormat:@"didTagRemoved, taginfo.Frequency = %f",[taginfo getFrequency]],
    [NSString stringWithFormat:@"didTagRemoved, taginfo.EPCHexString = %@",taginfo.EPCHexString],
    [NSString stringWithFormat:@"didTagRemoved, taginfo.TIDHexString = %@",taginfo.TIDHexString]];
    [childViewController displayLog:string];
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
