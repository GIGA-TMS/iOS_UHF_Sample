//
//  QTReadParameter.h
//  UHFSDK
//
//  Created by JangJack on 2020/10/24.
//  Copyright © 2020 Gianni. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TagAccessParameter.h"

NS_ASSUME_NONNULL_BEGIN

@interface QTReadParameter : TagAccessParameter

-(instancetype) initWithAccessPassword:(NSString *) accessPassword;
-(NSData *) toBytes;

@end

NS_ASSUME_NONNULL_END
