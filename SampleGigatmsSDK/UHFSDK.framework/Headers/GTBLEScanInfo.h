//
//  GTBLEScanInfo.h
//  UHFSDK
//
//  Created by Gianni on 2019/3/19.
//  Copyright © 2019 Gianni. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN

@interface GTBLEScanInfo : NSObject
@property (nonatomic,strong) NSArray<CBUUID *>* mServiceUUIDs;
@property (nonatomic,strong) NSArray<CBUUID *>* mRecieveUUIDs;
@property (nonatomic,strong) NSArray<CBUUID *>* mSendUUIDs;
@property (nonatomic,strong) NSData* mManufacturerData;
- (instancetype)init:(NSArray<CBUUID *> *) serviceUUIDs RecieveUUIDs:(NSArray<CBUUID *> *)recieveUUIDs SendUUIDs:(NSArray<CBUUID *> *)sendUUIDs;
- (instancetype)init:(NSArray<CBUUID *> *) serviceUUIDs RecieveUUIDs:(NSArray<CBUUID *> *)recieveUUIDs SendUUIDs:(NSArray<CBUUID *> *)sendUUIDs Manufacturer:(NSData*) mManufacturerData;
@end

NS_ASSUME_NONNULL_END
