//
//  Favorites.h
//  Panic AAlaram Application
//
//  Created by Zainu Corporation on 11/05/2014.
//  Copyright (c) 2014 Zohair Hemani - Stanford Assignment. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface Favorites : UIViewController<ABNewPersonViewControllerDelegate,UITableViewDelegate, UITableViewDataSource>
@property UIRefreshControl *refresh;
@property NSMutableArray* favouritesArray;
@property (strong, nonatomic) IBOutlet UITableView *favoritesTable;
- (NSMutableArray*)favouritesList;

@end
