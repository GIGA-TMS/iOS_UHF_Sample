//
//  DecodedData.h
//  GIGATMSSDK
//
//  Created by Gianni on 2019/10/7.
//  Copyright © 2019 Gianni. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DecodedData : NSObject

@property(nonatomic,assign) Byte mOutputDataType;
@property(nonatomic,assign) int mDataLength;
@property(nonatomic,strong) NSData* mData;

-(instancetype)initWithData:(NSData*)data;
@end

NS_ASSUME_NONNULL_END
