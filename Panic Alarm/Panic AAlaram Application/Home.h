//
//  FirstTab.h
//  Panic AAlaram Application
//
//  Created by Zainu Corporation on 02/05/2014.
//  Copyright (c) 2014 Zohair Hemani - Stanford Assignment. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <Foundation/Foundation.h>

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface Home : UIViewController <CLLocationManagerDelegate>

@property(strong,nonatomic) CLLocationManager * locationManager;
@property(strong,nonatomic) CLLocation *location;

- (IBAction)get_location:(id)sender;

- (IBAction)backgroundTouch:(id)sender;
- (IBAction)help_button:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *panic;


@end
