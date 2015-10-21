//
//  digitsVerification.m
//  Panic Alarm
//
//  Created by Avialdo on 20/10/2015.
//  Copyright © 2015 Zohair Hemani - Stanford Assignment. All rights reserved.
//

#import "digitsVerification.h"
#import <DigitsKit/DigitsKit.h>

@interface digitsVerification ()

@end

@implementation digitsVerification

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DGTAuthenticateButton *digitsButton = [DGTAuthenticateButton buttonWithAuthenticationCompletion:^(DGTSession *session, NSError *error) {
        // Inspect session/error objects
    }];
    [self.view addSubview:digitsButton];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)digitsButtonClick:(id)sender
{
//    NSString *phoneNumber = @"+34";
//    Digits *digits = [Digits sharedInstance];
//    [digits authenticateWithPhoneNumber:phoneNumber digitsAppearance:yourAppearance viewController:nil title:title completion:^(DGTSession *session, NSError *error) {
//        // Country selector will be set to Spain
//    }];
    
    [[Digits sharedInstance] authenticateWithCompletion:^(DGTSession *session, NSError *error) {
     //   UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
     //   UITabBarController *secondView = [storyboard instantiateViewControllerWithIdentifier:@"NavigationTime"];
        
    //    self.window.rootViewController = secondView;
     //   [self.window makeKeyAndVisible];
        
    }];
}

@end
