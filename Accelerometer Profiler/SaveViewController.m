//
//  RecordDataViewController.m
//  Accelerometer Profiler
//
//  Created by Stan on 7/15/14.
//  Copyright (c) 2014 aspyrx. All rights reserved.
//

#import "SaveViewController.h"

@interface SaveViewController ()

@end

@implementation SaveViewController

@synthesize delegate, profile;

- (void)viewWillAppear:(BOOL)animated {
    profile = [Profile new];
    
    self.nameTextField.text = @"";
    self.notesTextView.text = @"";
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return TRANSPORT_MODE_ENUM_SIZE;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [Profile nameForTransportMode:row];
    }
    
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0 && row >= 0 && row < TRANSPORT_MODE_ENUM_SIZE) {
        profile.transportMode = (transport_mode_t)row;
    }
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    activeField = textView;
}

- (void)textViewDidChange:(UITextView *)textView {
    profile.notes = textView.text;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self.notesTextView becomeFirstResponder];
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    activeField = textField;
}

#pragma mark - Interface methods

- (IBAction)recordingNameEditingChanged:(UITextField *)sender {
    profile.name = sender.text;
    if ([profile.name length] > 0) {
        self.saveButton.enabled = YES;
    } else {
        self.saveButton.enabled = NO;
    }
}

- (IBAction)tapViewTapped:(UITapGestureRecognizer *)sender {
    [activeField resignFirstResponder];
}

- (IBAction)cancelButtonPressed:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveButtonPressed:(UIBarButtonItem *)sender {
    [self.delegate saveRecordingWithProfile:profile];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
