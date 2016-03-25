//
//  PanicFrom.m
//  Panic Alarm
//
//  Created by Zainu Corporation on 05/07/2014.
//  Copyright (c) 2014 Zohair Hemani - Stanford Assignment. All rights reserved.
//

#import "PanicFrom.h"
#import "checkInternet.h"
#import "Map.h"
#import "Log.h"
#import "WebService.h"
#import "Constants.h"
#import "UIImageView+WebCache.h"

@interface PanicFrom ()
{
    checkInternet *c;
    UIActivityIndicatorView *progress;
    UIImage *img;
    NSString *profilePic;
    NSString *imagePathString;
    NSURL *imagePathUrl;
    NSData *data;
    float longitude;
    float latitude;
    BOOL sendLocation;
}
@end
@implementation PanicFrom

@synthesize panicPersonName;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.layer.cornerRadius = 10;
    
    c = [[checkInternet alloc]init];
    [c viewWillAppear:YES];
    progress = [c indicatorprogress:progress];
    [self.view addSubview:progress];
    [progress bringSubviewToFront:self.view];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestAlwaysAuthorization];
    
    if(self.canGoToMap)
    {
        self.findLocationButton.enabled = true;
    }
    else
    {
        self.findLocationButton.enabled = false;
    }
    self.panicView.backgroundColor = [UIColor whiteColor];
    
    UIImage *backgroundImage = [UIImage imageNamed:@"background.png"];
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:backgroundImage];
    (self.navigationController.navigationBar).titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    panicPersonName.text = [[[Log getPanicFromArray] valueForKey:@"username"][self.panicPersonId] uppercaseString];
    profilePic = [[Log getPanicFromArray] valueForKey:@"pic"][self.panicPersonId];
    self.panicMessage.text = [[Log getPanicFromArray] valueForKey:@"pMessage"][self.panicPersonId];
    self.panicNumber.text = [[Log getPanicFromArray] valueForKey:@"mynumber"][self.panicPersonId];
    
    imagePathString = @"http://steve-jones.co/iospanic/assets/upload/";
    imagePathString = [imagePathString stringByAppendingString:profilePic];
    
    [self.panicPersonImage sd_setImageWithURL:[NSURL URLWithString:imagePathString] placeholderImage:[UIImage imageNamed:@"no_image"] options:SDWebImageCacheMemoryOnly];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)findLocation:(id)sender
{
    if([CLLocationManager locationServicesEnabled])
    {
        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied)
        {
            [self showLocationPopUp];
        }
        else
        {
            //[progress startAnimating];
            sendLocation = YES;
            [self.locationManager startUpdatingLocation];
        }
    }
    else
    {
        [self showLocationPopUp];
    }
}

-(void) showLocationPopUp
{
    if([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)
    {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"This app does not have access to Location service" message:@"You can enable access in Settings->Privacy->Location->Location Services" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"This app does not have access to Location service" message:@"You can enable access in Settings->Privacy->Location->Location Services" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Settings", nil];
        alert.tag=121;
        [alert show];
    }
}

- (void)callWebService
{
    //NSString *locationString = [NSString stringWithFormat:@"%@,%@",[NSString stringWithFormat:@"%f",latitude],[NSString stringWithFormat:@"%f",longitude]];
    
    WebService *locationReceived = [[WebService alloc] init];
    NSMutableArray *locationResult =  [locationReceived FilePath:BASEURL ACCEPT_LOCATION parameterOne:[[Log getPanicFromArray] valueForKey:@"panicvictim_id"][self.panicPersonId] parameterTwo:[[Log getPanicFromArray] valueForKey:@"friendsnumber"][self.panicPersonId]];
    
    if([[locationResult valueForKey:@"success"] isEqualToString: @"200"])
    {
        [self performSegueWithIdentifier:@"goToMap" sender:self];
        [progress stopAnimating];
    }
    else
    {
        [self showAlertBoxWithTitle:@"Internet Issue" message:@"It seems your Internet connection is Down"];
        [progress stopAnimating];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [manager stopUpdatingLocation];
    CLLocation *location = locations.lastObject;
    
    if(sendLocation == YES)
    {
        sendLocation = NO;
        latitude = location.coordinate.latitude;
        longitude = location.coordinate.longitude;
        [progress startAnimating];
        [self callWebService];
        
        NSLog(@"latitude %f",latitude);
        NSLog(@"longitude %f",longitude);
    }

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 121 && buttonIndex == 1)
    {
        [[UIApplication sharedApplication] openURL:[NSURL  URLWithString:UIApplicationOpenSettingsURLString]];
        //[self.locationManager startUpdatingLocation];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    Map *map = segue.destinationViewController;
    
    if ([segue.identifier isEqualToString:@"goToMap"])
    {
        map.panicPersonId = self.panicPersonId;
        map.destinationLatitude = [[[Log getPanicFromArray] valueForKey:@"latitude"][self.panicPersonId]floatValue];
        map.destinationLongitude = [[[Log getPanicFromArray] valueForKey:@"longitude"][self.panicPersonId]floatValue];
        map.pinTitle = [[Log getPanicFromArray] valueForKey:@"username"][self.panicPersonId];
        map.pinSubtitle = [[Log getPanicFromArray] valueForKey:@"pMessage"][self.panicPersonId];
    }
}

-(void)showAlertBoxWithTitle:(NSString*)title message:(NSString*)message
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
                         }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}


@end
