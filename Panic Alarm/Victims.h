//
//  Victims.h
//  Panic Alarm
//
//  Created by Zainu Corporation on 18/07/2014.
//  Copyright (c) 2014 Zohair Hemani - Stanford Assignment. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Victims : UITableViewController
@property (strong, nonatomic) IBOutlet UITableView *mytable;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segments;
- (IBAction)SegmentAction:(id)sender;

+(NSArray *)getPanicFromArray;

+(NSArray *)getPanicToArray;
@end
