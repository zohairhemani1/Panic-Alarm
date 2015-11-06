//
//  UploadingContactsViewController.m
//  Panic Alarm
//
//  Created by Avialdo on 30/10/2015.
//  Copyright © 2015 Zohair Hemani - Stanford Assignment. All rights reserved.
//

#import "UploadingContactsViewController.h"
#import <DigitsKit/DigitsKit.h>
#import <DigitsKit/DGTContacts.h>

@interface UploadingContactsViewController ()

@end

@implementation UploadingContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    DGTAuthenticateButton *authenticateButton = [DGTAuthenticateButton buttonWithAuthenticationCompletion:^(DGTSession *session, NSError *error) {
        if (session) {
            // Delay showing the contacts uploader while the Digits screen animates off-screen
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self uploadDigitsContactsForSession:session];
            });
        }
    }];
    authenticateButton.center = self.view.center;
    [self.view addSubview:authenticateButton];

}

- (void)uploadDigitsContactsForSession:(DGTSession *)session {
    DGTContacts *digitsContacts = [[DGTContacts alloc] initWithUserSession:session];
    [digitsContacts startContactsUploadWithCompletion:^(DGTContactsUploadResult *result, NSError *error){
        // The result object tells you how many of the contacts were uploaded.
        NSLog(@"Total contacts: %zd, uploaded successfully: %zd", result.totalContacts, result.numberOfUploadedContacts);
        [self findDigitsFriendsForSession:session];
    }];
}

- (void)findDigitsFriendsForSession:(DGTSession *)session {
    DGTContacts *digitsContacts = [[DGTContacts alloc] initWithUserSession:session];
    // looking up friends happens in batches. Pass nil as cursor to get the first batch.
    [digitsContacts lookupContactMatchesWithCursor:nil completion:^(NSArray *matches, NSString *nextCursor, NSError *error) {
        // If nextCursor is not nil, you can continue to call lookupContactMatchesWithCursor: to retrieve even more friends.
        // Matches contain instances of DGTUser. Use DGTUser's userId to lookup users in your own database.
        NSLog(@"Friends:");
        for (DGTUser *digitsUser in matches) {
            NSLog(@"Digits ID: %@", digitsUser.userID);
        }
        // Show the alert on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *message = [NSString stringWithFormat:@"%zd friends found!", matches.count];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Lookup complete" message:message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:cancel];
            [self presentViewController:alertController animated:YES completion: nil];
        });
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
