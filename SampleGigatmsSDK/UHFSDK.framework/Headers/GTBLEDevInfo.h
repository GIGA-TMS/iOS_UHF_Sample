//
//  GTBLEDevInfo.h
//  LoginReaderSDK
//
//  Created by Gianni on 2019/3/18.
//  Copyright © 2019 Gianni. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "GTBLEScanInfo.h"
NS_ASSUME_NONNULL_BEGIN

@interface GTBLEDevInfo : NSObject
@property (nonatomic,strong) GTBLEScanInfo *mGTBLEScanInfo;
@property (nonatomic,strong,nullable) CBPeripheral* mPeripheral;
@property (nonatomic,strong,nullable) NSString *mLocalName;
@property (nonatomic,assign) NSInteger mRssi;
@property (nonatomic,strong,nullable) NSString* devROMVersion;

-(instancetype)init:(CBPeripheral* __nullable) peripheral devName:(NSString * __nullable)localName rssi:(NSInteger) rssi GTBLEScanInfo:(GTBLEScanInfo *)gtBLEScanInfo;
@end

NS_ASSUME_NONNULL_END
