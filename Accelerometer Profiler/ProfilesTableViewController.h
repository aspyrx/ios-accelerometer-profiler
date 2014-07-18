//
//  ProfilesTableViewController.h
//  Accelerometer Profiler
//
//  Created by Stan on 7/17/14.
//  Copyright (c) 2014 aspyrx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileDetailsTableViewController.h"

@interface ProfilesTableViewController : UITableViewController {
    NSMutableArray *profilePaths;
    NSMutableArray *profileMetadatas;
}

@end
