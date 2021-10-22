//
//  XEPCLentT.h
//  UHFSDK
//
//  Created by JangJack on 2020/7/25.
//  Copyright © 2020 Gianni. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(Byte, FindTagAction) {
    FindAnyTagAction                          = 0x00,
    FindPreviousTagWithoutXepcResponseAction  = 0x01,
    FindSpecificTagXepcWithExtendHeaderAction = 0x02,
    FindSpecificTagAction                     = 0x03,
};

@interface XEPCLentT : NSObject

-(instancetype) initWithAccessPassword: (NSString *) accessPassword FileTagAction: (FindTagAction) findTagAction;

-(instancetype) initWithAccessPassword: (NSString *) accessPassword FileTagAction: (FindTagAction) findTagAction SpecificXepc: (NSData *) specificXepc TidFlag:(BOOL) tidFlag;

+(int) XEPCLENT_T_LENGTH;
+(int) PASSWORD_FLAG;

+(Byte) getXEPCLent_T:(NSString *) accessPassword HexSelectedEpc:(NSString *) hexSelectedEpc;
-(NSData *) toBytes;

@end


NS_ASSUME_NONNULL_END
