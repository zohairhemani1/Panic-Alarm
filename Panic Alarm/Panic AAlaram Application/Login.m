//
//  FirstViewController.m
//  Panic AAlaram Application
//
//  Created by Zohair Hemani on 30/04/2014.
//  Copyright (c) 2014 Zohair Hemani - Stanford Assignment. All rights reserved.
//

#import "Login.h"
#import "Home.h"
#import <Parse/Parse.h>
#import "checkInternet.h"
#import "Constants.h"
#import <DigitsKit/DigitsKit.h>

@interface Login (){
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

@implementation Login
UIActivityIndicatorView *progress;

-(IBAction)backgroundTouched:(id)sender
{
    [self.insertusername resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    fileName = @"profile.png";
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

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"loggedIn"]isEqualToString:@"loggedIn"])
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        UITabBarController *secondView = [storyboard instantiateViewControllerWithIdentifier:@"NavigationTime"];
        [self presentViewController:secondView animated:YES completion:nil];
        
    }
}

- (void)downloadItems
{
    // Download the json file
    NSURL *jsonFileUrl = [NSURL URLWithString:@"http://steve-jones.co/iospanic/login.php"];
    
    // Create the NSURLConnection
    
    // Posting the values of edit text field to database to query the results.
    
    NSString *myRequestString = [NSString stringWithFormat:@"username=%@&password=%@&pic=%@",usernameEditText, [[NSUserDefaults standardUserDefaults]valueForKey:@"myPhoneNumber"],fileName];
    
    myRequestString = [myRequestString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@" \"#%/+:<>?@[\\]^`{|}"].invertedSet];
    
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
    NSError *err = nil;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData: returnData options: NSJSONReadingMutableContainers error: &err];
    
    if([[NSString stringWithFormat:@"%@",[jsonArray valueForKey:@"success"]] isEqualToString:@"1"] )
    {
        [[NSUserDefaults standardUserDefaults] setValue:[[jsonArray valueForKey:@"user"]valueForKey:@"panicMessage"] forKey:@"panicMessage"];
        [[NSUserDefaults standardUserDefaults] setValue:self.insertusername.text forKey:@"username"];
        [[NSUserDefaults standardUserDefaults] setValue:@"loggedIn" forKey:@"loggedIn"];
    }
    
    if(self.imageView.image != nil)
    {
        [self uploadImage];
    }
    else
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        UITabBarController *secondView = [storyboard instantiateViewControllerWithIdentifier:@"NavigationTime"];
        [self presentViewController:secondView animated:YES completion:nil];
    }
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
//    else
//    {
//        NSDictionary *jsonElement = jsonArray[0];
//        //NSLog(@"json value-->%@",jsonElement);
//        
//        
//        // Create a new location object and set its props to JsonElement properties
//        
//        username = jsonElement[@"username"];
//        password = jsonElement[@"password"];
//        
//        NSLog(@"username JSON%@",username);
//        NSLog(@"passwordJSON%@",password);
//        
//        NSLog(@"username EditText%@",usernameEditText);
//        NSLog(@"passwordEditText%@", [[NSUserDefaults standardUserDefaults]valueForKey:@"myPhoneNumber"]);
//        
//    }
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
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        UITabBarController *secondView = [storyboard instantiateViewControllerWithIdentifier:@"NavigationTime"];
        [self presentViewController:secondView animated:YES completion:nil];
        
        //[self performSegueWithIdentifier:@"login" sender:self];
    }
    
    NSLog(@"JsonArrayIs %@", jsonArray);
    
}


- (IBAction)login:(id)sender {
    
    if([self.insertusername.text isEqualToString:@""])
    {
        [self showAlertBox:NO title:@"Incomplete Information" message:@"It seems you have not inserted username!"];
    }
    else if((self.insertusername.text).length < 6)
    {
        [self showAlertBox:NO title:@"Sorry" message:@"The Username should be 6 charachter long!!"];
    }
    else {
        
    usernameEditText = self.insertusername.text;
    
    [[NSUserDefaults standardUserDefaults] setValue:usernameEditText forKey:@"name"];
    
    NSData* imageData = UIImageJPEGRepresentation(self.imageView.image, 1.0);
    [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:@"userImage"];
        
    [[Digits sharedInstance] authenticateWithCompletion:^(DGTSession *session, NSError *error) {
            // Inspect session/error objects
        [[NSUserDefaults standardUserDefaults]setValue:session.phoneNumber forKey:@"myPhoneNumber"];
        
        if([[NSUserDefaults standardUserDefaults]objectForKey:@"myPhoneNumber"] != nil)
        {
            PFInstallation *currentInstallation = [PFInstallation currentInstallation];
            
            NSString *myPhoneNumberChannel = [@"X_" stringByAppendingString:[[[NSUserDefaults standardUserDefaults]valueForKey:@"myPhoneNumber"] substringFromIndex:1]];
            
            [currentInstallation addUniqueObject:myPhoneNumberChannel forKey:@"channels"];
            [currentInstallation addUniqueObject:[[NSUserDefaults standardUserDefaults]valueForKey:@"myPhoneNumber"] forKey:@"myPhoneNumber"];
            [currentInstallation saveInBackground];
            
            [self downloadItems];
        }
        
        }];
        
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    uploadedimage = info[UIImagePickerControllerOriginalImage];
    (self.imageView).image = uploadedimage;
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"login"])
    {
        
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationBeginsFromCurrentState:YES];
	self.view.frame = CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y - 100.0), self.view.frame.size.width, self.view.frame.size.height);
	[UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationBeginsFromCurrentState:YES];
	self.view.frame = CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y + 100.0), self.view.frame.size.width, self.view.frame.size.height);
	[UIView commitAnimations];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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

@end

