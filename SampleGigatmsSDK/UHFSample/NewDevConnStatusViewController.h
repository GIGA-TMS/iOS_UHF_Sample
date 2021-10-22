//
//  NewDevConnStatusViewController.h
//  UHFSample
//
//  Created by JangJack on 2020/8/23.
//  Copyright © 2020 Gianni. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DevDetailTabBarViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewDevConnStatusViewController : UIViewController

-(void)setUHFDevice:(UHFDevice*) dev;
-(void)reloadData;
-(void)updateBLEFirmwareVersion:(NSString*)bleVer;
-(void)clearLog;
-(void)addLog:(NSString *) text;
-(void)displayLog:(NSString *) text;
@end

NS_ASSUME_NONNULL_END
