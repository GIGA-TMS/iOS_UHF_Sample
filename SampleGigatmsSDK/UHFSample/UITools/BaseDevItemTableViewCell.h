//
//  BaseDevItemTableViewCell.h
//  UHFSample
//
//  Created by Gianni on 2019/4/2.
//  Copyright © 2019 Gianni. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseDevItemTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labDevName;
@property (weak, nonatomic) IBOutlet UILabel *labDevInfo;
@property (weak, nonatomic) IBOutlet UILabel *labConnStauts;
@property (weak, nonatomic) IBOutlet UIButton *btnCtrl;
@property (weak, nonatomic) IBOutlet UIButton *btnConnect;

@end

NS_ASSUME_NONNULL_END
