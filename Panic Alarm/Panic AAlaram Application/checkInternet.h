//
//  checkInternet.h
//  Panic AAlaram Application
//
//  Created by Zainu Corporation on 20/05/2014.
//  Copyright (c) 2014 Zohair Hemani - Stanford Assignment. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

Reachability *hostReachable;
Reachability *internetReachable;
BOOL internetActive;
BOOL first_time;

@interface checkInternet : UIViewController<UIAlertViewDelegate>

- (void) viewWillAppear:(BOOL)animated;
- (void) checkNetworkStatus;
- (UIActivityIndicatorView *)indicatorprogress:(UIActivityIndicatorView *)progressing;
- (BOOL) internetstatus;

@end
