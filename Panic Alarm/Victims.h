//
//  Victims.h
//  Panic Alarm
//
//  Created by Zainu Corporation on 18/07/2014.
//  Copyright (c) 2014 Zohair Hemani - Stanford Assignment. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface Victims : UITableViewController<CLLocationManagerDelegate>

@property(strong,nonatomic) CLLocationManager * locationManager;
@property(strong,nonatomic) CLLocation *location;
@property (strong, nonatomic) IBOutlet UITableView *mytable;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segments;
- (IBAction)SegmentAction:(id)sender;
@property UIRefreshControl *refresh;

+(NSArray *)getPanicFromArray;

+(NSArray *)getPanicToArray;
@end
