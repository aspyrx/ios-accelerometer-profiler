//
//  ProfileDetailsTableViewController.h
//  Accelerometer Profiler
//
//  Created by Stan on 7/17/14.
//  Copyright (c) 2014 aspyrx. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Profile;

@interface ProfileDetailsTableViewController : UITableViewController {
    UIFont *nameFont;
    UIFont *notesFont;
}

@property Profile *profile;

@end
