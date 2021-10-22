//
//  DevDetailTabBarViewController.h
//  UHFSample
//
//  Created by Gianni on 2019/4/10.
//  Copyright © 2019 Gianni. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UHFSDK/UHFDevice.h>

NS_ASSUME_NONNULL_BEGIN

@interface DevDetailTabBarViewController : UITabBarController

@property (nonatomic, retain)  UHFDevice* passDev;
-(UHFDevice*) getUHFDevice;
@end

NS_ASSUME_NONNULL_END
