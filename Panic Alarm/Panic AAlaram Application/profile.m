//
//  About.m
//  Panic Alarm
//
//  Created by Zainu Corporation on 26/07/2014.
//  Copyright (c) 2014 Zohair Hemani - Stanford Assignment. All rights reserved.
//

#import "profile.h"
#import "WebService.h"

@implementation profile
{
    UIImage *uploadedimage;
    UIView *lineView;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.personName.text = [[[NSUserDefaults standardUserDefaults] valueForKey:@"name"] uppercaseString];
    
    self.personImage.layer.cornerRadius = 40;
    self.personImage.contentMode = UIViewContentModeScaleAspectFill;
    [self.personImage setClipsToBounds:YES];
    NSData* myEncodedImageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"userImage"];
    UIImage *img = [UIImage imageWithData:myEncodedImageData];
    
    self.personImage.image = img;
    
    lineView = [[UIView alloc] initWithFrame:CGRectMake(20, self.personName.frame.origin.y, self.view.bounds.size.width, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineView];
    
    lineView = [[UIView alloc] initWithFrame:CGRectMake(20, self.personName.frame.origin.y+25, self.view.bounds.size.width, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineView];
    
    self.messageText.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"panicMessage"];
    
    self.save.layer.cornerRadius = 5;
    [self.save setClipsToBounds:YES];
    
}

- (IBAction)upload:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"What do you want to do?"
                                 message:nil
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                                       [self presentViewController:picker animated:YES completion:nil];
                                                   }];
    
    UIAlertAction *photoRoll = [UIAlertAction actionWithTitle:@"Photo Roll" style:UIAlertActionStyleDestructive
                                                      handler:^(UIAlertAction * action) {
                                                          picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                                          [self presentViewController:picker animated:YES completion:nil];
                                                      }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * action) {
                                                   }];
    
    [alert addAction:camera];
    [alert addAction:photoRoll];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    self.personImage.layer.cornerRadius= self.personImage.frame.size.height/2;
    self.personImage.layer.masksToBounds = YES;
    self.personImage.layer.borderWidth = 0;
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    uploadedimage = info[UIImagePickerControllerOriginalImage];
    (self.personImage).image = uploadedimage;
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)save_action:(id)sender {
    
    WebService *updateMessage = [[WebService alloc] init];
     NSArray *result = [updateMessage FilePath:@"http://fajjemobile.info/iospanic/panicMessage.php" parameterOne:self.messageText.text parameterTwo:self.personName.text];
     NSString *status = [result valueForKey:@"success"];
    
    if([status isEqualToString:@"OK"])
    {
        [self showAlertBox:NO title:@"Status" message:@"Your Panic message has been updated" ];
        [[NSUserDefaults standardUserDefaults ] setValue:self.personName.text forKey:@"name"];
        [[NSUserDefaults standardUserDefaults ] setValue:self.messageText.text forKey:@"panicMessage"];
    }
    else
    {
        [self showAlertBox:NO title:@"Status" message:@"Your Panic message could not be updated."];
    }
    
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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

-(void)showAlertBox:(BOOL)moveBack title:(NSString*)title message:(NSString*)message
{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:title
                                 message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"Okay"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             if(moveBack == true)
                             {
                                 [self.navigationController popToRootViewControllerAnimated:YES];
                             }
                         }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.view.frame = CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y - 50.0), self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.view.frame = CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y + 50.0), self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

@end
