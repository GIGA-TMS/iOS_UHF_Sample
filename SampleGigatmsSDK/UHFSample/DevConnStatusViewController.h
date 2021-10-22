//
//  DevConnStatusViewController.h
//  UHFSample
//
//  Created by Gianni on 2019/4/18.
//  Copyright © 2019 Gianni. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DevDetailTabBarViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DevConnStatusViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *labFWVer;
@property (strong, nonatomic) IBOutlet UILabel *labDevInfo;
@property (strong, nonatomic) IBOutlet UILabel *labDevConnStatus;
@property (strong, nonatomic) IBOutlet UIButton *btnConnect;
@property (strong, nonatomic) IBOutlet UILabel *labBLEFWVer;
@property (strong, nonatomic) IBOutlet UIStackView *stackBLEInfo;

- (void)setUHFDevice:(UHFDevice*) dev;
-(void)reloadData;
-(void)updateBLEFirmwareVersion:(NSString*)bleVer;
@end

NS_ASSUME_NONNULL_END
