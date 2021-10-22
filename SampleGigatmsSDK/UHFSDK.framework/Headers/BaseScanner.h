//
//  BaseScanner.h
//  GIGATMSSDK
//
//  Created by Gianni on 2019/1/28.
//  Maintained by Wade on 2021/3/24.
//  Copyright © 2019 Gianni. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTCommonHeader.h"
#import "GTBLEDevInfo.h"
#import "GTBLEScanInfo.h"
#import "GTBaseDevInfo.h"

@class BaseScanner;

@interface BaseScanner : NSObject
{
}
@property (nonatomic, assign) GTConnectType mConnectType;
-(instancetype)init:(GTBaseDevInfo*) baseDevInfo;
-(instancetype)initByUDP:(int) port;
-(instancetype)initByBLE:(GTBLEScanInfo*)bleInfo;
-(void)changeConnectType:(GTConnectType)connType;
-(void)sendCMD:(NSData*) cmdData;
-(void)didCompleteUDPReadData:(int)read_length data:(NSData*)data channel:(NSString*)channelID;
-(void)didCompleteUDPWriteData:(int)write_length data:(NSData*)data;
/**
 Start to scan for devices.
 */
-(void)startScanDevice;
/**
 Set timeout and scan for UHF device through this timeout.
 
 @param time The timeout.
 */
-(void)setScanTime:(double)time;
/**
 Stop scanning for UHF devices.
 */
-(void)stopScan;
-(void)didBaseDiscoverBLEDevice:(GTBLEDevInfo *)dev data:(NSData* )data;
-(void)didBaseScanStop;

@end

