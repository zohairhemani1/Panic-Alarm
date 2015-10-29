//
//  GetLocation.m
//  Panic Alarm
//
//  Created by Zainu Corporation on 07/07/2014.
//  Copyright (c) 2014 Zohair Hemani - Stanford Assignment. All rights reserved.
//

#import "GetLocation.h"
#import "checkInternet.h"
#import "FirstTab.h"
#import "Favorites.h"
#import "WebService.h"
#import "Constants.h"
#import <Parse/Parse.h>
#import "SearchResultsTableViewController.h"

@interface GetLocation (){
checkInternet *c;
    NSMutableArray *favArray;
    NSArray *favRestJsonArray;
    UIButton *button;
    UIActivityIndicatorView *progress;
}
@end

@implementation GetLocation

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    (self.myContacts).separatorColor = [UIColor lightGrayColor];
    
    c = [[checkInternet alloc]init];
    [c viewWillAppear:YES];
    
    self.refresh = [[UIRefreshControl alloc] init];
    [self.refresh addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    [self.myContacts addSubview:self.refresh];
    
    progress = [c indicatorprogress:progress];
    [self.view addSubview:progress];
    [progress bringSubviewToFront:self.view];
    
    dispatch_queue_t myqueue = dispatch_queue_create("myqueue", NULL);
    dispatch_async(myqueue, ^(void) {
        
        [progress startAnimating];
        favArray = [Favorites favouritesList];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.myContacts reloadData];
            [progress stopAnimating];
        });
    });
    
    UINavigationController *searchResultsController = [self.storyboard instantiateViewControllerWithIdentifier:@"TableSearchResultsNavController"];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:searchResultsController];
    
    self.searchController.searchResultsUpdater = self;
    
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x,
                                                       self.searchController.searchBar.frame.origin.y,
                                                       self.searchController.searchBar.frame.size.width, 44.0);
    
    self.myContacts.tableHeaderView = self.searchController.searchBar;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.searchController.active)
    {
        return self.searchResults.count;
    }
    else
    {
        return favArray.count;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, tableView.frame.size.width, 18)];
    label.font = [UIFont boldSystemFontOfSize:15];
    label.text = @"Ask Location To Freinds";
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    
    view.backgroundColor = [UIColor colorWithRed:201/255.0 green:201/255.0 blue:206/255.0 alpha:1.0];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifierr = @"SimpleTableCell";
    UITableViewCell *cell;
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifierr];
    }
    
    self.definesPresentationContext = YES;
    
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(60, 8, 120, 19)];
    UILabel *phonenumber = [[UILabel alloc]initWithFrame:CGRectMake(60, 29, 80, 20)];
    NSString *pic = [favArray valueForKey:@"pic"][indexPath.row];
    
    name.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17.f];
    phonenumber.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:11.f];
    phonenumber.textColor = [UIColor grayColor];
    
    name.text = [favArray valueForKey:@"username"][indexPath.row];
    phonenumber.text=[favArray valueForKey:@"friendsnumber"][indexPath.row];
    
    NSString *imagePathString = @"http://fajjemobile.info/iospanic/assets/upload/";
    imagePathString = [imagePathString stringByAppendingString:pic];
    
    NSURL *imagePathUrl = [NSURL URLWithString:imagePathString];
    NSData *data = [[NSData alloc]initWithContentsOfURL:imagePathUrl];
    UIImage *img = [[UIImage alloc]initWithData:data ];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:img];
    imageView.frame = CGRectMake(10,5,40,40); //set these variables as you want
    imageView.layer.cornerRadius = 20;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [imageView setClipsToBounds:YES];
    
    button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(cell.frame.origin.x + 250, 10, 60, 30);
    [button setTitle:@"Find" forState:UIControlStateNormal];
    button.tag = indexPath.row;
    button.backgroundColor = [UIColor blackColor];
    [button addTarget:self action:@selector(FindLocation:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell addSubview:name];
    [cell addSubview:phonenumber];
    [cell addSubview:imageView];
    [cell.contentView addSubview:button];
    
    return cell;
    
}

#pragma mark - UISearchControllerDelegate & UISearchResultsDelegate

// Called when the search bar becomes first responder
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = self.searchController.searchBar.text;
    
    [self updateFilteredContentForAirlineName:searchString];
    
    // If searchResultsController
    if (self.searchController.searchResultsController) {
        
        UINavigationController *navController = (UINavigationController *)self.searchController.searchResultsController;
        
        // Present SearchResultsTableViewController as the topViewController
        SearchResultsTableViewController *vc = (SearchResultsTableViewController *)navController.topViewController;
        
        // Update searchResults
        vc.searchResults = self.searchResults;
        vc.searchTableTitle = self.title;
        
        // And reload the tableView with the new data
        
        [vc.tableView reloadData];
    }
}

// Update self.searchResults based on searchString, which is the argument in passed to this method
- (void)updateFilteredContentForAirlineName:(NSString *)airlineName
{
    if (airlineName == nil) {
        
        // If empty the search results are the same as the original data
        self.searchResults = [favArray mutableCopy];
    } else {
        
        NSMutableArray *newSearchResult = [[NSMutableArray alloc] init];
        
        // Else if the airline's name is
        for (NSDictionary *airline in favArray) {
            if ([airline[@"username"] containsString:airlineName]) {
                
                //      NSString *str = [NSString stringWithFormat:@"%@", airline[@"username"] /*, airline[@"icao"]*/];
                [newSearchResult addObject:airline];
            }
            
            self.searchResults = newSearchResult;
        }
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshTable{
    //TODO: refresh your data
    
    [self.refresh endRefreshing];
    [self.myContacts reloadData];
}

-(void)FindLocation:(id)sender{
    button = (UIButton *) sender;
    
    WebService *FindLocationRest = [[WebService alloc] init];
    favRestJsonArray = [FindLocationRest FilePath:BASEURL FIND_REST parameterOne:@"F" parameterTwo:[favArray valueForKey:@"friendsnumber"][button.tag] parameterThree:FIND_MESSAGE];
    
    NSLog(@"the returned value are: %@",[favRestJsonArray valueForKey:@"success"] );
    
    if([[favRestJsonArray valueForKey:@"success"] isEqualToString: @"200"])
    {
        NSLog(@"in code");
        
        [button setTitle:@"PENDING" forState:normal];
        
        PFPush *push = [[PFPush alloc] init];
        [push setChannel:@"X_090078601"];   // channels column in PARSE!
        NSString *FindNotificationMessage = [[favArray valueForKey:@"username"][button.tag] stringByAppendingString:@" is requesting your Location."];
        [push setMessage:FindNotificationMessage];
        //[push setData:data];
        [push sendPushInBackground];
    }
}

@end
