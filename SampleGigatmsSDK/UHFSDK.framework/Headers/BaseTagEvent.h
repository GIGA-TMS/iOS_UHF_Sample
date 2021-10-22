//
//  BaseTagEvent.h
//  UHFSDK
//
//  Created by JangJack on 2020/10/12.
//  Copyright © 2020 Gianni. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IUHFDeviceListener.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseTagEvent : NSObject

-(void) addEventType:(EventType) eventType;
-(void) setTagRemovePresented:(BOOL) flag;
-(void) setTidBank:(BOOL) flag;
-(void) setUserBank:(BOOL) flag;
-(Byte) getValue;

@end

NS_ASSUME_NONNULL_END
