//
//  ProfilesTableViewController.m
//  Accelerometer Profiler
//
//  Created by Stan on 7/17/14.
//  Copyright (c) 2014 aspyrx. All rights reserved.
//

#import "ProfilesTableViewController.h"
#import "ProfileMetadata.h"

@interface ProfilesTableViewController ()

@end

@implementation ProfilesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSString *profilesDir = [NSHomeDirectory() stringByAppendingPathComponent:kProfilesDirectory];
    if (![fm fileExistsAtPath:profilesDir]) {
        NSError *error;
        [fm createDirectoryAtPath:profilesDir withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"Error creating profiles directory: %@", error);
            return;
        }
    }
    
    NSError *error;
    profilePaths = [[[[fm contentsOfDirectoryAtPath:profilesDir error:&error] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self ENDSWITH '.csv'"]] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"self" ascending:NO]]] mutableCopy];
    if (error) {
        NSLog(@"Error getting contents of profiles directory: %@", error);
        return;
    }
    
    profileMetadatas = [NSMutableArray array];
    for (NSUInteger i = 0; i < [profilePaths count]; i++) {
        profileMetadatas[i] = [ProfileMetadata metadataFromFile:[profilesDir stringByAppendingPathComponent:profilePaths[i]]];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [profileMetadatas count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"profileCell"];
        
        ProfileMetadata *metadata = profileMetadatas[indexPath.row];
        
        cell.textLabel.text = metadata.name;
        NSDateFormatter *df = [NSDateFormatter new];
        [df setDateFormat:kDateFormatDisplay];
        cell.detailTextLabel.text = [df stringFromDate:metadata.date];
        
        return cell;
    }
    
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete && indexPath.section == 0) {
        NSError *error;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:[[NSHomeDirectory() stringByAppendingPathComponent:kProfilesDirectory] stringByAppendingPathComponent:profilePaths[indexPath.row]] error:&error];
        if (error)
            NSLog(@"Error deleting profile: %@", error);
        [profilePaths removeObjectAtIndex:indexPath.row];
        [profileMetadatas removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"profileCellSelected"]) {
        ProfileDetailsTableViewController *vc = segue.destinationViewController;
        [vc setMetadata:profileMetadatas[[self.tableView indexPathForCell:sender].row]];
    }
}

@end
