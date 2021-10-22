//
//  BaseTagData.h
//  UHFSDK
//
//  Created by JangJack on 2020/8/5.
//  Copyright © 2020 Gianni. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(Byte, EpcHeader) {
    EPC_SGTIN96 = 0x30,
    EPC_EAS     = 0x30,
    EPC_UDC     = 0xBA,
};

NS_ASSUME_NONNULL_BEGIN

@interface BaseTagData : NSObject

@property(assign) EpcHeader epcHeader;
@property(copy) NSString *barcode;

-(instancetype) initWithWriteEpcHeader: (EpcHeader) epcHeader Barcode:(NSString *) barcode;
-(NSData *) toBytes;

@end

NS_ASSUME_NONNULL_END
