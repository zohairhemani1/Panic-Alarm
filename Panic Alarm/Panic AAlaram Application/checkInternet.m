//
//  checkInternet.m
//  Panic AAlaram Application
//
//  Created by Zainu Corporation on 20/05/2014.
//  Copyright (c) 2014 Zohair Hemani - Stanford Assignment. All rights reserved.
//

#import "checkInternet.h"

@interface checkInternet ()

@end
BOOL alertTime= YES;
@implementation checkInternet


UIAlertView *alertbox;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    first_time =YES;
    alertTime=YES;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated
{
    // internert work //
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    // check if a pathway to a random host exists
    hostReachable = [Reachability reachabilityWithHostName:@"www.apple.com"];
    [hostReachable startNotifier];

    // internet work end //
}

-(void) checkNetworkStatus:(NSNotification *)notice
{
    // called after network status changes
    
    NetworkStatus internetStatus = [hostReachable currentReachabilityStatus];
    switch (internetStatus)
    {
        case NotReachable:
        {
            NSLog(@"The internet is down.");
            internetActive = NO;
            
            if(alertTime == YES){
                
                alertTime= NO;
            
                alertbox = [[UIAlertView alloc]initWithTitle:@"Internet Issue" message:@" It seems your Internet connection is Down!!" delegate:self cancelButtonTitle:Nil otherButtonTitles:@"Try again", nil];
            [alertbox show];
            
            }
            
            NSLog(@"The internet is not working.");
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"The internet is working via WIFI.");
            internetActive = YES;
           
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"The internet is working via WWAN.");
            internetActive = YES;
            
            break;
        }
    }
}

-(void) viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(UIActivityIndicatorView *)indicatorprogress:(UIActivityIndicatorView *)progressing{
 
    progressing = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    progressing.frame = CGRectMake(0.0, 0.0, 50.0, 50.0);
    progressing.center = self.view.center;
    [self.view addSubview:progressing];
    [progressing bringSubviewToFront:self.view];
    //[progressing setBackgroundColor:[UIColor blackColor]];
    [progressing setColor:[UIColor whiteColor ]];
    progressing.backgroundColor =[[UIColor blackColor] colorWithAlphaComponent:0.7f];
    progressing.layer.cornerRadius = 10;

    return progressing;
}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    if (buttonIndex == 0) {
//        
//        if (internetActive==NO){
//            alertbox = [[UIAlertView alloc]initWithTitle:@"Internet Issue" message:@" It seems your Internet connection is Down!!" delegate:self cancelButtonTitle:Nil otherButtonTitles:@"Try again", nil];
//            
//            [alertbox show];
//        }
//    }
//    
//}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
    alertTime = YES;
        NSLog(@"pressed");
    }
}

- (BOOL) internetstatus{
    return internetActive;
}
@end
