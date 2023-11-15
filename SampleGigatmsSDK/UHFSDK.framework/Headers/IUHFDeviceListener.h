//
//  IUHFDeviceListener.h
//  UHFSDK
//
//  Created by Gianni on 2019/3/27.
//  Maintained by Jack Jang, Syscode on 2020/05/15.
//  Maintained by Wade on 2021/3/23.
//  Copyright © 2019 Gianni. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GNPTagInfo.h"
#import "GNPDecodedTagData.h"

#import "BLEInformation.h"
#import "WiFiInformation.h"
#import "NetworkInformation.h"
#import "InetSocketAddress.h"

NS_ASSUME_NONNULL_BEGIN





typedef NS_ENUM(Byte, LockAction){
    LA_UNLOCK          = 0x00,
    LA_LOCK            = 0x01,
    LA_PERMA_UNLOCK    = 0x02,
    LA_PERMA_LOCK      = 0x03,
};

typedef NS_ENUM(Byte, MemoryBank){
    MBC_Reserve          = 0x00,
    MBC_EPC              = 0x01,
    MBC_TID              = 0x02,
    MBC_UserMemory       = 0x03,
    MBC_KILL_PASSWORD    = 0x04,
    MBC_ACCESS_PASSWORD  = 0x05,
};

typedef NS_ENUM(Byte, MemoryBankSelection){
    
    MBS_EPC         = 0x02,
    MBS_TID         = 0x04,
    MBS_PC_EPC      = 0x03,
    MBS_EPC_TID     = 0x06,
    MBS_PC_EPC_TID  = 0x07,
    MBS_EPC_ASCII   = 0x08,
};

typedef NS_ENUM(Byte, TagMemorySelection){
    
    TM_PC          = 0x01,
    TM_EPC         = 0x02,
    TM_TID         = 0x04,
    TM_EPC_ASCII   = 0x08,
    TM_USER        = 0x80,
};

typedef NS_ENUM(Byte, EventType){
    
    ET_TagPresented             = 0xFE,
    ET_TagPresentedWithRemoved  = 0xDE,
    ET_TagPresentedEx           = 0x00,
};


typedef NS_ENUM(Byte, KeyboardSimulation){
    
    KS_DISABLE      = 0x06,
    KS_HID_KEYBOARD = 0x03,
    KS_BLE_KEYBOARD = 0x05,
};


/**
 multiple
 
 - OI_TCP_SERVER_1_0: TS800 UR0250
 - OI_Default_1_0: TS800 UR0250
 - OI_HID_N_VCOM: HID
 - OI_BLE: BLE
 - OI_TCP_CLIENT: TCP Client
 - OI_TCP_SERVER: TCP Server
 */
typedef NS_ENUM(Byte, OutputInterface){
    OI_TCP_SERVER_1_0     = 0x04,
    OI_Default_1_0        = 0xFF,
    OI_HID_N_VCOM           = 0x08,
    OI_BLE                  = 0x10,
    OI_TCP_CLIENT           = 0x20,
    OI_TCP_SERVER           = 0x40,
};

typedef NS_ENUM(Byte, PostDataDelimiter){
    
    PDD_NONE            = 0x00,
    PDD_CARRIAGE        = 0x10,
    PDD_LINE            = 0x20,
    PDD_CARRIAGE_LINE   = 0x30,
    PDD_TAB             = 0x40,
};

typedef NS_ENUM(Byte, ActiveMode){
    AM_READ                     = 0x00,
    AM_COMMAND                  = 0x01,
    AM_TAG_ANALYSIS             = 0x04,
    AM_VERIFY                   = 0x05,
    AM_ENCODE                   = 0x06,
    AM_CUSTOMIZED_READ          = 0x07,
    AM_DEACTIVATE               = 0x08,
    AM_REACTIVATE               = 0x09,
    AM_DEACTIVATE_USER_BANK     = 0x0A,
    AM_REACTIVATE_USER_BANK     = 0x0B,
};

typedef NS_ENUM(Byte, TagDataEncodeType){
    TDE_UDC             = 0x01,
    TDE_SGTIN_96_EAS     = 0x02,
    TDE_SGTIN_96         = 0x04,
    TDE_RAW_DATA        = 0x08,
    TDE_ADI             = 0x10,
};


typedef NS_ENUM(Byte, BarcodeFormat){
    GTIN_14 = 0x03,
    GTIN_13 = 0x02,
    GTIN_12 = 0x01,
    GTIN_8  = 0x00,
    };


typedef NS_ENUM(Byte, EpcPrefixState){
    EPC_PREFIX_ON  = 0x00,
    EPC_PREFIX_OFF = 0x01,
    };

typedef NS_ENUM(Byte, EncodeType){
    EM_SGTIN_96                        = 0x00,
    EM_SGTIN_96_AND_EPC_PRERIX         = 0x01,
    EM_SGTIN_96_AND_EAS                = 0x02,
    EM_SGTIN_96_AND_EAS_AND_EPC_PRERIX = 0x03,
    EM_ALL                             = 0x04, // >= 4
    };

typedef NS_ENUM(Byte, TagProtection){
    TP_Specified_Password = 0x01,
    TP_Dynamic_Password   = 0x02,
    TP_Disabled           = 0x03,
    };

typedef NS_ENUM(Byte, UsbInterface) {
    UI_VIRTUAL_COMPORT = 0x00,
    UI_HID             = 0x01,
};

typedef NS_ENUM(Byte, OutputFormat) {
    OF_DISABLED                 = 0xFF,
    OF_AI_BARCODE_SERIAL_NUMBER = 0x01,
};


/**
 Specifies the repeats mode of sounding the buzzer.
 
 - BOM_Off: Selects to turn off beep sound
 - BOM_Once: Selects to sound the beep once
 - BOM_Repeat: Selects to repeatly sound the beep
 */
typedef NS_ENUM(Byte, BuzzerOperationMode){
    BOM_Off              = 0x00,
    BOM_Once      = 0x7F,
    BOM_Repeat        = 0xFF,
    
};

typedef NS_ENUM(Byte, ScanMode){
    SM_TRIGGER_A_LEVEL_CONTROL               = 0x00,
    SM_TRIGGER_A_LEVEL_CONTROL_AND_OFF_DELAY = 0x01,
    SM_TRIGGER_A_AND_RE_TRIGGER              = 0x02,
    SM_TRIGGER_A_TRIGGER_ONLY                = 0x03,
    SM_TRIGGER_A_TRIGGER_AND_LEVEL_OFF       = 0x04,
    SM_ALWAYS_SCAN                           = 0x7F,
    
};


/**
 Target
 
 - A: Tagget A selected for S0 to S3.
 - B: Tagget B selected for S0 to S3.
 - A_B: Toggle target A, B for S0 to S3.
 - deSL: Target A selected for SL session.
 - SL: Target B selected for SL session.
 - SL_deSL: Toggle target A, B for SL session.
 */
typedef NS_ENUM(Byte, Target){
    A              = 0x00,
    B              = 0x01,
    A_B            = 0x02,
    deSL           = 0x00,
    SL             = 0x01,
    SL_deSL        = 0x02,
};



/**
 Session
 
 - S0: Session 0 is selected for an inventory round.
 - S1: Session 1 is selected for an inventory round.
 - S2: Session 2 is selected for an inventory round.
 - S3: Session 3 is selected for an inventory round.
 - Session_SL: A selected flag, SL, which a reader may assert or deassert using a Select command.
 */
typedef NS_ENUM(Byte, Session){
    S0              = 0x00,
    S1              = 0x01,
    S2              = 0x02,
    S3              = 0x03,
    Session_SL              = 0x04,
    
};

/**
 TriggerType
 
 - Command: Command  Trigger
 - DigitalInput: DigitalInput  Trigger
 - Sensor: Sensor  Trigger
 - SensorAndDigitalInput: SensorAndDigitalInput  Trigger
 */
typedef NS_ENUM(Byte, TriggerType){
    
    Command                    = 0x01,
    DigitalInput               = 0x02,
    Sensor                     = 0x04,
    SensorAndDigitalInput      = 0x06,
};

typedef NS_ENUM(Byte, DeviceDataProtocol) {
    DD_RemoteHost_TCP = 0x00,
    DD_RemoteHost_UDP = 0x01,
    DD_RemoteHost_SSL = 0x02,
};

typedef NS_ENUM(Byte, IONumber) {
    OUTPUT_PIN_0 = 0x00,
    OUTPUT_PIN_1 = 0x01,
    OUTPUT_PIN_2 = 0x02,
    INPUT_PIN_0 = 0x04,
};

typedef NS_ENUM(Byte, IOState) {
    LOW   = 0x00,
    HIGHT = 0x01,
};

typedef NS_ENUM(Byte, State) {
    ON  = 0x01,
    OFF = 0x00,
};


/**
 RfSensitivityLevel
 
 - LEVEL_14_HIGHEST: The highest sensitivity level 14.
 - LEVEL_13: The sensitivity level 13.
 - LEVEL_12: The sensitivity level 12.
 - LEVEL_11: The sensitivity level 11.
 - LEVEL_10: The sensitivity level 10.
 - LEVEL_9: The sensitivity level 9.
 - LEVEL_8: The sensitivity level 8.
 - LEVEL_7: The sensitivity level 7.
 - LEVEL_6: The sensitivity level 6.
 - LEVEL_5: The sensitivity level 5.
 - LEVEL_4: The sensitivity level 4.
 - LEVEL_3: The sensitivity level 3.
 - LEVEL_2: The sensitivity level 2.
 - LEVEL_1_LOWEST: The lowest sensitivity level 1.
 */
typedef NS_ENUM(Byte, RfSensitivityLevel){
    LEVEL_14_HIGHEST    = (Byte) -90,
    LEVEL_13            = (Byte) -87,
    LEVEL_12            = (Byte) -84,
    LEVEL_11            = (Byte) -81,
    LEVEL_10            = (Byte) -80,
    LEVEL_9             = (Byte) -77,
    LEVEL_8             = (Byte) -74,
    LEVEL_7             = (Byte) -71,
    LEVEL_6             = (Byte) -68,
    LEVEL_5             = (Byte) -65,
    LEVEL_4             = (Byte) -63,
    LEVEL_3             = (Byte) -60,
    LEVEL_2             = (Byte) -57,
    LEVEL_1_LOWEST      = (Byte) -54
};

/**
 The callback protocol getting UHF operation result.
 */
@protocol IUHFDeviceListener <NSObject>

@optional

/**
 Callback that indicates the operation of command is success.
 
 @param strCMDName The command name.
 */
-(void)didGeneralSuccess:(NSString*)strCMDName;

/**
 Callback that indicates the operation of command is error.
 Notifies the application that an error has been detected and a suitable response is necessary to process the error condition.
 
 @param strCMDName The command name.
 @param strErrorMessage The error message.
 */
-(void)didGeneralERROR:(NSString*)strCMDName ErrMessage:(NSString*)strErrorMessage;

/**
 Callback that indicates the operation of command is timeout.
 
 @param strCMDName The command name.
 @param strErrorMessage The error message.
 @param data The received data.
 */
-(void)didGeneralTimeout:(NSString*)strCMDName ErrMessage:(NSString*)strErrorMessage Data:(NSData *) data;

#pragma mark - UHFDevice

-(void)didDirectIO:(int)settingValue;

/**
 Indicates that the reader reads a new tag.
 If the remote device is invertory and has detected a tag.
 @param taginfo The tag which is inventoried.
 */
-(void)didDiscoverTagInfo:(GNPTagInfo*)taginfo;
-(void)didDiscoverTagInfoEx:(GNPDecodedTagData*) decodedTagData;

/**
 Callback of `stopInventory:`
 
 @param taginfo The tag which is inventoried.
 */
-(void)didTagRemoved:(GNPTagInfo*)taginfo;

/**
 Callback of `readTag:`
 
 @param data the Tag data which is going to write to the tag.
 */
-(void)didReadTag:(NSData*)data;

#pragma mark - UHFDevice settings

/**
 Callback of GetDeviceID
 
 @param deviceID deviceID description
 */
-(void)didGetDeviceID:(Byte) deviceID;

/**
 Callback of `getFirmwareVersion:`
 
 @param fwVer The firmware version of the remote device.
 */
-(void)didGetFirmwareVersion:(NSString*)fwVer;

/**
 Callback of `getInventoryRoundInterval:`
 
 @param tenMilliSeconds The period to start an inventory round. Range: 0~254*10s. 255 represent 0.
 */
-(void)didGetInventoryRoundInterval:(int) tenMilliSeconds;

/**
 Callback of `getLinkFrequency:`
 
 @param linkFrequency The link frequency in KHz.
 */
-(void)didGetLinkFrequency:(int) linkFrequency;

/**
 Callback of `getProfile:`
 
 @param profile Specifies the RF input sensitivity level.
 */
-(void)didGetProfile:(int) profile;

/**
 Callback of `getQValue:`
 
 @param qValue The starting Q value for the number of slots in the round. The value ranges from 0 to 15.
 */
-(void)didGetQValue:(Byte) qValue;

/**
 Callback of `getRfPower:`
 
 @param rfPower Specifies the RF Power strength. The value is ranging from 1 to 27. The default value is 11. (Range:1~27)
 */
-(void)didGetRfPower:(int)rfPower;

/**
 Callback of `getRfSensitivity:`
 
 @param rfSensitivity Specifies the RF input sensitivity level.
 */
-(void)didGetRfSensitivity:(RfSensitivityLevel)rfSensitivity;

/**
 Callback of `getRxDecode:`
 
 @param rxDecode Specifies the encoding of backscattered data (tag to reader).
 */
-(void)didGetRxDecode:(int) rxDecode;

/**
 Callback of `getSessionAndTarget:`
 
 @param session The session flag to be selected for an inventory round.
 @param target Target indicates whether the Select modifies a Tag’s SL flag or its inventoried flag.
 */
-(void)didGetSessionAnd:(Session)session Target:(Target) target;

/**
 Callback of `getTagRemovedThreshold:`
 
 @param missingInventoryThreshold The count of missing discovering tag threshold of inventory rounds.
 */
-(void)didGetTagRemovedThreshold:(int) missingInventoryThreshold;

#pragma mark - TS100

/**
 Callback of `getInventoryActiveMode:`
 
 @param activeMode The Active mode of the connected remote device.
 */
-(void)didGetInventoryActiveMode:(ActiveMode) activeMode;

/**
 Callback of `readTagEx:`
 
 @param data The data from EPC bank.
 */
-(void)didReadTagEx:(NSData *)data;

#pragma mark - TS100 Device Settings

/**
 Callback of `getBarcodeReadFormat:`
 @param barcodeFormat The default format of barcode while reading a tag.
 */
-(void)didGetBarcodeReadFormat:(BarcodeFormat) barcodeFormat;

/**
 Callback of `getBLEDeviceName:`
 
 @param devName The device name of BLE through BLE interface.
 */
-(void)didGetBleDeviceName:(NSString*)devName;

/**
 Callback of `getBleMacAddress:`
 
 @param data The BLE Mac Address.
 */
-(void)didGetBleMacAddress:(NSData*)data;

/**
 Callback of `getBleRomVersion:`
 
 @param romVersion The firmware version of the ble module of the remote device.
 */
-(void)didGetBleRomVersion:(NSString*)romVersion;

/**
 Callback of `getBuzzerOperationMode:`
 
 @param bom Buzzer Operation Mode: Specifies the repeats mode of sounding the beep with the same pattern.
 */
-(void)didGetBuzzerOperationMode:(BuzzerOperationMode) bom;

/**
 Callback of `getDeactivateEpcPrefix:`
 
 @param getValue The value of EPC prefix.
 */
-(void)didGetDeactivateEpcPrefix:(NSData *) getValue;

/**
 Callback of `getFieldSeparator:`
 
 @param separator Seperator of ascii.
 */
-(void)didGetFieldSeparator:(Byte) separator;

/**
 Callback of `getFilter:`
 
 @param tagDataEncodeTypes Specifies the decoded type for reading tag data.
 */
-(void)didGetFilter:(TagDataEncodeType) tagDataEncodeTypes;

/**
 Callback of `getOutputFormat:`
 
 @param outputFormat The output format.
 */
-(void)didGetOutputFormat:(OutputFormat) outputFormat;

/**
 Callback of `getOutputInterfaces:`
 
 @param outputInterfaces The set of data output interface. also can 'outputInterface = OI_HID_N_VCOM | OI_BLE;'
 */
-(void)didGetOutputInterfaces:(int) outputInterfaces;

/**
 Callback of `getOutputInterfaces:`
 
 @param keyboardSimulation Keyboard Simulation.
 @param outputInterface The set of data output interface. also can 'outputInterface = OI_HID_N_VCOM | OI_BLE;'
 */
-(void)didGetOutputInterface:(KeyboardSimulation) keyboardSimulation OutputInterface:(OutputInterface) outputInterface;

/**
 Callback of `getPostDataDelimiter:`
 
 @param postDataDelimiter Specifies the delimiter append to the end of output data.
 @param memoryBankSelection Memory bank selection setting.
 */
-(void)didGetPostDataDelimiter:(PostDataDelimiter) postDataDelimiter MemoryBankSelection:(MemoryBankSelection) memoryBankSelection;

/**
 Callback of `getPrefix:`
 
 @param data The data of prefix.
 */
-(void)didGetPrefix:(NSData *) data;

/**
 Callback of `getReactivateEpcPrefix:`
 
 @param getValue The value of EPC prefix.
 */
-(void)didGetReactivateEpcPrefix:(NSData *) getValue;

/**
 Callback of `getRemoteHost`
 
 @param connectTimeout The timeout of connection.
 @param inetSocketAddress The InetSocketAddress.
 */
-(void)didGetRemoteHost:(int)connectTimeout InetSocketAddress:(InetSocketAddress *)inetSocketAddress;

/**
 Callback of `getSuffix:`
 
 @param data The data of suffix.
 */
-(void)didGetSuffix:(NSData *) data;

/**
 Callback of `getEventType:`
 
 @param eventType The type for the event command.
 */
-(void)didGetEventType:(EventType) eventType;

/**
 Callback of `getTagMemorySelection:`
 
 @param tagMemorySelection Memory bank selections setting.
 */
-(void)didGetTagMemorySelection:(TagMemorySelection)tagMemorySelection;

/**
 Callback of `getTagPresentedRepeatInterval:`
 
 @param period The period to raising a TagPresentedEvent. range: 1~255 (Unit: 100ms), 0:Always repeating raising event, 255: Never repeating raising event.
 */
-(void)didGetTagPresentedRepeatInterval:(int) period;

/**
 Callback of `getTagProtection:`
 
 @param tagProtection The tag protection mode.
 */
-(void)didGetTagProtection:(TagProtection) tagProtection;

/**
 Callback of `getTagProtectionAccessPassword:`
 
 @param accessPassword Access Password.
 */
-(void)didGetTagProtectionAccessPassword:(NSString *)accessPassword;

/**
 Callback of `getUsbInterface:`
 
 @param usbInterface The USB interface.
 */
-(void)didGetUsbInterface:(UsbInterface) usbInterface;

/**
 Callback of `getWiFiMacAddress:`
 
 @param wifiMacAddress The MAC address of the Wi-Fi module.
 */
-(void)didGetWiFiMacAddress:(NSString*)wifiMacAddress;

/**
 Callback of `getEncodeType:`
 
 @param encodeType The encode type.
 */
-(void)didGetEncodeType:(EncodeType) encodeType;

/**
 Callback of `getTransformEpcState:`
 
 @param state The EPC prefix state.
 */
-(void)didGetTransformEpcState:(EpcPrefixState) state;

/**
 Callback of `getTransformEpcPrefix:`
 
 @param getValue The value of EPC prefix.
 */
-(void)didGetTransformEpcPrefix:(int) getValue;

/**
 Callback of `getEpcNormalize:`
 
 @param enable The setting to enable/disable the EPC normalization.
 */
-(void)didGetEpcNormalize:(BOOL) enable;

#pragma mark - Command Callback for TS100 with ESP32 module


-(void)didGetWiFiTcpClient:(BOOL)enable remoteServerIp:(NSString*)remoteServerIp remoteServerPort:(NSString*)remoteServerPort connectionTimeout:(int)connectionTimeout;

-(void)didGetWiFiHostName:(NSString*)hostName;

-(void)didGetBleServiceMode:(BLEServiceMode)bleServiceMode;

-(void)didGetBleMode:(BLEMode)bleMode;

-(void)didGetBleInformation:(BLEInformation*)bleInformation;

-(void)didGetWiFiInformation:(WiFiInformation*)wifiInformation;

-(void)didGetNetworkInformation:(NetworkInformation*)networkInformation;

#pragma mark - Special Command Callback

/**
 Callback of `getBLEFirmwareVersion:`
 
 @param fwVer The firmware version of the remote device.
 */
-(void)didGetBLEFirmwareVersion:(NSString*)fwVer;

/**
 only TS800 & UR0250
 Callback of `cmdGetTriggerType:`
 
 @param triggerType The trigger source of inventory.
 */
-(void)didGetTriggerType:(TriggerType)triggerType;

/**
 Callback of `getFrequency:`
 
 @param frequencys Specifies the channel of hopping frequency for reading tag data.
 */
-(void)didGetFrequencyList:(NSArray*)frequencys;

-(void)didGet:(KeyboardSimulation) keyboardSimulation OutputInterfaces:(OutputInterface) outputInterfaces;

-(void)didGetScanMode:(ScanMode) sm;

-(void)didGetDeviceControl:(NSString*)strCMDName Data:(NSData *) data;

-(void)didGetIpAddress:(NSString*)ipAddress;

@end

NS_ASSUME_NONNULL_END
