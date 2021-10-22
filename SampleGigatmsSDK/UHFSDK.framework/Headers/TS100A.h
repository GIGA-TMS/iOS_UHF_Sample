//
//  TS100A.h
//  UHFSDK
//
//  Created by Gianni on 2019/4/29.
//  Copyright © 2019 Gianni. All rights reserved.
//

#import <UHFSDK/UHFSDK.h>
#import "TS100.h"
NS_ASSUME_NONNULL_BEGIN


@protocol ITS100ASpecialListener <NSObject>
@optional

@end



@interface TS100A : TS100

-(void)getInventoryActiveMode:(BOOL) isTemp;

-(void)setInventoryActiveMode:(BOOL) isTemp InventoryActiveMode:(ActiveMode) activeMode;

@end

NS_ASSUME_NONNULL_END
