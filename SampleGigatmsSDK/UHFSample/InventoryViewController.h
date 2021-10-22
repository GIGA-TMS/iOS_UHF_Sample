//
//  InventoryViewController.h
//  UHFSample
//
//  Created by Gianni on 2019/4/12.
//  Copyright © 2019 Gianni. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InventoryViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *labDevInfo;
@property (strong, nonatomic) IBOutlet UILabel *labConnStatus;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

NS_ASSUME_NONNULL_END
