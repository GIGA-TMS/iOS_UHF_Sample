//
//  GNetPlus.h
//  UHFSDK
//
//  Created by Gianni on 2019/3/25.
//  Copyright © 2019 Gianni. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IUM800LListener.h"
#import "GNPTagInfo.h"
#import "GNPDecodedTagData.h"
//#import "UHF/InetSocketAddress.h"
#import <UHFSDK/TagAccessParameter.h>
NS_ASSUME_NONNULL_BEGIN

@interface GNetPlus : NSObject

typedef NS_ENUM(Byte, GNetPlusCmdCode){
    
    GNP_QueryFirmwareVersion    = 0x010,
    GNP_SelectActiveMode        = 0x012,
    GNP_WriteSetting            = 0x022,
    GNP_ReadSetting             = 0x024,
    GNP_39_WriteMemBank         = 0x039,
    GNP_3B_ReadMemBank          = 0x03B,
    GNP_61_LockTag              = 0x061,
    GNP_63_KillTag              = 0x063,
    GNP_80_WriteTag             = 0x080,
    GNP_81_ReadTag              = 0x081,
    GNP_B0_ControlBuzzer        = 0x0B0,
    GNP_DeviceControl           = 0x0DC,
    GNP_DeviceData              = 0x0DD,
    GNP_EA_ExtraCMD             = 0x0EA,
    
    GNP_71_ProtectTagPrivacy    = 0x071,
};

typedef NS_ENUM(Byte, ExtraCommandOverloaded) {
    EC_WiFiMacAddress ,
};


typedef NS_ENUM(Byte, GNPReplyCmdCode){
    
    GNP_RC_SUCCEED      = 0x06,
    GNP_RC_Event        = 0x11,
    GNP_RC_FAIL         = 0x15
};

typedef NS_ENUM(Byte, GNPEventType){
    ET_43_TagCountChanged       = 0x43,
    ET_44_InputGPIOStateChanged = 0x44,
    ET_49_TagPresented          = 0x49,
    ET_52_TagRemoved            = 0x52,
    ET_53_SensorStateChanged    = 0x53,
    ET_62_NEW_TAG_EX            = 0x62,
};


typedef struct _GNPET_43_CountInfo
{
    int countType;
    short foundTags;
    short maxAntenns;
} SGNPET_43_CountInfo, *LPSGNPET_43_CountInfo;

typedef struct _GNPET_44_DevState
{
    int SourceID;
    int Length;
    int RFU;
    short Mask;
    short Status;
} SGNPET_44_DevState, *LPSGNPET_44_DevState;

typedef struct _GNPET_53_SenorState
{
    int SenorID;
    short Status;
} SGNPET_53_SenorState, *LPSGNPET_53_SenorState;



typedef NS_ENUM(Byte, _EEPROM_Address){
    _EPR_Addr_RF_POWER                      = 0x00,
    _EPR_Addr_RF_SENSITIVITY                = 0x01,
    _EPR_Addr_RX_DECODE                     = 0x02,
    _EPR_Addr_SESSION_AND_TARGET            = 0x03,
    _EPR_Addr_LINK_FREQUENCY                = 0x04,
    _EPR_Addr_TRIGGER_SOURCE_A              = 0x05,
    _EPR_Addr_TRIGGER_SOURCE_B              = 0x06,
    _EPR_Addr_EPC_TREXT                     = 0x07,
    _EPR_Addr_EPC_Q_BEGIN                   = 0x08,
    //
    _EPR_Addr_VIBRATOR                      = 0x09,
    
    _EPR_Addr_BuzzerOperationMode           = 0x0A,
    _EPR_Addr_FieldSeparator                = 0x0B,
    _EPR_Addr_B2E_Parameter                 = 0x0C,
    _EPR_Addr_DeviceEventMask               = 0x0D,
    
    _EPR_Addr_EVENT_TYPE                    = 0x0E,
    _EPR_Addr_MODEL_NUMBER                  = 0x0F,
    _EPR_Addr_BAUDRATE                      = 0x10,
    _EPR_Addr_ADDRESS                       = 0x11,
    _EPR_Addr_ACTIVE_MODE                   = 0x12,
    _EPR_Addr_TIME_TO_REMOVE                = 0x13,
    _EPR_Addr_REPEAT_INTERVAL               = 0x14,
    _EPR_Addr_InventoryRoundInterval        = 0x15,
    _EPR_Addr_INTERFACE                     = 0x16,
    _EPR_Addr_DECODE                        = 0x17,
    _EPR_Addr_READ_EPC_FORMAT               = 0x18,
    
    _EPR_Addr_19_ScanMode                   = 0x19,
    _EPR_Addr_SCAN_TIMEOUT_LOW              = 0x1A,                 //SCAN_Timeout由 2個 byte組成
    _EPR_Addr_SCAN_TIMEOUT_HIGH             = 0x1D,
    _EPR_Addr_PROFILE_ID                    = 0x1E,
    _EPR_Addr_NUMBER_OF_FREQUENCY           = 0x1F,
    _EPR_Addr_LISTEN_TIME_BYTE_HIGH         = 0x20,             //Listening_Time由 2個 byte組成
    _EPR_Addr_LISTEN_TIME_BYTE_LOW          = 0x21,
    _EPR_Addr_ALLOCATION_TIME_BYTE_HIGH     = 0x22,       //Allocation_Time由 2個 byte組成
    _EPR_Addr_ALLOCATION_TIME_BYTE_LOW      = 0x23,
    _EPR_Addr_IDLE_TIME_BYTE_HIGH           = 0x24,               //Idle_Time由 2個 byte組成
    _EPR_Addr_IDLE_TIME_BYTE_LOW            = 0x25,
    _EPR_Addr_RSSI_THRESHOLD                = 0x27,
    _EPR_Addr_FREQUENCY_START_ADDRESS       = 0x28,
    
    _EPR_Addr_DEACTIVATE_PEC_PREFIX_BYTE_HIGH = 0xFA,       //Deactivate EPC Prefix 由 2個 byte組成
    _EPR_Addr_DEACTIVATE_EPC_PREFIX_BYTE_LOW  = 0xFB,
    _EPR_Addr_REACTIVATE_PEC_PREFIX_BYTE_HIGH = 0xFC,       //Reactivate EPC Prefix 由 2個 byte組成
    _EPR_Addr_REACTIVATE_EPC_PREFIX_BYTE_LOW  = 0xFD,
    _EPR_Addr_TRANSFORM_EPC_PREFIX            = 0xFE,
    
};

typedef NS_ENUM(int, _TWO_BYTES_EEPROM_Address){

    _EPR_Addr_DEACTIVATE_PEC_PREFIX_BYTE = 0xFAFB,
    _EPR_Addr_PREFIX                     = 0x0100,
    _EPR_Addr_SUFFIX                     = 0x0110,
};

typedef NS_ENUM(Byte, _19_ScanMode){
    _19_TRIGGER_A_LEVEL_CONTROL     = 0x00,
    _19_ALWAYS_SCAN                 = 0xFF
};


//數值是自爽定義的
typedef NS_ENUM(Byte, _DC_CTRL_TABLE){
    _DC_CTRL_Trigger             = 0x00,
    _DC_CTRL_SoftwareTrigger     = 0x01,
    _DC_CTRL_SetIOPIN            = 0x02,
    _DC_CTRL_GetIOPIN            = 0x03,
};



typedef NS_ENUM(Byte, FrequencyID){
    EUROPE          = 0x01,
    JAPAN_952400    = 0x02,
    USA             = 0x03,
    CHINA920625     = 0x04,
    CHINA840125     = 0x05,
    KOREA           = 0x06,
    TAIWAN          = 0x07,
    BRAZIL          = 0x08,
    URUGUAY         = 0x09,
    ISRAEL          = 0x0A,
    JAPAN916800     = 0x0B,
    JAPAN920400     = 0x0C,
    USER_DEFINE     = 0xFE,
    DEFAULT         = 0xFF
};




typedef NS_ENUM(Byte, _3B_MemBankCode){
    
    MB_Reserve          = 0x00,
    MB_EPC              = 0x01,
    MB_TID              = 0x02,
    MB_UserMemory       = 0x03,
    /**
     * The "Kill Password" part of reserve bank (For Lock command only)
     */
    MB_KILL_PASSWORD =  0x04,
    /**
     * The "Access Password" part of reserve bank(For Lock command only)
     */
    MB_ACCESS_PASSWORD = 0x05,
};




typedef struct _GNetPlusResult
{
    int address;
    int cmdCode;
    int parameterLength;
    
    union {
        unsigned char* _10_getFWInfo;
        int _12_ActiveMode;
        int _22_19_ScanMode;
        int _24_19_ScanMode;
        unsigned char* _EA_macAddress;
        unsigned char* _DD_remoteHost;
    };
} SHACMDGNETPLUSRESULT, *LPSHACMDGNETPLUSRESULT;

//typedef struct _GTLockInfos
//{
//    _3B_MemBankCode memBank_R;
//    LockAction action;
//} SLockInfos, *LPLockInfos;

@property (nonatomic, assign) id<IUM800LListener> UM800LListener;
-(instancetype)init:(id<IUM800LListener>)listener;
-(NSData*)hcmdQueryFirmwareVersion;

-(NSData*)hcmdControlBuzzer:(Byte)buzzerCtrl;
-(NSData*)hcmdSelectActiveMode:(char)mode;
-(NSData*)hcmdSelectActiveMode:(char)mode EventType:(char)eventType;
-(NSData*)hcmdWriteSetting:(BOOL)isTemp Address:(char)iAddr Value:(NSData*)val;

-(NSData*)hcmdReadSetting:(BOOL)isTemp Address:(char)iAddr ReadLen:(char)readLen;
-(NSData*)hcmdReadSetting:(BOOL)isTemp Address:(char)iAddr ReadLen:(char)readLen DataSet:(nullable NSMutableSet *) dataSet;

-(NSData*)hcmdWriteMemBankPWD:(NSData*)dataPWD MemBankCode:(_3B_MemBankCode)bmCode writeData:(NSData*)data;
-(NSData*)hcmdWriteMemBankPWD:(NSData*)dataPWD MemBankCode:(_3B_MemBankCode)bmCode OffSet:(NSData *)dataOffSet writeData:(NSData*)data;
-(NSData*)hcmdWriteMemBankEPC:(NSData*)dataEPC PWD:(NSData*)dataPWD MemBankCode:(_3B_MemBankCode)bmCode OffSet:(NSData *)dataOffSet writeData:(NSData*)data;
//-(NSData*)hcmdWriteMemBank:(_3B_MemBankCode)bmCode writeData:(NSData*)data;
-(NSData*)hcmdReadMemBank:(_3B_MemBankCode)bmCode;
-(NSData*)hcmdReadMemBank:(BOOL)isAnyTag PWD:(NSData*)pwd MemBankCode:(char)bmCode OffSet:(NSData*)offset ReadLen:(NSData*)readLen;
-(NSData*)hcmdReadMemBank8:(NSData*)hexSelectedPcEpc PWD:(NSData*)pwd MemBankCode:(char)bmCode OffSet:(NSData*)offset ReadLen:(NSData*)readLen;
-(NSData*)hcmdDeviceControl:(NSData*)parameterData;
-(NSData*)hcmdTriggerSourceControl:(Byte)ctrlCodeValue;
-(NSData*)hcmdSoftwareTriggerControl:(BOOL)enable;
-(NSData*)hcmdSetIOState:(char)PIN Output:(BOOL)output;
-(NSData*)hcmdSetIOState:(NSDictionary *) gpioIOStates;
-(NSData*)hcmdGetIOState;
-(NSData*)hcmdLockTag:(NSData*)dataPWD LockInfos:(NSMutableArray*)lockInfos;
-(NSData*)hcmdLockTag:(nullable NSString*)accessPassword SelectedPcEpc:(nullable NSString *)selectedPcEpc LockInfos:(NSMutableArray*)lockInfos;
-(NSData*)hcmdKillTag:(nullable NSString*)accessPassword KillPWD:(nullable NSString*)killPWD;
-(NSData*)hcmdExtra:(NSString*)strCMDData;
-(NSData*)hcmdDeviceData:(Byte)action Index:(Byte)index;
-(NSData*)hcmdDeviceData:(Byte)action Index:(Byte)index ConnectTimeout:(int) connectTimeout InetSocketAddress:(InetSocketAddress *) inetSocketAddress;
-(NSData*)hcmdDeviceData:(Byte)action Index:(Byte)index Data:(NSData *) data;
//-(NSData*)hcmdReadTagEx:(NSData* __nullable)readPwd;
-(NSString*) getErrorMessage:(int) errorCode;
-(BOOL)parseRecvGNetPlusData:(int)read_length data:(NSData*)val dataOut:(NSValue*)valOut;
- (BOOL)parseRecvGNetPlusEventData:(int)read_length data:(NSData*)val dataOut:(NSValue*)valOut;
-(void)setSingleAckCMDCode:(Byte)cmdCode EEPAddr:(Byte)eAddr SWAPICode:(Byte)apiCode;

-(NSData*)hcmdExtra:(NSString*)strCMDData ExtraCommandOverloaded:(ExtraCommandOverloaded) extraCommandOverloaded;
-(NSData*)hcmdWriteTag:(NSData*)xepcLentT EpcData:(NSData*)ecpData;
-(NSData*)hcmdWriteEpc:(NSData*)writeData;
-(NSData*)hcmdWriteTagEx:(NSData*)writeData;
-(NSData*)hcmdReadTagEx:(NSData*)writeData;

-(NSData*)hcmdReadSetting:(BOOL)isTemp TwoByteAddress:(int)iAddr ReadLen:(char)readLen;
-(NSData*)hcmdWriteSetting:(BOOL)isTemp TwoByteAddress:(int)iAddr Value:(NSData*)val;
-(NSData*)hcmdGetCommandTriggerState;
-(NSData*)hcmdSetCommandTriggerState:(NSDictionary *) states;
-(NSData*)hcmdExtra:(int)extraCode CommandType:(int) commandType Command:(int) command;
-(NSData*)hcmdExtra:(int)extraCode CommandType:(int) commandType Command:(int) command Parameter:(NSData*) parameter;
-(NSData*)hcmdExtra:(int)extraCode CommandType:(int) commandType Command:(int) command mask:(int)mask;
-(NSData*)hcmdDirectIO:(int) command Data:(NSData *) data;

-(NSData*)hcmdWriteSettingForInventoryActiveMode:(BOOL)isTemp Address:(char)iAddr Value:(NSData*)val;
-(NSData*)hcmdProtectTagPrivacy:(TagAccessParameter*)tagAccessParameter;

-(NSArray *)getCurrentInfo;
-(Byte) getCurrentCMDCode;
-(SoftwareAPINameCode) getCurrentApiCode;

@end

NS_ASSUME_NONNULL_END
