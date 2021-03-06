//
//  About.m
//  Panic Alarm
//
//  Created by Zainu Corporation on 26/07/2014.
//  Copyright (c) 2014 Zohair Hemani - Stanford Assignment. All rights reserved.
//

#import "profile.h"
#import "WebService.h"
#import "Constants.h"
#import "checkInternet.h"

@implementation profile
{
    checkInternet *c;
    UIImage *uploadedimage;
    UIView *lineView;
    NSString *fileName;
    bool imagechanged;
    UIActivityIndicatorView *progress;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    
    c = [[checkInternet alloc]init];
    [c viewWillAppear:YES];
    progress = [c indicatorprogress:progress];
    [self.view addSubview:progress];
    [progress bringSubviewToFront:self.view];
    
    fileName = @"profile.png";
    
    imagechanged = false;
    self.personName.text = [[[NSUserDefaults standardUserDefaults] valueForKey:@"name"] capitalizedString];
    self.personImage.layer.cornerRadius = 35;
    self.personImage.contentMode = UIViewContentModeScaleAspectFill;
    [self.personImage setClipsToBounds:YES];
    [self.view setBackgroundColor:[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0]];
    
    NSData* myEncodedImageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"userImage"];
    UIImage *img;
    if(myEncodedImageData == nil)
    {
        img = [UIImage imageNamed:@"no_image"];
    }
    else
    {
        img = [UIImage imageWithData:myEncodedImageData];
    }
    
    self.personImage.image = img;
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
    
    if(uploadedimage != self.personImage.image)
    {
        imagechanged = true;
        NSLog(@"image has been changed");
    }
    
    (self.personImage).image = uploadedimage;
    NSData* imageData = UIImageJPEGRepresentation(self.personImage.image, 1.0);
    [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:@"userImage"];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)save_action:(id)sender {
    
    if([self.personName.text isEqualToString:@""] || [self.messageText.text isEqualToString:@""])
    {
        [self showAlertBox:NO title:@"Status" message:@"Please insert name and message first."];
    }
    if(self.personName.text.length < 3)
    {
        [self showAlertBox:NO title:@"Status" message:@"Your username must be of 3 charactrs at least."];
    }
    else
    {
        [progress startAnimating];
        
        WebService *updateMessage = [[WebService alloc] init];
        NSArray *result = [updateMessage FilePath:@"http://steve-jones.co/iospanic/panicMessage.php" parameterOne:self.messageText.text parameterTwo:self.personName.text];
        NSString *status = [result valueForKey:@"success"];
        
        if([status isEqualToString:@"OK"])
        {
            if(self.personImage.image != nil && imagechanged == true)
            {
                imagechanged = false;
                [self uploadImage];
            }
            [self showAlertBox:NO title:@"Status" message:@"Your Panic details has been updated"];
            [[NSUserDefaults standardUserDefaults ] setValue:self.messageText.text forKey:@"panicMessage"];
            [[NSUserDefaults standardUserDefaults ] setValue:self.personName.text forKey:@"name"];
            
            [progress stopAnimating];
        }
        else
        {
            [self showAlertBox:NO title:@"Internet Issue" message:@"It seems your Internet connection is Down"];
            [progress stopAnimating];
        }
    }
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)eventtouch {
    [self.view endEditing:(YES)];
    
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

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.view.frame = CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y - 100.0), self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.view.frame = CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y + 100.0), self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

- (void)uploadImage
{
    
    //[progress startAnimating];
    int randomNumber = arc4random() % 100000;
    NSLog(@"RandomNumber: %i", randomNumber);
    NSString *imageNameRandomNumber = (@(randomNumber)).stringValue;
    fileName = [imageNameRandomNumber stringByAppendingString:@".jpg"];
    //UIImage *myImage = [UIImage imageNamed:imageNameRandomNumber];
    //UIImageView *myImageView =[[UIImageView alloc]initWithImage:uploadedimage];
    //UIView *myView = [[UIView alloc] init];
    //[myView addSubview:myImageView];
    /*
     turning the image into a NSData object
     getting the image back out of the UIImageView
     setting the quality to 90
     */
    NSData *imageData = UIImageJPEGRepresentation(uploadedimage, 0);
    // setting up the URL to post to
    NSString *urlString = [BASEURL stringByAppendingString:@"image_upload.php"];
    
    // setting up the request object now
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    request.URL = [NSURL URLWithString:urlString];
    request.HTTPMethod = @"POST";
    NSLog(@"URL: %@",urlString);
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    /*
     now lets create the body of the post
     */
    NSMutableData *body = [NSMutableData data];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\n", fileName]] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"username\"\r\n\r\n%@", [[NSUserDefaults standardUserDefaults]valueForKey:@"name"] ] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"password\"\r\n\r\n%@", [[NSUserDefaults standardUserDefaults]valueForKey:@"myPhoneNumber"]] dataUsingEncoding:NSUTF8StringEncoding]];
    // setting the body of the post to the reqeust
    
    request.HTTPBody = body;
    
    // now lets make the connection to the web
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSError *err = nil;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData: returnData options: NSJSONReadingMutableContainers error: &err];
    
    if([[jsonArray valueForKey:@"success"] isEqualToString:@"0"] )
    {
        
    }
    
    NSLog(@"JsonArrayIs %@", jsonArray);
    
}

@end
