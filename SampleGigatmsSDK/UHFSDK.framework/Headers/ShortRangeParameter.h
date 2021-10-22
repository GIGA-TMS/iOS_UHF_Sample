//
//  ShortRangeParameter.h
//  UHFSDK
//
//  Created by JangJack on 2020/10/24.
//  Copyright © 2020 Gianni. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TagAccessParameter.h"

typedef NS_ENUM(Byte, ShortRange_ShortRangeType) {
    NORMAL_RANGE = 0x00,
    SHORT_RANGE  = 0x01,
};

NS_ASSUME_NONNULL_BEGIN

@interface ShortRangeParameter : TagAccessParameter

-(instancetype) initWithAccessPassword:(NSString *) accessPassword;
-(void) assignShortRangeType:(ShortRange_ShortRangeType) shortRangeType;
-(NSData *) toBytes;

@end

NS_ASSUME_NONNULL_END
