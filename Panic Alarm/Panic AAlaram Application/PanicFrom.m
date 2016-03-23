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

@interface PanicFrom (){
checkInternet *c;
    UIImage *img;
    NSString *profilePic ;
    NSString *imagePathString ;
    NSURL *imagePathUrl;
    NSData *data ;
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
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
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
    //NSLog(@"the panic person id is: %d",self.panicPersonId);
    
    panicPersonName.text = [[[Log getPanicFromArray] valueForKey:@"username"][self.panicPersonId] uppercaseString];
    profilePic = [[Log getPanicFromArray] valueForKey:@"pic"][self.panicPersonId];
    self.panicMessage.text = [[Log getPanicFromArray] valueForKey:@"pMessage"][self.panicPersonId];
    self.panicNumber.text = [[Log getPanicFromArray] valueForKey:@"mynumber"][self.panicPersonId];
    
    imagePathString = @"http://steve-jones.co/iospanic/assets/upload/";
    imagePathString = [imagePathString stringByAppendingString:profilePic];
    
    imagePathUrl = [NSURL URLWithString:imagePathString];
    data = [[NSData alloc]initWithContentsOfURL:imagePathUrl];
    img = [[UIImage alloc]initWithData:data ];
    (self.panicPersonImage).image = img;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (IBAction)findLocation:(id)sender
{
    if([[NSUserDefaults standardUserDefaults]valueForKey:@"latitude"] !=nil)
    {
        NSString *locationString = [NSString stringWithFormat:@"%@,%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"latitude"],[[NSUserDefaults standardUserDefaults]valueForKey:@"longitude"]];
        
        [self.locationManager stopUpdatingLocation];
        
        [self performSegueWithIdentifier:@"goToMap" sender:self];
        WebService *locationReceived = [[WebService alloc] init];
        [locationReceived FilePath:BASEURL ACCEPT_LOCATION parameterOne:[[Log getPanicFromArray] valueForKey:@"panicvictim_id"][self.panicPersonId] parameterTwo:[[Log getPanicFromArray] valueForKey:@"friendsnumber"][self.panicPersonId] parameterThree:locationString];
        
        
        //parameter1 : id
        //2: panicvictim_id
        //3: friendsnumber
    }
    else
    {
        NSLog(@"3");
        
        if([[[UIDevice currentDevice] systemVersion] floatValue]<8.0)
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
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    // NSLog(@"in location update");
    [manager stopUpdatingLocation];
    CLLocation *location = locations.lastObject;
    [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%f",location.coordinate.latitude] forKey:@"latitude"];
    [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%f",location.coordinate.longitude] forKey:@"longitude"];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 121 && buttonIndex == 1)
    {
        [[UIApplication sharedApplication] openURL:[NSURL  URLWithString:UIApplicationOpenSettingsURLString]];
        [self.locationManager startUpdatingLocation];
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

@end
