//
//  About.m
//  Panic Alarm
//
//  Created by Zainu Corporation on 26/07/2014.
//  Copyright (c) 2014 Zohair Hemani - Stanford Assignment. All rights reserved.
//

#import "profile.h"
#import "WebService.h"

@implementation profile{
    UIImage *uploadedimage;
    UIView *lineView;
    UIAlertView *statusAlert;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    self.messageText.delegate = self;
    
    self.personName.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"name"];
    self.personName.delegate = self;
    
    self.personImage.layer.cornerRadius = 40;
    [self.personImage setClipsToBounds:YES];
    
    lineView = [[UIView alloc] initWithFrame:CGRectMake(20, self.personName.frame.origin.y, self.view.bounds.size.width, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineView];
    
    lineView = [[UIView alloc] initWithFrame:CGRectMake(20, self.personName.frame.origin.y+25, self.view.bounds.size.width, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineView];
    
    self.messageText.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"panicMessage"];
    
    self.save.layer.cornerRadius = 5;
    [self.save setClipsToBounds:YES];

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UIView * txt in self.view.subviews){
        if ([txt isKindOfClass:[UITextField class]] && [txt isFirstResponder]) {
            [txt resignFirstResponder];
        }
        
        else if ([txt isKindOfClass:[UITextView class]] && [txt isFirstResponder]) {
            [txt resignFirstResponder];
        }
        
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    
    
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Camera"]) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Photos"]) {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    else{
        return;
    }
    [self presentViewController:picker animated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    uploadedimage = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.personImage setImage:uploadedimage];
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (IBAction)upload:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"What do you want to do?"
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"Camera", @"Photos", nil];
    
    [actionSheet showInView:self.view];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self animateTextView: textView up: YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self animateTextView: textView up: NO];
}

- (void) animateTextView: (UITextView*) textView up: (BOOL) up
{
    const int movementDistance = 80; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

- (IBAction)save_action:(id)sender {
    
    WebService *updateMessage = [[WebService alloc] init];
     NSArray *result = [updateMessage FilePath:@"http://bizsocialcard.com/iospanic/panicMessage.php" parameterOne:self.messageText.text parameterTwo:self.personName.text];
     NSString *status = [result valueForKey:@"success"];
    
    if([status isEqualToString:@"OK"]){
        statusAlert = [[UIAlertView alloc]initWithTitle:@"Status" message:@" Your Panic message has been updated" delegate:self cancelButtonTitle:Nil otherButtonTitles:@"OK", nil];
        
        [[NSUserDefaults standardUserDefaults ] setObject:self.personName.text forKey:@"name"];
        [[NSUserDefaults standardUserDefaults ] setObject:self.messageText.text forKey:@"panicMessage"];
        [statusAlert show];
    }
    else{
        statusAlert = [[UIAlertView alloc]initWithTitle:@"Status" message:@"Your Panic message could not be updated." delegate:self cancelButtonTitle:Nil otherButtonTitles:@"OK", nil];
        [statusAlert show];

    }
    
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
@end
