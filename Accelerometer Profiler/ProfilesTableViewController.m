//
//  ProfilesTableViewController.m
//  Accelerometer Profiler
//
//  Created by Stan on 7/17/14.
//  Copyright (c) 2014 aspyrx. All rights reserved.
//

#import "ProfilesTableViewController.h"
#import "ProfileMetadata.h"
#import "Profile.h"

@interface ProfilesTableViewController ()

@end

@implementation ProfilesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    profilePaths = [NSMutableOrderedSet orderedSet];
    profileMetadatas = [NSMutableOrderedSet orderedSet];
    self.loadingIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    self.loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    
    [[NSOperationQueue new] addOperationWithBlock:^(void) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^(void) {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.loadingIndicator];
            [self.loadingIndicator startAnimating];
        }];
        
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
        profilePaths = [NSMutableOrderedSet orderedSetWithArray:[[[fm contentsOfDirectoryAtPath:profilesDir error:&error] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self ENDSWITH '.csv'"]] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"self" ascending:NO]]]];
        if (error) {
            NSLog(@"Error getting contents of profiles directory: %@", error);
            return;
        }
        
        for (NSString *path in profilePaths) {
            [profileMetadatas addObject:[ProfileMetadata metadataFromFile:[profilesDir stringByAppendingPathComponent:path]]];
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.loadingIndicator stopAnimating];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [profileMetadatas count];
    }
    
    return [super tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"profileCell"];
        
        ProfileMetadata *metadata = profileMetadatas[indexPath.row];
        
        cell.textLabel.text = metadata.name;
        NSDateFormatter *df = [NSDateFormatter new];
        [df setDateFormat:kDateFormatDisplay];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@\t%@", [df stringFromDate:metadata.date], [ProfileMetadata nameForTransportMode:metadata.transportMode]];
        
        return cell;
    }
    
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
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

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ProfileDetailsTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"profileDetailsViewController"];
        
        [[NSOperationQueue new] addOperationWithBlock:^(void) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^(void) {
                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.loadingIndicator];
                [self.loadingIndicator startAnimating];
            }];
            
            NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:kProfilesDirectory] stringByAppendingPathComponent:profilePaths[indexPath.row]];
            vc.profile = [Profile profileFromFile:path];
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^(void) {
                [self.loadingIndicator stopAnimating];
                self.navigationItem.rightBarButtonItem = self.editButtonItem;
                [self.navigationController pushViewController:vc animated:YES];
            }];
        }];
    }
}

@end
