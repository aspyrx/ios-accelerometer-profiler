//
//  ProfileDetailsTableViewController.m
//  Accelerometer Profiler
//
//  Created by Stan on 7/17/14.
//  Copyright (c) 2014 aspyrx. All rights reserved.
//

#import "ProfileDetailsTableViewController.h"
#import "ProfileDataViewController.h"
#import "ProfileMetadata.h"
#import "Profile.h"

@interface ProfileDetailsTableViewController ()

@end

@implementation ProfileDetailsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    nameFont = [UIFont systemFontOfSize:16.0f];
    notesFont = [UIFont systemFontOfSize:14.0f];
}

#pragma mark - UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        NSDateFormatter *df = [NSDateFormatter new];
        [df setDateFormat:kDateFormatDisplay];
        return [df stringFromDate:self.profile.metadata.date];
    }
    
    return [super tableView:tableView titleForHeaderInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = self.profile.metadata.name;
                    cell.textLabel.numberOfLines = 0;
                    break;
                case 1:
                    cell.textLabel.text = self.profile.metadata.notes;
                    cell.textLabel.numberOfLines = 0;
                    break;
            }
            
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = [ProfileMetadata nameForTransportMode:self.profile.metadata.transportMode];
                    break;
            }
            
            break;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return [self.profile.metadata.name sizeWithFont:nameFont constrainedToSize:CGSizeMake(self.tableView.frame.size.width - 120, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping].height + 16.0f;
        } else if (indexPath.row == 1) {
            return [self.profile.metadata.notes sizeWithFont:notesFont constrainedToSize:CGSizeMake(self.tableView.frame.size.width - 120, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping].height + 16.0f;
        }
    }
    return UITableViewAutomaticDimension;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"displaySensorData"]) {
        ProfileDataViewController *vc = segue.destinationViewController;
        vc.profile = self.profile;
    }
}

@end
