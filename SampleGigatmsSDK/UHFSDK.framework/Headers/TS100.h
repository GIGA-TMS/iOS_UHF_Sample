//
//  TS100.h
//  UHFSDK
//
//  Created by WadeGigatms on 2023/6/14.
//  Copyright © 2023 Gianni. All rights reserved.
//

#ifndef TS100_h
#define TS100_h

//
//  TS100.h
//  UHFSDK
//
//  Created by Gianni on 2019/4/29.
//  Maintained by Jack Jang, Syscode on 2020/05/15.
//  Maintained by Wade on 2021/3/23.
//  Maintained by Wade on 2023/6/14.
//  Copyright © 2019 Gianni. All rights reserved.
//

#import <UHFSDK/UHFSDK.h>
#import "UHFDevice.h"
#import <UHFSDK/BaseTagData.h>
#import <UHFSDK/SGTIN96TagData.h>
#import <UHFSDK/SGTIN96EASTagData.h>
#import <UHFSDK/UDCTagData.h>
#import <UHFSDK/BaseTagEvent.h>
#import <UHFSDK/TagAccessParameter.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(Byte, TS100SpecialCode){
    SW_EE_TS100_getBleDeviceName      = 0x00,
};

@protocol ITS100SpecialListener <NSObject>
@optional
@end

@interface TS100 : UHFDevice

#pragma mark - TS100

/**
 Initialize setting of TS100, please call it after connected with remote TS100.
 */
-(void)cmdInitializeSettings;

/**
 Start inventory tags with specific encoded data type.
 
 @param tagDataEncodeTypes The filter of the tag data encode type.
 */
-(void)startInventoryEx:(NSMutableSet *) tagDataEncodeTypes;

/**
 Get Active Mode of the device.
 
 @param isTemp True value specifies the changes are temporary overwrides for settings. The changes are not saved into the EEPROM and take immediate effect (no rebooting required). False value specifies the changes are permanently overwrides for settings And also saved into the EEPROM. The changes will keep after rebooting the device. Please make sure the setting of frequency is conform to standards.
 */
-(void)getInventoryActiveMode:(BOOL) isTemp;

/**
 Set Active Mode of the device.
 
 @param isTemp True value specifies the changes are temporary overwrides for settings. The changes are not saved into the EEPROM and take immediate effect (no rebooting required). False value specifies the changes are permanently overwrides for settings And also saved into the EEPROM. The changes will keep after rebooting the device. Please make sure the setting of frequency is conform to standards.
 @param activeMode The Active mode of the connected remote device.
 */
-(void)setInventoryActiveMode:(BOOL) isTemp InventoryActiveMode:(ActiveMode) activeMode;

/**
 Control the buzzer action of remote TS100.
 
 @param buzzerAct The buzzer action.
 */
-(void)controlBuzzer:(BuzzerAction)buzzerAct;

/**
 Transform barcode to EPC. The command would transform barcode data to EPC and write into the tag.
 
 @param baseTagData Barcode data which is going to write to the EPC bank of the tag.
 */
-(void)writeTagEx:(BaseTagData *) baseTagData;

/**
 Transform barcode to EPC. The command would transform barcode data to EPC and write into the tag with `hexAccessPassword`.
 
 @param baseTagData Barcode data which is going to write to the EPC bank of the tag.
 @param hexAccessPassword The access password of the tag.
 */
-(void)writeTagEx:(BaseTagData *) baseTagData HexAccessPassword:(NSString*)hexAccessPassword;

/**
 Read the data from EPC bank and transform the data into barcode data. The data could get from `IUHFDeviceListner.didReadTagEx` The transform format would influences by the default `BarcodeFormat` setting. Please see also `getBarcodeReadFormat` and `setBarcodeReadFormat`.
 */
-(void)readTagEx;

/**
 Read the data from EPC bank with `hexAccessPassword` and transform the data into barcode data. The data could get from `IUHFDeviceListner.didReadTagEx` The transform format would influences by the default `BarcodeFormat` setting. Please see also `getBarcodeReadFormat` and `setBarcodeReadFormat`.
 
 @param strPwd The access password of the tag.
 */
-(void)readTagEx:(NSString*)strPwd;

#pragma mark - TS100 Device Settings

/**
 Get the default barcode format of `readRagEx` command.
 
 @param isTemp True value specifies the changes are temporary overwrides for settings. The changes are not saved into the EEPROM and take immediate effect (no rebooting required). False value specifies the changes are permanently overwrides for settings And also saved into the EEPROM. The changes will keep after rebooting the device.
 */
-(void)getBarcodeReadFormat:(BOOL) isTemp;

/**
 Set the default barcode format of `readRagEx` command.
 
 @param isTemp True value specifies the changes are temporary overwrides for settings. The changes are not saved into the EEPROM and take immediate effect (no rebooting required). False value specifies the changes are permanently overwrides for settings And also saved into the EEPROM. The changes will keep after rebooting the device.
 @param barcodeFormat The default format of barcode while reading a tag.
 */
-(void)setBarcodeReadFormat:(BOOL) isTemp BarcodeFormat:(BarcodeFormat) barcodeFormat;

/**
 Get the device name of BLE through BLE interface.
 */
-(void)getBleDeviceName;

/**
 Set the device name of BLE through BLE interface.
 
 @param devName The device name.
 */
-(void)setBleDeviceName:(NSString*)devName;

/**
 Get BLE Mac Address.
 */
-(void)getBleMacAddress;

/**
 Get Firmware version of the ble module of the remote device.
 */
-(void)getBleRomVersion;

/**
 Get the BuzzerAdapter Operation Mode of remote TS100.
 
 @param isTemp True value specifies the changes are temporary overwrides for settings. The changes are not saved into the EEPROM and take immediate effect (no rebooting required). False value specifies the changes are permanently overwrides for settings And also saved into the EEPROM. The changes will keep after rebooting the device. Please make sure the setting of frequency is conform to standards.
 */
-(void)getBuzzerOperationMode:(BOOL) isTemp;

/**
 Set the BuzzerAdapter Operation Mode of remote TS100.
 
 @param isTemp True value specifies the changes are temporary overwrides for settings. The changes are not saved into the EEPROM and take immediate effect (no rebooting required). False value specifies the changes are permanently overwrides for settings And also saved into the EEPROM. The changes will keep after rebooting the device. Please make sure the setting of frequency is conform to standards.
 @param bom Buzzer Operation Mode: Specifies the repeats mode of sounding the beep with the same pattern.
 */
-(void)setBuzzerOperationMode:(BOOL) isTemp BuzzerOperationMode:(BuzzerOperationMode) bom;
-(void)cmdSet:(BOOL) isTemp BuzzerOperationMode:(BuzzerOperationMode) bom;

/**
 Get deactivate epc prefix.
 
 @param isTemp True value specifies the changes are temporary overwrides for settings. The changes are not saved into the EEPROM and take immediate effect (no rebooting required). False value specifies the changes are permanently overwrides for settings And also saved into the EEPROM. The changes will keep after rebooting the device.
 */
-(void)getDeactivateEpcPrefix:(BOOL) isTemp;

/**
 Set deactivate epc prefix.
 
 @param isTemp True value specifies the changes are temporary overwrides for settings. The changes are not saved into the EEPROM and take immediate effect (no rebooting required). False value specifies the changes are permanently overwrides for settings And also saved into the EEPROM. The changes will keep after rebooting the device.
 @param prefix The prefix.
 */
-(void)setDeactivateEpcPrefix:(BOOL) isTemp Prefix:(NSData *) prefix;

/**
 Get Field Separator of keyboard output format.
 
 @param isTemp True value specifies the changes are temporary overwrides for settings. The changes are not saved into the EEPROM and take immediate effect (no rebooting required). False value specifies the changes are permanently overwrides for settings And also saved into the EEPROM. The changes will keep after rebooting the device.
 */
-(void)getFieldSeparator:(BOOL) isTemp;

/**
 Set Field Separator of keyboard output format.
 
 @param isTemp True value specifies the changes are temporary overwrides for settings. The changes are not saved into the EEPROM and take immediate effect (no rebooting required). False value specifies the changes are permanently overwrides for settings And also saved into the EEPROM. The changes will keep after rebooting the device.
 @param separator Seperator of ascii.
 */
-(void)setFieldSeparator:(BOOL) isTemp FieldSeparator:(NSData *) separator;

/**
 Get the Filters of inventorying tags.
 
 @param isTemp True value specifies the changes are temporary overwrites for settings. The changes are not saved into the EEPROM and take immediate effect (no rebooting required). False value specifies the changes are permanently overwrites for settings And also saved into the EEPROM. The changes will keep after rebooting the device.
 */
-(void)getFilter:(BOOL) isTemp;

/**
 Set the Filters of inventorying tags.
 
 @param isTemp True value specifies the changes are temporary overwrites for settings. The changes are not saved into the EEPROM and take immediate effect (no rebooting required). False value specifies the changes are permanently overwrites for settings And also saved into the EEPROM. The changes will keep after rebooting the device.
 @param filterTypes Specifies the decoded type for reading tag data.
 */
-(void)setFilter:(BOOL) isTemp TagDataEncodeType:(NSMutableSet *) filterTypes;

/**
 Get output format of tag.
 
 @param isTemp True value specifies the changes are temporary overwrides for settings. The changes are not saved into the EEPROM and take immediate effect (no rebooting required). False value specifies the changes are permanently overwrides for settings And also saved into the EEPROM. The changes will keep after rebooting the device.
 */
-(void)getOutputFormat:(BOOL) isTemp;

/**
 Set output format of tag.
 
 @param isTemp True value specifies the changes are temporary overwrides for settings. The changes are not saved into the EEPROM and take immediate effect (no rebooting required). False value specifies the changes are permanently overwrides for settings And also saved into the EEPROM. The changes will keep after rebooting the device.
 @param outputFormat The output format.
 */
-(void)setOutputFormat:(BOOL) isTemp OutputFormat:(OutputFormat) outputFormat;

/**
 Gets the data output interface.
 
 @param isTemp isTemp True value specifies the changes are temporary overwrites for settings. The changes are not saved into the EEPROM and take immediate effect (no rebooting required). False value specifies the changes are permanently overwrites for settings And also saved into the EEPROM. The changes will keep after rebooting the device.
 
 */
-(void)getOutputInterfaces:(BOOL) isTemp;

//"(boolean temporary, 單選KeyboardSimulation,多選OutputInterface)

/**
 Set the data output interface.
 
 @param isTemp isTemp True value specifies the changes are temporary overwrites for settings. The changes are not saved into the EEPROM and take immediate effect (no rebooting required). False value specifies the changes are permanently overwrites for settings And also saved into the EEPROM. The changes will keep after rebooting the device.
 @param keyboardSimulation Keyboard Simulation.
 @param outputInterface  The set of data output interface. also can 'outputInterface = OI_HID_N_VCOM | OI_BLE;'
 */
-(void)setOutputInterfaces:(BOOL) isTemp KeyboardSimulation:(KeyboardSimulation) keyboardSimulation OutputInterface:(NSMutableSet *) outputInterface;
-(void)cmdSet:(BOOL) isTemp KeyboardSimulation:(KeyboardSimulation) keyboardSimulation OutputInterface:(OutputInterface) outputInterface;

/**
 Get Post Data Delimiter & Memory Bank Selection setting.
 
 @param isTemp isTemp isTemp True value specifies the changes are temporary overwrites for settings. The changes are not saved into the EEPROM and take immediate effect (no rebooting required). False value specifies the changes are permanently overwrites for settings And also saved into the EEPROM. The changes will keep after rebooting the device.
 */
-(void)getPostDataDelimiter:(BOOL) isTemp;

/**
 Set Post Data Delimiter.
 
 @param isTemp isTemp isTemp True value specifies the changes are temporary overwrites for settings. The changes are not saved into the EEPROM and take immediate effect (no rebooting required). False value specifies the changes are permanently overwrites for settings And also saved into the EEPROM. The changes will keep after rebooting the device.
 @param postDataDelimiter Specifies the delimiter append to the end of output data.
 */
-(void)setPostDataDelimiter:(BOOL) isTemp PostDataDelimiter:(NSMutableSet *) postDataDelimiter;

/**
 Get prefix of keyboard output format.
 
 @param isTemp True value specifies the changes are temporary overwrides for settings. The changes are not saved into the EEPROM and take immediate effect (no rebooting required). False value specifies the changes are permanently overwrides for settings And also saved into the EEPROM. The changes will keep after rebooting the device.
 */
-(void)getPrefix:(BOOL) isTemp;

/**
 Set prefix of keyboard output format.
 
 @param isTemp True value specifies the changes are temporary overwrides for settings. The changes are not saved into the EEPROM and take immediate effect (no rebooting required). False value specifies the changes are permanently overwrides for settings And also saved into the EEPROM. The changes will keep after rebooting the device.
 @param prefix The prefix.
 */
-(void)setPrefix:(BOOL) isTemp Prefix:(NSData *) prefix;

/**
 Get reactivate epc prefix.
 
 @param isTemp True value specifies the changes are temporary overwrides for settings. The changes are not saved into the EEPROM and take immediate effect (no rebooting required). False value specifies the changes are permanently overwrides for settings And also saved into the EEPROM. The changes will keep after rebooting the device.
 */
-(void)getReactivateEpcPrefix:(BOOL) isTemp;

/**
 Set reactivate epc prefix.
 
 @param isTemp True value specifies the changes are temporary overwrides for settings. The changes are not saved into the EEPROM and take immediate effect (no rebooting required). False value specifies the changes are permanently overwrides for settings And also saved into the EEPROM. The changes will keep after rebooting the device.
 @param prefix The prefix.
 */
-(void)setReactivateEpcPrefix:(BOOL) isTemp Prefix:(NSData *) prefix;

/**
 Get Remote Host IP, Port and Connect timeout The data would get from `IUHFDeviceListner.didGetRemoteHost` While socketAddress is null, it means that there is no remote host.
 */
-(void)getRemoteHost;

/**
 Set the remote host connect timeout, IP and Port. If socketAddress is null, it would clear the remote host setting.
 
 @param connectTimeout The time to disconnect with remote host. Unit: 100ms.
 @param inetSocketAddress IP and Port data of remote host.
 */
-(void)setRemoteHost:(int) connectTimeout InetSocketAddress:(InetSocketAddress *) inetSocketAddress;

/**
 Get prefix of keyboard output format.
 
 @param isTemp True value specifies the changes are temporary overwrides for settings. The changes are not saved into the EEPROM and take immediate effect (no rebooting required). False value specifies the changes are permanently overwrides for settings And also saved into the EEPROM. The changes will keep after rebooting the device.
 */
-(void)getSuffix:(BOOL) isTemp;

/**
 Set prefix of keyboard output format.
 
 @param isTemp True value specifies the changes are temporary overwrides for settings. The changes are not saved into the EEPROM and take immediate effect (no rebooting required). False value specifies the changes are permanently overwrides for settings And also saved into the EEPROM. The changes will keep after rebooting the device.
 @param suffix The suffix.
 */
-(void)setSuffix:(BOOL) isTemp Suffix:(NSData *) suffix;

/**
 Gets the event command type.
 
 @param isTemp isTemp True value specifies the changes are temporary overwrites for settings. The changes are not saved into the EEPROM and take immediate effect (no rebooting required). False value specifies the changes are permanently overwrites for settings And also saved into the EEPROM. The changes will keep after rebooting the device.
 */
-(void)getEventType:(BOOL) isTemp;

/**
 Sets the event command type.
 
 @param isTemp isTemp True value specifies the changes are temporary overwrites for settings. The changes are not saved into the EEPROM and take immediate effect (no rebooting required). False value specifies the changes are permanently overwrites for settings And also saved into the EEPROM. The changes will keep after rebooting the device.
 @param eventType The type for the event command.
 */
-(void)setEventType:(BOOL) isTemp EventType:(BaseTagEvent *) eventType;
-(void)cmdSet:(BOOL) isTemp EventType:(EventType) eventType;

/**
 Get Memory Bank Selection setting. The setting works at keyboard output and didDiscoverTagInfoEx.
 When the filter is disable (`disableFilter`).This setting decides the output memory bank data. The data will get from `IUHFDeviceListner.didDiscoverTagInfoEx` and KeyboardSimulation.
 @param isTemp True value specifies the changes are temporary overwrites for settings. The changes are not saved into the EEPROM and take immediate effect (no rebooting required). False value specifies the changes are permanently overwrites for settings And also saved into the EEPROM. The changes will keep after rebooting the device.
 */
-(void)getTagMemorySelection:(BOOL) isTemp;

/**
 Set Memory Bank Selections setting. The setting works at keyboard output and didDiscoverTagInfoEx.
 
 @param isTemp True value specifies the changes are temporary overwrites for settings. The changes are not saved into the EEPROM and take immediate effect (no rebooting required). False value specifies the changes are permanently overwrites for settings And also saved into the EEPROM. The changes will keep after rebooting the device.
 @param tagMemory Memory Bank Selections setting.
 */
-(void)setTagMemorySelection:(BOOL) isTemp TagMemory:(NSMutableSet *) tagMemory;

/**
 Get the threshold to raise a TagRemovedEvent(IUHFDeviceListner.didDiscoveredTag).
 
 @param isTemp True value specifies the changes are temporary overwrides for settings. The changes are not saved into the EEPROM and take immediate effect (no rebooting required). False value specifies the changes are permanently overwrides for settings And also saved into the EEPROM. The changes will keep after rebooting the device.
 */
-(void)getTagPresentedRepeatInterval:(BOOL)isTemp;

/**
 Set the threshold to raise a TagPresentedEvent(IUHFDeviceListner.didDiscoveredTag).
 
 @param isTemp True value specifies the changes are temporary overwrides for settings. The changes are not saved into the EEPROM and take immediate effect (no rebooting required). False value specifies the changes are permanently overwrides for settings And also saved into the EEPROM. The changes will keep after rebooting the device.
 @param time The period to raising a TagPresentedEvent. range: 1~255 (Unit: 100ms), 0:Always repeating raising event, 255: Never repeating raising event.
 */
-(void)setTagPresentedRepeatInterval:(BOOL)isTemp Time:(int)time;

/**
 Get Tag Protection Mode.
 
 @param isTemp True value specifies the changes are temporary overwrides for settings. The changes are not saved into the EEPROM and take immediate effect (no rebooting required). False value specifies the changes are permanently overwrides for settings And also saved into the EEPROM. The changes will keep after rebooting the device.
 */
-(void)getTagProtection:(BOOL) isTemp;

/**
 Set Tag Protection Mode.
 
 @param isTemp True value specifies the changes are temporary overwrides for settings. The changes are not saved into the EEPROM and take immediate effect (no rebooting required). False value specifies the changes are permanently overwrides for settings And also saved into the EEPROM. The changes will keep after rebooting the device.
 @param tagProtection The tag protection mode.
 */
-(void)setTagProtection:(BOOL) isTemp TagProtection:(TagProtection) tagProtection;

/**
 Get Tag Protection Access Password which is stored in device.
 */
-(void)getTagProtectionAccessPassword;

/**
 Set Tag Protection Access Password which is stored in device.
 
 @param accessPassword Access Password.
 */
-(void)setTagProtectionAccessPassword:(NSData *) accessPassword;

/**
 Get USB Interface. VCOM or HID.
 
 @param isTemp True value specifies the changes are temporary overwrides for settings. The changes are not saved into the EEPROM and take immediate effect (no rebooting required). False value specifies the changes are permanently overwrides for settings And also saved into the EEPROM. The changes will keep after rebooting the device.
 */
-(void)getUsbInterface:(BOOL) isTemp;

/**
 Set USB Interface. VCOM or HID.
 
 @param isTemp True value specifies the changes are temporary overwrides for settings. The changes are not saved into the EEPROM and take immediate effect (no rebooting required). False value specifies the changes are permanently overwrides for settings And also saved into the EEPROM. The changes will keep after rebooting the device.
 @param usbInterface The USB interface.
 */
-(void)setUsbInterface:(BOOL) isTemp UsbInterface:(UsbInterface) usbInterface;

/**
 Get the mac address of the Wi-Fi module The data would get from `IUHFDeviceListner.didGetWiFiMacAddress`.
 */
-(void)getWiFiMacAddress;

/**
 Connect to AP with SSID and PasswordFlag. Can't use while connecting device through wi-fi.
 
 @param strSSID The SSID of the Wi-Fi.
 @param strPwd The password of the Wi-Fi.
 */
-(void)setWifiSettings:(NSString*)strSSID PWD:(NSString*)strPwd;

/**
 Connect to AP with SSID and PasswordFlag. Disable DHCP and specifies IO, Gateway and subnetMask. Can't use while connecting device through wi-fi.
 
 @param strSSID The SSID of the Wi-Fi.
 @param strPwd The password of the Wi-Fi..
 @param strIP Define IP.
 @param strGateway Define Gateway.
 @param strSubNetMask Define SubNetMask.
 */
-(void)setWifiSettings:(NSString*)strSSID PWD:(NSString*)strPwd IP:(NSString*)strIP Gateway:(NSString*)strGateway  SubNetMask:(NSString*)strSubNetMask;

/**
 Get Encode Type.
 
 @param isTemp True value specifies the changes are temporary overwrides for settings. The changes are not saved into the EEPROM and take immediate effect (no rebooting required). False value specifies the changes are permanently overwrides for settings And also saved into the EEPROM. The changes will keep after rebooting the device.
 */
-(void)getEncodeType:(BOOL) isTemp;

/**
 Set Encode Type.
 
 @param isTemp True value specifies the changes are temporary overwrides for settings. The changes are not saved into the EEPROM and take immediate effect (no rebooting required). False value specifies the changes are permanently overwrides for settings And also saved into the EEPROM. The changes will keep after rebooting the device.
 @param encodeType The encode type.
 */
-(void)setEncodeType:(BOOL) isTemp EncodeType:(EncodeType) encodeType;

/**
 Gets the rule of determining to normalize the reading EPC data.
 
 @param isTemp True value specifies the changes are temporary overwrides for settings. The changes are not saved into the EEPROM and take immediate effect (no rebooting required). False value specifies the changes are permanently overwrides for settings And also saved into the EEPROM. The changes will keep after rebooting the device.
 */
-(void)getTransformEpcState:(BOOL) isTemp;

/**
 Sets to determine to normalize the reading EPC data.
 
 @param isTemp True value specifies the changes are temporary overwrides for settings. The changes are not saved into the EEPROM and take immediate effect (no rebooting required). False value specifies the changes are permanently overwrides for settings And also saved into the EEPROM. The changes will keep after rebooting the device.
 @param state The EPC prefix state.
 */
-(void)setTransformEpcState:(BOOL) isTemp State:(EpcPrefixState) state;

/**
 Gets the company length used to normalize the EPC data. This setting is only used when the TransformEpcState set to EAN/UPC.
 
 @param isTemp True value specifies the changes are temporary overwrides for settings. The changes are not saved into the EEPROM and take immediate effect (no rebooting required). False value specifies the changes are permanently overwrides for settings And also saved into the EEPROM. The changes will keep after rebooting the device.
 */
-(void)getTransformEpcPrefix:(BOOL) isTemp;

/**
 Sets the company length used to normalize the EPC data. This setting is only used when the TransformEpcState set to EAN/UPC.
 
 @param isTemp True value specifies the changes are temporary overwrides for settings. The changes are not saved into the EEPROM and take immediate effect (no rebooting required). False value specifies the changes are permanently overwrides for settings And also saved into the EEPROM. The changes will keep after rebooting the device.
 @param prefix The prefix.
 */
-(void)setTransformEpcPrefix:(BOOL) isTemp Prefix:(NSData *) prefix;

/**
 Control the untraceable features for a tag.
 
 @param tagAccessParameter The tag access parameter.
 */
-(void)protectTagPrivacy:(TagAccessParameter *) tagAccessParameter;

/**
 Gets the setting used to enable/disable the EPC normalization function.
 
 @param isTemp True value specifies the changes are temporary overwrides for settings. The changes are not saved into the EEPROM and take immediate effect (no rebooting required). False value specifies the changes are permanently overwrides for settings And also saved into the EEPROM. The changes will keep after rebooting the device.
 */
-(void)getEpcNormalize:(BOOL) isTemp;

/**
 Sets the setting used to enable/disable the EPC normalization function.
 
 @param isTemp True value specifies the changes are temporary overwrides for settings. The changes are not saved into the EEPROM and take immediate effect (no rebooting required). False value specifies the changes are permanently overwrides for settings And also saved into the EEPROM. The changes will keep after rebooting the device.
 @param enable The setting to enable/disable the EPC normalization.
 */
-(void)setEpcNormalize:(BOOL) isTemp Enable:(BOOL) enable;

// For ESP32 Module

-(void)getWiFiTcpClient;

-(void)setWiFiTcpClient:(BOOL)enable remoteServerIp:(NSString*)remoteServerIp remoteServerPort:(NSString*)remoteServerPort connectionTimeout:(int)connectionTimeout;

-(void)getWiFiHostName;

-(void)setWiFiHostName:(NSString*)hostName;

-(void)getBleServiceMode;

-(void)setBleServiceMode:(BLEServiceMode)bleServiceMode;

-(void)getBleMode;

-(void)setBleMode:(BLEMode)bleMode;

-(void)getBleInformation;

-(void)getWiFiInformation;

-(void)getNetworkInformation;

+(NSData *)dataFromHexString:(NSString *) string;

@end

NS_ASSUME_NONNULL_END


#endif /* TS100_h */
