//
//  TestingApiViewController.m
//  UHFSample
//
//  Created by Gianni on 2019/4/12.
//  Copyright © 2019 Gianni. All rights reserved.
//
#import "MBProgressHUD.h"
#import "TestingApiViewController.h"
#import "DevDetailTabBarViewController.h"
#import "DevConnStatusViewController.h"
#import <UHFSDK/GNetPlus.h>
#import <UHFSDK/GNPTagInfo.h>
#import <UHFSDK/GNPLockInfos.h>
#import <UHFSDK/TS100.h>
#import <UHFSDK/TS100A.h>
#import <UHFSDK/TS800.h>
#import <UHFSDK/UR0250.h>
#import <UHFSDK/BaseTagEvent.h>

#import <UHFSDK/XEPCLentT.h>

@interface TestingApiViewController () <IUHFDeviceListener, DevConnectionCallback>
@property (weak, nonatomic) IBOutlet UITextView *testingLogTextView;
@property (weak, nonatomic) IBOutlet UIButton *test_1_Button;
@property (weak, nonatomic) IBOutlet UIButton *test_2_Button;
@property (weak, nonatomic) IBOutlet UIButton *test_3_Button;
@property (weak, nonatomic) IBOutlet UIButton *test_4_Button;
@property (weak, nonatomic) IBOutlet UIButton *test_5_Button;
@property (weak, nonatomic) IBOutlet UIButton *test_6_Button;
@property (weak, nonatomic) IBOutlet UIButton *test_7_Button;
@property (weak, nonatomic) IBOutlet UIButton *clear_log_Button;

@end

typedef NS_ENUM(Byte, NextTestItem) {
    API_BLEConnect                     = 0x00,
    API_StartInventory                 = 0x01,
    API_StopInventory                  = 0x02,
    API_WriteEpc_1                     = 0x03,
    API_WriteEpc_2                     = 0x04,
    API_ReadTag_1                      = 0x05,
    API_ReadTag_2                      = 0x06,
    API_WriteTag_1                     = 0x07,
    API_WriteTag_2                     = 0x08,
    API_GetRfPower                     = 0x0A,
    API_SetRfPower                     = 0x0B,
    API_GetRfSensitivity               = 0x0C,
    API_SetRfSensitivity               = 0x0D,
    API_GetFrequency                   = 0x0E,
    API_SetFrequency                   = 0x0F,
    API_GetQValue                      = 0x10,
    API_SetQValue                      = 0x11,
    API_SetSessionAndTarget            = 0x12,
    API_GetSessionAndTarget            = 0x13,
    API_GetFirmwareVersion             = 0x14,
    API_SetTagRemovedThread            = 0x15,
    API_GetTagRemovedThread            = 0x16,
    API_SetInventoryReoundInterval     = 0x17,
    API_GetInventoryReoundInterval     = 0x18,
    API_LockTag_1                      = 0x19,
    API_LockTag_2                      = 0x1A,
    API_KillTag_1                      = 0x1B,
    API_KillTag_2                      = 0x1C,
    API_GetRxDecode                    = 0x1D,
    API_SetRxDecode                    = 0x1E,
    API_GetLinkFrequency               = 0x1F,
    API_SetLinkFrequency               = 0x20,
    API_GetProfile                     = 0x21,
    API_SetProfile                     = 0x22,
    API_DirectIO                       = 0x23,
    
    // Foe TS100
    API_GetBleDeviceName               = 0x24,
    API_SetBleDeviceName               = 0x25,
    API_GetBleMacAddress               = 0x26,
    API_GetBleRomVersion               = 0x27,
    API_StartInventoryEx               = 0x28,
    API_GetInventoryActiveMode         = 0x29,
    API_SetInventoryActiveMode         = 0x2A,
    API_GetBuzzerOperationMode         = 0x2B,
    API_SetBuzzerOperationMode         = 0x2C,
    API_SetFilter                      = 0x2D,
    API_GetFilter                      = 0x2E,
    API_ControlBuzzer                  = 0x2F,
    API_GetEventType                   = 0x30,
    API_SetEventType                   = 0x31,
    API_SetOutputInterfaces            = 0x32,
    API_GetOutputInterfaces            = 0x33,
    API_GetPostDataDelimiter           = 0x34,
    API_SetPostDataDelimiter           = 0x35,
    API_GetTagMemorySelection          = 0x36,
    API_SetTagMemorySelection          = 0x37,
    API_SetWifiSettings_1              = 0x38,
    API_SetWifiSettings_2              = 0x39,
    API_SetTagPresentedRepeatInterval  = 0x3A,
    API_GetTagPresentedRepeatInterval  = 0x3B,
    API_GetWiFiMacAddress              = 0x3C,
    API_SetRemoteHost                  = 0x3D,
    API_GetRemoteHost                  = 0x3E,
    API_WriteTagEx_1                   = 0x3F,
    API_WriteTagEx_2                   = 0x40,
    API_ReadTagEx_1                    = 0x41,
    API_ReadTagEx_2                    = 0x42,
    API_GetBarcodeReadFormat           = 0x43,
    API_SetBarcodeReadFormat           = 0x44,
    API_GetFieldSeparator              = 0x45,
    API_SetFieldSeparator              = 0x46,
    API_GetPrefix                      = 0x47,
    API_SetPrefix                      = 0x48,
    API_GetSuffix                      = 0x49,
    API_SetSuffix                      = 0x4A,
    API_GetDeactivateEpcPrefix         = 0x4B,
    API_SetDeactivateEpcPrefix         = 0x4C,
    API_GetReactivateEpcPrefix         = 0x4D,
    API_SetReactivateEpcPrefix         = 0x4E,
    API_GetTransformEpcState           = 0x4F,
    API_SetTransformEpcState           = 0x50,
    API_GetTransformEpcPrefix          = 0x51,
    API_SetTransformEpcPrefix          = 0x52,
    API_GetEncodeType                  = 0x53,
    API_SetEncodeType                  = 0x54,
    API_GetTagProtection               = 0x55,
    API_SetTagProtection               = 0x56,
    API_GetTagProtectionAccessPassword = 0x57,
    API_SetTagProtectionAccessPassword = 0x58,
    API_GetUsbInterface                = 0x59,
    API_SetUsbInterface                = 0x5A,
    API_GetOutputFormat                = 0x5B,
    API_SetOutputFormat                = 0x5C,
    API_GetEpcNormalize                = 0x5D,
    API_SetEpcNormalize                = 0x5E,

    //Foe TS800
    API_SetTriggerType                 = 0x5F,
    API_GetTriggerType                 = 0x60,
    API_GetIOState                     = 0x61,
    API_SetIOState                     = 0x62,
    API_SetOutputInterface             = 0x63,
    API_GetOutputInterface             = 0x64,
    API_SetScanMode                    = 0x65,
    API_GetScanMode                    = 0x66,
    API_SetCommandTriggerState         = 0x67,
    API_GetCommandTriggerState         = 0x68,
    API_GetWiFiApList_1                = 0x69,
    API_GetWiFiApList_2                = 0x6A,
    API_GetIpAddress                   = 0x6B,
    
    API_GetDeviceID                    = 0x6C,
    API_SetDeviceID                    = 0x6D,

    API_BLEDisconnect                  = 0xF4,
    
};

@implementation TestingApiViewController
{
    BOOL nonBlocking;
    BOOL isConnected;
    BOOL isGettingFirmwareVersion;
    int callbackCount;
    UHFDevice* passDev;
    NSMutableArray *actionArrayAfterCallback;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    DevDetailTabBarViewController* ctrler = (DevDetailTabBarViewController*)self.tabBarController;
    passDev = [ctrler getUHFDevice];
    [passDev setListener:self];

    nonBlocking = TRUE;
    callbackCount = 0;
    
    _testingLogTextView.editable = NO;
}
- (void)viewWillAppear:(BOOL)animated {
    [passDev setListener:self];
    
    [passDev setConnCallback:self];
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

- (void) deactivateTestingButons {
    
}

- (void) activeTestingButtons {
    
}

- (void) addLog: (NSString *) text {
    NSString *logs = [_testingLogTextView text];
    
    [_testingLogTextView setText:[NSString stringWithFormat:@"%@\n%@\n", logs, text]];
    NSRange bottom = NSMakeRange(_testingLogTextView.text.length, 0);
    [_testingLogTextView scrollRangeToVisible:bottom];
    
    [_testingLogTextView setScrollEnabled:NO];
    [_testingLogTextView setScrollEnabled:YES];
}

- (void) disableButtons {
    self->_test_1_Button.enabled = FALSE;
    self->_test_2_Button.enabled = FALSE;
    self->_test_3_Button.enabled = FALSE;
    self->_test_4_Button.enabled = FALSE;
    self->_test_5_Button.enabled = FALSE;
    self->_test_6_Button.enabled = FALSE;
    self->_test_7_Button.enabled = FALSE;

    [self->_test_1_Button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self->_test_2_Button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self->_test_3_Button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self->_test_4_Button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self->_test_5_Button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self->_test_6_Button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self->_test_7_Button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
}

- (void) enableButtons {
    self->_test_1_Button.enabled = TRUE;
    self->_test_2_Button.enabled = TRUE;
    self->_test_3_Button.enabled = TRUE;
    self->_test_4_Button.enabled = TRUE;
    self->_test_5_Button.enabled = TRUE;
    self->_test_6_Button.enabled = TRUE;
    self->_test_7_Button.enabled = TRUE;

    [self->_test_1_Button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self->_test_2_Button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self->_test_3_Button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self->_test_4_Button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self->_test_5_Button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self->_test_6_Button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self->_test_7_Button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

- (void) run:(NSMutableArray *) actions {
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self addLog:[NSString stringWithFormat:@"run, actions = %@", actions]];
//    });

    callbackCount = 0;
//
//    if (actionArrayAfterCallback != NULL && [actionArrayAfterCallback count] > 0) {
//        [actionArrayAfterCallback removeAllObjects];
//        actionArrayAfterCallback = nil;
//    }
    
    int finishedItems = 0;

    for (int i = 0; i < [actions count]; i++ && finishedItems++) {
        NSArray *item = actions[i];
        if ([item count] < 1 || [item count] > 3) {
            continue;
        }
        
        int action = [item[0] intValue];
        int repeat = 1;
        BOOL waitForCallback = FALSE;
        if ([item count] >= 2) {
            repeat = [item[1] intValue];
        }
        
        if ([item count] == 3) {
            waitForCallback = [item[2] boolValue];
        }

//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self addLog:[NSString stringWithFormat:@"run, number of actions = %lu, action = %d, repeat = %d, waitForCallback = %d", [actions count], action, repeat, waitForCallback]];
//        });
//
//        continue;
        switch (action) {
            case API_BLEConnect: {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    for (int j = 0; j < repeat; j++) {
                        if (waitForCallback) {
                            self->callbackCount++;
                        }
                        [self connectDevice];
                    }
                });
                break;
            }
                
            case API_StartInventory: {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    for (int j = 0; j < repeat; j++) {
                        if (waitForCallback) {
                            self->callbackCount += 2; // callback : didGeneralSucess will be invoked twice for each command.
                        }
                        [self->passDev startInventory:ET_PC_EPC];
                        [self addLog:@"startInventory!!!"];
                    }
                });
                break;
            }
                
            case API_StopInventory: {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    for (int j = 0; j < repeat; j++) {
                        if (waitForCallback) {
                            self->callbackCount++;
                        }
                        [self->passDev stopInventory];
                        [self addLog:@"stopInventory!!!"];
                    }
                });
                break;
            }
                
            case API_WriteEpc_1: {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    for (int j = 0; j < repeat; j++) {
                        if (waitForCallback) {
                            self->callbackCount++;
                        }
                        NSData* bEPC  = [GLog CreateDataWithHexString:@"12345678"];

                        [self->passDev writeEpc:@"00000000" EPCData:bEPC];
                        [self addLog:@"writeEpc 1!!!"];
                        NSLog(@"Tesing API : writeEpc 1");
                    }
                });
                break;
            }
                
            case API_WriteEpc_2: {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    for (int j = 0; j < repeat; j++) {
                        if (waitForCallback) {
                            self->callbackCount++;
                        }
                        NSData* bEPC  = [GLog CreateDataWithHexString:@"11111111"];

                        [self->passDev writeEpc:@"3800" HexAccessPassword:@"00000000" EPCData:bEPC];
                        [self addLog:@"writeEpc 2!!!"];
                        NSLog(@"Tesing API : writeEpc 2");
                    }
                });
                break;
            }
                
            // Testing : readTag : OK
            case API_ReadTag_1: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    for (int j = 0; j < repeat; j++) {
                        if (waitForCallback) {
                            self->callbackCount++;
                        }
                        [self->passDev readTag:@"00000000" MemoryBank:MBC_Reserve StartAddr:0 ReadLen:0];
                        [self addLog:@"readTag 1!!!"];
                    }
                });
                break;
            }
                
            // Testing : readTag : OK
            case API_ReadTag_2: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    for (int j = 0; j < repeat; j++) {
                        if (waitForCallback) {
                            self->callbackCount++;
                        }
                        [self->passDev readTag:@"" PWD:@"00000000" MemoryBank:MBC_Reserve StartAddr:0 ReadLen:0];
                        [self addLog:@"readTag 2!!!"];
                    }
                });
                break;
            }
                
            case API_WriteTag_1: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    for (int j = 0; j < repeat; j++) {
                        if (waitForCallback) {
                            self->callbackCount++;
                        }
                        NSData* bEPC  = [GLog CreateDataWithHexString:@"12345678"];

                        [self->passDev writeTag:@"00000000" MemoryBank:MBC_Reserve StartAddr:0 Data:bEPC];
                        [self addLog:@"writeTag 1!!!"];
                    }
                });
                break;
            }
                
            case API_WriteTag_2: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    for (int j = 0; j < repeat; j++) {
                        if (waitForCallback) {
                            self->callbackCount++;
                        }
                        NSData* bEPC  = [GLog CreateDataWithHexString:@"87654321"];

                        [self->passDev writeTag:@"3800" PWD:@"00000000" MemoryBank:MBC_Reserve StartAddr:0 Data:bEPC];
                        [self addLog:@"writeTag 2!!!"];
                    }
                });
                break;
            }
                
            case API_GetRfPower: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    for (int j = 0; j < repeat; j++) {
                        if (waitForCallback) {
                            self->callbackCount++;
                        }
                        [self->passDev getRfPower:true];
                        [self addLog:@"getRfPower!!!"];
                    }
                });
                break;
            }
                
            case  API_SetRfPower: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    for (int j = 0; j < repeat; j++) {
                        if (waitForCallback) {
                            self->callbackCount++;
                        }
                        [self->passDev setRfPower:true RFPower:15];
                        [self addLog:@"setRfPower!!!"];
                    }
                });
                break;
            }
                
            case API_GetRfSensitivity: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    for (int j = 0; j < repeat; j++) {
                        if (waitForCallback) {
                            self->callbackCount++;
                        }
                        [self->passDev getRfSensitivity:true];
                        [self addLog:@"getRfSensitivity!!!"];
                    }
                });
                break;
            }
                
            case API_SetRfSensitivity: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    for (int j = 0; j < repeat; j++) {
                        if (waitForCallback) {
                            self->callbackCount++;
                        }
                        [self->passDev setRfSensitivity:true RfSensitivityLevel:LEVEL_10];
                        [self addLog:@"setRfSensitivity!!!"];
                    }
                });
                break;
            }
                
            case API_GetFrequency: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    for (int j = 0; j < repeat; j++) {
                        if (waitForCallback) {
                            self->callbackCount++;
                        }
                        [self->passDev getFrequency:true];
                        [self addLog:@"getFrequency!!!"];
                    }
                });
                break;
            }
                
            case API_SetFrequency: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    for (int j = 0; j < repeat; j++) {
                        if (waitForCallback) {
                            self->callbackCount++;
                        }
                        [self->passDev setFrequency:true List:@[@902.75, @903.25, @903.75, @904.25, @904.75, @905.25, @905.75, @906.25, @906.75, @907.25, @907.75, @908.25, @908.75, @909.25, @909.75, @910.25, @910.75, @911.25, @911.75, @912.25, @912.75, @913.25, @913.75, @914.25, @914.75, @915.25, @915.75, @916.25, @916.75, @917.25, @917.75, @918.25, @918.75, @919.25, @919.75, @920.25, @920.75, @921.25, @921.75, @922.25, @922.75, @923.25, @923.75, @924.25, @924.75, @925.25, @925.75, @926.25, @926.75, @927.25]];
                        [self addLog:@"setFrequency!!!"];
                    }
                });
                break;
            }
                
            case API_GetQValue: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    for (int j = 0; j < repeat; j++) {
                        if (waitForCallback) {
                            self->callbackCount++;
                        }
                        [self->passDev getQValue:true];
                        [self addLog:@"getQValue!!!"];
                    }
                });
                break;
            }
                
            case API_SetQValue: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    for (int j = 0; j < repeat; j++) {
                        if (waitForCallback) {
                            self->callbackCount++;
                        }
                        [self->passDev setQValue:true QValue:0];
                        [self addLog:@"setQValue!!!"];
                    }
                });
                break;
            }
                
            case API_SetSessionAndTarget: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    for (int j = 0; j < repeat; j++) {
                        if (waitForCallback) {
                            self->callbackCount++;
                        }
                        [self->passDev setSessionAndTarget:true Session:S0 Target:A];
                        [self addLog:@"setSessionAndTarget!!!"];
                    }
                });
                break;
            }
                
            case API_GetSessionAndTarget: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    for (int j = 0; j < repeat; j++) {
                        if (waitForCallback) {
                            self->callbackCount++;
                        }
                        [self->passDev getSessionAndTarget:true];
                        [self addLog:@"getSessionAndTarget!!!"];
                    }
                });
                break;
            }
                
            case API_GetFirmwareVersion: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    for (int j = 0; j < repeat; j++) {
                        if (waitForCallback) {
                            self->callbackCount++;
                        }
                        [self->passDev getFirmwareVersion];
                        [self addLog:@"getFirmwareVersion!!!"];
                    }
                });
                break;
            }
                
            case API_SetTagRemovedThread: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    for (int j = 0; j < repeat; j++) {
                        if (waitForCallback) {
                            self->callbackCount++;
                        }
                        [self->passDev setTagRemovedThreshold:true Round:5];
                        [self addLog:@"setTagRemovedThreshold!!!"];
                    }
                });
                break;
            }
                
            case API_GetTagRemovedThread: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    for (int j = 0; j < repeat; j++) {
                        if (waitForCallback) {
                            self->callbackCount++;
                        }
                        [self->passDev getTagRemovedThreshold:true];
                        [self addLog:@"getTagRemovedThreshold!!!"];
                    }
                });
                break;
            }
                
            case API_SetInventoryReoundInterval: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    for (int j = 0; j < repeat; j++) {
                        if (waitForCallback) {
                            self->callbackCount++;
                        }
                        [self->passDev setInventoryRoundInterval:true InventoryRoundInterval:254];
                        [self addLog:@"setInventoryRoundInterval!!!"];
                    }
                });
                break;
            }
                
            case API_GetInventoryReoundInterval: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    for (int j = 0; j < repeat; j++) {
                        if (waitForCallback) {
                            self->callbackCount++;
                        }
                        [self->passDev getInventoryRoundInterval:true];
                        [self addLog:@"getInventoryRoundInterval!!!"];
                    }
                });
                break;
            }
                
            case API_LockTag_1: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    for (int j = 0; j < repeat; j++) {
                        if (waitForCallback) {
                            self->callbackCount++;
                        }
                        NSMutableArray* array = [[NSMutableArray alloc] initWithCapacity:1];
                        GNPLockInfos* lockInfo = [[GNPLockInfos alloc] init];
                        lockInfo.action = LA_UNLOCK;
                        lockInfo.memBank_R = MBC_EPC;
                        [array addObject:lockInfo];
                        [self->passDev lockTag:array];
                        [self addLog:@"lockTag 1!!!"];
                    }
                });
                break;
            }
                
            case API_LockTag_2: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    for (int j = 0; j < repeat; j++) {
                        if (waitForCallback) {
                            self->callbackCount++;
                        }
                        NSMutableArray* array = [[NSMutableArray alloc] initWithCapacity:1];
                        GNPLockInfos* lockInfo = [[GNPLockInfos alloc] init];
                        lockInfo.action = LA_UNLOCK;
                        lockInfo.memBank_R = MBC_EPC;
                        [array addObject:lockInfo];
                        [self->passDev lockTag:@"00000000" LockInfos:array];
                        [self addLog:@"lockTag 2!!!"];
                    }
                });
                break;
            }
                
            case API_KillTag_1: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    for (int j = 0; j < repeat; j++) {
                        if (waitForCallback) {
                            self->callbackCount++;
                        }
                        [self->passDev killTag:@"00000000"];
                        [self addLog:@"killTag 1!!!"];
                    }
                });
                break;
            }
                
            case API_KillTag_2: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    for (int j = 0; j < repeat; j++) {
                        if (waitForCallback) {
                            self->callbackCount++;
                        }
                        [self->passDev killTag:@"00000000" KillPWD:@"00000000"];
                        [self addLog:@"killTag 2!!!"];
                    }
                });
                break;
            }
                
            case API_GetRxDecode: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    for (int j = 0; j < repeat; j++) {
                        if (waitForCallback) {
                            self->callbackCount++;
                        }
                        [self->passDev getRxDecode:true];
                        [self addLog:@"getRxDecode!!!"];
                    }
                });
                break;
            }
                
            case API_SetRxDecode: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    for (int j = 0; j < repeat; j++) {
                        if (waitForCallback) {
                            self->callbackCount++;
                        }
                        [self->passDev setRxDecode:true RxDecodeType:MILLER_4];
                        [self addLog:@"setRxDecode!!!"];
                    }
                });
                break;
            }
                
            case API_GetLinkFrequency: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    for (int j = 0; j < repeat; j++) {
                        if (waitForCallback) {
                            self->callbackCount++;
                        }
                        [self->passDev getLinkFrequency:true];
                        [self addLog:@"getLinkFrequency!!!"];
                    }
                });
                break;
            }
                
            case API_SetLinkFrequency: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    for (int j = 0; j < repeat; j++) {
                        if (waitForCallback) {
                            self->callbackCount++;
                        }
                        [self->passDev setLinkFrequency:true LinkFrequency:LF_256KHZ];
                        [self addLog:@"setLinkFrequency!!!"];
                    }
                });
                break;
            }
                
            case API_GetProfile: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    for (int j = 0; j < repeat; j++) {
                        if (waitForCallback) {
                            self->callbackCount++;
                        }
                        [self->passDev getProfile:true];
                        [self addLog:@"getProfile!!!"];
                    }
                });
                break;
            }
                
            case API_SetProfile: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    for (int j = 0; j < repeat; j++) {
                        if (waitForCallback) {
                            self->callbackCount++;
                        }
                        [self->passDev setProfile:true Profile:254];
                        [self addLog:@"setProfile!!!"];
                    }
                });
                break;
            }
                
            case API_DirectIO: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    for (int j = 0; j < repeat; j++) {
                        if (waitForCallback) {
                            self->callbackCount++;
                        }
//                        int command = GNP_WriteSetting;
//                        NSData *data = [GLog CreateDataWithHexString:@"801200"];
                        int command = GNP_QueryFirmwareVersion;
                        NSData *data = [GLog CreateDataWithHexString:@"00"];
                        
                        [self->passDev directIO:command Data:data];
                        [self addLog:@"directIO!!!"];
                    }
                });
                break;
            }
                
            case API_GetBleDeviceName: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    if ([self->passDev isMemberOfClass:[TS100 class]]) {
                        TS100 *ts100 = (TS100 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ts100 getBleDeviceName];
                            [self addLog:@"getBleDeviceName!!!"];
                        }
                    } else if ([self->passDev isMemberOfClass:[TS800 class]]) {
                        TS800 *ts800 = (TS800 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ts800 getBleDeviceName];
                            [self addLog:@"getBleDeviceName!!!"];
                        }
                    } else if ([self->passDev isMemberOfClass:[UR0250 class]]) {
                        UR0250 *ur0250 = (UR0250 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ur0250 getBleDeviceName];
                            [self addLog:@"getBleDeviceName!!!"];
                        }
                    }

                });
                break;
            }
                
            case API_SetBleDeviceName: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    if ([self->passDev isMemberOfClass:[TS100 class]]) {
                        TS100 *ts100 = (TS100 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ts100 setBleDeviceName:@"GBLECOM"];
                            [self addLog:@"setBleDeviceName!!!"];
                        }
                    } else if ([self->passDev isMemberOfClass:[TS800 class]]) {
                        TS800 *ts800 = (TS800 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ts800 setBleDeviceName:@"TS800"];
                            [self addLog:@"setBleDeviceName!!!"];
                        }
                    } else if ([self->passDev isMemberOfClass:[UR0250 class]]) {
                        UR0250 *ur0250 = (UR0250 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ur0250 setBleDeviceName:@"UR0250"];
                            [self addLog:@"setBleDeviceName!!!"];
                        }
                    }

                });
                break;
            }

            case API_GetBleMacAddress: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    if ([self->passDev isMemberOfClass:[TS100 class]]) {
                        TS100 *ts100 = (TS100 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ts100 getBleMacAddress];
                            [self addLog:@"getBleMacAddress!!!"];
                        }
                    } else if ([self->passDev isMemberOfClass:[TS800 class]]) {
                        TS800 *ts800 = (TS800 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ts800 getBleMacAddress];
                            [self addLog:@"getBleMacAddress!!!"];
                        }
                    } else if ([self->passDev isMemberOfClass:[UR0250 class]]) {
                        UR0250 *ur0260 = (UR0250 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ur0260 getBleMacAddress];
                            [self addLog:@"getBleMacAddress!!!"];
                        }
                    }

                });
                break;
            }

            case API_GetBleRomVersion: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    if ([self->passDev isMemberOfClass:[TS100 class]]) {
                        TS100 *ts100 = (TS100 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ts100 getBleRomVersion];
                            [self addLog:@"getBleRomVersion!!!"];
                        }
                    } else if ([self->passDev isMemberOfClass:[TS800 class]]) {
                        TS800 *ts800 = (TS800 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ts800 getBleRomVersion];
                            [self addLog:@"getBleRomVersion!!!"];
                        }
                    } else if ([self->passDev isMemberOfClass:[UR0250 class]]) {
                        UR0250 *ur0260 = (UR0250 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ur0260 getBleRomVersion];
                            [self addLog:@"getBleRomVersion!!!"];
                        }
                    }

                });
                break;
            }
                
            case API_StartInventoryEx: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    if ([self->passDev isMemberOfClass:[TS100 class]]) {
                        TS100 *ts100 = (TS100 *) self->passDev;
                        self->callbackCount += 2; // callback : two for GNP_SelectActiveMode of parseRecvGNetPlusData.
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            NSMutableSet *tagDataEncodeTypes = [[NSMutableSet alloc] init];
                            [tagDataEncodeTypes addObject:@(TDE_UDC)];
                            [tagDataEncodeTypes addObject:@(TDE_SGTIN_96_EAS)];
                            [tagDataEncodeTypes addObject:@(TDE_SGTIN_96)];
                            [tagDataEncodeTypes addObject:@(TDE_RAW_DATA)];
                            [ts100 startInventoryEx:tagDataEncodeTypes];
                            [self addLog:@"startInventoryEx!!!"];
                        }
                    }

                });
                break;
            }
                
            case API_GetInventoryActiveMode: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    if ([self->passDev isMemberOfClass:[TS100 class]]) {
                        TS100 *ts100 = (TS100 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ts100 getInventoryActiveMode:true];
                            [self addLog:@"getInventoryActiveMode!!!"];
                        }
                    } else if ([self->passDev isMemberOfClass:[TS100A class]]) {
                        TS100A *ts100a = (TS100A *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ts100a getInventoryActiveMode:true];
                            [self addLog:@"getInventoryActiveMode!!!"];
                        }
                    } else if ([self->passDev isMemberOfClass:[TS800 class]]) {
                        TS800 *ts800 = (TS800 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ts800 getInventoryActiveMode:true];
                            [self addLog:@"getInventoryActiveMode!!!"];
                        }
                    } else if ([self->passDev isMemberOfClass:[UR0250 class]]) {
                        UR0250 *ur0250 = (UR0250 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ur0250 getInventoryActiveMode:true];
                            [self addLog:@"getInventoryActiveMode!!!"];
                        }
                    }

                });
                break;
            }
                
            case API_SetInventoryActiveMode: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    if ([self->passDev isMemberOfClass:[TS100 class]]) {
                        TS100 *ts100 = (TS100 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ts100 setInventoryActiveMode:true InventoryActiveMode:AM_READ];
                            [self addLog:@"setInventoryActiveMode!!!"];
                        }
                    } else if ([self->passDev isMemberOfClass:[TS100A class]]) {
                        TS100A *ts100a = (TS100A *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ts100a setInventoryActiveMode:true InventoryActiveMode:AM_READ];
                            [self addLog:@"setInventoryActiveMode!!!"];
                        }
                    } else if ([self->passDev isMemberOfClass:[TS800 class]]) {
                        TS800 *ts800 = (TS800 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ts800 setInventoryActiveMode:true InventoryActiveMode:AM_READ];
                            [self addLog:@"setInventoryActiveMode!!!"];
                        }
                    } else if ([self->passDev isMemberOfClass:[UR0250 class]]) {
                        UR0250 *ur0250 = (UR0250 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ur0250 setInventoryActiveMode:true InventoryActiveMode:AM_READ];
                            [self addLog:@"setInventoryActiveMode!!!"];
                        }
                    }

                });
                break;
            }
                
            case API_SetBuzzerOperationMode: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    if ([self->passDev isMemberOfClass:[TS100 class]]) {
                        TS100 *ts100 = (TS100 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ts100 setBuzzerOperationMode:true BuzzerOperationMode:BOM_Off];
                            [self addLog:@"setBuzzerOperationMode!!!"];
                        }
                    } else if ([self->passDev isMemberOfClass:[TS800 class]]) {
                        TS800 *ts800 = (TS800 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ts800 setBuzzerOperationMode:true BuzzerOperationMode:BOM_Off];
                            [self addLog:@"setBuzzerOperationMode!!!"];
                        }
                    }

                });
                break;
            }
                
            case API_GetBuzzerOperationMode: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    if ([self->passDev isMemberOfClass:[TS100 class]]) {
                        TS100 *ts100 = (TS100 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ts100 getBuzzerOperationMode:true];
                            [self addLog:@"getBuzzerOperationMode!!!"];
                        }
                    } else if ([self->passDev isMemberOfClass:[TS800 class]]) {
                        TS800 *ts800 = (TS800 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ts800 getBuzzerOperationMode:true];
                            [self addLog:@"getBuzzerOperationMode!!!"];
                        }
                    }

                });
                break;
            }
                
            case API_SetFilter: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    if ([self->passDev isMemberOfClass:[TS100 class]]) {
                        TS100 *ts100 = (TS100 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            NSMutableSet *tagDataEncodeTypes = [[NSMutableSet alloc] init];
                            [tagDataEncodeTypes addObject:@(TDE_UDC)];
                            [tagDataEncodeTypes addObject:@(TDE_SGTIN_96_EAS)];
                            [tagDataEncodeTypes addObject:@(TDE_SGTIN_96)];
                            [tagDataEncodeTypes addObject:@(TDE_RAW_DATA)];
                            [ts100 setFilter:true TagDataEncodeType:tagDataEncodeTypes];
                            [self addLog:@"setFilter!!!"];
                        }
                    }

                });
                break;
            }
                
            case API_GetFilter: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    if ([self->passDev isMemberOfClass:[TS100 class]]) {
                        TS100 *ts100 = (TS100 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ts100 getFilter:true];
                            [self addLog:@"getFilter!!!"];
                        }
                    }

                });
                break;
            }
                
            case API_ControlBuzzer: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    if ([self->passDev isMemberOfClass:[TS100 class]]) {
                        TS100 *ts100 = (TS100 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ts100 controlBuzzer:BA_Success];
                            [self addLog:@"controlBuzzer!!!"];
                        }
                    } else if ([self->passDev isMemberOfClass:[TS800 class]]) {
                        TS800 *ts800 = (TS800 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ts800 controlBuzzer:BA_Success];
                            [self addLog:@"controlBuzzer!!!"];
                        }
                    }

                });
                break;
            }
                
            case API_GetEventType: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    if ([self->passDev isMemberOfClass:[TS100 class]]) {
                        TS100 *ts100 = (TS100 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ts100 getEventType:true];
                            [self addLog:@"getEventType!!!"];
                        }
                    } else if ([self->passDev isMemberOfClass:[TS800 class]]) {
                        TS800 *ts800 = (TS800 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ts800 getEventType:true];
                            [self addLog:@"getEventType!!!"];
                        }
                    } else if ([self->passDev isMemberOfClass:[UR0250 class]]) {
                        UR0250 *ur0250 = (UR0250 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                             if (waitForCallback) {
                                 self->callbackCount++;
                             }
                             [ur0250 getEventType:true];
                             [self addLog:@"getEventType!!!"];
                        }
                    }

                });
                break;
            }
                
            case API_SetEventType: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    if ([self->passDev isMemberOfClass:[TS100 class]]) {
                        TS100 *ts100 = (TS100 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            BaseTagEvent *baseTagEvent = [[BaseTagEvent alloc] init];
                            [baseTagEvent addEventType:ET_TagPresentedEx];
                            [ts100 setEventType:true EventType:baseTagEvent];
                            [self addLog:@"setEventType!!!"];
                        }
                    } else if ([self->passDev isMemberOfClass:[TS800 class]]) {
                        TS800 *ts800 = (TS800 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            BaseTagEvent *baseTagEvent = [[BaseTagEvent alloc] init];
                            [baseTagEvent addEventType:ET_TagPresentedEx];
                            [ts800 setEventType:true EventType:baseTagEvent];
                            [self addLog:@"setEventType!!!"];
                        }
                    } else if ([self->passDev isMemberOfClass:[UR0250 class]]) {
                        UR0250 *ur0250 = (UR0250 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            BaseTagEvent *baseTagEvent = [[BaseTagEvent alloc] init];
                            [baseTagEvent addEventType:ET_TagPresentedEx];
                            [ur0250 setEventType:true EventType:baseTagEvent];
                            [self addLog:@"setEventType!!!"];
                        }
                    }

                });
                break;
            }
                
            case API_SetOutputInterfaces: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    if ([self->passDev isMemberOfClass:[TS100 class]]) {
                        TS100 *ts100 = (TS100 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            NSMutableSet *outputInterfaces = [[NSMutableSet alloc] init];
                            [outputInterfaces addObject:@(OI_Default_1_0)];
                            [ts100 setOutputInterfaces:true KeyboardSimulation:KS_HID_KEYBOARD OutputInterface:outputInterfaces];
                            [self addLog:@"setOutputInterfaces!!!"];
                        }
                    }

                });
                break;
            }
                
            case API_GetOutputInterfaces: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    if ([self->passDev isMemberOfClass:[TS100 class]]) {
                        TS100 *ts100 = (TS100 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ts100 getOutputInterfaces:false];
                            [self addLog:@"getOutputInterfaces!!!"];
                        }
                    }

                });
                break;
            }
                
            case API_GetPostDataDelimiter: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    if ([self->passDev isMemberOfClass:[TS100 class]]) {
                        TS100 *ts100 = (TS100 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ts100 getPostDataDelimiter:true];
                            [self addLog:@"getPostDataDelimiter!!!"];
                        }
                    }

                });
                break;
            }
                
            case API_SetPostDataDelimiter: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    if ([self->passDev isMemberOfClass:[TS100 class]]) {
                        TS100 *ts100 = (TS100 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            NSMutableSet *postDataDelimiter = [[NSMutableSet alloc] init];
                            [postDataDelimiter addObject:@(PDD_CARRIAGE)];
//                            [ts100 setPostDataDelimiter:true PostDataDelimiter:postDataDelimiter MemoryBankSelection:MBS_EPC];
                            [ts100 setPostDataDelimiter:true PostDataDelimiter:postDataDelimiter];
                            [self addLog:@"setPostDataDelimiter!!!"];
                        }
                    }

                });
                break;
            }
                
            case API_GetTagMemorySelection: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    if ([self->passDev isMemberOfClass:[TS100 class]]) {
                        TS100 *ts100 = (TS100 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ts100 getTagMemorySelection:true];
                            [self addLog:@"getTagMemorySelection!!!"];
                        }
                    }

                });
                break;
            }
                
            case API_SetTagMemorySelection: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    if ([self->passDev isMemberOfClass:[TS100 class]]) {
                        TS100 *ts100 = (TS100 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            NSMutableSet *tagMemorySelection = [[NSMutableSet alloc] init];
                            [tagMemorySelection addObject:@(TM_TID)];
                            [ts100 setTagMemorySelection:true TagMemory:tagMemorySelection];
                            [self addLog:@"setTagMemorySelection!!!"];
                        }
                    }

                });
                break;
            }
                
            case API_SetWifiSettings_1: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    if ([self->passDev isMemberOfClass:[TS100 class]]) {
                        TS100 *ts100 = (TS100 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount+=3;
                            }
                            [ts100 setWifiSettings:@"iPad" PWD:@"cghch543vbn"];
                            [self addLog:@"setWifiSettings 1!!!"];
                        }
                    } else if ([self->passDev isMemberOfClass:[TS800 class]]) {
                        TS800 *ts800 = (TS800 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount+=3;
                            }
                            [ts800 setWifiSettings:@"iPad" PWD:@"cghch543vbn"];
                            [self addLog:@"setWifiSettings 1!!!"];
                        }
                    } else if ([self->passDev isMemberOfClass:[UR0250 class]]) {
                        UR0250 *ur0250 = (UR0250 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount+=3;
                            }
                            [ur0250 setWifiSettings:@"iPad" PWD:@"cghch543vbn"];
                            [self addLog:@"setWifiSettings 1!!!"];
                        }
                    }

                });
                break;
            }
                
            case API_SetWifiSettings_2: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    if ([self->passDev isMemberOfClass:[TS100 class]]) {
                        TS100 *ts100 = (TS100 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount+=4;
                            }
                            [ts100 setWifiSettings:@"iPad" PWD:@"cghch543vbn" IP:@"192.168.0.123" Gateway:@"192.168.0.1" SubNetMask:@"255.255.255.0"];
                            [self addLog:@"setWifiSettings 2!!!"];
                        }
                    } else if ([self->passDev isMemberOfClass:[TS800 class]]) {
                        TS800 *ts800 = (TS800 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount+=4;
                            }
                            [ts800 setWifiSettings:@"iPad" PWD:@"cghch543vbn" IP:@"192.168.0.123" Gateway:@"192.168.0.1" SubNetMask:@"255.255.255.0"];
                            [self addLog:@"setWifiSettings 1!!!"];
                        }
                    } else if ([self->passDev isMemberOfClass:[UR0250 class]]) {
                        UR0250 *ur0250 = (UR0250 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount+=4;
                            }
                            [ur0250 setWifiSettings:@"iPad" PWD:@"cghch543vbn" IP:@"192.168.0.123" Gateway:@"192.168.0.1" SubNetMask:@"255.255.255.0"];
                            [self addLog:@"setWifiSettings 1!!!"];
                        }
                    }

                });
                break;
            }
                
            case API_SetTagPresentedRepeatInterval: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    if ([self->passDev isMemberOfClass:[TS100 class]]) {
                        TS100 *ts100 = (TS100 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ts100 setTagPresentedRepeatInterval:true Time:254];
                            [self addLog:@"setTagPresentedRepeatInterval!!!"];
                        }
                    } else if ([self->passDev isMemberOfClass:[TS800 class]]) {
                        TS800 *ts800 = (TS800 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ts800 setTagPresentedRepeatInterval:true Time:254];
                            [self addLog:@"setTagPresentedRepeatInterval!!!"];
                        }
                    } else if ([self->passDev isMemberOfClass:[UR0250 class]]) {
                        UR0250 *ur0250 = (UR0250 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ur0250 setTagPresentedRepeatInterval:true Time:254];
                            [self addLog:@"setTagPresentedRepeatInterval!!!"];
                        }
                    }

                });
                break;
            }
                
            case API_GetTagPresentedRepeatInterval: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    if ([self->passDev isMemberOfClass:[TS100 class]]) {
                        TS100 *ts100 = (TS100 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ts100 getTagPresentedRepeatInterval:true];
                            [self addLog:@"getTagPresentedRepeatInterval!!!"];
                        }
                    } else if ([self->passDev isMemberOfClass:[TS800 class]]) {
                        TS800 *ts800 = (TS800 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ts800 getTagPresentedRepeatInterval:true];
                            [self addLog:@"getTagPresentedRepeatInterval!!!"];
                        }
                    } else if ([self->passDev isMemberOfClass:[UR0250 class]]) {
                        UR0250 *ur0250 = (UR0250 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ur0250 getTagPresentedRepeatInterval:true];
                            [self addLog:@"getTagPresentedRepeatInterval!!!"];
                         }
                     }

                });
                break;
            }
                
            case API_GetWiFiMacAddress: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    if ([self->passDev isMemberOfClass:[TS100 class]]) {
                        TS100 *ts100 = (TS100 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ts100 getWiFiMacAddress];
                            [self addLog:@"getWiFiMacAddress!!!"];
                        }
                    } else if ([self->passDev isMemberOfClass:[TS800 class]]) {
                        TS800 *ts800 = (TS800 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ts800 getWiFiMacAddress];
                            [self addLog:@"getWiFiMacAddress!!!"];
                        }
                    } else if ([self->passDev isMemberOfClass:[UR0250 class]]) {
                        UR0250 *ur0250 = (UR0250 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ur0250 getWiFiMacAddress];
                            [self addLog:@"getWiFiMacAddress!!!"];
                        }
                    }

                });
                break;
            }
                
            case API_SetRemoteHost: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    if ([self->passDev isMemberOfClass:[TS100 class]]) {
                        TS100 *ts100 = (TS100 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            InetAddress *inetAddress = [[InetAddress alloc] init:@"192.168.0.123"];
                            InetSocketAddress *inetSocketAddress = [[InetSocketAddress alloc] init:inetAddress Port:1111];
                            [ts100 setRemoteHost:4 InetSocketAddress:inetSocketAddress];
                            [self addLog:@"setRemoteHost!!!"];
                        }
                    } else if ([self->passDev isMemberOfClass:[TS800 class]]) {
                        TS800 *ts800 = (TS800 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            InetAddress *inetAddress = [[InetAddress alloc] init:@"192.168.0.123"];
                            InetSocketAddress *inetSocketAddress = [[InetSocketAddress alloc] init:inetAddress Port:1111];
                            [ts800 setRemoteHost:4 InetSocketAddress:inetSocketAddress];
                            [self addLog:@"setRemoteHost!!!"];
                        }
                    } else if ([self->passDev isMemberOfClass:[UR0250 class]]) {
                        UR0250 *ur0250 = (UR0250 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            InetAddress *inetAddress = [[InetAddress alloc] init:@"192.168.0.123"];
                            InetSocketAddress *inetSocketAddress = [[InetSocketAddress alloc] init:inetAddress Port:1111];
                            [ur0250 setRemoteHost:4 InetSocketAddress:inetSocketAddress];
                            [self addLog:@"setRemoteHost!!!"];
                        }
                    }

                });
                break;
            }
                
            case API_GetRemoteHost: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    if ([self->passDev isMemberOfClass:[TS100 class]]) {
                        TS100 *ts100 = (TS100 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ts100 getRemoteHost];
                            [self addLog:@"getRemoteHost!!!"];
                        }
                    } else if ([self->passDev isMemberOfClass:[TS800 class]]) {
                        TS800 *ts800 = (TS800 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ts800 getRemoteHost];
                            [self addLog:@"getRemoteHost!!!"];
                        }
                    } else if ([self->passDev isMemberOfClass:[UR0250 class]]) {
                        UR0250 *ur0250 = (UR0250 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ur0250 getRemoteHost];
                            [self addLog:@"getRemoteHost!!!"];
                        }
                    }

                });
                break;
            }
                
            case API_WriteTagEx_1: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    if ([self->passDev isMemberOfClass:[TS100 class]]) {
                        TS100 *ts100 = (TS100 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            BaseTagData *baseTagData = [[BaseTagData alloc] initWithWriteEpcHeader:EPC_SGTIN96 Barcode:@"12345678"];
                            [ts100 writeTagEx:baseTagData];
                            [self addLog:@"writeTagEx 1!!!"];
                        }
                    }
                });
                break;
            }
                
            case API_WriteTagEx_2: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    if ([self->passDev isMemberOfClass:[TS100 class]]) {
                        TS100 *ts100 = (TS100 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            BaseTagData *baseTagData = [[BaseTagData alloc] initWithWriteEpcHeader:EPC_SGTIN96 Barcode:@"12345678"];
                            [ts100 writeTagEx:baseTagData HexAccessPassword:@"00000000"];
                            [self addLog:@"writeTagEx 2!!!"];
                        }
                    }
                });
                break;
            }
                
            case API_ReadTagEx_1: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    if ([self->passDev isMemberOfClass:[TS100 class]]) {
                        TS100 *ts100 = (TS100 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ts100 readTagEx];
                            [self addLog:@"readTagEx 1!!!"];
                        }
                    }
                });
                break;
            }
                
            case API_ReadTagEx_2: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    if ([self->passDev isMemberOfClass:[TS100 class]]) {
                        TS100 *ts100 = (TS100 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ts100 readTagEx:@"00000000"];
                            [self addLog:@"readTagEx 2!!!"];
                        }
                    }
                });
                break;
            }
                
            case API_GetBarcodeReadFormat: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    if ([self->passDev isMemberOfClass:[TS100 class]]) {
                        TS100 *ts100 = (TS100 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ts100 getBarcodeReadFormat:true];
                            [self addLog:@"getBarcodeReadFormat!!!"];
                        }
                    }

                });
                break;
            }
                
            case API_SetBarcodeReadFormat: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    if ([self->passDev isMemberOfClass:[TS100 class]]) {
                        TS100 *ts100 = (TS100 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ts100 setBarcodeReadFormat:true BarcodeFormat:GTIN_14];
                            [self addLog:@"setBarcodeReadFormat!!!"];
                        }
                    }

                });
                break;
            }
                
            case API_GetFieldSeparator: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    if ([self->passDev isMemberOfClass:[TS100 class]]) {
                        TS100 *ts100 = (TS100 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ts100 getFieldSeparator:true];
                            [self addLog:@"getFieldSeparator!!!"];
                        }
                    }

                });
                break;
            }
                
            case API_SetFieldSeparator: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    if ([self->passDev isMemberOfClass:[TS100 class]]) {
                        TS100 *ts100 = (TS100 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            NSString *string = @".";
//                            NSData *separator = [string dataUsingEncoding:NSUTF8StringEncoding];
//                            NSData *separator = [TS100 dataFromHexString:string];
                            NSData *separator = [string dataUsingEncoding:NSUTF8StringEncoding];
                            [ts100 setFieldSeparator:true FieldSeparator:separator];
                            [self addLog:@"setFieldSeparator!!!"];
                        }
                    }

                });
                break;
            }
                
            case API_GetPrefix: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    if ([self->passDev isMemberOfClass:[TS100 class]]) {
                        TS100 *ts100 = (TS100 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ts100 getPrefix:false];
                            [self addLog:@"getPrefix!!!"];
                        }
                    }

                });
                break;
            }
                
            case API_SetPrefix: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    if ([self->passDev isMemberOfClass:[TS100 class]]) {
                        TS100 *ts100 = (TS100 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            NSData* prefix  = [GLog CreateDataWithHexString:@"1234"];

                            [ts100 setPrefix:TRUE Prefix:prefix];
                            [self addLog:@"setPrefix!!!"];
                        }
                    }

                });
                break;
            }
                
            case API_GetSuffix: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    if ([self->passDev isMemberOfClass:[TS100 class]]) {
                        TS100 *ts100 = (TS100 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ts100 getSuffix:false];
                            [self addLog:@"getSuffix!!!"];
                        }
                    }

                });
                break;
            }
                
            case API_SetSuffix: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    if ([self->passDev isMemberOfClass:[TS100 class]]) {
                        TS100 *ts100 = (TS100 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            NSData* suffix  = [GLog CreateDataWithHexString:@"1234"];

                            [ts100 setSuffix:TRUE Suffix:suffix];
                            [self addLog:@"setSuffix!!!"];
                        }
                    }

                });
                break;
            }
                
            case API_GetDeactivateEpcPrefix: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    if ([self->passDev isMemberOfClass:[TS100 class]]) {
                        TS100 *ts100 = (TS100 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ts100 getDeactivateEpcPrefix:TRUE];
                            [self addLog:@"getDeactivateEpcPrefix!!!"];
                        }
                    }

                });
                break;
            }
                
            case API_SetDeactivateEpcPrefix: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    if ([self->passDev isMemberOfClass:[TS100 class]]) {
                        TS100 *ts100 = (TS100 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            NSData* prefix  = [GLog CreateDataWithHexString:@"1234"];
                            
                            [ts100 setDeactivateEpcPrefix:TRUE Prefix:prefix];
                            [self addLog:@"setDeactivateEpcPrefix!!!"];
                        }
                    }

                });
                break;
            }
                
            case API_GetReactivateEpcPrefix: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    if ([self->passDev isMemberOfClass:[TS100 class]]) {
                        TS100 *ts100 = (TS100 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ts100 getReactivateEpcPrefix:TRUE];
                            [self addLog:@"getReactivateEpcPrefix!!!"];
                        }
                    }

                });
                break;
            }
                
            case API_SetReactivateEpcPrefix: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    if ([self->passDev isMemberOfClass:[TS100 class]]) {
                        TS100 *ts100 = (TS100 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            NSData* prefix  = [GLog CreateDataWithHexString:@"1234"];
                            
                            [ts100 setReactivateEpcPrefix:TRUE Prefix:prefix];
                            [self addLog:@"setReactivateEpcPrefix!!!"];
                        }
                    }

                });
                break;
            }
                
            case API_GetTransformEpcState: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    if ([self->passDev isMemberOfClass:[TS100 class]]) {
                        TS100 *ts100 = (TS100 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ts100 getTransformEpcState:TRUE];
                            [self addLog:@"getTransformEpcState!!!"];
                        }
                    }

                });
                break;
            }
                
            case API_SetTransformEpcState: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    if ([self->passDev isMemberOfClass:[TS100 class]]) {
                        TS100 *ts100 = (TS100 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ts100 setTransformEpcState:TRUE State:EPC_PREFIX_ON];
                            [self addLog:@"setTransformEpcState!!!"];
                        }
                    }

                });
                break;
            }
                
            case API_GetTransformEpcPrefix: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    if ([self->passDev isMemberOfClass:[TS100 class]]) {
                        TS100 *ts100 = (TS100 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ts100 getTransformEpcPrefix:TRUE];
                            [self addLog:@"getTransformEpcPrefix!!!"];
                        }
                    }

                });
                break;
            }
                
            case API_SetTransformEpcPrefix: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    if ([self->passDev isMemberOfClass:[TS100 class]]) {
                        TS100 *ts100 = (TS100 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            NSData* prefix  = [GLog CreateDataWithHexString:@"1234"];
                            
                            [ts100 setTransformEpcPrefix:TRUE Prefix:prefix];
                            [self addLog:@"setTransformEpcPrefix!!!"];
                        }
                    }

                });
                break;
            }
                
            case API_GetEncodeType: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    if ([self->passDev isMemberOfClass:[TS100 class]]) {
                        TS100 *ts100 = (TS100 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ts100 getEncodeType:TRUE];
                            [self addLog:@"getEncodeType!!!"];
                        }
                    }

                });
                break;
            }
                
            case API_SetEncodeType: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    if ([self->passDev isMemberOfClass:[TS100 class]]) {
                        TS100 *ts100 = (TS100 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            
                            [ts100 setEncodeType:true EncodeType:EM_ALL];
                            [self addLog:@"setEncodeType!!!"];
                        }
                    }

                });
                break;
            }
                
            case API_GetTagProtection: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    if ([self->passDev isMemberOfClass:[TS100 class]]) {
                        TS100 *ts100 = (TS100 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ts100 getTagProtection:TRUE];
                            [self addLog:@"getTagProtection!!!"];
                        }
                    }

                });
                break;
            }
                
            case API_SetTagProtection: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    if ([self->passDev isMemberOfClass:[TS100 class]]) {
                        TS100 *ts100 = (TS100 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            
                            [ts100 setTagProtection:true TagProtection:TP_Disabled];
                            [self addLog:@"setTagProtection!!!"];
                        }
                    }

                });
                break;
            }
                
            case API_GetTagProtectionAccessPassword: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    if ([self->passDev isMemberOfClass:[TS100 class]]) {
                        TS100 *ts100 = (TS100 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ts100 getTagProtectionAccessPassword];
                            [self addLog:@"getTagProtectionAccessPassword!!!"];
                        }
                    }

                });
                break;
            }
                
            case API_SetTagProtectionAccessPassword: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    if ([self->passDev isMemberOfClass:[TS100 class]]) {
                        TS100 *ts100 = (TS100 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            
                            [ts100 setTagProtectionAccessPassword:[GLog CreateDataWithHexString:@"11111111"]];
                            [self addLog:@"setTagProtectionAccessPassword!!!"];
                        }
                    }

                });
                break;
            }
                
            case API_GetUsbInterface: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    if ([self->passDev isMemberOfClass:[TS100 class]]) {
                        TS100 *ts100 = (TS100 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ts100 getUsbInterface:TRUE];
                            [self addLog:@"getUsbInterface!!!"];
                        }
                    }

                });
                break;
            }
                
            case API_SetUsbInterface: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    if ([self->passDev isMemberOfClass:[TS100 class]]) {
                        TS100 *ts100 = (TS100 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount+=2;
                            }
                            
                            [ts100 setUsbInterface:true UsbInterface:UI_HID];
                            [self addLog:@"setUsbInterface!!!"];
                        }
                    }

                });
                break;
            }
                
            case API_GetOutputFormat: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    if ([self->passDev isMemberOfClass:[TS100 class]]) {
                        TS100 *ts100 = (TS100 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ts100 getOutputFormat:TRUE];
                            [self addLog:@"getOutputFormat!!!"];
                        }
                    }

                });
                break;
            }
                
            case API_SetOutputFormat: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    if ([self->passDev isMemberOfClass:[TS100 class]]) {
                        TS100 *ts100 = (TS100 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount+=2;
                            }
                            
                            [ts100 setOutputFormat:true OutputFormat:OF_DISABLED];
                            [self addLog:@"setOutputFormat!!!"];
                        }
                    }

                });
                break;
            }
                
            case API_SetTriggerType: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    if ([self->passDev isMemberOfClass:[TS800 class]]) {
                        TS800 *ts800 = (TS800 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
//                            NSMutableSet *triggerType = Command;
                            NSMutableSet *triggerType = [[NSMutableSet alloc] init];
                            [triggerType addObject:@(Command)];
                            [triggerType addObject:@(DigitalInput)];
                            [triggerType addObject:@(Sensor)];
                            [ts800 setTriggerType:false TriggerType:triggerType];
                            [self addLog:@"setOutputInterface!!!"];
                        }
                    }else if ([self->passDev isMemberOfClass:[UR0250 class]]) {
                        UR0250 *ur0250 = (UR0250 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
//                            TriggerType triggerType = Command;
                            NSMutableSet *triggerType = [[NSMutableSet alloc] init];
                            [triggerType addObject:@(Command)];
                            [triggerType addObject:@(DigitalInput)];
                            [triggerType addObject:@(Sensor)];
                            [ur0250 setTriggerType:false TriggerType:triggerType];
                            [self addLog:@"setOutputInterface!!!"];
                        }
                    }

                });
                break;
            }
                
            case API_GetTriggerType: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    if ([self->passDev isMemberOfClass:[TS800 class]]) {
                        TS800 *ts800 = (TS800 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ts800 getTriggerType:true];
                            [self addLog:@"getTriggerType!!!"];
                        }
                    } else if ([self->passDev isMemberOfClass:[UR0250 class]]) {
                        UR0250 *ur0250 = (UR0250 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ur0250 getTriggerType:true];
                            [self addLog:@"getTriggerType!!!"];
                        }
                    }

                });
                break;
            }
                
            case API_GetIOState: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    if ([self->passDev isMemberOfClass:[TS800 class]]) {
                        TS800 *ts800 = (TS800 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ts800 getIOState];
                            [self addLog:@"getIOState!!!"];
                        }
                    } else if ([self->passDev isMemberOfClass:[UR0250 class]]) {
                        UR0250 *ur0250 = (UR0250 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ur0250 getIOState];
                            [self addLog:@"getIOState!!!"];
                        }
                    }

                });
                break;
            }
                
            case API_SetIOState: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    if ([self->passDev isMemberOfClass:[TS800 class]]) {
                        TS800 *ts800 = (TS800 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            IONumber ioNumber = OUTPUT_PIN_0;
                            IOState ioState = LOW;
                            [ts800 setIOState:ioNumber IOState:ioState];
                            [self addLog:@"setIOState!!!"];
                        }
                    } else if ([self->passDev isMemberOfClass:[UR0250 class]]) {
                        UR0250 *ur0250 = (UR0250 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            IONumber ioNumber = OUTPUT_PIN_0;
                            IOState ioState = LOW;
                            [ur0250 setIOState:ioNumber IOState:ioState];
                            [self addLog:@"setIOState!!!"];
                        }
                    }

                });
                break;
            }
                
            case API_SetOutputInterface: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    if ([self->passDev isMemberOfClass:[TS800 class]]) {
                        TS800 *ts800 = (TS800 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ts800 setOutputInterface:true KeyboardSimulation:KS_HID_KEYBOARD OutputInterface:OI_Default_1_0];
                            [self addLog:@"setOutputInterface!!!"];
                        }
                    }

                });
                break;
            }
                
            case API_GetOutputInterface: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    if ([self->passDev isMemberOfClass:[TS800 class]]) {
                        TS800 *ts800 = (TS800 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ts800 getOutputInterface:true];
                            [self addLog:@"getOutputInterface!!!"];
                        }
                    }

                });
                break;
            }
                
            case API_SetScanMode: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    if ([self->passDev isMemberOfClass:[TS800 class]]) {
                        TS800 *ts800 = (TS800 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ts800 setScanMode:true ScanMode:SM_TRIGGER_A_LEVEL_CONTROL];
                            [self addLog:@"setScanMode!!!"];
                        }
                    } else if ([self->passDev isMemberOfClass:[UR0250 class]]) {
                        UR0250 *ur0250 = (UR0250 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ur0250 setScanMode:true ScanMode:SM_TRIGGER_A_LEVEL_CONTROL];
                            [self addLog:@"setScanMode!!!"];
                        }
                    }

                });
                break;
            }
                
            case API_GetScanMode: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    if ([self->passDev isMemberOfClass:[TS800 class]]) {
                        TS800 *ts800 = (TS800 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ts800 getScanMode:true];
                            [self addLog:@"getScanMode!!!"];
                        }
                    } else if ([self->passDev isMemberOfClass:[UR0250 class]]) {
                        UR0250 *ur0250 = (UR0250 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ur0250 getScanMode:true];
                            [self addLog:@"getScanMode!!!"];
                        }
                    }

                });
                break;
            }
                
            case API_SetCommandTriggerState: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    if ([self->passDev isMemberOfClass:[TS800 class]]) {
                        TS800 *ts800 = (TS800 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ts800 setCommandTriggerState:ON];
                            [self addLog:@"setCommandTriggerState!!!"];
                        }
                    } else if ([self->passDev isMemberOfClass:[UR0250 class]]) {
                        UR0250 *ur0250 = (UR0250 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ur0250 setCommandTriggerState:ON];
                            [self addLog:@"setCommandTriggerState!!!"];
                        }
                    }

                });
                break;
            }
                
            case API_GetCommandTriggerState: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    if ([self->passDev isMemberOfClass:[TS800 class]]) {
                        TS800 *ts800 = (TS800 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ts800 getCommandTriggerState];
                            [self addLog:@"getCommandTriggerState!!!"];
                        }
                    } else if ([self->passDev isMemberOfClass:[UR0250 class]]) {
                        UR0250 *ur0250 = (UR0250 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ur0250 getCommandTriggerState];
                            [self addLog:@"getCommandTriggerState!!!"];
                        }
                    }

                });
                break;
            }
                
            case API_GetIpAddress: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    if ([self->passDev isMemberOfClass:[TS800 class]]) {
                        TS800 *ts800 = (TS800 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ts800 getIpAddress];
                            [self addLog:@"getIpAddress!!!"];
                        }
                    }

                });
                break;
            }
                
            case API_BLEDisconnect: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    for (int j = 0; j < repeat; j++) {
                        if (waitForCallback) {
                            self->callbackCount++;
                        }
                        [self disconnectDevice];
                    }
                });
                break;
            }
                
            case API_GetDeviceID: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    for (int j = 0; j < repeat; j++) {
                        if (waitForCallback) {
                            self->callbackCount++;
                        }
                        [self->passDev getDeviceID:true];
                        [self addLog:@"getDeviceID!!!"];
                    }
                });
                break;
            }
                
            case API_SetDeviceID: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    for (int j = 0; j < repeat; j++) {
                        if (waitForCallback) {
                            self->callbackCount++;
                        }
                        [self->passDev setDeviceID:true DeviceID:255];
                        [self addLog:@"setDeviceID!!!"];
                    }
                });
                break;
            }
                
            case API_GetEpcNormalize: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    if ([self->passDev isMemberOfClass:[TS100 class]]) {
                        TS100 *ts100 = (TS100 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            [ts100 getEpcNormalize:TRUE];
                            [self addLog:@"getEpcNormalize!!!"];
                        }
                    }

                });
                break;
            }
                
            case API_SetEpcNormalize: {
                dispatch_async(dispatch_get_main_queue(), ^{

                    if ([self->passDev isMemberOfClass:[TS100 class]]) {
                        TS100 *ts100 = (TS100 *) self->passDev;
                        for (int j = 0; j < repeat; j++) {
                            if (waitForCallback) {
                                self->callbackCount++;
                            }
                            
                            [ts100 setEpcNormalize:true Enable:true];
                            [self addLog:@"setEpcNormalize!!!"];
                        }
                    }

                });
                break;
            }

            default: {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self addLog:[NSString stringWithFormat:@"undefined action, action = %d, repeat = %d, waitForCallback = %d", action, repeat, waitForCallback]];
                });
            }
                break;
        }
        
        if (waitForCallback) {
            [actions removeObjectsInRange:NSMakeRange(0, i + 1)];
            actionArrayAfterCallback = [[NSMutableArray alloc] initWithArray:actions copyItems:true];
            [actions removeAllObjects];
            break;
        } else {
            if (actionArrayAfterCallback != NULL && [actionArrayAfterCallback count] > 0) {
                [actionArrayAfterCallback removeAllObjects];
                actionArrayAfterCallback = nil;
            }
        }
    }
    
    if ([actions count] == finishedItems) {

        dispatch_async(dispatch_get_main_queue(), ^{
            [self addLog:@"測試結束"];
            
            [self enableButtons];
        });
    }
}

- (IBAction)test_1:(id)sender {
    if (passDev == nil) {
        [self addLog:@"\nBase Device 是 null, 無法測試..."];
        return;
    }
    isGettingFirmwareVersion = false;
    
    [self disableButtons];
    
    [self addLog:@"\n測試 1... 連線後取得 FW 的 ROM Version..."];
    
    [self addLog:@"1. BLE Connect..."];
    [self addLog:@"2. 連線成功的 Callback，下 getFirmwareVersion..."];
    [self addLog:@"3. 取得 FirmwareVersion 的 Callback 檢查 FirmwareVersion 是否正確..."];
    [self addLog:@"4. 檢查完畢後斷線..."];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject: @[@(API_BLEConnect), @(1), @(TRUE)]];
    
    [array addObject: @[@(API_GetFirmwareVersion), @(1), @(TRUE)]];
    
    [array addObject: @[@(API_BLEDisconnect), @(1)]];

    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(run:) object:array];

    [thread start];
}

- (IBAction)test_2:(id)sender {
    if (passDev == nil) {
        [self addLog:@"\nBase Device 是 null, 無法測試..."];
        return;
    }
    isGettingFirmwareVersion = false;
    
    [self disableButtons];

    [self addLog:@"\n測試 2... 連線後取得 Frequency十次..."];
    
    [self addLog:@"1. BLE Connect..."];
    [self addLog:@"2. 連線成功的 Callback，用 for loop 下 10 個 getFrequency..."];
    [self addLog:@"3. 取得 getFrequency 的 Callback 檢查是否有收到 10 次 Frequency，Frequency 是否正確..."];
    [self addLog:@"4. 檢查完畢後斷線..."];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject: @[@(API_BLEConnect), @(1), @(TRUE)]];
    
    [array addObject: @[@(API_GetFrequency), @(10), @(TRUE)]];
    
    [array addObject: @[@(API_BLEDisconnect), @(1)]];

    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(run:) object:array];

    [thread start];
}

- (IBAction)test_3:(id)sender {
    if (passDev == nil) {
        [self addLog:@"\nBase Device 是 null, 無法測試..."];
        return;
    }
    isGettingFirmwareVersion = false;
    
    [self disableButtons];
    
    [self addLog:@"\n測試 3... 連線後設定 Frequenc十次..."];
    
    [self addLog:@"1. BLE Connect..."];
    [self addLog:@"2. 連線成功的 Callback，用 for loop 下 10 個 setFrequency..."];
    [self addLog:@"3. 取得 getFrequency 的 Callback 檢查是否有收到 10 次 Frequency，Frequency 是否正確..."];
    [self addLog:@"4. 檢查完畢後斷線..."];

    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject: @[@(API_BLEConnect), @(1), @(TRUE)]];
    
    [array addObject: @[@(API_SetFrequency), @(10), @(TRUE)]];
    
    [array addObject: @[@(API_BLEDisconnect), @(1)]];

    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(run:) object:array];

    [thread start];
}

- (IBAction)test_4:(id)sender {
    if (passDev == nil) {
        [self addLog:@"\nBase Device 是 null, 無法測試..."];
        return;
    }
    isGettingFirmwareVersion = false;
    
    [self disableButtons];
    
    [self addLog:@"\n測試 4... 連線後取得 getFirmwareVersion，再 getBleDeviceName..."];
    
    [self addLog:@"1. BLE Connect..."];
    [self addLog:@"2. 連線成功的 Callback，下 getBleDeviceName..."];
    [self addLog:@"3. 取得 FirmwareVersion 的 Callback 檢查 FirmwareVersion 是否正確..."];
    [self addLog:@"4. 檢查完，在 Callback 裡下 getBleDeviceName..."];
    [self addLog:@"5. 檢查 getBleDeviceName 是否正確..."];
    
    [self addLog:@"4. 檢查完畢後斷線..."];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject: @[@(API_BLEConnect), @(1), @(TRUE)]];
    
    [array addObject: @[@(API_GetFirmwareVersion), @(1), @(TRUE)]];
    
    [array addObject: @[@(API_GetBleDeviceName), @(1), @(TRUE)]];
    
    [array addObject: @[@(API_BLEDisconnect), @(1)]];

    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(run:) object:array];

    [thread start];
}

- (IBAction)test_5:(id)sender {
    if (passDev == nil) {
        [self addLog:@"\nBase Device 是 null, 無法測試..."];
        return;
    }
    isGettingFirmwareVersion = false;
    
    [self disableButtons];
    
    [self addLog:@"\n測試 5... 連線後取得 getFirmwareVersion，再 setFrequency..."];
    
    [self addLog:@"1. BLE Connect..."];
    [self addLog:@"2. 連線成功的 Callback，下 getFirmwareVersion..."];
    [self addLog:@"3. 取得 FirmwareVersion 的 Callback 檢查 FirmwareVersion 是否正確..."];
    [self addLog:@"4. 檢查完，在 Callback 裡下 setFrequency..."];
    [self addLog:@"5. 檢查 setFrequency 是否正確..."];
    
    [self addLog:@"4. 檢查完畢後斷線..."];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject: @[@(API_BLEConnect), @(1), @(TRUE)]];
    
    [array addObject: @[@(API_GetFirmwareVersion), @(1), @(TRUE)]];
    
    [array addObject: @[@(API_SetFrequency), @(1), @(TRUE)]];
    
    [array addObject: @[@(API_BLEDisconnect), @(1)]];

    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(run:) object:array];

    [thread start];
}

- (IBAction)test_6:(id)sender {
    if (passDev == nil) {
        [self addLog:@"\nBase Device 是 null, 無法測試..."];
        return;
    }
    isGettingFirmwareVersion = false;
    
    [self disableButtons];
    
    [self addLog:@"\n測試 6... 在傳輸資料時斷線，再次連線下 readTag..."];
    
    [self addLog:@"1. BLE Connect..."];
    [self addLog:@"2. 連線成功的 Callback，用 for loop 下 10 個 getFirmwareVersion，再馬上斷線..."];
    [self addLog:@"3. 再次 BLE 連線..."];
    [self addLog:@"4. 連線成功後再下 readTag..."];
    [self addLog:@"5. 檢查 readTag 內容是否正確..."];
    
    [self addLog:@"4. 檢查完畢後斷線..."];
        
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject: @[@(API_BLEConnect), @(1), @(TRUE)]];
    
    [array addObject: @[@(API_GetFirmwareVersion), @(10), @(FALSE)]];
    
    [array addObject: @[@(API_BLEDisconnect), @(1)]];
    
    [array addObject: @[@(API_BLEConnect), @(1), @(TRUE)]];
    
    [array addObject: @[@(API_ReadTag_1), @(1), @(TRUE)]];
    
    [array addObject: @[@(API_BLEDisconnect), @(1)]];

    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(run:) object:array];

    [thread start];
}

- (IBAction)test_7:(id)sender {
    if (passDev == nil) {
        [self addLog:@"\nBase Device 是 null, 無法測試..."];
        return;
    }
    isGettingFirmwareVersion = false;
    
    [self disableButtons];
    
    [self addLog:@"\n測試 7... 自行定義測試組合..."];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject: @[@(API_BLEConnect), @(1), @(TRUE)]];
    
    // Testing : startInventory : OK
//    [array addObject: @[@(API_StartInventory), @(10), @(TRUE)]];
    
    // Testing : stopInventory : OK
//    [array addObject: @[@(API_StopInventory), @(10), @(TRUE)]];
    
    // Testing : writeEpc : OK
//    [array addObject: @[@(API_WriteEpc_1), @(10), @(TRUE)]];
    
    // Testing : writeEpc : OK
//    [array addObject: @[@(API_WriteEpc_2), @(10), @(TRUE)]];
    
    // Testing : readTag : OK
//    [array addObject: @[@(API_ReadTag_1), @(3), @(TRUE)]];
    
    // Testing : readTag : OK
//    [array addObject: @[@(API_ReadTag_2), @(1), @(TRUE)]];
    
    // Testing : writeTag : OK
//    [array addObject: @[@(API_WriteTag_1), @(10), @(TRUE)]];
    
    // Testing : writeTag : OK
//    [array addObject: @[@(API_WriteTag_2), @(10), @(TRUE)]];
    
    // Testing : getRfPower : OK
//    [array addObject: @[@(API_GetRfPower), @(1), @(TRUE)]];
    
    // Testing : setRfPower : OK
//    [array addObject: @[@(API_SetRfPower), @(1)]];
    
    // Testing : getRfSensitivity : OK
//    [array addObject: @[@(API_GetRfSensitivity), @(1)]];
    
    // Testing : setRfSensitivity : OK
//    [array addObject: @[@(API_SetRfSensitivity), @(10), @(TRUE)]];
    
    // Testing : getFrequency : OK
//    [array addObject: @[@(API_GetFrequency), @(10), @(TRUE)]];
    
    // Testing : setFrequency : OK
//    [array addObject: @[@(API_SetFrequency), @(10), @(TRUE)]];
    
    // Testing : getQValue : OK
//    [array addObject: @[@(API_GetQValue), @(10), @(TRUE)]];
    
    // Testing : setQValue : OK
//    [array addObject: @[@(API_SetQValue), @(10), @(TRUE)]];
    
    // Testing : setSessionAndTarget : OK
//    [array addObject: @[@(API_SetSessionAndTarget), @(10), @(TRUE)]];
  
    // Testing : getSessionAndTarget : OK
//    [array addObject: @[@(API_GetSessionAndTarget), @(10), @(TRUE)]];
    
    // Testing : getFirmwareVersion : OK
//    [array addObject: @[@(API_GetFirmwareVersion), @(1), @(TRUE)]];
    
    // Testing : setTagRemovedThreshold : OK
//    [array addObject: @[@(API_SetTagRemovedThread), @(10), @(TRUE)]];
    
    // Testing : getTagRemovedThreshold : OK
//    [array addObject: @[@(API_GetTagRemovedThread), @(10), @(TRUE)]];

    // Testing : setInventoryRoundInterval : OK
//    [array addObject: @[@(API_SetInventoryReoundInterval), @(10), @(TRUE)]];
    
    // Testing : getInventoryRoundInterval : OK
//    [array addObject: @[@(API_GetInventoryReoundInterval), @(10), @(TRUE)]];
    
    // Testing : lockTag : OK
//    [array addObject: @[@(API_LockTag_1), @(10), @(TRUE)]];
    
    // Testing : lockTag : OK
//    [array addObject: @[@(API_LockTag_2), @(10), @(TRUE)]];

    // TODO: Testing : API_KillTag_1 : Error  sending ReqRN, Same As Android
//    [array addObject: @[@(API_KillTag_1), @(1), @(TRUE)]];
    
    // TODO: Testing : API_KillTag_1 : Error  sending ReqRN, Same As Android
//    [array addObject: @[@(API_KillTag_2), @(1), @(TRUE)]];
    
    // Testing : getRxDecode : OK
//    [array addObject: @[@(API_GetRxDecode), @(10), @(TRUE)]];
    
    // Testing : setRxDecode : OK
//    [array addObject: @[@(API_SetRxDecode), @(10), @(TRUE)]];
    
    // Testing : getLinkFrequency : OK
//    [array addObject: @[@(API_GetLinkFrequency), @(10), @(TRUE)]];
    
    // Testing : setLinkFrequency : OK
//    [array addObject: @[@(API_SetLinkFrequency), @(10), @(TRUE)]];
    
    // Testing : getProfile : OK
//    [array addObject: @[@(API_GetProfile), @(10), @(TRUE)]];
    
    // Testing : setProfile : OK
//    [array addObject: @[@(API_SetProfile), @(10), @(TRUE)]];
    
    // Testing : directIO : OK
//    [array addObject: @[@(API_DirectIO), @(10), @(TRUE)]];
    
    // Testing : getDeviceID : OK
//    [array addObject: @[@(API_GetDeviceID), @(10), @(TRUE)]];
    
    // Testing : setDeviceID : OK
//    [array addObject: @[@(API_SetDeviceID), @(10), @(TRUE)]];
	    
    if ([self->passDev isMemberOfClass:[TS100 class]]) {
        // Testing : getBleDeviceName : OK
//        [array addObject: @[@(API_GetBleDeviceName), @(10), @(TRUE)]];
        
        // Testing : setBleDeviceName : OK
//        [array addObject: @[@(API_SetBleDeviceName), @(10), @(TRUE)]];
        
        // Testing : getBleMacAddress : OK
//        [array addObject: @[@(API_GetBleMacAddress), @(10), @(TRUE)]];
        
        // Testing : getBleRomVersion : OK
//        [array addObject: @[@(API_GetBleRomVersion), @(1), @(TRUE)]];
        
        // Testing : startInventoryEx : OK
//        [array addObject: @[@(API_StartInventoryEx), @(1), @(TRUE)]];
    
        // Testing : getInventoryActiveMode : OK
//        [array addObject: @[@(API_GetInventoryActiveMode), @(10), @(TRUE)]];
        
        // Testing : setInventoryActiveMode : OK
//        [array addObject: @[@(API_SetInventoryActiveMode), @(10), @(TRUE)]];
        
        // Testing : setBuzzerOperationMode : OK
//        [array addObject: @[@(API_SetBuzzerOperationMode), @(10), @(TRUE)]];
        
        // Testing : getBuzzerOperationMode : OK
//        [array addObject: @[@(API_GetBuzzerOperationMode), @(10), @(TRUE)]];
        
        // Testing : setFilter : OK
//        [array addObject: @[@(API_SetFilter), @(10), @(TRUE)]];
        
        // Testing : getFilter : OK
//        [array addObject: @[@(API_GetFilter), @(10), @(TRUE)]];
        
        // Testing : controlBuzzer : OK
//        [array addObject: @[@(API_ControlBuzzer), @(10), @(TRUE)]];
        
        // Testing : getEventType : OK
//        [array addObject: @[@(API_GetEventType), @(10), @(TRUE)]];

        // Testing : setEventType : OK
//        [array addObject: @[@(API_SetEventType), @(10), @(TRUE)]];
        
        // Testing : setOutputInterfaces : OK
//        [array addObject: @[@(API_SetOutputInterfaces), @(10), @(TRUE)]];
        
        // Testing : getOutputInterfaces : OK
//        [array addObject: @[@(API_GetOutputInterfaces), @(10), @(TRUE)]];
        
        // Testing : getPostDataDelimiter : OK
//        [array addObject: @[@(API_GetPostDataDelimiter), @(10), @(TRUE)]];
        
        // Testing : setPostDataDelimiter : OK
//        [array addObject: @[@(API_SetPostDataDelimiter), @(10), @(TRUE)]];
        
        // Testing : getTagMemorySelection : OK
//        [array addObject: @[@(API_GetTagMemorySelection), @(10), @(TRUE)]];
        
        // Testing : setTagMemorySelection : OK
//        [array addObject: @[@(API_SetTagMemorySelection), @(10), @(TRUE)]];
        
        // Testing : setWifiSettings : OK
//        [array addObject: @[@(API_SetWifiSettings_1), @(10), @(TRUE)]];
        
        // Testing : setWifiSettings : OK
//        [array addObject: @[@(API_SetWifiSettings_2), @(10), @(TRUE)]];
        
        // Testing : setTagPresentedRepeatInterval : OK
//        [array addObject: @[@(API_SetTagPresentedRepeatInterval), @(10), @(TRUE)]];
        
        // Testing : getTagPresentedRepeatInterval : OK
//        [array addObject: @[@(API_GetTagPresentedRepeatInterval), @(10), @(TRUE)]];
        
        // Testing : getWiFiMacAddress : OK
//        [array addObject: @[@(API_GetWiFiMacAddress), @(10), @(TRUE)]];
        
        // Testing : setRemoteHost : OK
//        [array addObject: @[@(API_SetRemoteHost), @(10), @(TRUE)]];
        
        // Testing : getRemoteHost : OK
//        [array addObject: @[@(API_GetRemoteHost), @(10), @(TRUE)]];
        
        // Testing : writeTagEx : OK
//        [array addObject: @[@(API_WriteTagEx_1), @(10), @(TRUE)]];
        
        // Testing : writeTagEx : OK
        [array addObject: @[@(API_WriteTagEx_2), @(10), @(TRUE)]];
        
        // Testing : readTagEx : OK
//        [array addObject: @[@(API_ReadTagEx_1), @(10), @(TRUE)]];
        
        // Testing : readTagEx : OK
//        [array addObject: @[@(API_ReadTagEx_2), @(10), @(TRUE)]];
        
        // Testing : getBarcodeReadFormat : OK
//        [array addObject: @[@(API_GetBarcodeReadFormat), @(10), @(TRUE)]];
        
        // Testing : setBarcodeReadFormat : OK
//        [array addObject: @[@(API_SetBarcodeReadFormat), @(10), @(TRUE)]];
        
        // Testing : getFieldSeparator : OK
//        [array addObject: @[@(API_GetFieldSeparator), @(10), @(TRUE)]];
        
        // Testing : setFieldSeparator : OK
//        [array addObject: @[@(API_SetFieldSeparator), @(10), @(TRUE)]];

        // Testing : getPrefix : OK
//        [array addObject: @[@(API_GetPrefix), @(10), @(TRUE)]];
        
        // Testing : setPrefix : OK
//        [array addObject: @[@(API_SetPrefix), @(10), @(TRUE)]];
        
        // Testing : getSuffix : OK
//        [array addObject: @[@(API_GetSuffix), @(10), @(TRUE)]];
        
        // Testing : setSuffix : OK
//        [array addObject: @[@(API_SetSuffix), @(10), @(TRUE)]];
        
        // Testing : getDeactivateEpcPrefix : OK
//        [array addObject: @[@(API_GetDeactivateEpcPrefix), @(10), @(TRUE)]];
        
        // Testing : setDeactivateEpcPrefix : OK
//        [array addObject: @[@(API_SetDeactivateEpcPrefix), @(10), @(TRUE)]];
                
        // Testing : getReactivateEpcPrefix : OK
//        [array addObject: @[@(API_GetReactivateEpcPrefix), @(10), @(TRUE)]];
                
        // Testing : setReactivateEpcPrefix : OK
//        [array addObject: @[@(API_SetReactivateEpcPrefix), @(10), @(TRUE)]];
        
        // Testing : getTransformEpcState : OK
//        [array addObject: @[@(API_GetTransformEpcState), @(10), @(TRUE)]];
        
        // Testing : setTransformEpcState : OK
//        [array addObject: @[@(API_SetTransformEpcState), @(10), @(TRUE)]];
        
        // Testing : getTransformEpcPrefix : OK
//        [array addObject: @[@(API_GetTransformEpcPrefix), @(10), @(TRUE)]];

        // Testing : setTransformEpcPrefix : OK
//        [array addObject: @[@(API_SetTransformEpcPrefix), @(10), @(TRUE)]];
        
        // Testing : getEncodeType : OK
//        [array addObject: @[@(API_GetEncodeType), @(10), @(TRUE)]];

        // Testing : setEncodeType : OK
//        [array addObject: @[@(API_SetEncodeType), @(10), @(TRUE)]];
        
        // Testing : getTagProtection : OK
//        [array addObject: @[@(API_GetTagProtection), @(10), @(TRUE)]];

        // Testing : setTagProtection : OK
//        [array addObject: @[@(API_SetTagProtection), @(10), @(TRUE)]];
        
        // Testing : getTagProtectionAccessPassword : OK
//        [array addObject: @[@(API_GetTagProtectionAccessPassword), @(10), @(TRUE)]];

        // Testing : setTagProtectionAccessPassword : OK
//        [array addObject: @[@(API_SetTagProtectionAccessPassword), @(10), @(TRUE)]];
        
        // Testing : getUsbInterface : OK
//        [array addObject: @[@(API_GetUsbInterface), @(10), @(TRUE)]];

        // Testing : setUsbInterface : OK
//        [array addObject: @[@(API_SetUsbInterface), @(10), @(TRUE)]];
        
        // Testing : getOutputFormat : OK
//        [array addObject: @[@(API_GetOutputFormat), @(10), @(TRUE)]];

        // Testing : setOutputFormat : OK
//        [array addObject: @[@(API_SetOutputFormat), @(1), @(TRUE)]];
        
        // Testing : getEpcNormalize : OK
        [array addObject: @[@(API_GetEpcNormalize), @(10), @(TRUE)]];

        // Testing : setEncNormalize : OK
//        [array addObject: @[@(API_SetEpcNormalize), @(1), @(TRUE)]];
    }
    
    if ([self->passDev isMemberOfClass:[TS100A class]]) {
        // Testing : getInventoryActiveMode : OK
//        [array addObject: @[@(API_GetInventoryActiveMode), @(10), @(TRUE)]];
                
        // Testing : setInventoryActiveMode : OK
//        [array addObject: @[@(API_SetInventoryActiveMode), @(10), @(TRUE)]];
    }
        
    if ([self->passDev isMemberOfClass:[TS800 class]]) {
        // Testing : getBleDeviceName : OK
//        [array addObject: @[@(API_GetBleDeviceName), @(10), @(TRUE)]];
        
        // Testing : setBleDeviceName : OK
//        [array addObject: @[@(API_SetBleDeviceName), @(10), @(TRUE)]];
        
        // Testing : getBleRomVersion : OK
//        [array addObject: @[@(API_GetBleRomVersion), @(10), @(TRUE)]];
        
        // Testing : getBleMacAddress : OK
//        [array addObject: @[@(API_GetBleMacAddress), @(10), @(TRUE)]];

        // Testing : getInventoryActiveMode : OK
//        [array addObject: @[@(API_GetInventoryActiveMode), @(10), @(TRUE)]];
        
        // Testing : setInventoryActiveMode : OK
//        [array addObject: @[@(API_SetInventoryActiveMode), @(10), @(TRUE)]];
        
        // Testing : setTriggerType : OK
        [array addObject: @[@(API_SetTriggerType), @(1), @(TRUE)]];
        
        // Testing : getTriggerType : OK
//        [array addObject: @[@(API_GetTriggerType), @(10), @(TRUE)]];
        
        // Testing : getIOState : OK
//        [array addObject: @[@(API_GetIOState), @(10), @(TRUE)]];
        
        // Testing : setIOState : OK
//        [array addObject: @[@(API_SetIOState), @(10), @(TRUE)]];
                                
        // Testing : getOutputInterface : OK
//        [array addObject: @[@(API_GetOutputInterface), @(10), @(TRUE)]];

        // Testing : setOutputInterface : OK
//        [array addObject: @[@(API_SetOutputInterface), @(10), @(TRUE)]];
        
        // Testing : setBuzzerOperationMode : OK
//        [array addObject: @[@(API_SetBuzzerOperationMode), @(10), @(TRUE)]];
        
        // Testing : getBuzzerOperationMode : OK
//        [array addObject: @[@(API_GetBuzzerOperationMode), @(10), @(TRUE)]];
        
        // Testing : controlBuzzer : OK
//        [array addObject: @[@(API_ControlBuzzer), @(10), @(TRUE)]];
        
        // Testing : setScanMode : OK
//        [array addObject: @[@(API_SetScanMode), @(10), @(TRUE)]];
        
        // Testing : getScanMode : OK
//        [array addObject: @[@(API_GetScanMode), @(10), @(TRUE)]];
        
        // Testing : getCommandTriggerState : OK
//        [array addObject: @[@(API_GetCommandTriggerState), @(10), @(TRUE)]];
        
        // Testing : setCommandTriggerState : OK
//        [array addObject: @[@(API_SetCommandTriggerState), @(10), @(TRUE)]];
        
        // Testing : setWifiSettings : OK
//        [array addObject: @[@(API_SetWifiSettings_1), @(10), @(TRUE)]];
        
        // Testing : setWifiSettings : OK
//        [array addObject: @[@(API_SetWifiSettings_2), @(10), @(TRUE)]];
        
        // Testing : setTagPresentedRepeatInterval : OK
//        [array addObject: @[@(API_SetTagPresentedRepeatInterval), @(10), @(TRUE)]];
        
        // Testing : getTagPresentedRepeatInterval : OK
//        [array addObject: @[@(API_GetTagPresentedRepeatInterval), @(10), @(TRUE)]];
        
        // Testing : getEventType : OK
//        [array addObject: @[@(API_GetEventType), @(10), @(TRUE)]];

        // Testing : setEventType : OK
//        [array addObject: @[@(API_SetEventType), @(10), @(TRUE)]];
        
        // Testing : getWiFiMacAddress : OK
//        [array addObject: @[@(API_GetWiFiMacAddress), @(10), @(TRUE)]];
        
        // Testing : setRemoteHost : OK
//        [array addObject: @[@(API_SetRemoteHost), @(10), @(TRUE)]];
        
        // Testing : getRemoteHost : OK
//        [array addObject: @[@(API_GetRemoteHost), @(10), @(TRUE)]];
        
        // TODO: Testing : getWiFiApList : No eed to implemented
//        [array addObject: @[@(API_GetWiFiApList_1), @(1), @(TRUE)]];
        
        // TODO: Testing : getWiFiApList : No eed to implemented
//        [array addObject: @[@(API_GetWiFiApList_2), @(1), @(TRUE)]];
        
        // Testing : getIpAddress : OK
//        [array addObject: @[@(API_GetIpAddress), @(10), @(TRUE)]];
    }
        
    if ([self->passDev isMemberOfClass:[UR0250 class]]) {
        // Testing : getBleDeviceName : OK
//        [array addObject: @[@(API_GetBleDeviceName), @(10), @(TRUE)]];
                
        // Testing : setBleDeviceName : OK
//        [array addObject: @[@(API_SetBleDeviceName), @(10), @(TRUE)]];
        
        // Testing : getBleMacAddress : OK
//        [array addObject: @[@(API_GetBleMacAddress), @(10), @(TRUE)]];
        
        // Testing : getBleRomVersion : OK
//        [array addObject: @[@(API_GetBleRomVersion), @(10), @(TRUE)]];

        // Testing : getInventoryActiveMode : OK
//        [array addObject: @[@(API_GetInventoryActiveMode), @(10), @(TRUE)]];
        
        // Testing : setInventoryActiveMode : OK
//        [array addObject: @[@(API_SetInventoryActiveMode), @(10), @(TRUE)]];
        
        // Testing : setTriggerType : OK
//        [array addObject: @[@(API_SetTriggerType), @(10), @(TRUE)]];
        
        // Testing : getTriggerType : OK
//        [array addObject: @[@(API_GetTriggerType), @(10), @(TRUE)]];
        
        // Testing : getIOState : OK
//        [array addObject: @[@(API_GetIOState), @(10), @(TRUE)]];
        
        // Testing : setIOState : OK
//        [array addObject: @[@(API_SetIOState), @(10), @(TRUE)]];
        
        // Testing : setScanMode : OK
//        [array addObject: @[@(API_SetScanMode), @(10), @(TRUE)]];
        
        // Testing : getScanMode : OK
//        [array addObject: @[@(API_GetScanMode), @(10), @(TRUE)]];
        
        // Testing : getCommandTriggerState : OK
//        [array addObject: @[@(API_GetCommandTriggerState), @(10), @(TRUE)]];
        
        // Testing : setCommandTriggerState : OK
//        [array addObject: @[@(API_SetCommandTriggerState), @(10), @(TRUE)]];
        
        // Testing : setWifiSettings : OK
//        [array addObject: @[@(API_SetWifiSettings_1), @(10), @(TRUE)]];
        
        // Testing : setWifiSettings : OK
//        [array addObject: @[@(API_SetWifiSettings_2), @(10), @(TRUE)]];
        
        // Testing : setTagPresentedRepeatInterval : OK
//        [array addObject: @[@(API_SetTagPresentedRepeatInterval), @(10), @(TRUE)]];
        
        // Testing : getTagPresentedRepeatInterval : OK
//        [array addObject: @[@(API_GetTagPresentedRepeatInterval), @(10), @(TRUE)]];
        
        // Testing : getEventType : OK
//        [array addObject: @[@(API_GetEventType), @(10), @(TRUE)]];

        // Testing : setEventType : OK
//        [array addObject: @[@(API_SetEventType), @(10), @(TRUE)]];
        
        // Testing : getWiFiMacAddress : OK
//        [array addObject: @[@(API_GetWiFiMacAddress), @(10), @(TRUE)]];
        
        // Testing : setRemoteHost : OK
//        [array addObject: @[@(API_SetRemoteHost), @(10), @(TRUE)]];
        
        // Testing : getRemoteHost : OK
//        [array addObject: @[@(API_GetRemoteHost), @(10), @(TRUE)]];
    }

    [array addObject: @[@(API_BLEDisconnect), @(1)]];
    
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(run:) object:array];

    [thread start];
}
- (IBAction)clearLog:(id)sender {
    NSString *logs = [_testingLogTextView text];
    
    [_testingLogTextView setText:@""];
    NSRange bottom = NSMakeRange(_testingLogTextView.text.length, 0);
    [_testingLogTextView scrollRangeToVisible:bottom];
    
    [_testingLogTextView setScrollEnabled:NO];
    [_testingLogTextView setScrollEnabled:YES];
}

#pragma mark Testing API

- (void) connectDevice {
    if (passDev) {
        switch (passDev.getDevInfo.currentConnStatus) {
            case DevDisconnected:
            {
                [self addLog:@"BLE 連線中..."];
                [passDev Connect];
            }
                break;
            case DevConnected:
            {
                [passDev DisConnect];
                [self addLog:@"BLE 連線中..."];
                [passDev Connect];
            }
                break;
            default:
                [passDev DisConnect];
                [self addLog:@"BLE 連線中..."];
                [passDev Connect];
                break;
        }
    }
}

- (void) disconnectDevice {
    if (passDev) {
        [passDev DisConnect];
    }
}

- (void)didUpdateConnectionStatus:(BaseDevice*)dev Status:(GTDevConnStatus) connectedState err_code:(int)nErrCode{
    
    switch (connectedState) {
        case DevConntError:
            [self addLog:@"練線錯誤!!!"];
            isConnected = false;
            break;
        case DevDisconnected:
            if (isConnected) {
                [self addLog:@"已斷線!!!"];
                if (callbackCount > 0) {
                    callbackCount--;
                }
                if ([actionArrayAfterCallback count] > 0 && callbackCount == 0) {
                    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(run:) object:actionArrayAfterCallback];
                    
                    [thread start];
                }
            }
            isConnected = false;
            break;
        case DevConnecting:
            [self addLog:@"連線中!!!"];
            isConnected = false;
            break;
        case DevConnected:
            if (!isConnected) {
                [self addLog:@"已連線!!!"];
                if (callbackCount > 0) {
                    callbackCount--;
                }
                if ([actionArrayAfterCallback count] > 0 && callbackCount == 0) {
                    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(run:) object:actionArrayAfterCallback];
                    
                    [thread start];
                }
            }
            isConnected = true;
           
            break;
        default:
            break;
    }
}

-(void) executeRemainingTasks {
    if (callbackCount > 0) {
        callbackCount--;
    }
    if ([actionArrayAfterCallback count] > 0 && callbackCount == 0) {
        NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(run:) object:actionArrayAfterCallback];
        
        [thread start];
    }
}

-(void)didReadTag:(NSData *)data{
    [self addLog:[NSString stringWithFormat:@"didReadTag = %@",data]];

//    if (callbackCount > 0) {
//        callbackCount--;
//    }
//    if ([actionArrayAfterCallback count] > 0 && callbackCount == 0) {
//        NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(run:) object:actionArrayAfterCallback];
//
//        [thread start];
//    }
    [self executeRemainingTasks];
}

-(void)didGetRfPower:(int)rfPower{
    [self addLog:[NSString stringWithFormat:@"didGetRfPower = %d",rfPower]];

    [self executeRemainingTasks];
}

-(void)didGetRfSensitivity:(RfSensitivityLevel)rfSensitivity{
    [self addLog:[NSString stringWithFormat:@"didGetRfSensitivity = %d",rfSensitivity]];
    
    [self executeRemainingTasks];
}

- (void)didGetFrequencyList:(NSArray *)frequencys {
    NSString* strFrequency = @"";
    for (int i = 0 ; i < [frequencys count]; i++) {
        double num = [[frequencys objectAtIndex:i]doubleValue];
        strFrequency = [NSString stringWithFormat:@"%@%0.2f, ", strFrequency, num];
    }
    [self addLog:[NSString stringWithFormat:@"didGetFrequencyList = %@",frequencys]];
    
    [self executeRemainingTasks];
}

-(void)didGetQValue:(Byte) qValue{
    [self addLog:[NSString stringWithFormat:@"didGetQValue = %d",qValue]];
    
    [self executeRemainingTasks];
}

-(void)didGetSessionAnd:(Session)session Target:(Target) target{
    [self addLog:[NSString stringWithFormat:@"didGetSessionAnd, session= %d, target = %d",session, target]];
    
    [self executeRemainingTasks];
}

- (void)didGetFirmwareVersion:(NSString *)fwVer {
    [self addLog:[NSString stringWithFormat:@"didGetFirmwareVersion = %@",fwVer]];
    [passDev getDevInfo].devROMVersion = fwVer;
    isGettingFirmwareVersion = false;
    
//    [passDev getBLEFirmwareVersion];

    [self executeRemainingTasks];
}

-(void)didGetTagRemovedThreshold:(int)missingInventoryThreshold{
    [self addLog:[NSString stringWithFormat:@"didGetTagRemovedThreshold, missingInventoryThreshold = %d",missingInventoryThreshold]];

    [self executeRemainingTasks];
}

-(void)didGetInventoryRoundInterval:(int)tenMilliSeconds{
    [self addLog:[NSString stringWithFormat:@"didGetInventoryRoundInterval, tenMilliSeconds = %d",tenMilliSeconds]];
    
    [self executeRemainingTasks];
}

-(void)didGetRxDecode:(int)rxDecode{
    [self addLog:[NSString stringWithFormat:@"didGetRxDecode, rxDecode = %d",rxDecode]];
    
    [self executeRemainingTasks];
}

-(void)didGetLinkFrequency:(int)linkFrequency{
    [self addLog:[NSString stringWithFormat:@"didGetLinkFrequency, linkFrequency = %d",linkFrequency]];
    
    [self executeRemainingTasks];
}

-(void)didGetProfile:(int)profile{
    [self addLog:[NSString stringWithFormat:@"didGetProfile, profile = %d",profile]];
    
    [self executeRemainingTasks];
}

-(void)didGetBleDeviceName:(NSString *)devName{
    [self addLog:[NSString stringWithFormat:@"didGetBleDeviceName, devName = %@",devName]];
    
    [self executeRemainingTasks];
}

-(void)didGetBleMacAddress:(NSData *)data{
    [self addLog:[NSString stringWithFormat:@"didGetBleMacAddress, data = %@",data]];
    
    [self executeRemainingTasks];
}

-(void)didGetBleRomVersion:(NSString *)romVersion{
    [self addLog:[NSString stringWithFormat:@"didGetBleRomVersion, romVersion = %@",romVersion]];
    
    [self executeRemainingTasks];
}

- (void)didGetBLEFirmwareVersion:(NSString *)fwVer {
    [self addLog:[NSString stringWithFormat:@"didGetBLEFirmwareVersion, fwVer= %@",fwVer]];
    
    [self executeRemainingTasks];
}

- (void)didDiscoverTagInfoEx:(GNPDecodedTagData *)decodedTagData{
    [self addLog:[NSString stringWithFormat:@"didDiscoverTagInfoEx, decodedTagData= %@",decodedTagData]];
    
    [self executeRemainingTasks];
}

-(void)didGetInventoryActiveMode:(ActiveMode)activeMode{
    [self addLog:[NSString stringWithFormat:@"didGetInventoryActiveMode, activeMode = %d",activeMode]];
    
    [self executeRemainingTasks];
}

-(void)didGetBuzzerOperationMode:(BuzzerOperationMode) bom{
    [self addLog:[NSString stringWithFormat:@"didGetBuzzerOperationMode, bom = %d",bom]];
    
    [self executeRemainingTasks];
}

- (void)didGetFilter:(TagDataEncodeType)tagDataEncodeTypes{
    [self addLog:[NSString stringWithFormat:@"didGetFilter, tagDataEncodeTypes = %d",tagDataEncodeTypes]];
    
    [self executeRemainingTasks];
}

-(void)didGetEventType:(EventType) eventType{
    [self addLog:[NSString stringWithFormat:@"didGetEventType, eventType = %d",eventType]];
    
    [self executeRemainingTasks];
}

-(void)didGetOutputInterfaces:(int) settingValue {
    [self addLog:[NSString stringWithFormat:@"didGetOutputInterfaces, settingValue = %d",settingValue]];

    [self executeRemainingTasks];
}

-(void)didGetPostDataDelimiter:(PostDataDelimiter)postDataDelimiter MemoryBankSelection:(MemoryBankSelection)memoryBankSelection{
    [self addLog:[NSString stringWithFormat:@"didGetPostDataDelimiter, postDataDelimiter = %d, memoryBankSelection = %d",postDataDelimiter, memoryBankSelection]];
    
    [self executeRemainingTasks];
}

-(void)didGetTagMemorySelection:(TagMemorySelection)tagMemorySelection{
    [self addLog:[NSString stringWithFormat:@"didGetTagMemorySelection, tagMemorySelection = %d",tagMemorySelection]];
    
    [self executeRemainingTasks];
}

-(void)didGetWiFiMacAddress:(NSString *)wifiMacAddress{
    [self addLog:[NSString stringWithFormat:@"didGetWiFiMacAddress, wifiMacAddress = %@",wifiMacAddress]];

    [self executeRemainingTasks];
}

-(void)didGetTagPresentedRepeatInterval:(int)interval {
    [self addLog:[NSString stringWithFormat:@"didGetTagPresentedRepeatInterval, interval = %d",interval]];
    
    [self executeRemainingTasks];
}

-(void)didGetRemoteHost:(int)connectTime InetSocketAddress:(InetSocketAddress *)inetSocketAddress {
    [self addLog:[NSString stringWithFormat:@"didGetRemoteHost, connectTime = %d, address = %@, port = %d", connectTime, [[inetSocketAddress getHost] getHostAddress], [inetSocketAddress getPort]]];
    
    [self executeRemainingTasks];
}

-(void)didReadTagEx:(NSData *)data{
    [self addLog:[NSString stringWithFormat:@"didReadTagEx, data = %@",data]];
    [self executeRemainingTasks];
}

-(void)didGetBarcodeReadFormat:(BarcodeFormat) barcodeFormat{
    [self addLog:[NSString stringWithFormat:@"didGetBarcodeReadFormat, barcodeFormat = %d",barcodeFormat]];
    
    [self executeRemainingTasks];
}

-(void)didGetFieldSeparator:(Byte) separator {
    [self addLog:[NSString stringWithFormat:@"didGetFieldSeparator, separator = %@(0x%02x)", [NSString stringWithFormat:@"%c", separator], separator]];
    
    [self executeRemainingTasks];
}

- (void)didGetPrefix:(NSData * )data {
    [self addLog:[NSString stringWithFormat:@"didGetPrefix, data = %@",data]];

    [self executeRemainingTasks];
}

- (void)didGetSuffix:(NSData * )data {
    [self addLog:[NSString stringWithFormat:@"didGetSuffix, data = %@",data]];

    [self executeRemainingTasks];
}

- (void)didGetDeactivateEpcPrefix:(NSData *)prefixes {
    [self addLog:[NSString stringWithFormat:@"didGetDeactivateEpcPrefix, prefixes = %@",[GLog CreateHexStringWithData:prefixes]]];

    [self executeRemainingTasks];
}

- (void)didGetReactivateEpcPrefix:(NSData *)prefixes {
    [self addLog:[NSString stringWithFormat:@"didGetReactivateEpcPrefix, prefixes = %@",[GLog CreateHexStringWithData:prefixes]]];

    [self executeRemainingTasks];
}

-(void)didGetTransformEpcState:(EpcPrefixState)state {
    [self addLog:[NSString stringWithFormat:@"didGetTransformEpcState, state = %d",state]];
    
    [self executeRemainingTasks];
}

- (void)didGetTransformEpcPrefix:(int)setValue {
    [self addLog:[NSString stringWithFormat:@"didGetTransformEpcPrefix, setValue = %d",setValue]];
    
    [self executeRemainingTasks];
}

- (void)didGetEncodeType:(EncodeType)encodeType {
    [self addLog:[NSString stringWithFormat:@"didGetEncodeType, encodeType = %d",encodeType]];
    
    [self executeRemainingTasks];
}

- (void)didGetTagProtection:(TagProtection)tagProtection {
    [self addLog:[NSString stringWithFormat:@"didGetTagProtection, tagProtection = %d",tagProtection]];
    
    [self executeRemainingTasks];
}

-(void)didGetTagProtectionAccessPassword:(NSString *)accessPassword {
    [self addLog:[NSString stringWithFormat:@"didGetTagProtectionAccessPassword, accessPassword = %@",accessPassword]];
    
    [self executeRemainingTasks];
}

-(void)didGetUsbInterface:(UsbInterface)usbInterface {
    [self addLog:[NSString stringWithFormat:@"UsbInterface, usbInterface = %d",usbInterface]];
    
    [self executeRemainingTasks];
}

-(void)didGetOutputFormat:(OutputFormat)outputFormat {
    [self addLog:[NSString stringWithFormat:@"didGetOutputFormat, outputFormat = %d",outputFormat]];
    
    [self executeRemainingTasks];
}

-(void)didGetTriggerType:(TriggerType)triggerType {
    [self addLog:[NSString stringWithFormat:@"didGetTriggerType, triggerType = %d",triggerType]];
    
    [self executeRemainingTasks];
}

-(void)didGetOutputInterface:(KeyboardSimulation) keyboardSimulation OutputInterface:(OutputInterface) outputInterface {
    [self addLog:[NSString stringWithFormat:@"didGetOutputInterface, keyboardSimulation = %d, outputInterface = %d",keyboardSimulation, outputInterface]];
    
    [self executeRemainingTasks];
}

-(void)didGetDeviceControl:(NSString*)strCMDName Data:(NSData *) data {
    [self addLog:[NSString stringWithFormat:@"didGetDeviceControl, strCMDName = %@, data = %@", strCMDName, data]];
    
    [self executeRemainingTasks];
}

-(void)didGetScanMode:(ScanMode)sm{
    [self addLog:[NSString stringWithFormat:@"didGetScanMode, sm = %d",sm]];
    
    [self executeRemainingTasks];
}

-(void)didGetIpAddress:(NSString *)ipAddress{
    [self addLog:[NSString stringWithFormat:@"didGetIpAddress, ipAddress = %@",ipAddress]];

    [self executeRemainingTasks];
}

- (void)didDirectIO:(int)settingValue {
    [self addLog:[NSString stringWithFormat:@"didDriectIO, settingValue = %d",settingValue]];
    
    [self executeRemainingTasks];
}

-(void)didGeneralSuccess:(NSString*)strCMDName{
    [self addLog:[NSString stringWithFormat:@"didGeneralSuccess = %@",strCMDName]];
    NSLog(@"UI didGeneralSuccess strCMDName = %@",strCMDName);
    [self showToast:strCMDName message:@"Success"];
    
    [self executeRemainingTasks];
}

-(void)didGeneralERROR:(NSString*)strCMDName ErrMessage:(NSString*)strErrorMessage{
    [self addLog:[NSString stringWithFormat:@"didGeneralERROR strCMDName = %@, strErrorMessage = %@", strCMDName, strErrorMessage]];
    [self showToast:strCMDName message:strErrorMessage];
    
    [self executeRemainingTasks];
}

-(void)didGeneralTimeout:(NSString*)strCMDName ErrMessage:(NSString*)strErrorMessage Data:(NSData *) data{
    [self addLog:[NSString stringWithFormat:@"didGeneralTimeout strCMDName = %@, strErrorMessage = %@, data = %@", strCMDName, strErrorMessage, data]];
    [self showToast:strCMDName message:strErrorMessage];
    
    [self executeRemainingTasks];
}

-(void)didGetDeviceID:(Byte) deviceID{
    [self addLog:[NSString stringWithFormat:@"didGetDeviceID = %d",deviceID]];
    
    [self executeRemainingTasks];
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





-(void)didDiscoverTagInfo:(GNPTagInfo*)taginfo{
    [self addLog:[NSString stringWithFormat:@"didDiscoverTagInfo, taginfo.TagNumber = %d",taginfo.TagNumber]];
    [self addLog:[NSString stringWithFormat:@"didDiscoverTagInfo, taginfo.RSSI = %02X",taginfo.RSSI]];
    [self addLog:[NSString stringWithFormat:@"didDiscoverTagInfo, taginfo.Frequency = %f",[taginfo getFrequency]]];
//    [self addLog:[NSString stringWithFormat:@"didDiscoverTagInfo, taginfo.EPC = %@",taginfo.EPC]];
    [self addLog:[NSString stringWithFormat:@"didDiscoverTagInfo, taginfo.EPCHexString = %@",taginfo.EPCHexString]];
//    [self addLog:[NSString stringWithFormat:@"didDiscoverTagInfo, taginfo.TID = %@",taginfo.TID]];
    [self addLog:[NSString stringWithFormat:@"didDiscoverTagInfo, taginfo.TIDHexString = %@",taginfo.TIDHexString]];
}

-(void)didTagRemoved:(GNPTagInfo*)taginfo{
    [self addLog:[NSString stringWithFormat:@"didTagRemoved, taginfo.TagNumber = %d",taginfo.TagNumber]];
    [self addLog:[NSString stringWithFormat:@"didTagRemoved, taginfo.RSSI = %02X",taginfo.RSSI]];
    [self addLog:[NSString stringWithFormat:@"didTagRemoved, taginfo.Frequency = %f",[taginfo getFrequency]]];
//    [self addLog:[NSString stringWithFormat:@"didTagRemoved, taginfo.EPC = %@",taginfo.EPC]];
    [self addLog:[NSString stringWithFormat:@"didTagRemoved, taginfo.EPCHexString = %@",taginfo.EPCHexString]];
//    [self addLog:[NSString stringWithFormat:@"didTagRemoved, taginfo.TID = %@",taginfo.TID]];
    [self addLog:[NSString stringWithFormat:@"didTagRemoved, taginfo.TIDHexString = %@",taginfo.TIDHexString]];
}

-(void)didGetEpcNormalize:(BOOL) enable {
    [self addLog:[NSString stringWithFormat:@"didGetEpcNormalize enable = %d", enable]];
    
    [self executeRemainingTasks];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        [self.textView resignFirstResponder];
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
    [hud hideAnimated:YES afterDelay:3];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.textView resignFirstResponder];
    return true;
}
-(void)didGetMemoryBankSelection:(MemoryBankSelection) memoryBankSelection{
    NSLog(@"\nTestingApiViewController didGetMemoryBankSelection MemoryBankSelection = %d",memoryBankSelection);
}

@end
