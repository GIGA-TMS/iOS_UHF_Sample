//
//  DevDetailTabBarViewController.m
//  UHFSample
//
//  Created by Gianni on 2019/4/10.
//  Copyright © 2019 Gianni. All rights reserved.
//

#import "DevDetailTabBarViewController.h"

@interface DevDetailTabBarViewController ()

@end

@implementation DevDetailTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [[[self.tabviewController viewControllers] objectAtIndex:2]
//     setBadgeValue:[NSString stringWithFormat:@"%d",[myArray count]];
}




-(UHFDevice*) getUHFDevice{
    return self.passDev;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
