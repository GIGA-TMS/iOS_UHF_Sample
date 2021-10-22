//
//  Glog.h
//  GIGATMSSDK
//
//  Created by Gianni on 2018/5/3.
//  Copyright © 2018年 Gianni. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG
#define GLog(x, fmt, ...) if ((x)) { NSLog(@"[T:%d] %s [L:%d] " fmt, [NSThread currentThread].isMainThread, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__); }
#else
#define GLog(x, fmt, ...)
#endif


@interface GLog : NSObject

+(void)D:(NSString*) message;
+(void)D:(NSString*) title  Msn:(NSString*) message;
+(void)byNSData:(NSString*) title data:(NSData *) cmdData;
+(void)byChar:(NSString*) title dataSrc:(const char*) pBuff;
+(void)byChar:(NSString*) title dataSrc:(const char*) pBuff Len:(int)length;
+(void)Glog:(NSData *) cmdData;

+(NSString*)CreateHexStringWithData:(NSData*)data;
+(NSData *) CreateDataWithHexString:(NSString *)inputString;

@end
