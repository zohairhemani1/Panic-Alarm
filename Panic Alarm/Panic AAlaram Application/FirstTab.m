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
}
@end

UIActivityIndicatorView *progress;
@implementation FirstTab

bool first_time_on_database=YES;
bool condition=NO;

-(IBAction)backgroundTouch:(id)sender
{
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    [self.locationManager setDelegate:self];
    self.location = [[CLLocation alloc] init];
    
    UIImage *backgroundImage = [UIImage imageNamed:@"background_tabone"];
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:backgroundImage];
    condition=YES;
    
   // self.title = @"Hello World";
    
    c= [[checkInternet alloc]init];
    [c viewWillAppear:YES];
    
    //this is how you can use the indicator view//
    progress = [c indicatorprogress:progress];
    [self.view addSubview:progress];
    [progress bringSubviewToFront:self.view];
    // indicator view end
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    dispatch_queue_t myqueue = dispatch_queue_create("myqueue", NULL);
    dispatch_async(myqueue, ^(void) {
        
        [progress startAnimating];
        
        [self fetchingFriendsWhoAdded];
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update UI on main queue
            
            [progress stopAnimating];
            
        });
        
    });

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)get_location:(id)sender {
    
    [self.panic setBackgroundImage:[UIImage animatedImageNamed:@"panic_animation" duration:3.0] forState:UIControlStateNormal];
    
    AVAudioPlayer *player;
    //SystemSoundID soundID;
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"alarmsound" ofType:@"mp3"];
    NSURL *soundUrl = [NSURL fileURLWithPath:soundPath];
    player = [[AVAudioPlayer alloc]initWithContentsOfURL:soundUrl error:nil];
    [player play];
    

    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
    [progress startAnimating];
    
    /* [NSTimer scheduledTimerWithTimeInterval:60.0
     target:self
     selector:@selector(throwinglocationtodatabase)
     userInfo:nil
     repeats:YES]; */
    
    NSMutableArray* list = [Favorites favouritesList];
    victimName = [[NSUserDefaults standardUserDefaults] stringForKey:@"name"];
    victimNumber = [[NSUserDefaults standardUserDefaults] stringForKey:@"password"];
    
    for (int i=0; i<[list count]; i++)
    {
        NSLog(@"Fav Item: %@", [list objectAtIndex:i]);
        friendsNumber = @"X_";
        friendsNumber = [friendsNumber stringByAppendingString:[[list valueForKey:@"friendsnumber"] objectAtIndex:i]];
        NSLog(@"NO: %@", friendsNumber);
        NSString *msg = [victimName stringByAppendingString:@" is in Danger! Please track his location."];
        
        NSDictionary *data = @{
                               @"alert": msg,
                               @"name": victimName,
                               @"number": victimNumber,
                               @"sound":@"cheering.caf"
                               };
      //  NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"alert",
                             // @"cheering.caf", @"sound",
                             // nil];
        
        PFPush *push = [[PFPush alloc] init];
        [push setChannel:friendsNumber];   // channels column in PARSE!
        [push setData:data];
        [push sendPushInBackground];
        
    }

    [progress stopAnimating];
}


// Location Manager Delegate Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [manager stopUpdatingLocation];
    CLLocation *location = [locations lastObject];
    
    latitude = location.coordinate.latitude;
    longitude = location.coordinate.longitude;

    if(first_time_on_database)
    {
        [self PanicVictimRest];
    }
    first_time_on_database = NO;
    

}

-(void)PanicVictimRest{
    
    NSLog(@"longitude is: %f",longitude);
    NSLog(@"latitude is: %f",latitude);
    
    NSMutableDictionary *panic_victim_data = [[NSMutableDictionary alloc] init];
    [panic_victim_data setValue:[NSString stringWithFormat:@"%f",latitude] forKey:@"latitude"];
    [panic_victim_data setValue:[NSString stringWithFormat:@"%f",longitude] forKey:@"longitude"];
    [panic_victim_data setValue:victimName forKey:@"name"];
    [panic_victim_data setValue:victimNumber forKey:@"password"];
    [panic_victim_data setValue:@"P" forKey:@"type"];
    [panic_victim_data setValue: [[NSUserDefaults standardUserDefaults] stringForKey:@"panicMessage"] forKey:@"panicMessage"];
    //[favouritesObj favouritesArray];
    
    NSArray *PanicVictimDataArray = [[NSArray alloc] initWithObjects:panic_victim_data, nil];
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:PanicVictimDataArray
                        options:NSJSONWritingPrettyPrinted
                        error:&error];
    if ([jsonData length] > 0 &&
        error == nil)
    {
        //NSLog(@"Successfully serialized the dictionary into data = %@", jsonData);
        NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                     encoding:NSUTF8StringEncoding];
        WebService *PanicVictimRestAPI = [[WebService alloc] init];
        [PanicVictimRestAPI FilePath:@"http://www.bizsocialcard.com/iospanic/panicButton.php" parameterOne:jsonString];
    }
   
}


//-(void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    
//    if(condition){
//        
//        condition=NO;
//        
//    }
//    
//}

-(void)fetchingFriendsWhoAdded
{
    
    [[UITabBar appearance] setSelectionIndicatorImage:
     [UIImage imageNamed:@"selected_tabbaritem.png"]];
    [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"tabbarbackground.png"]];
    
    WebService *myWebservice = [[WebService alloc] init];
    NSArray *friendsToAcceptArray = [myWebservice FilePath:@"http://www.bizsocialcard.com/iospanic/getFriends.php" parameterOne:@""];
    
    for(NSDictionary *item in friendsToAcceptArray)
    {
        NSString *fullName;
        NSString *phoneNumber;
        NSString *phoneNumberToAdd;
        NSString *activate;
        NSString *profilePic;
        NSLog(@" friendsToAcceptItem: %@", item);
        
        for (int i=0; i < [SecondViewController.finalArrayStaticFunction count]; i++)
        {
            phoneNumber = [SecondViewController.finalArrayStaticFunction[i] valueForKeyPath:@"phoneNumber"];
            NSString *friendsNumber  = [item valueForKey:@"friendsnumber"];
            profilePic  = [item valueForKey:@"pic"];
            NSString * storedNumber = [[NSUserDefaults standardUserDefaults] stringForKey:@"password"];
            
            
            
            if([[item valueForKey:@"mynumber"] isEqualToString:phoneNumber] && !([[item valueForKey:@"mynumber"] isEqualToString:storedNumber]))
                
            {
                fullName = [SecondViewController.finalArrayStaticFunction[i] valueForKey:@"fullName"];
                phoneNumberToAdd = [SecondViewController.finalArrayStaticFunction[i] valueForKey:@"phoneNumber"];
                NSLog(@"Accept Contact : %@ %@",fullName,phoneNumber);
                activate = [item valueForKey:@"activate"];
                
            }
            else if ([[item valueForKey:@"mynumber"] isEqualToString:storedNumber] && [friendsNumber isEqualToString:phoneNumber])
            {
                fullName = [SecondViewController.finalArrayStaticFunction[i] valueForKey:@"fullName"];
                phoneNumberToAdd = [SecondViewController.finalArrayStaticFunction[i] valueForKey:@"phoneNumber"];
                NSLog(@"Pending Contact: %@ %@",fullName,phoneNumber);
                activate = @"00";
            }
        }
        
        if(fullName!=nil && phoneNumber!=nil){
            [item setValue:fullName forKey:@"fullName"];
            [item setValue:phoneNumberToAdd forKey:@"phoneNumber"];
            [item setValue:activate forKeyPath:@"activate"];
            [item setValue:profilePic forKey:@"0"];
            [SecondViewController.friendWhoUseAppStaticFunction addObject:item];
        }
        
    } // ending for loop
    
    
    
    //set the number of notifications here//
    int notifiations = [friendsToAcceptArray count];
    //zohair work now//
    
    if(notifiations==0){
        [[[[[self tabBarController] tabBar] items] objectAtIndex:1] setBadgeValue:nil];
    }
    else{
        NSString* notifiations_string = [NSString stringWithFormat:@"%i", notifiations];
        [[[[[self tabBarController] tabBar] items] objectAtIndex:1] setBadgeValue:notifiations_string];
    }
    
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField: textField up: YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField: textField up: NO];
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = 100; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

@end
