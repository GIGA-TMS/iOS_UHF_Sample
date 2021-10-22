//
//  GTBaseDevInfo.h
//  GIGATMSSDK
//
//  Created by Gianni on 2019/3/21.
//  Copyright © 2019 Gianni. All rights reserved.
//

#import "GTCommonHeader.h"
#import <Foundation/Foundation.h>
#import "GTWifiInfo.h"
#import "GTBLEDevInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface GTBaseDevInfo : NSObject

@property (nonatomic,assign) GTClassCode classCode;
@property (nonatomic,assign) Byte classVer;
@property (nonatomic,assign) GTConnectType connectType;
@property (nonatomic,strong,nullable) NSString* productName;
@property (nonatomic,strong,nullable) NSString* devName;
@property (nonatomic,strong,nullable) NSString* password;

@property (nonatomic,strong,nullable) NSString* devUidInfo;

@property (nonatomic,strong,nullable) NSString* strConnStauts;
@property (nonatomic,assign) GTDevConnStatus currentConnStatus;

@property (nonatomic,strong,nullable) NSString* devROMVersion;


@property (nonatomic,strong,nullable) GTBLEDevInfo* _bleDevInfo;
@property (nonatomic,strong,nullable) GTWifiInfo* _wifiInfo;

-(instancetype)init:(GTClassCode) nClassCode ClassVer:(Byte)nClassVer ConnType:(GTConnectType) nConnectType BLEDevInfo:(GTBLEDevInfo* __nullable) nBLEDevInfo WifiInfo:(GTWifiInfo* __nullable) nWiFiInfo;
-(instancetype)initWithWiFi:(GTClassCode)nClassCode ClassVer:(Byte)nClassVer ConnType:(GTConnectType) nConnectType WiFiInfo:(GTWifiInfo*) nWifiInfo;
-(instancetype)initWithBLE:(GTClassCode)nClassCode ClassVer:(Byte)nClassVer BLEDevInfo:(GTBLEDevInfo*) nBLEInfo;
-(BOOL)isEqualToDev:(NSString*)identifierInfo;
-(void)updateConnStautes:(GTDevConnStatus)status;
-(GTClassCode)changeClassCode:(GTClassCode)classCode;
-(Byte)changeClassVer:(Byte)classVer;
@end

NS_ASSUME_NONNULL_END
