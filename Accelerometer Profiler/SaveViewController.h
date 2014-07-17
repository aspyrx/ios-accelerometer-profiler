//
//  RecordDataViewController.h
//  Accelerometer Profiler
//
//  Created by Stan on 7/15/14.
//  Copyright (c) 2014 aspyrx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Profile.h"

@interface SaveViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UITextViewDelegate> {
    UIResponder *activeField;
}

@property (strong) id <ProfileRecorder> delegate;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextView *notesTextView;
@property (weak, nonatomic) IBOutlet UIPickerView *transportModePickerView;

- (IBAction)recordingNameEditingChanged:(UITextField *)sender;
- (IBAction)tapViewTapped:(UITapGestureRecognizer *)sender;
- (IBAction)cancelButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)saveButtonPressed:(UIBarButtonItem *)sender;

@end
