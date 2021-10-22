//
//  InetSocketAddress.h
//  UHFSDK
//
//  Created by JangJack on 2020/7/2.
//  Copyright © 2020 Gianni. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "InetAddress.h"

NS_ASSUME_NONNULL_BEGIN

@interface InetSocketAddress : NSObject

-(instancetype)init:(InetAddress *) addr Port:(int) port;

-(void)setPort:(int) port;

-(InetAddress *)getHost;

-(void)setAddress:(InetAddress *) addr Port:(int) port;

//-(void)InetSocketAddress:(NSString *) hostname Port:(int) port;

-(int)getPort;


@end

NS_ASSUME_NONNULL_END
