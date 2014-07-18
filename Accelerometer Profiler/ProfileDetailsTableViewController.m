//
//  ProfileDetailsTableViewController.m
//  Accelerometer Profiler
//
//  Created by Stan on 7/17/14.
//  Copyright (c) 2014 aspyrx. All rights reserved.
//

#import "ProfileDetailsTableViewController.h"
#import "ProfileMetadata.h"

@interface ProfileDetailsTableViewController ()

@end

@implementation ProfileDetailsTableViewController

@synthesize metadata;

#pragma mark - UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        NSDateFormatter *df = [NSDateFormatter new];
        [df setDateFormat:kDateFormatDisplay];
        return [df stringFromDate:metadata.date];
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    switch (indexPath.section) {
        case 0: {
            cell.textLabel.text = metadata.name;
        }
    }
    
    return cell;
}

@end
