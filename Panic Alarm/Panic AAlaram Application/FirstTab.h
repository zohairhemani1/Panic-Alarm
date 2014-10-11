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

@interface FirstTab : UIViewController <CLLocationManagerDelegate, UITextFieldDelegate>

@property(strong,nonatomic) CLLocationManager * locationManager;
@property(strong,nonatomic) CLLocation *location;

- (IBAction)get_location:(id)sender;

-(void)locationManager:(CLLocationManager *)manager;
-(void)currentLocationToDatabaseLatitude:(NSString * )latitude longitude:(NSString *) longitude;
- (IBAction)backgroundTouch:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *panic;


@end
