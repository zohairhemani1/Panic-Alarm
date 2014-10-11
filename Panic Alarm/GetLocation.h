//
//  GetLocation.h
//  Panic Alarm
//
//  Created by Zainu Corporation on 07/07/2014.
//  Copyright (c) 2014 Zohair Hemani - Stanford Assignment. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface GetLocation : UIViewController<ABNewPersonViewControllerDelegate,UITableViewDelegate, UITableViewDataSource>
@property UIRefreshControl *refresh;

@property (weak, nonatomic) IBOutlet UITableView *myContacts;

@end
