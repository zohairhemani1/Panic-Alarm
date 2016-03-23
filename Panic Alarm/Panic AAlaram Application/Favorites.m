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
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"

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
    
    //UINavigationController *searchResultsController = [self.storyboard instantiateViewControllerWithIdentifier:@"TableSearchResultsNavController"];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    
    self.searchController.searchResultsUpdater = self;
    self.searchController.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x,
                                                       self.searchController.searchBar.frame.origin.y,
                                                       self.searchController.searchBar.frame.size.width, 44.0);
    
    self.favoritesTable.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = YES;
    
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = searchController.searchBar.text;
    [self filterContentForSearchText:searchString scope:nil];
    [self.favoritesTable reloadData];
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    if ([searchText isEqualToString:@""])
    {
        self.searchResults = [favouritesArray mutableCopy];
    }
    else
    {
        NSMutableArray *newSearchResult = [[NSMutableArray alloc] init];
        int dictionaryIndex = 0;
        for (NSDictionary *insideObject in favouritesArray)
        {
            dictionaryIndex ++;
            if ([[insideObject[@"username"] capitalizedString] containsString:[searchText capitalizedString]])
            {
                [newSearchResult addObject:insideObject];
            }
        }
        self.searchResults = newSearchResult;
    }
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
    UITableViewCell *cell;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifierr];
    }

    storedNumber = [[NSUserDefaults standardUserDefaults]valueForKey:@"myPhoneNumber"];
    NSString *number;
    NSString *pic;
    NSString *fullName;
    UILabel *name;
    UILabel *phonenumber;
    
    if(self.searchController.active)
    {
        if(![[self.searchResults valueForKey:@"friendsnumber"][indexPath.row] isEqualToString:storedNumber])
            number = [self.searchResults valueForKey:@"friendsnumber"][indexPath.row];
        else if (![[self.searchResults valueForKey:@"mynumber"][indexPath.row] isEqualToString:storedNumber])
            number = [self.searchResults valueForKey:@"mynumber"][indexPath.row];
        
        fullName = [self.searchResults valueForKey:@"username"][indexPath.row];
        
        pic = [self.searchResults valueForKey:@"pic"][indexPath.row];
    }
    else
    {
        if(![[favouritesArray valueForKey:@"friendsnumber"][indexPath.row] isEqualToString:storedNumber])
            number = [favouritesArray valueForKey:@"friendsnumber"][indexPath.row];
        else if (![[favouritesArray valueForKey:@"mynumber"][indexPath.row] isEqualToString:storedNumber])
            number = [favouritesArray valueForKey:@"mynumber"][indexPath.row];
        
        fullName = [favouritesArray valueForKey:@"username"][indexPath.row];
        
        pic = [favouritesArray valueForKey:@"pic"][indexPath.row];
    }
    
    name = [[UILabel alloc]initWithFrame:CGRectMake(60, 8, 140, 19)];
    phonenumber = [[UILabel alloc]initWithFrame:CGRectMake(60, 25, 80, 20)];
    
    if(fullName !=nil)
    {
        name.text = fullName.uppercaseString;
        phonenumber.text = number;
    }
    
    name.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.f];
    phonenumber.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:11.f];
    phonenumber.textColor = [UIColor grayColor];

    NSString *imagePathString = @"http://steve-jones.co/iospanic/assets/upload/";
    imagePathString = [imagePathString stringByAppendingString:pic];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(10,5,40,40); //set these variables as you want
    imageView.layer.cornerRadius = 20;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [imageView setClipsToBounds:YES];
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:imagePathString] placeholderImage:[UIImage imageNamed:@"no_image"] options:SDWebImageCacheMemoryOnly];
    
    if (cell.subviews)
    {
        for (UIView *subview in (cell.contentView).subviews)
        {
            [subview removeFromSuperview];
        }
    }
    
    button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(cell.frame.origin.x + 210, 10, 100, 30);
    button.clipsToBounds = YES;
    button.layer.cornerRadius = 5;
    [button setTitle:@"Find" forState:UIControlStateNormal];
    button.tag = indexPath.row;
    button.backgroundColor = [UIColor colorWithRed:89.0f/255 green:34.0f/255 blue:122.0f/255 alpha:1.0];
    [button addTarget:self action:@selector(FindLocation:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell addSubview:name];
    [cell addSubview:phonenumber];
    [cell addSubview:imageView];
    [cell addSubview:button];
    return cell;
}

-(void)FindLocation:(id)sender{
    button = (UIButton *) sender;
    
    button.enabled = false;
    
    storedNumber = [[NSUserDefaults standardUserDefaults]valueForKey:@"myPhoneNumber"];
    NSString *number;
    NSString *name;
    
    if(self.searchController.active)
    {
        if(![[self.searchResults valueForKey:@"friendsnumber"][button.tag] isEqualToString:storedNumber])
            number = [self.searchResults valueForKey:@"friendsnumber"][button.tag];
        else if (![[self.searchResults valueForKey:@"mynumber"][button.tag] isEqualToString:storedNumber])
            number = [self.searchResults valueForKey:@"mynumber"][button.tag];
        
        name = [self.searchResults valueForKey:@"username"][button.tag];
    }
    else
    {
        if(![[favouritesArray valueForKey:@"friendsnumber"][button.tag] isEqualToString:storedNumber])
            number = [favouritesArray valueForKey:@"friendsnumber"][button.tag];
        else if (![[favouritesArray valueForKey:@"mynumber"][button.tag] isEqualToString:storedNumber])
            number = [favouritesArray valueForKey:@"mynumber"][button.tag];
        
        name = [favouritesArray valueForKey:@"username"][button.tag];
    }
    
    WebService *FindLocationRest = [[WebService alloc] init];
    favRestJsonArray = [FindLocationRest FilePath:BASEURL FIND_REST parameterOne:@"F" parameterTwo:number parameterThree:FIND_MESSAGE];
    
    if([[favRestJsonArray valueForKey:@"success"] isEqualToString: @"200"])
    {
        [self showAlertBoxWithTitle:@"Request sent" message:[NSString stringWithFormat:@"Location request to %@ is sent successfully",name]];
        
        NSString *msg = [NSString stringWithFormat:@"%@ has requested your location",[[NSUserDefaults standardUserDefaults]valueForKey:@"username"]];
        
        NSDictionary *data = @{
                               @"alert": msg,
                               @"name": name,
                               @"number": number,
                               @"sound":@"cheering.caf"
                               };

        PFPush *push = [[PFPush alloc] init];
        NSString *friendsNumber = @"X_";
        friendsNumber = [friendsNumber stringByAppendingString:[number substringFromIndex:1]];
        [push setChannel:friendsNumber];   // channels column in PARSE!
        NSString *FindNotificationMessage = [name stringByAppendingString:@" is requesting your Location."];
        [push setMessage:FindNotificationMessage];
        [push setData:data];
        [push sendPushInBackground];
        button.enabled = true;
    }
    else
    {
        button.enabled = true;
    }
}

//- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
//{
//    NSString *searchString = self.searchController.searchBar.text;
//    
//    [self updateFilteredContentForAirlineName:searchString];
//    
//    // If searchResultsController
//    if (self.searchController.searchResultsController) {
//        
//        UINavigationController *navController = (UINavigationController *)self.searchController.searchResultsController;
//        
//        // Present SearchResultsTableViewController as the topViewController
//        SearchResultsTableViewController *vc = (SearchResultsTableViewController *)navController.topViewController;
//        
//        // Update searchResults
//        vc.searchResults = self.searchResults;
//        vc.searchTableTitle = @"Favourites";
//        vc.classType = @"favourites";
//        // And reload the tableView with the new data
//        [vc.tableView reloadData];
//    }
//}
//
//// Update self.searchResults based on searchString, which is the argument in passed to this method
//- (void)updateFilteredContentForAirlineName:(NSString *)airlineName
//{
//    if (airlineName == nil)
//    {
//        // If empty the search results are the same as the original data
//        self.searchResults = [favouritesArray mutableCopy];
//    }
//    else
//    {
//        NSMutableArray *newSearchResult = [[NSMutableArray alloc] init];
//        int dictionaryIndex = 0;
//        // Else if the airline's name is
//        for (NSDictionary *airline in favouritesArray)
//        {
//            dictionaryIndex ++;
//            if (([[airline[@"username"] capitalizedString] containsString:airlineName]) || ([[airline[@"username"] uppercaseString] containsString:airlineName]) ||  ([[airline[@"username"] lowercaseString] containsString:airlineName]))
//            {
//                [airline setValue:[imagesArray objectAtIndex:dictionaryIndex-1] forKey:@"imageInNSData"];
//                [newSearchResult addObject:airline];
//            }
//            self.searchResults = newSearchResult;
//        }
//    }
//}

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
        [updateMessage FilePath:@"http://steve-jones.co/iospanic/deleteFriend.php" parameterOne:[favouritesArray valueForKey:@"mynumber"][indexPath.row] parameterTwo:[favouritesArray valueForKey:@"friendsnumber"][indexPath.row]];
        
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
        favJson = [favouritesService FilePath:@"http://steve-jones.co/iospanic/favourites.php" parameterOne:[[NSUserDefaults standardUserDefaults]valueForKey:@"myPhoneNumber"]];
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
    [self.favoritesTable reloadData];
}

-(void)showAlertBoxWithTitle:(NSString*)title message:(NSString*)message
{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"Okay"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                         }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
