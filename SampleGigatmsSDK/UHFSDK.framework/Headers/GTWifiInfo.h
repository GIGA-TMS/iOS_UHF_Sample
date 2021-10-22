//
//  GTWifiInfo.h
//  GIGATMSSDK
//
//  Created by Gianni on 2019/3/21.
//  Copyright © 2019 Gianni. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GTWifiInfo : NSObject

@property (nonatomic,strong) NSString* ip;
@property (nonatomic,strong) NSString* port;

@property (nonatomic,strong) NSString* devMacAddr;
@property (nonatomic,strong) NSString* devName;
@property (nonatomic,strong) NSString* devVersion;
-(instancetype)init:(NSString*)nIP Port:(NSString*)nPort;
-(instancetype)init:(NSString*)nIP Port:(NSString*)nPort devMacAddr:(NSString*) devMacAddr Name:(NSString*) devName DevVer:(NSString*) devVersion;
@end

NS_ASSUME_NONNULL_END
