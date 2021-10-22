//
//  UHFDevice.h
//  UHFSDK
//
//  Created by Gianni on 2019/3/20.
//  Maintained by Jack Jang, Syscode on 2020/05/15.
//  Maintained by Wade on 2021/3/23.
//  Copyright © 2019 Gianni. All rights reserved.
//

#import "IUHFDeviceListener.h"
#import "BaseDevice.h"

#import "GNPSwAPICode.h"

#import "InetSocketAddress.h"

NS_ASSUME_NONNULL_BEGIN

/**
 UHFDevice communicates with remote UHF device.
 */
@interface UHFDevice : BaseDevice

/**
 SpecifSpecifies the tag data format received at OnTagPresented Event.
 
 - ET_PC_EPC: The ouput data is PC + EPC fields data.
 - ET_PC_EPC_TID: The ouput data is PC + EPC fields + TID bank data.
 - ET_PC_EPC_Data: The ouput data is PC + EPC fields dataand Memory Bank.
 - ET_PC_EPC_TID_Data: The ouput data is PC + EPC fields + TID bank data and Memory Bank.
 */
typedef NS_ENUM(Byte, TagPresentedType){
    //    ET_PC_EPC             = 0xFF,
    //    ET_PC_EPC_TID         = 0xFE,
    //    ET_PC_EPC_Data        = 0xFD,
    //    ET_PC_EPC_TID_Data    = 0xFC,
    //    EVENT_62              = 0x00,
    //    ET_RF80TagEvent         = 0x80 bit:7 is 1
    ET_PC_EPC             = 0xDF,
    ET_PC_EPC_TID         = 0xDE,
    
};

//typedef NS_ENUM(Byte, ScanMode){
//    TRIGGER_A_LEVEL_CONTROL     = 0x00,
//    ALWAYS_SCAN                 = 0xFF
//};


/**
 UHF family list type
 
 - UHF_UR0250: UHF Device 1 - UR0250
 - UHF_TS100: UHF Device 2 - TS100
 - UHF_TS800: UHF Device 3 - TS800
 - UHF_PWD100: UHF Device 4 - PWD100
 - UHF_TS100A: UHF Device 5 - TS100A
 */
typedef NS_ENUM(Byte, ClassVer){
    UHF_UR0250              = 0x00,
    UHF_TS100               = 0x01,
    UHF_TS100A              = 0x02,
    UHF_TS800               = 0x03,
    UHF_MU400H              = 0x04,
    UHF_NR800               = 0x05,
    UHF_PWD100              = 0x06,
};

/**
 Specifies the pattern of sounding buzzer
 
 -  BA_Success: Selects success beep sound
 -  BA_Failure: Selects failure beep sounrd
 -  BA_Disable: Selects to turn off beep sound
 -  BA_Auto: Selects to use default beep sound
 */
typedef NS_ENUM(Byte, BuzzerAction){
    BA_Success = 0x00,// Selects success beep sound
    BA_Failure = 0x01,// Selects failure beep sounrd
    BA_Disable = 0xFE,// 254 Selects to turn off beep sound
    BA_Auto = 0xFF,// 255 Selects to use default beep sound
};

/**
 Rx Decode Type
 */
typedef NS_ENUM(Byte, RxDecodeType){
    FM0                 = 0x00,
    MILLER_2            = 0x01,
    MILLER_4            = 0x02,
    MILLER_8            = 0x03,
};

/**
 Link Frequency
 */
typedef NS_ENUM(Byte, LinkFrequency) {
    LF_40KHZ            = 0x00,
    LF_80KHZ            = 0x03,
    LF_160KHZ           = 0x06,
    LF_213_POINT_3KHZ   = 0x08,
    LF_256KHZ           = 0x09,
    LF_320KHZ           = 0x0C,
    LF_640KHZ           = 0x0F,
};

/**
 Profile ID
 */
typedef NS_ENUM(Byte, Profile) {
    PID_Single_Frequency    = 0x00,
    PID_Europe              = 0x01,
    PID_Japan_952_POINT_4   = 0x02,
    PID_USA                 = 0x03,
    PID_China_920_POINT_625 = 0x04,
    PID_China_840_POINT_125 = 0x05,
    PID_Korea               = 0x06,
    PID_Taiwan              = 0x07,
    PID_Brazil              = 0x08,
    PID_Uruguay             = 0x09,
    PID_Israel              = 0x0A,
    PID_Japan_916_POINT_8   = 0x0B,
    PID_Japan_920_POINT_4   = 0x0C,
    PID_User_Define         = 0xFE,
    PID_Default             = 0xFF,
};


/**
 UHF Device callback
 */
@property (nonatomic, assign, nullable) id<IUHFDeviceListener> uhfListener;
@property (nonatomic, assign) ClassVer classVer;

-(instancetype)initWithInfo:(GTBaseDevInfo*) info;

/**
 Gets the version of SDK library
 
 @return Version
 */
-(NSString *)getSDKVersion;

/**
 Set ts800 reply listener
 
 @param listener see IUHFDeviceListener
 */
-(void)setListener:(id<IUHFDeviceListener>)listener;

/**
 Connect to remote device.
 */
-(void)Connect;

/**
 Initializes the device settings.
 
 @param classVer The UHF device.
 */
-(void)cmdInitializeSettings:(ClassVer) classVer;

#pragma mark - Special Command List

/**
 Only for TS800 & UR0250
 Set Scan Mode
 
 @param isTemp  If the value is true, this setting will write into EEPROM.
 @param scanMode Scan Mode
 */
-(void)cmdSetScanMode:(BOOL)isTemp  ScanMode:(ScanMode) scanMode;

/**
 Only for TS800 & UR0250
 Get Trigger Source
 
 @param isTemp  If the value is true, this setting will write into EEPROM.
 */

-(void)cmdGetTriggerType:(BOOL)isTemp;

/**
 Only for TS800 & UR0250
 Set Trigger Sourec
 
 @param isTemp  If the value is true, this setting will write into EEPROM.
 @param triggerType The trigger source of inventory.
 */
-(void)cmdSetTriggerType:(BOOL)isTemp TriggerType:(TriggerType) triggerType;

/**
 Only for TS100
 Control reader to make a specified sound beep.
 
 @param buzzerAct Buzze ActionbuzzerAct
 */
-(void)controlBuzzer:(BuzzerAction)buzzerAct;

#pragma mark - Special Command List

/// send  Special Multi CMD
/// @param datas  Special CMD format
/// @param apiCode software api code
/// @param cmdCount cmd conunt
-(void)cmdMarkMultiCMD:(NSMutableArray*) datas CMDCode:(Byte)apiCode CMDCount:(int)cmdCount;

/// send  Special CMD
/// @param cmdData Special CMD format
-(void)sendGNetCMD:(NSData*)cmdData;
-(void)cmdSpecial:(NSData*)cmdData CMDCode:(int)apiCode CMDCount:(int)cmdCount;
-(void)cmdSetSpecialSetting:(BOOL)isTemp Address:(char)iAddr Value:(NSData*)val CMDCode:(int)apiCode;
-(void)cmdGetSpecialSetting:(BOOL)isTemp Address:(char)iAddr ReadLen:(char)readLen CMDCode:(int)apiCode;

#pragma mark - Special Command Callback

-(void)didSetSpecialSetting:(short)settingAddr Value:(int)settingValue;
-(void)didSetSpecialSetting:(short)settingAddr Values:(NSData *)settingValues;

-(void)didGetSpecialSetting:(int)settingAddr Value:(int)settingValue;
-(void)didGetSpecialSetting:(int)settingAddr Values:(NSData *)settingValues;

#pragma mark - UHFDevice API

/**
 Used by manufacture only.
 Send direct data to device.
 
 @param command Command code of command.
 @param data Parameter of command.
 */
-(void)directIO:(Byte)command Data:(NSData*)data;

/**
 Start Inventory mEPC Tag.
 Starts the process of tag inventory using specified trigger source.
 @see IUHFDeviceListener
 @see  didEventTagPresented:
 @seealso GNPTagInfo
 
 @param tagPresentedType Specify the way of triggering the RF power to read tag data.
 */
-(void)startInventory:(TagPresentedType) tagPresentedType;

/**
 Stop Inventory mEPC Tag.
 Stops the process of tag inventory.
 @see  didGeneralSuccess:
 */
-(void)stopInventory;

/**
 * Start inventory tags with specific encoded data type.
 
 @param tagDataEncodeType ex:tagDataEncodeType = UDC | EAN_UPC_EAS;
 */
-(void)startInventoryEx:(TagDataEncodeType) tagDataEncodeType;

/**
 Writes specified data to EPC memory bank. This command would calculate PC and write the PC and EPC data to the tag.
 
 @param hexAccessPassword Specifies the password to write data.
 @param epcData Specifies the data to write to memory bank.
 */
-(void)writeEpc:(NSString*)hexAccessPassword EPCData:(NSData*)epcData;

/**
 Selects a tag and writes specified data to EPC memory bank. * This command would calculate PC and write the PC and EPC data to the tag.

 @param hexSelectedPcEpc Specifies the tag PC EPC to be selected.
 @param hexAccessPassword Specifies the password to write data.
 @param epcData Specifies the data to write to memory bank.
*/
-(void)writeEpc:(NSString*)hexSelectedPcEpc HexAccessPassword: (NSString*)hexAccessPassword EPCData:(NSData*)epcData;

/**
 Writes specified data to given memory bank.
 
 @param hexAccessPassword Specifies the password to write data.
 @param memoryBank Specifies which memory bank to write.
 @param startWordAddress Specifies the start word address of memory bank to write data.When write EPC bank, notice that EPC starts from address 02, the first two 2 words are for CRC and PC.
 @param data Specifies the data to write to memory bank.
 */
-(void)writeTag:(NSString*)hexAccessPassword MemoryBank:(MemoryBank)memoryBank StartAddr:(int)startWordAddress Data:(NSData*)data;

/**
 Writes specified data to given memory bank.
 
 @param hexSelectedPcEpc Specifies the tag PC EPC to be selected.
 @param hexAccessPassword Specifies the password to write data.
 @param memoryBank Specifies which memory bank to write.
 @param startWordAddress Specifies the start word address of memory bank to write data.When write EPC bank, notice that EPC starts from address 02, the first two 2 words are for CRC and PC.
 @param data Specifies the data to write to memory bank.
 */
-(void)writeTag:(NSString*)hexSelectedPcEpc PWD:(NSString*)hexAccessPassword MemoryBank:(MemoryBank)memoryBank StartAddr:(int)startWordAddress Data:(NSData*)data;

/**
 Reads EPC memory bank data of tag.
 
 @param password Password of the tag that is going to read. (4 byte/2 Hex String)
 */
-(void)cmdReadEPC:(NSString*)password;

/**
 Reads tag data from given memory bank.
 
 @param hexSelectedPcEpc Specifies the tag PC EPC to be selected.
 @param hexAccessPassword Specifies the password to write data.
 @param memoryBank Specifies which memory bank to write.
 @param startWordAddress Specifies the start word address of memory bank to read data.When read EPC bank, notice that EPC starts from address 02, the first two 2 words are for CRC and PC.
 @param readLength Specifies the length to read from memory bank.
 */
-(void)readTag:(NSString*) hexSelectedPcEpc PWD:(NSString*)hexAccessPassword MemoryBank:(MemoryBank) memoryBank StartAddr:(int)startWordAddress ReadLen:(int)readLength;

/**
 Reads tag data from given memory bank.
 
 @param hexAccessPassword Specifies the password to write data.
 @param memoryBank Specifies which memory bank to write.
 @param startWordAddress Specifies the start word address of memory bank to read data.When read EPC bank, notice that EPC starts from address 02, the first two 2 words are for CRC and PC.
 @param readLength Specifies the length to read from memory bank.
 */
-(void)readTag:(NSString*)hexAccessPassword MemoryBank:(MemoryBank) memoryBank StartAddr:(int)startWordAddress ReadLen:(int)readLength;

/**
 Lock the first tag that is inventoried.
 The Access password is decided by the remote connected device.
 
 @param lockInfos The Lock Action to specified memory bank. see GNPLockInfos.h
 */
-(void)lockTag:(NSMutableArray*)lockInfos;

/**
 Use `accessPassword` to Lock the first tag that is inventoried.
 
 @param accessPassword Access Password.
 @param lockInfos The Lock Action to specified memory bank. see GNPLockInfos.h
 */
-(void)lockTag:( NSString*)accessPassword LockInfos:(NSMutableArray*)lockInfos;

-(void)lockTag:(nullable NSString*)accessPassword SelectedPcEpc:(nullable NSString *)selectedPcEpc LockInfos:(NSMutableArray*)lockInfos;

/**
 Use `hexKillPassword` to kill tag. The access password is decided byte the remote connected device.
 
 @param hexKillPassword Kill Password.
 */
-(void)killTag:(NSString*)hexKillPassword;

/**
 Use `hexAccessPassword` to access tag and use `hexKillPassword` to kill tag.
 @param accessPassword Access Password.
 @param hexKillPassword Kill Password.
 */
-(void)killTag:(nullable NSString*)accessPassword KillPWD:(nullable NSString*)hexKillPassword;

#pragma mark - UHFDevice Settings API

/**
 Get ID of device.
 
 @param isTemp True value specifies the changes are temporary overwrides for settings. The changes are not saved into the EEPROM and take immediate effect (no rebooting required). False value specifies the changes are permanently overwrides for settings And also saved into the EEPROM. The changes will keep after rebooting the device.
 */
-(void)getDeviceID:(BOOL) isTemp;

/**
 Set ID of device.
 
 @param isTemp True value specifies the changes are temporary overwrides for settings. The changes are not saved into the EEPROM and take immediate effect (no rebooting required). False value specifies the changes are permanently overwrides for settings And also saved into the EEPROM. The changes will keep after rebooting the device.
 @param deviceID Device ID.
 */
-(void)setDeviceID:(BOOL) isTemp DeviceID:(Byte) deviceID;

-(void)getBLEFirmwareVersion;

/**
 Get Device Information
 Gets the firmware program version running on the device.
 */
-(void)getFirmwareVersion;

/**
 Get Frequency List
 Gets the channel of hopping frequency in MHz.
 
 @param isTemp True value specifies the changes are temporary overwrides for settings. The changes are not saved into the EEPROM and take immediate effect (no rebooting required). False value specifies the changes are permanently overwrides for settings And also saved into the EEPROM. The changes will keep after rebooting the device.
 */
-(void)getFrequency:(BOOL) isTemp;

/**
 Set Frequency List
 Sets the channel of hopping frequency in MHz.
 
 @param isTemp True value specifies the changes are temporary overwrides for settings. The changes are not saved into the EEPROM and take immediate effect (no rebooting required). False value specifies the changes are permanently overwrides for settings And also saved into the EEPROM. The changes will keep after rebooting the device.
 @param frequencyList Specifies the channel of hopping frequency for reading tag data.
 */
-(void)setFrequency:(BOOL) isTemp List:(NSArray*) frequencyList;

/**
 Get the InventoryRoundInterval.
 
 @param isTemp True value specifies the changes are temporary overwrides for settings. The changes are not saved into the EEPROM and take immediate effect (no rebooting required). False value specifies the changes are permanently overwrides for settings And also saved into the EEPROM. The changes will keep after rebooting the device.
 */
-(void)getInventoryRoundInterval:(BOOL)isTemp;

/**
 Set the InventoryRoundInterval.
 
 @param isTemp True value specifies the changes are temporary overwrides for settings. The changes are not saved into the EEPROM and take immediate effect (no rebooting required). False value specifies the changes are permanently overwrides for settings And also saved into the EEPROM. The changes will keep after rebooting the device.
 @param tenMilliSeconds The period to start an inventory round. Range: 0~254*10s. 255 represent 0;
 */
-(void)setInventoryRoundInterval:(BOOL)isTemp InventoryRoundInterval:(int)tenMilliSeconds;

/**
 Gets the link frequency of tag backscatter (tag to reader).
 
 @param isTemp True value specifies the changes are temporary overwrides for settings. The changes are not saved into the EEPROM and take immediate effect (no rebooting required). False value specifies the changes are permanently overwrides for settings And also saved into the EEPROM. The changes will keep after rebooting the device.
 */
-(void)getLinkFrequency:(BOOL)isTemp;

/**
 Sets the link frequency of tag backscatter (tag to reader).
 
 @param isTemp True value specifies the changes are temporary overwrides for settings. The changes are not saved into the EEPROM and take immediate effect (no rebooting required). False value specifies the changes are permanently overwrides for settings And also saved into the EEPROM. The changes will keep after rebooting the device.
 @param linkFrequency The link frequency in KHz.
 */
-(void)setLinkFrequency:(BOOL)isTemp LinkFrequency:(LinkFrequency) linkFrequency;

/**
 Get the frequency profile of the device.
 
 @param isTemp True value specifies the changes are temporary overwrides for settings. The changes are not saved into the EEPROM and take immediate effect (no rebooting required). False value specifies the changes are permanently overwrides for settings And also saved into the EEPROM. The changes will keep after rebooting the device.
 */
-(void)getProfile:(BOOL)isTemp;

/**
 Set the frequency profile of the device.
 
 @param isTemp True value specifies the changes are temporary overwrides for settings. The changes are not saved into the EEPROM and take immediate effect (no rebooting required). False value specifies the changes are permanently overwrides for settings And also saved into the EEPROM. The changes will keep after rebooting the device.
 @param profile Specifies the RF input sensitivity level.
 */
-(void)setProfile:(BOOL)isTemp Profile:(Profile) profile;

/**
 Get Q Value.
 Gets the starting Q value for the number of slots in the round.
 
 @param isTemp True value specifies the changes are temporary overwrides for settings. The changes are not saved into the EEPROM and take immediate effect (no rebooting required). False value specifies the changes are permanently overwrides for settings And also saved into the EEPROM. The changes will keep after rebooting the device.
 */
-(void)getQValue:(BOOL) isTemp;

/**
 Set Q Value.
 Sets the starting Q value for the number of slots in the round.
 
 @param isTemp  True value specifies the changes are temporary overwrides for settings. The changes are not saved into the EEPROM and take immediate effect (no rebooting required). False value specifies the changes are permanently overwrides for settings And also saved into the EEPROM. The changes will keep after rebooting the device.
 @param qvalue The starting Q value for the number of slots in the round. The value ranges from 0 to 15.
 */
-(void)setQValue:(BOOL) isTemp QValue:(Byte) qvalue;

/**
 Read the RF power of remote device.
 
 @param isTemp  True value specifies the changes are temporary overwrides for settings. The changes are not saved into the EEPROM and take immediate effect (no rebooting required). False value specifies the changes are permanently overwrides for settings And also saved into the EEPROM. The changes will keep after rebooting the device.
 */
-(void)getRfPower:(BOOL)isTemp;

/**
 Set the RF Power of remote device.
 
 @param isTemp True value specifies the changes are temporary overwrides for settings. The changes are not saved into the EEPROM and take immediate effect (no rebooting required). False value specifies the changes are permanently overwrides for settings And also saved into the EEPROM. The changes will keep after rebooting the device.
 @param rfPower Specifies the RF Power strength. The value is ranging from 1 to 27. The default value is 11. (Range:1~27)
 */
-(void)setRfPower:(BOOL)isTemp RFPower:(Byte) rfPower;

/**
 Get the RX RF input sensitivity level.
 
 @param isTemp True value specifies the changes are temporary overwrides for settings. The changes are not saved into the EEPROM and take immediate effect (no rebooting required). False value specifies the changes are permanently overwrides for settings And also saved into the EEPROM. The changes will keep after rebooting the device.
 */
-(void)getRfSensitivity:(BOOL)isTemp;

/**
 Define the RX RF input sensitivity level.
 
 @param isTemp Write the sensitivity value to RAM or not. It the value is true, the sensitivity value will be write to RAM.
 @param sensitivity Specifies the RF input sensitivity level.
 */
-(void)setRfSensitivity:(BOOL)isTemp RfSensitivityLevel:(RfSensitivityLevel) sensitivity;

/**
 Gets the encoding of backscattered data (tag to reader).
 Tags shall encode the backscattered data as either FM0 baseband or Miller modulation of a subcarrier at the data rate.
 
 @param isTemp True value specifies the changes are temporary overwrides for settings. The changes are not saved into the EEPROM and take immediate effect (no rebooting required). False value specifies the changes are permanently overwrides for settings And also saved into the EEPROM. The changes will keep after rebooting the device.
 */
-(void)getRxDecode:(BOOL)isTemp;

/**
 Sets the encoding of backscattered data (tag to reader).
 Tags shall encode the backscattered data as either FM0 baseband or Miller modulation of a subcarrier at the data rate.
 @param isTemp True value specifies the changes are temporary overwrides for settings. The changes are not saved into the EEPROM and take immediate effect (no rebooting required). False value specifies the changes are permanently overwrides for settings And also saved into the EEPROM. The changes will keep after rebooting the device.
 @param rxDecodeType Specifies the encoding of backscattered data (tag to reader).
 */
-(void)setRxDecode:(BOOL)isTemp RxDecodeType:(RxDecodeType) rxDecodeType;

/**
 Get Session & Target
 Gets the session flag used for inventory round.
 Gets the target for inventory round.
 
 @param isTemp True value specifies the changes are temporary overwrides for settings. The changes are not saved into the EEPROM and take immediate effect (no rebooting required). False value specifies the changes are permanently overwrides for settings And also saved into the EEPROM. The changes will keep after rebooting the device.
 */
-(void)getSessionAndTarget:(BOOL) isTemp;

/**
 Set Session & Target
 Sets the target for inventory round.
 Sets the session flag used for inventory round.
 
 @param isTemp True value specifies the changes are temporary overwrides for settings. The changes are not saved into the EEPROM and take immediate effect (no rebooting required). False value specifies the changes are permanently overwrides for settings And also saved into the EEPROM. The changes will keep after rebooting the device.
 @param target Target indicates whether the Select modifies a Tag’s SL flag or its inventoried flag.
 @param session The session flag to be selected for an inventory round.
 */
-(void)setSessionAndTarget:(BOOL) isTemp Session:(Session) session Target:(Target)target;

/**
 Get the threshold to raise a TagRemovedEvent(IUHFDeviceListener.didTagRemoved).
 
 @param isTemp True value specifies the changes are temporary overwrides for settings. The changes are not saved into the EEPROM and take immediate effect (no rebooting required). False value specifies the changes are permanently overwrides for settings And also saved into the EEPROM. The changes will keep after rebooting the device.
 */
-(void)getTagRemovedThreshold:(BOOL)isTemp;

/**
 Set the threshold to raise a TagRemovedEvent(IUHFDeviceListener.didTagRemoved).
 
 @param isTemp True value specifies the changes are temporary overwrides for settings. The changes are not saved into the EEPROM and take immediate effect (no rebooting required). False value specifies the changes are permanently overwrides for settings And also saved into the EEPROM. The changes will keep after rebooting the device.
 @param round The count of missing discovering tag threshold of inventory rounds.
 */
-(void)setTagRemovedThreshold:(BOOL)isTemp Round:(int)round;

#pragma mark - Unknown API

-(void)cmdSet:(BOOL)isTemp BuzzerOperationMode:(BuzzerOperationMode) bom;
-(void)cmdSet:(BOOL)isTemp InventoryRoundInterval:(int)tenMilliSeconds;

-(void)cmdGetThenSetSpecialSetting:(BOOL)isTemp Address:(char)iAddr ReadLen:(char)readLen DataSet:(NSMutableSet *)dataSet CMDCode:(SoftwareAPINameCode)apiCode;

-(void)markGetThenSetEEPROMCMDtoSendbyData:(BOOL)isTemp Address:(char)iAddr ReadLen:(char)readLen DataSet:(NSMutableSet *)dataSet CMDCode:(SoftwareAPINameCode)apiCode;

/**
 for TS100
 */

-(void)UM800LdidGeneralERROR:(SoftwareAPINameCode)apiCode ErrMessage:(NSString*)strErrorMessage;

-(void)markGetEEPROMCMDtoSendbyData:(BOOL)isTemp Address:(char)iAddr ReadLen:(char)readLen CMDCode:(SoftwareAPINameCode)apiCode;

-(void)markSetEEPROMCMDtoSendbyData:(BOOL)isTemp Address:(char)iAddr Value:(NSData*)val CMDCode:(SoftwareAPINameCode)apiCode;

-(void)markGNPSingleAckCMDtoSend:(NSData*)cmdData CMDCode:(SoftwareAPINameCode)apiCode CMDCount:(int)cmdCount;

-(void)markGNPSingleAckCMDtoSend:(NSData*)cmdData CMDCode:(SoftwareAPINameCode)apiCode CMDCount:(int)cmdCount DataSet:(nullable NSMutableSet *) dataSet;

-(void)addGNPSingleAckCMDtoSend:(NSData*)cmdData CMDCode:(SoftwareAPINameCode)apiCode;

-(void)cmdWriteEPC:(NSString*)hexSelectedPcEpc PWD:(NSString*)hexAccessPassword EPCData:(NSData*)epcData;

- (NSData *) getPcEpc:(NSData *) epcData;

-(void)cmdGetSpecialSetting:(BOOL)isTemp TwoByteAddress:(int)iAddr ReadLen:(char)readLen CMDCode:(int)apiCode;

-(void)cmdSetSpecialSetting:(BOOL)isTemp TwoByteAddress:(int)iAddr Value:(NSData*)val CMDCode:(SoftwareAPINameCode)apiCode;

-(void)markSetEEPROMCMDtoSendbyData:(BOOL)isTemp TwoByteAddress:(int)iAddr Value:(NSData*)val CMDCode:(SoftwareAPINameCode)apiCode;

-(void)markSetEEPROMCMDtoSendbyDataForInventoryActiveMode:(BOOL)isTemp Address:(char)iAddr Value:(NSData*)val CMDCode:(SoftwareAPINameCode)apiCode;

@end

NS_ASSUME_NONNULL_END
