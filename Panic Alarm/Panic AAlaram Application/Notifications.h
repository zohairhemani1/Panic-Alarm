//
//  Notifications.h
//  Panic Alarm
//
//  Created by Zainu Corporation on 04/08/2014.
//  Copyright (c) 2014 Zohair Hemani - Stanford Assignment. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Notifications : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *notificationstable;

@end
