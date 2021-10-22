//
//  GNPDecodedTagData.h
//  GIGATMSSDK
//
//  Created by Gianni on 2019/9/20.
//  Copyright © 2019 Gianni. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DecodedData.h"
NS_ASSUME_NONNULL_BEGIN



typedef NS_ENUM(Byte, InputDecodeType){
    TAG_DATA        = 0x00,
    UDC             = 0xBA,
    EAN_UPC         = 0x30,
    INFO            = 0xBF,
};


typedef NS_ENUM(Byte, TagOutputDataType){
    PC          = 0x01,
    EPC         = 0x02,
    PC_EPC      = 0x03,
    TID         = 0x04,
    USER        = 0x08,
    ASCII       = 0x10,
    DEACTIVATE  = 0x12,
    REACTIVE    = 0x13,
};

typedef NS_ENUM(Byte, UdcOutputDataType){
    BCD = 0x00,
    UDC_ASCII = 0x01,
};

typedef NS_ENUM(Byte, EanUpcOutputDataType){
    WITHOUT_EAS = 0x00,
    WITH_EAS = 0x01,
};

typedef NS_ENUM(Byte, InfoOutputDataType){
    CARD_TYPE = 0x00,
    ISSUE_DATA = 0x01,
    BCD_USER_ID = 0x02,
    ASCII_USER_ID = 0x03,
    USER_NAME = 0x04,
    
};

/**
 Decoded Tag Data Format
 */
@interface GNPDecodedTagData : NSObject
@property(nonatomic,strong) NSData* DeviceSerialNumber;
@property(nonatomic,strong) NSData* TID;
@property(nonatomic,assign) int TagSerialNumberLength;
@property(nonatomic,strong) NSData* TagSerialNumber;
@property(nonatomic,assign) InputDecodeType DecodeType;
@property(nonatomic,strong) NSMutableArray* DecodedDataList;



@property(nonatomic,assign) int Count;

-(instancetype)initWithNewTagExData:(NSData*)data;
-(NSString*)getTIDHexString;
-(void)updateCount:(int)count;
@end
NS_ASSUME_NONNULL_END
