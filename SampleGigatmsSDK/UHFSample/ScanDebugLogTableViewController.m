//
//  ScanDebugLogTableViewController.m
//  UHFSample
//
//  Created by Gianni on 2019/11/20.
//  Copyright © 2019 Gianni. All rights reserved.
//

#import "ScanDebugLogTableViewController.h"
#import "ScanDebugLogItemTableViewCell.h"

@interface ScanDebugLogTableViewController ()

@end

@implementation ScanDebugLogTableViewController
{
 NSMutableArray* mLogList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setRowHeight:10];
    
    if (mLogList == nil) {
        mLogList = [[NSMutableArray alloc] init];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return mLogList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ScanDebugLogItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScanDebugLogCell" forIndexPath:indexPath];
    NSString* tempLog = [mLogList objectAtIndex:indexPath.row];
    
    if (tempLog) {
        cell.txtLog.text = tempLog;
    }
    return cell;
}

-(void)updateLog:(NSString*)log{
    [mLogList addObject:log];
    [self.tableView reloadData];
    //self.tableView.contentInset =  UIEdgeInsetsMake(0, -10, 0, 10);
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
