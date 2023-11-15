//
//  NewInventoryViewController.m
//  UHFSample
//
//  Created by JangJack on 2020/8/22.
//  Copyright © 2020 Gianni. All rights reserved.
//

#import "NewInventoryViewController.h"
#import "TagItemTableViewCell.h"
#import <UHFSDK/GNPTagInfo.h>
#import <UHFSDK/TS100.h>
#import <UHFSDK/TS100A.h>
#import <UHFSDK/TS800.h>
#import <UHFSDK/UR0250.h>
#import "DevDetailTabBarViewController.h"
#import "NewDevConnStatusViewController.h"
#import "MBProgressHUD.h"

@interface NewInventoryViewController () <UIPickerViewDelegate,UIPickerViewDataSource,IUHFDeviceListener>
@property (weak, nonatomic) IBOutlet UIPickerView *pickerTagPresentedType;
@property (weak, nonatomic) IBOutlet UISwitch *switchUDC;
@property (weak, nonatomic) IBOutlet UISwitch *switchSGTIN_96_EAS;
@property (weak, nonatomic) IBOutlet UISwitch *switchSGTIN_96;
@property (weak, nonatomic) IBOutlet UISwitch *switchRAW_DATA;

@property (weak, nonatomic) IBOutlet UIPickerView *pickerActiveMode;

@end

@implementation NewInventoryViewController {
    NSMutableArray* allTagItems;
    UHFDevice* passDev;
    NewDevConnStatusViewController* childViewController;
    
    NSArray *tagPresentedType;
    NSArray *activeModes;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (passDev) {
        [passDev setListener:self];
        
        
        
    }
    allTagItems = [[NSMutableArray alloc]init];
    [childViewController clearLog];
    
    tagPresentedType = @[@"PC_EPC", @"PC_EPC_TID"];
    activeModes = @[@"READ", @"COMMAND", @"TAG_ANALYSIS", @"CUSTOMIZED_READ", @"DEACTIVATE", @"REACTIVATE", @"DEACTIVATE_USER_BANK", @"REACTIVATE_USER_BANK"];
    
    self.pickerTagPresentedType.dataSource = self;
    self.pickerTagPresentedType.delegate = self;
    [self.pickerTagPresentedType setTag:1];
    [self.pickerTagPresentedType selectRow:0 inComponent:0 animated:true];
    
    self.pickerActiveMode.dataSource = self;
    self.pickerActiveMode.delegate = self;
    [self.pickerActiveMode setTag:2];
    [self.pickerActiveMode selectRow:0 inComponent:0 animated:true];
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
            iCount = tagPresentedType.count;
        }
            break;
            
        case 2: {
            iCount = activeModes.count;
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
            strValue = tagPresentedType[row];
        }
            break;
            
        case 2: {
            strValue = activeModes[row];
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
            strValue = tagPresentedType[row];
        }
            break;
            
        case 2: {
            strValue = activeModes[row];
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

- (IBAction)actStopInventory:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            [self->passDev stopInventory];
        }
    }
}

- (IBAction)actStartInventory:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            int tagPresented = (int) [self.pickerTagPresentedType selectedRowInComponent:0];
        
            if (tagPresented == 0) {
                [self->passDev startInventory:ET_PC_EPC];
            } else {
                [self->passDev startInventory:ET_PC_EPC_TID];
            }
        }
    }
}

- (IBAction)actStartInventoryEx:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            if ([self->passDev isMemberOfClass:[TS100 class]]) {
//                NSMutableArray *tagDataEncodeTypes = [NSMutableArray array];
                NSMutableSet *tagDataEncodeTypes = [[NSMutableSet alloc] init];
                if ([self.switchUDC isOn]) {
                    [tagDataEncodeTypes addObject:@(TDE_UDC)];
                }
                
                if ([self.switchSGTIN_96_EAS isOn]) {
                    [tagDataEncodeTypes addObject:@(TDE_SGTIN_96_EAS)];
                }
                
                if ([self.switchSGTIN_96 isOn]) {
                    [tagDataEncodeTypes addObject:@(TDE_SGTIN_96)];
                }

                if ([self.switchRAW_DATA isOn]) {
                    [tagDataEncodeTypes addObject:@(TDE_RAW_DATA)];
                }
                if ([self->passDev isMemberOfClass:[TS100 class]]) {
                    TS100 *ts100 = (TS100 *) self->passDev;
                    
                    [ts100 startInventoryEx:tagDataEncodeTypes];
                }
            }
        }
    }}


- (IBAction)actGetInventoryActiveMode:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            if ([self->passDev isMemberOfClass:[TS100 class]]) {
                TS100 *ts100 = (TS100 *) self->passDev;
                [ts100 getInventoryActiveMode:true];
            } else if ([self->passDev isMemberOfClass:[TS100A class]]) {
                TS100A *ts100a = (TS100A *) self->passDev;
                [ts100a getInventoryActiveMode:true];
            } else if ([self->passDev isMemberOfClass:[TS800 class]]) {
                TS800 *ts800 = (TS800 *) self->passDev;
                [ts800 getInventoryActiveMode:true];
            } else if ([self->passDev isMemberOfClass:[UR0250 class]]) {
                UR0250 *ur0250 = (UR0250 *) self->passDev;
                [ur0250 getInventoryActiveMode:true];
            }
        }
    }
}

- (IBAction)actSetInventoryActiveMode:(id)sender {
    if (self->passDev != nil) {
        if (self->passDev.getDevInfo.currentConnStatus == DevDisconnected) {
            [childViewController addLog:@"Device Not Connected!"];
        } else {
            int activeMode = AM_READ;
            switch ((int) [self.pickerActiveMode selectedRowInComponent:0]) {
                case 0: {
                    activeMode = AM_READ;
                }
                    break;
                    
                case 1: {
                    activeMode = AM_COMMAND;
                }
                    break;
                    
                case 2: {
                    activeMode = AM_TAG_ANALYSIS;
                }
                    break;
                    
                case 3: {
                    activeMode = AM_CUSTOMIZED_READ;
                }
                    break;
                    
                case 4: {
                    activeMode = AM_DEACTIVATE;
                }
                    break;
                    
                case 5: {
                    activeMode = AM_REACTIVATE;
                }
                    break;
                    
                case 6: {
                    activeMode = AM_DEACTIVATE_USER_BANK;
                }
                    break;
                    
                case 7: {
                    activeMode = AM_REACTIVATE_USER_BANK;
                }
                    break;
                    
                default:
                    break;
            }
            
            if ([self->passDev isMemberOfClass:[TS100 class]]) {
                TS100 *ts100 = (TS100 *) self->passDev;
                [ts100 setInventoryActiveMode:true InventoryActiveMode:activeMode];
            } else if ([self->passDev isMemberOfClass:[TS100A class]]) {
                TS100A *ts100a = (TS100A *) self->passDev;
                [ts100a setInventoryActiveMode:true InventoryActiveMode:activeMode];
            } else if ([self->passDev isMemberOfClass:[TS800 class]]) {
                TS800 *ts800 = (TS800 *) self->passDev;
                [ts800 setInventoryActiveMode:true InventoryActiveMode:activeMode];
            } else if ([self->passDev isMemberOfClass:[UR0250 class]]) {
                UR0250 *ur0250 = (UR0250 *) self->passDev;
                [ur0250 setInventoryActiveMode:true InventoryActiveMode:activeMode];
            }
        }
    }
}

#pragma mark - UHF API Callback

-(void)didGetInventoryActiveMode:(ActiveMode)activeMode{
    int pickerViewRow = 0;
    if (activeMode == AM_READ) {
        [self.pickerActiveMode selectRow:0 inComponent:0 animated:true];
        pickerViewRow = 0;
    } else if (activeMode == AM_COMMAND) {
        [self.pickerActiveMode selectRow:1 inComponent:0 animated:true];
        pickerViewRow = 1;
    } else if (activeMode == AM_TAG_ANALYSIS) {
        [self.pickerActiveMode selectRow:2 inComponent:0 animated:true];
        pickerViewRow = 2;
    } else if (activeMode == AM_CUSTOMIZED_READ) {
        [self.pickerActiveMode selectRow:3 inComponent:0 animated:true];
        pickerViewRow = 3;
    } else if (activeMode == AM_DEACTIVATE) {
        [self.pickerActiveMode selectRow:4 inComponent:0 animated:true];
        pickerViewRow = 4;
    } else if (activeMode == AM_REACTIVATE) {
        [self.pickerActiveMode selectRow:5 inComponent:0 animated:true];
        pickerViewRow = 5;
    } else if (activeMode == AM_DEACTIVATE_USER_BANK) {
        [self.pickerActiveMode selectRow:6 inComponent:0 animated:true];
        pickerViewRow = 6;
    } else if (activeMode == AM_REACTIVATE_USER_BANK) {
        [self.pickerActiveMode selectRow:7 inComponent:0 animated:true];
        pickerViewRow = 7;
    }
    [childViewController addLog:[NSString stringWithFormat:@"didGetInventoryActiveMode, activeMode = %@", activeModes[pickerViewRow]]];
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
    [childViewController addLog:[NSString stringWithFormat:@"didGetBLEFirmwareVersion, fwVer = %@",fwVer]];
    [passDev getDevInfo]._bleDevInfo.devROMVersion = fwVer;
    [childViewController reloadData];
}

- (void)didGetWiFiMacAddress:(NSString *)wifiMacAddress {
    [childViewController addLog:[NSString stringWithFormat:@"didGetWiFiMacAddress, wifiMacAddress = %@",wifiMacAddress]];
    [childViewController reloadData];
}

-(void)didDiscoverTagInfo:(GNPTagInfo*)taginfo{
    NSString *string = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@",
                        [NSString stringWithFormat:@"didDiscoverTagInfo, taginfo.TagNumber = %d",taginfo.TagNumber],
                        [NSString stringWithFormat:@"didDiscoverTagInfo, taginfo.RSSI = %d",taginfo.RSSI],
                        [NSString stringWithFormat:@"didDiscoverTagInfo, taginfo.Frequency = %f",[taginfo getFrequency]],
                        [NSString stringWithFormat:@"didDiscoverTagInfo, taginfo.EPCHexString = %@",taginfo.EPCHexString],
                        [taginfo.TIDHexString isEqual: @""] ? @"" : [NSString stringWithFormat:@"didDiscoverTagInfo, taginfo.TIDHexString = %@",taginfo.TIDHexString]];
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
                        [NSString stringWithFormat:@"didTagRemoved, taginfo.RSSI = %d",taginfo.RSSI],
                        [NSString stringWithFormat:@"didTagRemoved, taginfo.Frequency = %f",[taginfo getFrequency]],
                        [NSString stringWithFormat:@"didTagRemoved, taginfo.EPCHexString = %@",taginfo.EPCHexString],
                        [taginfo.TIDHexString isEqual: @""] ? @"" : [NSString stringWithFormat:@"didDiscoverTagInfo, taginfo.TIDHexString = %@",taginfo.TIDHexString]];
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
