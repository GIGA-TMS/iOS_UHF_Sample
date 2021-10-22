//
//  InetAddress.h
//  UHFSDK
//
//  Created by JangJack on 2020/7/2.
//  Copyright © 2020 Gianni. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface InetAddress : NSObject
-(instancetype) init:(NSString *)host;
-(NSString *)getHostAddress;

+(InetAddress *) getByName:(NSString *) string;
@end

NS_ASSUME_NONNULL_END
