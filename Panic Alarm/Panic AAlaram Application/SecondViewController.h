//
//  SecondViewController.h
//  Panic AAlaram Application
//
//  Created by Zohair Hemani on 30/04/2014.
//  Copyright (c) 2014 Zohair Hemani - Stanford Assignment. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface SecondViewController : UIViewController<ABNewPersonViewControllerDelegate,UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate, UISearchDisplayDelegate>

+ (NSMutableArray *)friendWhoUseAppStaticFunction;
+ (NSMutableArray *)finalArrayStaticFunction;

@property (weak, nonatomic) IBOutlet UITableView *myTable;

@end

