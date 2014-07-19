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

@synthesize delegate;

- (void)viewWillAppear:(BOOL)animated {
    self.nameTextField.text = @"";
    self.notesTextView.text = @"";
    [self.transportModePickerView selectRow:TransportModeWalk inComponent:0 animated:NO];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return TRANSPORT_MODE_ENUM_SIZE;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [ProfileMetadata nameForTransportMode:(transport_mode_t)row];
    }
    
    return nil;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    activeField = textView;
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    activeField = textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self.notesTextView becomeFirstResponder];
    return NO;
}

#pragma mark - Interface methods

- (IBAction)recordingNameEditingChanged:(UITextField *)sender {
    self.saveButton.enabled = [sender.text length] > 0;
}

- (IBAction)tapViewTapped:(UITapGestureRecognizer *)sender {
    [activeField resignFirstResponder];
}

- (IBAction)cancelButtonPressed:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveButtonPressed:(UIBarButtonItem *)sender {
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.saveButton setCustomView:indicator];
    
    NSOperationQueue *queue = [NSOperationQueue new];
    [queue addOperationWithBlock:^(void) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^(void) {
            [self.view setUserInteractionEnabled:NO];
            [indicator startAnimating];
        }];
        
        ProfileMetadata *metadata = [ProfileMetadata new];
        metadata.date = [NSDate date];
        metadata.name = self.nameTextField.text;
        metadata.notes = self.notesTextView.text;
        metadata.transportMode = (transport_mode_t)[self.transportModePickerView selectedRowInComponent:0];
        [self.delegate saveRecordingWithMetadata:metadata];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^(void) {
            [indicator stopAnimating];
            [self.view setUserInteractionEnabled:YES];
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }];
}

@end
