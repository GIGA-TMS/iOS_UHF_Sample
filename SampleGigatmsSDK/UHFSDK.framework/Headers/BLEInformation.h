//
//  BLEInformation.h
//  UHFSDK
//
//  Created by WadeGigatms on 2023/6/14.
//  Copyright © 2023 Gianni. All rights reserved.
//t

#ifndef BLEInformation_h
#define BLEInformation_h

typedef NS_ENUM(Byte, BLEServiceMode){
    BLE_Serial = 0x31,
    BLE_Keyboard = 0x32,
};

typedef NS_ENUM(Byte, BLEMode){
    BLE_OFF = 0x30,
    BLE_Server = 0x31
};

typedef NS_ENUM(Byte, TXPower){
    _minus_12_dBm = 0x00,
    _minus_9_dBm = 0x01,
    _minus_6_dBm = 0x02,
    _minus_3_dBm = 0x03,
    _0_dBm = 0x04,
    _3_dBm = 0x05,
    _6_dBm = 0x06,
    _9_dBm = 0x07,
};

@interface BLEInformation : NSObject

-(instancetype)init:(NSData*)data;

@property(nonatomic,assign) NSString* macAddress;
@property(nonatomic,assign) BLEMode bleMode;
@property(nonatomic,copy) NSString* deviceName;
@property(nonatomic,assign) NSString* manufacturerId;
@property(nonatomic,assign) BLEServiceMode serviceMode;
@property(nonatomic,assign) TXPower txPower;
@property(nonatomic,assign) BOOL connectStatus;

@end

#endif /* BLEInformation_h */
