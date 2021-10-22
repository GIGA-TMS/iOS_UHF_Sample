//
//  ScanDevV2ViewController.h
//  UHFSample
//
//  Created by Gianni on 2019/8/27.
//  Copyright © 2019 Gianni. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScanDevV2ViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIPickerView *pickerDevClass;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerDevConChannl;
@property (strong, nonatomic) IBOutlet UIButton *btnScan;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *txtAppVer;

@end

NS_ASSUME_NONNULL_END
