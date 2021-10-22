//
//  UHFScanner.h
//  UHFSDK
//
//  Created by Gianni on 2019/3/19.
//  Maintained by Wade on 2021/3/24.
//  Copyright © 2019 Gianni. All rights reserved.
//

#import "BaseScanner.h"
#import "UHFDevice.h"

NS_ASSUME_NONNULL_BEGIN
@class UHFScanner;

@protocol UHFScannerCallback <NSObject>
@optional
-(void)didScanStop;
-(void)didDiscoverDevice:(BaseDevice*)dev;
-(void)didError:(NSString*)strError;
@end

@protocol UHFScannerDebugCallback <NSObject>
@optional
-(void)didDebugWriteRawData:(NSData *)data channel:(NSString *)channelID;
-(void)didDebugReadRawData:(NSData *)data channel:(NSString *)channelID;
@end

/**
 UHFScanner scans for UHF devices
 */
@interface UHFScanner : BaseScanner
@property (nonatomic, assign) id<UHFScannerCallback> mUHFScannerCallback;
@property (nonatomic, assign) id<UHFScannerDebugCallback> mUHFScannerDebugCallback;
-(instancetype)init:(id<UHFScannerCallback>)callback ClassVer:(ClassVer)nClassVer;
-(void)changeClassVer:(Byte)classVer;
/**
 Start to scan for devices.
 */
-(void)startScanDevice;

@end

NS_ASSUME_NONNULL_END
