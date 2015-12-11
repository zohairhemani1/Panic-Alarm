//
//  Favorites.m
//  Panic AAlaram Application
//
//  Created by Zainu Corporation on 11/05/2014.
//  Copyright (c) 2014 Zohair Hemani - Stanford Assignment. All rights reserved.
//

#import "Favorites.h"
#import "PanicFrom.h"
#import "WebService.h"
#import "Constants.h"
#import <Parse/Parse.h>
#import "checkInternet.h"

@interface Favorites ()
{
    checkInternet *c;
    NSString *storedNumber;
    UIActivityIndicatorView *progress;
    UIButton *button;
    NSArray *favRestJsonArray;
    UIImage *img;
    NSMutableArray *imagesArray;
}
@end

@implementation Favorites
static NSMutableArray* favouritesArray;
@synthesize favoritesTable;

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

    UIImage *backgroundImage = [UIImage imageNamed:@"background_tabone"];
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:backgroundImage];

    (self.favoritesTable).separatorColor = [UIColor lightGrayColor];
    
    c = [[checkInternet alloc]init];
    [c viewWillAppear:YES];
    
    self.refresh = [[UIRefreshControl alloc] init];
    [self.refresh addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    [self.favoritesTable addSubview:self.refresh];
    
    progress = [c indicatorprogress:progress];
    [self.view addSubview:progress];
    [progress bringSubviewToFront:self.view];
    
    dispatch_queue_t myqueue = dispatch_queue_create("myqueue", NULL);
    dispatch_async(myqueue, ^(void) {
        
        [progress startAnimating];
        [Favorites favouritesList];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update UI on main queue

            [self.favoritesTable reloadData];
            [progress stopAnimating];
            
        });
        
    });
    
    imagesArray = [[NSMutableArray alloc]init];
    
    UINavigationController *searchResultsController = [self.storyboard instantiateViewControllerWithIdentifier:@"TableSearchResultsNavController"];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:searchResultsController];
    
    self.searchController.searchResultsUpdater = self;
    self.searchController.delegate = self;
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x,
                                                       self.searchController.searchBar.frame.origin.y,
                                                       self.searchController.searchBar.frame.size.width, 44.0);
    
    self.favoritesTable.tableHeaderView = self.searchController.searchBar;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchController.active)
    {
        return (self.searchResults).count;
    }
    else
    {
        return favouritesArray.count;
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
    label.text =  @"Friends Who Have Added Me";
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    
    view.backgroundColor = [UIColor colorWithRed:201/255.0 green:201/255.0 blue:206/255.0 alpha:1.0];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // NSLog(@"Index: %@ ",indexPath.row);
    static NSString *simpleTableIdentifierr = @"SimpleTableCell";
    UITableViewCell *cell ;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifierr];
    }

    storedNumber = [[NSUserDefaults standardUserDefaults]valueForKey:@"myPhoneNumber"];
    NSString *number;
    
    if(![[favouritesArray valueForKey:@"friendsnumber"][indexPath.row] isEqualToString:storedNumber])
        number = [favouritesArray valueForKey:@"friendsnumber"][indexPath.row];
    else if (![[favouritesArray valueForKey:@"mynumber"][indexPath.row] isEqualToString:storedNumber])
        number = [favouritesArray valueForKey:@"mynumber"][indexPath.row];
    else
        NSLog(@"No Number.");
    
    NSString *fullName;
    UILabel *name;
    
    fullName = [favouritesArray valueForKey:@"username"][indexPath.row];
    
    NSString *pic = [favouritesArray valueForKey:@"pic"][indexPath.row];
    
    name = [[UILabel alloc]initWithFrame:CGRectMake(60, 8, 120, 19)];
    UILabel *phonenumber = [[UILabel alloc]initWithFrame:CGRectMake(60, 29, 80, 20)];
    if(fullName !=nil)
    {
        name.text = fullName.capitalizedString;
        phonenumber.text = number;
    }
    
    name.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15.f];
    phonenumber.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:11.f];
    phonenumber.textColor = [UIColor grayColor];

    NSString *imagePathString = @"http://fajjemobile.info/iospanic/assets/upload/";
    imagePathString = [imagePathString stringByAppendingString:pic];
    
    NSURL *imagePathUrl = [NSURL URLWithString:imagePathString];
    NSData *data = [[NSData alloc]initWithContentsOfURL:imagePathUrl];
    img = [[UIImage alloc]initWithData:data];
    
    NSData* imageData = UIImagePNGRepresentation(img);
    [imagesArray addObject:imageData];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:img];
    imageView.frame = CGRectMake(10,5,40,40); //set these variables as you want
    imageView.layer.cornerRadius = 20;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [imageView setClipsToBounds:YES];
    
    if (cell.subviews){
        for (UIView *subview in (cell.contentView).subviews) {
            [subview removeFromSuperview];
        }
    }
    
    button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(cell.frame.origin.x + 250, 10, 60, 30);
    [button setTitle:@"Find" forState:UIControlStateNormal];
    button.tag = indexPath.row;
    button.backgroundColor = [UIColor blackColor];
    [button addTarget:self action:@selector(FindLocation:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell addSubview:name];
    [cell addSubview:phonenumber];
    [cell addSubview:imageView];
    [cell addSubview:button];
    return cell;
}

-(void)FindLocation:(id)sender{
    button = (UIButton *) sender;
    
    WebService *FindLocationRest = [[WebService alloc] init];
    favRestJsonArray = [FindLocationRest FilePath:BASEURL FIND_REST parameterOne:@"F" parameterTwo:[favouritesArray valueForKey:@"friendsnumber"][button.tag] parameterThree:FIND_MESSAGE];
    
    NSLog(@"the returned value are: %@",[favRestJsonArray valueForKey:@"success"]);
    
    if([[favRestJsonArray valueForKey:@"success"] isEqualToString: @"200"])
    {
        NSLog(@"in code");
        
        [button setTitle:@"PENDING" forState:normal];
        
        PFPush *push = [[PFPush alloc] init];
        [push setChannel:@"X_090078601"];   // channels column in PARSE!
        NSString *FindNotificationMessage = [[favouritesArray valueForKey:@"username"][button.tag] stringByAppendingString:@"is requesting your Location."];
        [push setMessage:FindNotificationMessage];
        //[push setData:data];
        [push sendPushInBackground];
    }
}

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
        vc.searchTableTitle = @"Favourites";
        vc.classType = @"favourites";
        // And reload the tableView with the new data
        [vc.tableView reloadData];
    }
}

// Update self.searchResults based on searchString, which is the argument in passed to this method
- (void)updateFilteredContentForAirlineName:(NSString *)airlineName
{
    if (airlineName == nil)
    {
        // If empty the search results are the same as the original data
        self.searchResults = [favouritesArray mutableCopy];
    }
    else
    {
        NSMutableArray *newSearchResult = [[NSMutableArray alloc] init];
        int dictionaryIndex = 0;
        // Else if the airline's name is
        for (NSDictionary *airline in favouritesArray)
        {
            dictionaryIndex ++;
            if (([[airline[@"username"] capitalizedString] containsString:airlineName]) || ([[airline[@"username"] uppercaseString] containsString:airlineName]) ||  ([[airline[@"username"] lowercaseString] containsString:airlineName]))
            {
                [airline setValue:[imagesArray objectAtIndex:dictionaryIndex-1] forKey:@"imageInNSData"];
                [newSearchResult addObject:airline];
            }
            self.searchResults = newSearchResult;
        }
    }
}

- (void)refreshTable
{
    [self.refresh endRefreshing];
    favouritesArray = nil;
    
    [progress startAnimating];
    dispatch_queue_t myqueue = dispatch_queue_create("myqueue", NULL);
    dispatch_async(myqueue, ^(void) {
        [Favorites favouritesList];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update UI on main queue
            
            [self.favoritesTable reloadData];
            [progress stopAnimating];
        });
    });
}

// ----- swipe to delete ----- //

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSLog(@"the delete array object is %@",[favouritesArray valueForKey:@"username"][indexPath.row]);
        
        WebService *updateMessage = [[WebService alloc] init];
        [updateMessage FilePath:@"http://fajjemobile.info/iospanic/deleteFriend.php" parameterOne:[favouritesArray valueForKey:@"mynumber"][indexPath.row] parameterTwo:[favouritesArray valueForKey:@"friendsnumber"][indexPath.row]];
        
        [favouritesArray removeObjectAtIndex:indexPath.row];
        [tableView reloadData];
    }
}

+ (NSMutableArray*)favouritesList
{
    WebService *favouritesService = [[WebService alloc] init];
    NSArray * favJson = [[NSArray alloc] init];
    //NSString *storedNumber = [[NSUserDefaults standardUserDefaults] valueForKey:@"myPhoneNumber"];
    
    if(favouritesArray == nil)
    {
        favJson = [favouritesService FilePath:@"http://fajjemobile.info/iospanic/favourites.php" parameterOne:[[NSUserDefaults standardUserDefaults]valueForKey:@"myPhoneNumber"]];
        favouritesArray = [[NSMutableArray alloc] init];
        for(NSDictionary *item in favJson)
        {
            [favouritesArray addObject:item];
            //NSLog(@" favouritesArray: %@", favouritesArray);
        }
    }
    return favouritesArray;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didDismissSearchController:(UISearchController *)searchController
{
    NSLog(@"search returned");
}

@end
