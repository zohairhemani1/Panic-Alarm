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
#import "SearchResultsTableViewController.h"

@interface SecondViewController : UIViewController<ABNewPersonViewControllerDelegate,UISearchResultsUpdating,UISearchControllerDelegate,UISearchBarDelegate,UISearchDisplayDelegate>

@property UIRefreshControl *refresh;
+ (NSMutableArray *)friendWhoUseAppStaticFunction;
+ (NSMutableArray *)finalArrayStaticFunction;

@property (weak, nonatomic) IBOutlet UITableView *myTable;

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray *searchResults;

@end

