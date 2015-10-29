//
//  digitsVerification.m
//  Panic Alarm
//
//  Created by Avialdo on 20/10/2015.
//  Copyright © 2015 Zohair Hemani - Stanford Assignment. All rights reserved.
//

#import "digitsVerification.h"
#import <DigitsKit/DigitsKit.h>
#import "Terms.h"

@interface digitsVerification ()

@end

@implementation digitsVerification

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    DGTAuthenticateButton *authButton;
//    authButton = [DGTAuthenticateButton buttonWithAuthenticationCompletion:^(DGTSession *session, NSError *error) {
//        if (session.userID) {
//            // TODO: associate the session userID with your user model
//            
//            NSString * storyboardName = @"Main";
//            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
//            UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"termScreen"];
//            
//            [self presentViewController:vc animated:YES completion:nil];
//            
//
//        } else if (error) {
//            NSLog(@"Authentication error: %@", error.localizedDescription);
//        }
//    }];
//    authButton.center = self.view.center;
//    [self.view addSubview:authButton];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)digitsButtonClick:(id)sender
{
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    
    UIViewController<DGTCompletionViewController> * vc = [storyboard instantiateViewControllerWithIdentifier:@"termScreen"];
    
    Digits *digits = [Digits sharedInstance];
    DGTAuthenticationConfiguration *configuration = [[DGTAuthenticationConfiguration alloc] initWithAccountFields:DGTAccountFieldsDefaultOptionMask];
    configuration.phoneNumber = @"+345555555555";
    [digits authenticateWithNavigationViewController:self.navigationController configuration:configuration completionViewController:vc];
    
}

@end
