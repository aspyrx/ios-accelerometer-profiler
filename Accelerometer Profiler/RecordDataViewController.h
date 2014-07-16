//
//  RecordDataViewController.h
//  Accelerometer Profiler
//
//  Created by Stan on 7/15/14.
//  Copyright (c) 2014 aspyrx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RecordingStartDelegate <NSObject>

- (void)shouldStartRecording;

@end

@interface RecordDataViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, assign) id <RecordingStartDelegate> delegate;

- (IBAction)cancelButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)doneButtonPressed:(UIBarButtonItem *)sender;

@end
