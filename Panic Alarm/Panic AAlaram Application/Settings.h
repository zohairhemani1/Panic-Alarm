//
//  Settings.h
//  Panic Alarm
//
//  Created by Zainu Corporation on 10/07/2014.
//  Copyright (c) 2014 Zohair Hemani - Stanford Assignment. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Settings : UITableViewController
@property (weak, nonatomic) IBOutlet UITableView *settingsTable;
@property (nonatomic, strong) UIActivityViewController *activityViewController;

@end
