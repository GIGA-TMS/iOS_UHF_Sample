//
//  GNPLockInfos.h
//  GIGATMSSDK
//
//  Created by Gianni on 2019/11/8.
//  Copyright © 2019 Gianni. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IUHFDeviceListener.h"

NS_ASSUME_NONNULL_BEGIN

@interface GNPLockInfos : NSObject

@property (nonatomic, assign) MemoryBank memBank_R;
@property (nonatomic, assign) LockAction action;
@end

NS_ASSUME_NONNULL_END
