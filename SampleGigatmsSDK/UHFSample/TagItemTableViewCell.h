//
//  TagItemTableViewCell.h
//  UHFSample
//
//  Created by Gianni on 2019/4/15.
//  Copyright © 2019 Gianni. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TagItemTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *labNo;
@property (strong, nonatomic) IBOutlet UILabel *labEPC;
@property (strong, nonatomic) IBOutlet UILabel *labCount;

@end

NS_ASSUME_NONNULL_END
