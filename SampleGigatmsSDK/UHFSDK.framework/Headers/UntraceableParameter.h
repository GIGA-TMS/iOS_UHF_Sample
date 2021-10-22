//
//  UntraceableParameter.h
//  UHFSDK
//
//  Created by JangJack on 2020/10/24.
//  Copyright © 2020 Gianni. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TagAccessParameter.h"

typedef NS_ENUM(Byte, Untraceable_FlagU) {
    FlagU_DEASSERT_U = 0x00,
    FlagU_ASSERT_U   = 0x01,
};

typedef NS_ENUM(Byte, Untraceable_EPC) {
    EPC_SHOW = 0x00,
    EPC_HIDE = 0x01,
};

typedef NS_ENUM(Byte, Untraceable_TID) {
    TID_SHOW       = 0x00,
    TID_HIDE_SHOME = 0x01,
    TID_HIDE_ALL   = 0x02,
};

typedef NS_ENUM(Byte, Untraceable_User) {
    User_VIEW = 0x00,
    User_HIDE = 0x01,
};

typedef NS_ENUM(Byte, Untraceable_Range) {
    Range_NORMAL             = 0x00,
    Range_TOGGLE_TEMPORARILY = 0x01,
    Range_REDUCE             = 0x02,
};

NS_ASSUME_NONNULL_BEGIN

@interface UntraceableParameter : TagAccessParameter

-(instancetype) initWithAccessPassword:(NSString *) accessPassword;
-(void) assignFlagU:(Untraceable_FlagU) flagU;
-(void) assignEPC:(Untraceable_EPC) epc;
-(void) assignTID:(Untraceable_TID) tid;
-(void) assignUser:(Untraceable_User) user;
-(void) assignRange:(Untraceable_Range) range;
-(void) assignEpcLength:(int) length;
-(NSData *) toBytes;

@end

NS_ASSUME_NONNULL_END
