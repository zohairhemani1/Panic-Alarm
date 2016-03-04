//
//  FirstTab.m
//  Panic AAlaram Application
//
//  Created by Zainu Corporation on 02/05/2014.
//  Copyright (c) 2014 Zohair Hemani - Stanford Assignment. All rights reserved.
//

#import "FirstTab.h"
#import "WebService.h"
#import "SecondViewController.h"
#import "checkInternet.h"
#import  "Favorites.h"
#import <Parse/Parse.h>
#import <AVFoundation/AVFoundation.h>

@interface FirstTab (){
    checkInternet *c;
    NSString *victimName;
    NSString *victimNumber;
    Favorites *favouritesObj;
    NSString *friendsNumber;
    float longitude;
    float latitude;
    AVAudioPlayer *player;
}
@end

UIActivityIndicatorView *progress;
@implementation FirstTab

bool first_time_on_database=YES;
bool condition=NO;

-(IBAction)backgroundTouch:(id)sender
{
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    UIImage *backgroundImage = [UIImage imageNamed:@"background_tabone"];
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:backgroundImage];
    condition=YES;
    
    c= [[checkInternet alloc]init];
    [c viewWillAppear:YES];
    
    //this is how you can use the indicator view//
    progress = [c indicatorprogress:progress];
    [self.view addSubview:progress];
    [progress bringSubviewToFront:self.view];
    // indicator view end
    
    //[progress startAnimating];
    dispatch_queue_t myqueue = dispatch_queue_create("myqueue", NULL);
    dispatch_async(myqueue, ^(void) {
        
        [self fetchingFriendsWhoAdded];
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
        //[progress stopAnimating];
    });

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)help_button:(id)sender
{
    [self showAlertBox:NO title:@"Help Desk" message:@"You can press the E button to send panic to your Friends"];
}

- (IBAction)get_location:(id)sender
{
    if([Favorites favouritesList].count>0)
    {
        if([[NSUserDefaults standardUserDefaults]valueForKey:@"latitude"] != nil)
        {
            [progress startAnimating];
            
            NSMutableArray* list = [Favorites favouritesList];
            victimName = [[NSUserDefaults standardUserDefaults] stringForKey:@"name"];
            victimNumber = [[NSUserDefaults standardUserDefaults] valueForKey:@"myPhoneNumber"];
            
            for (int i=0; i<list.count; i++)
            {
                NSLog(@"Fav Item: %@", list[i]);
                friendsNumber = @"X_";
                if(![[list valueForKey:@"friendsnumber"][i] isEqualToString:victimNumber])
                    friendsNumber = [friendsNumber stringByAppendingString:[[list valueForKey:@"friendsnumber"][i]substringFromIndex:1]];
                else if (![[list valueForKey:@"mynumber"][i] isEqualToString:victimNumber])
                    friendsNumber = [friendsNumber stringByAppendingString:[[list valueForKey:@"mynumber"][i]substringFromIndex:1]];

                NSLog(@"NO: %@", friendsNumber);
                NSString *msg = [[victimName capitalizedString] stringByAppendingString:@" is in danger. Please track his location."];
                
                NSDictionary *data = @{
                                       @"alert": msg,
                                       @"name": victimName,
                                       @"number": victimNumber,
                                       @"sound":@"cheering.caf"
                                       };
                
                PFPush *push = [[PFPush alloc] init];
                [push setChannel:friendsNumber];   // channels column in PARSE!
                [push setData:data];
                [push sendPushInBackground];
            }
            [self PanicVictimRest];
            [progress stopAnimating];
        }
        else{
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
    else
    {
        [self showAlertBox:NO title:@"ERROR" message:@"You don't have any friends."];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 121 && buttonIndex == 1)
    {
        [[UIApplication sharedApplication] openURL:[NSURL  URLWithString:UIApplicationOpenSettingsURLString]];
        [self.locationManager startUpdatingLocation];
    }
}

-(void)stopSoundAndAnimation
{
    [player stop];
    [self.panic setBackgroundImage:[UIImage imageNamed:@"panic_animation4"] forState:normal];
}

// Location Manager Delegate Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
   // NSLog(@"in location update");
    [manager stopUpdatingLocation];
    CLLocation *location = locations.lastObject;
    
    latitude = location.coordinate.latitude;
    longitude = location.coordinate.longitude;
    
    if(!([[NSString stringWithFormat:@"%f",longitude] isEqualToString:@"0.000000"]))
    {
        [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%f",longitude] forKey:@"longitude"];
        [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%f",latitude] forKey:@"latitude"];
    }
}

-(void)PanicVictimRest{
    
    if(!([[NSString stringWithFormat:@"%f",longitude] isEqualToString:@"0.000000"]))
    {
        [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%f",longitude] forKey:@"longitude"];
        [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%f",latitude] forKey:@"latitude"];
        
        // Sound and animation work //
        [self.panic setBackgroundImage:[UIImage animatedImageNamed:@"panic_animation" duration:3.0] forState:UIControlStateNormal];
        NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"alarmsound" ofType:@"mp3"];
        NSURL *soundUrl = [NSURL fileURLWithPath:soundPath];
        player = [[AVAudioPlayer alloc]initWithContentsOfURL:soundUrl error:nil];
        [player play];
        
        [NSTimer scheduledTimerWithTimeInterval:5.0
                                         target:self
                                       selector:@selector(stopSoundAndAnimation)
                                       userInfo:nil
                                        repeats:YES];
        // Sound and animation work //
        
        first_time_on_database = NO;
        NSMutableDictionary *panic_victim_data = [[NSMutableDictionary alloc] init];
        [panic_victim_data setValue:[NSString stringWithFormat:@"%f",latitude] forKey:@"latitude"];
        [panic_victim_data setValue:[NSString stringWithFormat:@"%f",longitude] forKey:@"longitude"];
        [panic_victim_data setValue:victimName forKey:@"name"];
        [panic_victim_data setValue:victimNumber forKey:@"password"];
        [panic_victim_data setValue:@"P" forKey:@"type"];
        [panic_victim_data setValue: [[NSUserDefaults standardUserDefaults] stringForKey:@"panicMessage"] forKey:@"panicMessage"];
        //[favouritesObj favouritesArray];
        
        NSArray *PanicVictimDataArray = @[panic_victim_data];
        
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization
                            dataWithJSONObject:PanicVictimDataArray
                            options:NSJSONWritingPrettyPrinted
                            error:&error];
        if (jsonData.length > 0 &&
            error == nil)
        {
            //NSLog(@"Successfully serialized the dictionary into data = %@", jsonData);
            NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                         encoding:NSUTF8StringEncoding];
            WebService *PanicVictimRestAPI = [[WebService alloc] init];
            [PanicVictimRestAPI FilePath:@"http://fajjemobile.info/iospanic/panicButton.php" parameterOne:jsonString];
        }
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //[self.locationManager startUpdatingLocation];
}

-(void)fetchingFriendsWhoAdded
{
    
   // [[UITabBar appearance] setSelectionIndicatorImage:
   //  [UIImage imageNamed:@"selected_tabbaritem.png"]];
   // [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"tabbarbackground.png"]];
    
    WebService *myWebservice = [[WebService alloc] init];
    NSArray *friendsToAcceptArray = [myWebservice FilePath:@"http://fajjemobile.info/iospanic/getFriends.php" parameterOne:@""];
    
    // Notification Badge Number //
    NSUInteger notifications = friendsToAcceptArray.count;
    
    if(notifications==0)
    {
        [self.tabBarController.tabBar.items[1] setBadgeValue:nil];
    }
    else
    {
        NSString* notifications_string = [NSString stringWithFormat:@"%i", notifications];
        self.tabBarController.tabBar.items[1].badgeValue = notifications_string;
    }

    for(NSDictionary *item in friendsToAcceptArray)
    {
        NSString *fullName;
        NSString *phoneNumber;
        NSString *phoneNumberToAdd;
        NSString *activate;
        NSString *profilePic;
        NSLog(@" friendsToAcceptItem: %@", item);
        
        for (int i=0; i < (SecondViewController.finalArrayStaticFunction).count; i++)
        {
            phoneNumber = [SecondViewController.finalArrayStaticFunction[i] valueForKeyPath:@"phoneNumber"];
            NSString *friendsNumberz  = [item valueForKey:@"friendsnumber"];
            profilePic  = [item valueForKey:@"pic"];
            NSString * storedNumber = [[NSUserDefaults standardUserDefaults]valueForKey:@"myPhoneNumber"];

            if([[item valueForKey:@"mynumber"] isEqualToString:phoneNumber] && !([[item valueForKey:@"mynumber"] isEqualToString:storedNumber]))
                
            {
                fullName = [SecondViewController.finalArrayStaticFunction[i] valueForKey:@"fullName"];
                phoneNumberToAdd = [SecondViewController.finalArrayStaticFunction[i] valueForKey:@"phoneNumber"];
                NSLog(@"Accept Contact : %@ %@",fullName,phoneNumber);
                activate = [item valueForKey:@"activate"];
                
            }
            else if ([[item valueForKey:@"mynumber"] isEqualToString:storedNumber] && [friendsNumberz isEqualToString:phoneNumber])
            {
                fullName = [SecondViewController.finalArrayStaticFunction[i] valueForKey:@"fullName"];
                phoneNumberToAdd = [SecondViewController.finalArrayStaticFunction[i] valueForKey:@"phoneNumber"];
                NSLog(@"Pending Contact: %@ %@",fullName,phoneNumber);
                activate = @"00";
            }
        }
        
        if(fullName!=nil && phoneNumber!=nil){
            NSLog(@"adding object in dictionary");
            [item setValue:fullName forKey:@"fullName"];
            [item setValue:phoneNumberToAdd forKey:@"phoneNumber"];
            [item setValue:activate forKeyPath:@"activate"];
            [item setValue:profilePic forKey:@"0"];
            [SecondViewController.friendWhoUseAppStaticFunction addObject:item];
        }
        
    } // ending for loop
    
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
