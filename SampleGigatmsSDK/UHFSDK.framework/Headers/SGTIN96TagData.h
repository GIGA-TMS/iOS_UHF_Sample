//
//  SGTIN96TagData.h
//  GIGATMSSDK
//
//  Created by JangJack on 2020/9/4.
//  Copyright © 2020 Gianni. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BaseTagData.h"

typedef NS_ENUM(Byte, Filter) {
    ALL_OTHERS        = 0x00,
    POS_TRADE         = 0x01,
    TRANSPORT         = 0x02,
    RESERVED_3        = 0x03,
    HANDLING          = 0x04,
    RESERVED_5        = 0x05,
    UNIT_LOAD         = 0x06,
    UNIT_INSIDE_TRADE = 0x07,
};

typedef NS_ENUM(Byte, CompanyPrefixLength) {
    DIGITS_6  = 0x06,
    DIGITS_7  = 0x05,
    DIGITS_8  = 0x04,
    DIGITS_9  = 0x03,
    DIGITS_10 = 0x02,
    DIGITS_11 = 0x01,
    DIGITS_12 = 0x00,
};

NS_ASSUME_NONNULL_BEGIN

@interface SGTIN96TagData : BaseTagData

@property (assign) CompanyPrefixLength mCompanyPrefixLength;
@property (assign) Filter mFilter;
@property (copy) NSString *mSerialNumber;

-(instancetype) initWithEpcHader:(EpcHeader) epcHeader Barcode:(NSString *) barcode Filter:(Filter) filter CompanyPrefixLength:(CompanyPrefixLength) companyPrefixLength SerialNumber:(NSString *) serialNumber;
-(NSData *) getSpecificDataBytes;

@end

NS_ASSUME_NONNULL_END
