//
//  GNPTagInfo.h
//  UHFSDK
//
//  Created by Gianni on 2019/3/26.
//  Copyright © 2019 Gianni. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN



/**
 Tag Information Format
 */
@interface GNPTagInfo : NSObject
@property(nonatomic,assign) int TagNumber;
/**
 Presents the Received Signal Strength Indicator of reading tag.
 */
@property(nonatomic,assign) int RSSI;
@property(nonatomic,strong) NSData* Frequency;
@property(nonatomic,assign) int Length;
@property(nonatomic,assign) int EPCLength;
@property(nonatomic,strong) NSData* EPC;

/**
 Presents the PC, EPC ID In HEX String.
 */
@property(nonatomic,strong) NSString* EPCHexString;
@property(nonatomic,assign) int TIDLength;
@property(nonatomic,strong,nullable) NSData* TID;

/**
 Presents the TID In HEX String.
 */
@property(nonatomic,strong,nullable) NSString* TIDHexString;
@property(nonatomic,assign) int Antenna;

@property(nonatomic,assign) int Count;

-(instancetype)initWithData:(NSData*)data;

-(void)updateCount:(int)count;
-(double)getFrequency;

@end

NS_ASSUME_NONNULL_END
