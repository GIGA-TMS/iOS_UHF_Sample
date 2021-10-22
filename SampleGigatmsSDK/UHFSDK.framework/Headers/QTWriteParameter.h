//
//  QTWriteParameter.h
//  UHFSDK
//
//  Created by JangJack on 2020/10/24.
//  Copyright © 2020 Gianni. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TagAccessParameter.h"

typedef NS_ENUM(Byte, QTWrite_AccessOption) {
    QTWrite_VOLATILE_MEMORY = 0x00,
    QTWrite_NVM_MEMORY      = 0x01,
};

typedef NS_ENUM(Byte, QTWrite_QT_SR) {
    QT_SR_TAG_DOSE_NOT_REDUCES_RANGE = 0x00,
    QT_SR_TAG_REDUCES_RANGE          = 0x01,
};

typedef NS_ENUM(Byte, QTWrite_QT_MEM) {
    QT_MEM_USE_PRIVATE_MEMORY_MAP = 0x00,
    QT_MEM_USE_PUBLIC_MEMORY_MAP  = 0x01,
};

NS_ASSUME_NONNULL_BEGIN

@interface QTWriteParameter : TagAccessParameter

-(instancetype) initWithAccessPassword:(NSString *) accessPassword;
-(void) assignAccessOption:(QTWrite_AccessOption) accessOption;
-(void) assignQT_SR:(QTWrite_QT_SR) qt_sr;
-(void) assignQT_MEM:(QTWrite_QT_MEM) qt_mem;
-(NSData *) toBytes;

@end

NS_ASSUME_NONNULL_END
