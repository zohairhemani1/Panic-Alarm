//
//  FirstViewController.m
//  Panic AAlaram Application
//
//  Created by Zohair Hemani on 30/04/2014.
//  Copyright (c) 2014 Zohair Hemani - Stanford Assignment. All rights reserved.
//

#import "FirstViewController.h"
#import "FirstTab.h"
#import <Parse/Parse.h>
#import "checkInternet.h"
#import "Constants.h"

@interface FirstViewController (){
    NSMutableData *_downloadedData;
    UIImage *uploadedimage;
    NSString * storedNumber;
    checkInternet *c;
    NSString *username;
    NSString *password;
    NSString *usernameEditText;
    NSString *passwordEditText;
    NSString *fileName;
}

@end

@implementation FirstViewController
UIActivityIndicatorView *progress;


-(IBAction)backgroundTouched:(id)sender
{
    [self.insertusername resignFirstResponder];
    [self.insertpassword resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    fileName = @"default.png";
        c = [[checkInternet alloc]init];
        [c viewWillAppear:YES];
    
	// Do any additional setup after loading the view, typically from a nib.
    UIImage *backgroundImage = [UIImage imageNamed:@"background.png"];
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:backgroundImage];

    UIImage *navbackgroundImage = [UIImage imageNamed:@"favorites_top"];
    [[UINavigationBar appearance] setBackgroundImage:navbackgroundImage forBarMetrics:UIBarMetricsDefault];
    [UITextField appearance].tintColor = [UIColor blackColor];
    
    UIView *statusBarbg = [[UIView alloc] init];
    statusBarbg.frame = CGRectMake(0, 0, 320, 20);
    statusBarbg.backgroundColor = [UIColor blackColor];
    [self.view addSubview:statusBarbg];
    
    progress = [c indicatorprogress:progress];
    [self.view addSubview:progress];
    [progress bringSubviewToFront:self.view];

    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
    
    UIView *paddingView;
    
    for(UITextField *textField in self.myTextFieldsCollection)
    {
        paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
        textField.leftView = paddingView;
        textField.leftViewMode = UITextFieldViewModeAlways;
    }
}

- (void)downloadItems
{
    // Download the json file
    NSURL *jsonFileUrl = [NSURL URLWithString:@"http://fajjemobile.info/iospanic/login.php"];
    
    // Create the NSURLConnection
    
    // Posting the values of edit text field to database to query the results.
    
    NSString *myRequestString = [NSString stringWithFormat:@"username=%@&password=%@&pic=%@",usernameEditText, passwordEditText,fileName];
    
    // Create Data from request
    NSData *myRequestData = [NSData dataWithBytes: myRequestString.UTF8String length: myRequestString.length];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: jsonFileUrl];
    // set Request Type
    
    request.HTTPMethod = @"POST";
    // Set content-type
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    // Set Request Body
    request.HTTPBody = myRequestData;
    // Now send a request and get Response
    NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil];
    // Log Response
    NSString *response = [[NSString alloc] initWithBytes:returnData.bytes length:returnData.length encoding:NSUTF8StringEncoding];
    NSLog(@"%@",response);
    
    [NSURLConnection connectionWithRequest:request delegate:self];
    
//    FirstTab *first = [[FirstTab alloc] initWithNibName:Nil bundle:nil];
//    [self presentViewController:first animated:YES completion:nil];
    //[self showMainMenu];
    
}

#pragma mark NSURLConnectionDataProtocol Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // Initialize the data object
    _downloadedData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the newly downloaded data
    [_downloadedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // Create an array to store the locations
    //NSMutableArray *_locations = [[NSMutableArray alloc] init];
    
    // Parse the JSON that came in
    NSError *error;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:_downloadedData options:NSJSONReadingAllowFragments error:&error];
    
    //jsonArray[0] = {2,4};

    if(jsonArray.count == 0)
    {
        NSLog(@"JSON returning empty array");
    }
    else
    {
        NSDictionary *jsonElement = jsonArray[0];
        //NSLog(@"json value-->%@",jsonElement);
        
        
        // Create a new location object and set its props to JsonElement properties
        
        username = jsonElement[@"username"];
        password = jsonElement[@"password"];
        
        NSLog(@"username JSON%@",username);
        NSLog(@"passwordJSON%@",password);
        
        NSLog(@"username EditText%@",usernameEditText);
        NSLog(@"passwordEditText%@", passwordEditText);
        
    }
}


- (void)uploadImage
{
    
    [progress startAnimating];
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
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"username\"\r\n\r\n%@", usernameEditText] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"password\"\r\n\r\n%@", passwordEditText] dataUsingEncoding:NSUTF8StringEncoding]];
	// setting the body of the post to the reqeust
    
	request.HTTPBody = body;
	
	// now lets make the connection to the web
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	//NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
      NSError *err = nil;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData: returnData options: NSJSONReadingMutableContainers error: &err];
    
    if([[jsonArray valueForKey:@"success"] isEqualToString:@"0"] )
    {
        [[NSUserDefaults standardUserDefaults ] setValue:self.insertusername.text forKey:@"username"];
        [[NSUserDefaults standardUserDefaults ] setValue:self.insertpassword.text forKey:@"password"];
        
        [[NSUserDefaults standardUserDefaults ] setValue:@"loggedIn" forKey:@"loggedIn"];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        UITabBarController *secondView = [storyboard instantiateViewControllerWithIdentifier:@"NavigationTime"];
        [self presentViewController:secondView animated:YES completion:nil];
        
        //[self performSegueWithIdentifier:@"login" sender:self];
    }
    
    NSLog(@"JsonArrayIs %@", jsonArray);
    
}


- (IBAction)login:(id)sender {
    
    if([self.insertusername.text isEqualToString:@""] ||[self.insertpassword.text isEqualToString:@""])
    {
        [self showAlertBox:NO title:@"Incomplete Information" message:@"It seems you have not inserted username or password!!"];
    }
    else if((self.insertusername.text).length < 6)
    {
        [self showAlertBox:NO title:@"Sorry" message:@"The Username should be 6 charachter long!!"];
    }
    else if((self.insertpassword.text).length < 6)
    {
        [self showAlertBox:NO title:@"Sorry" message:@"The Password should be 6 charachter long!!"];
    }
    
    else{
        
    usernameEditText = self.insertusername.text;
    passwordEditText = self.insertpassword.text;
    
    [[NSUserDefaults standardUserDefaults] setValue:usernameEditText forKey:@"name"];
    [[NSUserDefaults standardUserDefaults] setValue:passwordEditText forKey:@"password"];
    
    NSData* imageData = UIImagePNGRepresentation(self.imageView.image);
    [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:@"userImage"];
        
   // NSString * storedName = [[NSUserDefaults standardUserDefaults] stringForKey:@"name"];
        // getting code.
        
    storedNumber = [[NSUserDefaults standardUserDefaults] valueForKey:@"password"];
    
   // CGImageRef cgref = [uploadedimage CGImage];
   // CIImage *cim = [uploadedimage CIImage];
    
//    if (cim == nil && cgref == NULL)
//    {
//        NSLog(@"no underlying data"); // image not uploaded by user
//    }
//    else
//    {
//        
//    }
    [self uploadImage]; // uploads image & inserts username password into database. - checks login.
    
    //[self downloadItems]; // inserts username password into database. - checks login.
    
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    NSString * phone = @"X_";
    phone = [phone stringByAppendingString:self.insertpassword.text];
       [currentInstallation addUniqueObject:phone forKey:@"channels"];
        [currentInstallation addUniqueObject:phone forKey:@"number"];
        [currentInstallation saveInBackground];

    }
 
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

    self.imageView.layer.cornerRadius= self.imageView.frame.size.height/2;
    //layer.cornerRadius = cell.yourImageView.frame.size.height /2;
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.borderWidth = 0;
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    uploadedimage = info[UIImagePickerControllerOriginalImage];
    (self.imageView).image = uploadedimage;
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"login"]){
        
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:YES];
	self.animationView.frame = CGRectMake(self.animationView.frame.origin.x, (self.animationView.frame.origin.y - 50.0), self.animationView.frame.size.width, self.animationView.frame.size.height);
	[UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:YES];
	self.animationView.frame = CGRectMake(self.animationView.frame.origin.x, (self.animationView.frame.origin.y + 50.0), self.animationView.frame.size.width, self.animationView.frame.size.height);
	[UIView commitAnimations];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)showAlertBox:(BOOL)moveBack title:(NSString*)title message:(NSString*)message
{
    UIAlertController * alert=   [UIAlertController
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

@end

