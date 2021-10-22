//
//  GTDeviceManager.h
//  GIGATMSSDK
//
//  Created by Gianni on 2019/4/8.
//  Copyright © 2019 Gianni. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseDevice.h"
NS_ASSUME_NONNULL_BEGIN

@interface GTDeviceManager : NSObject
+ (GTDeviceManager*)sharedDeviceManager;

-(NSArray*)listDevices;
-(BaseDevice*)addDevice:(GTBaseDevInfo*)device;

-(void)removeAllDevice;
-(BOOL)removeDeviceWithUID:(NSString*)uid;
-(BOOL)removeDeviceWithUID:(NSString*)uid aid:(int)aid;

-(BOOL)isDeviceWithUid:(NSString*)uid;
@end

NS_ASSUME_NONNULL_END
