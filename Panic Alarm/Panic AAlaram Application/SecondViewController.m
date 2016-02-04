//
//  SecondViewController.m
//  Panic AAlaram Application
//
//  Created by Zohair Hemani on 30/04/2014.
//  Copyright (c) 2014 Zohair Hemani - Stanford Assignment. All rights reserved.
//

#import "SecondViewController.h"
#import "WebService.h"
#import <Parse/Parse.h>
#import "checkInternet.h"


@interface SecondViewController ()
{
    checkInternet *c;
    UIRefreshControl *refreshControl;
    UIButton *button;
    UIActivityIndicatorView *progress;
    NSMutableArray *resultArray;
    NSArray *searchResults;
    NSMutableArray *imagesArray;
}

@end

@implementation SecondViewController
@synthesize myTable;

static NSMutableArray *friendsWhoUseApp;
static NSMutableArray *finalArray;

NSArray *DistinctFriendsWhoUseApp;

+ (NSMutableArray *)friendWhoUseAppStaticFunction
{
    if (!friendsWhoUseApp)
        friendsWhoUseApp = [[NSMutableArray alloc] initWithCapacity:4000];
    
    return friendsWhoUseApp;
}

+ (NSMutableArray *)finalArrayStaticFunction
{
    if (!finalArray)
        finalArray  = [[NSMutableArray alloc] init];
    
    return finalArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *backgroundImage = [UIImage imageNamed:@"background_tabone"];
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:backgroundImage];
    
    self.refresh = [[UIRefreshControl alloc] init];
    [self.refresh addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    [self.myTable addSubview:self.refresh];
    
    (self.myTable).separatorColor = [UIColor lightGrayColor];
    
    c= [[checkInternet alloc]init];
    [c viewWillAppear:YES];
    
    progress = [c indicatorprogress:progress];
    [self.view addSubview:progress];
    
    [progress bringSubviewToFront:self.view];
    [progress startAnimating];
    dispatch_queue_t myqueue = dispatch_queue_create("myqueue", NULL);
    dispatch_async(myqueue, ^(void) {
        
        [self sendingJSONArrayToServer];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update UI on main queue
            
            [self.myTable reloadData];
            [progress stopAnimating];
        });
        
    });
    
    imagesArray = [[NSMutableArray alloc]init];
    
//    UITableViewController *tableViewController = [[UITableViewController alloc] init];
//    tableViewController.tableView = self.myTable;
//    
//    refreshControl = [[UIRefreshControl alloc] init];
//    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
//    tableViewController.refreshControl = refreshControl;
    
    UINavigationController *searchResultsController = [self.storyboard instantiateViewControllerWithIdentifier:@"TableSearchResultsNavController"];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:searchResultsController];
    
    self.searchController.searchResultsUpdater = self;
    self.searchController.delegate = self;
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x,
                                                       self.searchController.searchBar.frame.origin.y,
                                                       self.searchController.searchBar.frame.size.width, 44.0);
    
    self.myTable.tableHeaderView = self.searchController.searchBar;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchController.active)
    {
        return (self.searchResults).count;
    }
    else
    {
        return DistinctFriendsWhoUseApp.count;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
    label.text = @"Friends Who Use Panic Alarm";
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    
    view.backgroundColor = [UIColor colorWithRed:201/255.0 green:201/255.0 blue:206/255.0 alpha:1.0];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    UITableViewCell *cell ;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    
    NSString *fullName = [DistinctFriendsWhoUseApp valueForKey:@"fullName"][indexPath.row];
    NSString *number = [DistinctFriendsWhoUseApp valueForKey:@"password"][indexPath.row];
    NSString *profilePic = [DistinctFriendsWhoUseApp valueForKey:@"picture"][indexPath.row];
    NSString *accReq = [DistinctFriendsWhoUseApp valueForKey:@"accReq"][indexPath.row];
    NSString *activate = [DistinctFriendsWhoUseApp valueForKey:@"activate"][indexPath.row];
    
    NSString *imagePathString = @"http://fajjemobile.info/iospanic/assets/upload/";
    imagePathString = [imagePathString stringByAppendingString:profilePic];
    
    NSURL *imagePathUrl = [NSURL URLWithString:imagePathString];
    NSData *data = [[NSData alloc]initWithContentsOfURL:imagePathUrl];
    UIImage *img = [[UIImage alloc]initWithData:data];
    
    NSData* imageData = UIImageJPEGRepresentation(img, 1.0);
    [imagesArray addObject:imageData];

    UIImageView *imageView = [[UIImageView alloc] initWithImage:img];
    imageView.frame = CGRectMake(10, 5, 40, 40);
    imageView.layer.cornerRadius = 20;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [imageView setClipsToBounds:YES];
    [cell addSubview:imageView];
    
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(60, 6, 150, 20)];
    UILabel *phonenumber = [[UILabel alloc]initWithFrame:CGRectMake(60, 28, 80, 20)];
    
    if(fullName !=nil)
    {
        name.text = [fullName uppercaseString];
        phonenumber.text = number;
    }

    name.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15.f];
    phonenumber.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:11.f];
    phonenumber.textColor = [UIColor grayColor];
    
    button = [[UIButton alloc]initWithFrame:CGRectMake(cell.frame.origin.x + 235, 07, 60, 36)];
    
    
    if([activate isKindOfClass:[NSNull class]])
    {
        NSLog(@"in first condition");
        
        [button setBackgroundImage:[UIImage imageNamed:@"add_friend"] forState:normal];
        [button addTarget:self action:@selector(addFriend:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    else if(activate != nil && [activate isEqual: @"0"])
    {
        if (accReq != nil && [accReq isEqual: @"0"]) {
            [button setBackgroundImage:[UIImage imageNamed:@"accept_friend"] forState:normal];
            [button addTarget:self action:@selector(acceptFriendRequest:) forControlEvents:UIControlEventTouchUpInside];

        }
        else if (accReq != nil && [accReq isEqual: @"1"])
        {
            [button setBackgroundImage:[UIImage imageNamed:@"req_sent"] forState:normal];
            //[button addTarget:self action:@selector(acceptFriendRequest:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
//    else
//    {
//         NSLog(@"activate3: --> %@, %ld",activateValue, (long)indexPath.row);
//        [button setBackgroundImage:[UIImage imageNamed:@"add_friend"] forState:normal];
//        [button addTarget:self action:@selector(addFriend:) forControlEvents:UIControlEventTouchUpInside];
//    }
    
    button.tag = indexPath.row;
    [cell addSubview:button];
    [cell addSubview:phonenumber];
    [cell addSubview:name];
    return cell;
}

- (void)acceptFriendRequest:(id)sender
{
    button = (UIButton*) sender;
    //[button setBackgroundImage:[UIImage imageNamed:@"accept_friend"] forState:UIControlStateNormal];
    
    [button setHidden:true];
    
    NSString *numberToAccept = [DistinctFriendsWhoUseApp valueForKey:@"password"][button.tag];
    NSString *nameToAccept = [DistinctFriendsWhoUseApp valueForKey:@"fullName"][button.tag];
    NSLog(@"Tapped Tag %ld: %@ %@", (long)button.tag, numberToAccept, nameToAccept);
    
    NSString *msg = [NSString stringWithFormat:@"%@ accepted your friend request",[DistinctFriendsWhoUseApp valueForKey:@"fullName"][button.tag]];
    
    NSDictionary *data = @{
                           @"alert": msg,
                           @"name": [DistinctFriendsWhoUseApp valueForKey:@"fullName"][button.tag],
                           @"number": numberToAccept,
                           @"sound":@"cheering.caf"
                           };
    
    PFPush *push = [[PFPush alloc] init];
    
    NSString *friendsNumber = @"X_";
    friendsNumber = [friendsNumber stringByAppendingString:[numberToAccept substringFromIndex:1]];

    
    [push setChannel:friendsNumber];   // channels column in PARSE!
    [push setMessage:[NSString stringWithFormat:@"%@ accepted your friend request",nameToAccept]];
    [push setData:data];
    [push sendPushInBackground];
    
    NSString * storedNumber = [[NSUserDefaults standardUserDefaults] valueForKey:@"myPhoneNumber"];
    
    NSLog(@"Stored Number: %@", storedNumber);
    NSLog(@"Number To Accept %@", numberToAccept);
    
    WebService *acceptRequest = [[WebService alloc] init];
    [acceptRequest FilePath:@"http://fajjemobile.info/iospanic/accept-button.php" parameterOne:storedNumber parameterTwo:numberToAccept];
}

- (void)addFriend:(id)sender
{
    button = (UIButton*) sender;
    
    NSString *numberToAdd = [DistinctFriendsWhoUseApp valueForKey:@"password"][button.tag];
    NSString *nameToAdd = [DistinctFriendsWhoUseApp valueForKey:@"fullName"][button.tag];

    [button setBackgroundImage:[UIImage imageNamed:@"req_sent"] forState:normal];

    NSString *msg = [NSString stringWithFormat:@"%@ has sent you a friend request",nameToAdd];
    
    NSDictionary *data = @{
                           @"alert": msg,
                           @"name": nameToAdd,
                           @"number": numberToAdd,
                           @"sound":@"cheering.caf"
                           };
    
    NSString *friendsNumber = @"X_"; // is pe notification jati hai
    friendsNumber = [friendsNumber stringByAppendingString:[numberToAdd substringFromIndex:1]];
    
    PFPush *push = [[PFPush alloc] init];
    [push setChannel:friendsNumber];   // channels column in PARSE!

    
    [push setMessage:msg];
    [push setData:data];
    [push sendPushInBackground];
    
    WebService *addFriend = [[WebService alloc] init];
    [addFriend FilePath:@"http://fajjemobile.info/iospanic/add_friends.php" parameterOne:[DistinctFriendsWhoUseApp valueForKey:@"password"][button.tag] parameterTwo:@""];
    
}

-(void)sendingJSONArrayToServer
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:SecondViewController.finalArrayStaticFunction
                        options:NSJSONWritingPrettyPrinted
                        error:&error];
    if (jsonData.length > 0 &&
        error == nil)
    {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                     encoding:NSUTF8StringEncoding];

        WebService *myWebService = [[WebService alloc] init];
        resultArray = [myWebService FilePath:@"http://fajjemobile.info/iospanic/json-contacts.php" parameterOne:jsonString parameterTwo:[[NSUserDefaults standardUserDefaults]valueForKey:@"myPhoneNumber"]];
        
        if (!resultArray)
        {
            NSLog(@"Error parsing JSON: %@", error);
        }
        else
        {
            //int arrayCount = resultArray.count;
            
            for (int i = 0; i < resultArray.count; i++)
            {
                NSString *firstNumber = [[resultArray[i] valueForKey:@"phoneNumber"] substringFromIndex: [[resultArray[i] valueForKey:@"phoneNumber"] length] - 10];
                
                for (int k = i+1 ; k < resultArray.count; k++)
                {
                    NSString *secondNumber = [[resultArray[k] valueForKey:@"phoneNumber"] substringFromIndex: [[resultArray[k] valueForKey:@"phoneNumber"] length] - 10];
 
                    if([firstNumber isEqualToString:secondNumber])
                    {
                        [resultArray removeObjectAtIndex:k];
                        k = k-1;
                    }
                }
            }
            friendsWhoUseApp = resultArray;
        }
    }
    else if (jsonData.length == 0 && error == nil)
    {
        NSLog(@"No data was returned after serialization.");
    }
    else if (error != nil)
    {
        NSLog(@"An error happened = %@", error);
    }
    
    DistinctFriendsWhoUseApp = [SecondViewController.friendWhoUseAppStaticFunction copy];
    
    NSInteger index = DistinctFriendsWhoUseApp.count - 1;
    
    for (id object in [DistinctFriendsWhoUseApp reverseObjectEnumerator]) {
        
        if ([friendsWhoUseApp
             indexOfObject:object inRange:NSMakeRange(0, index)]
            != NSNotFound)
        {
            [friendsWhoUseApp removeObjectAtIndex:index];
        }
        index--;
    }
    // ending funtion here
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
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
        vc.searchTableTitle = @"Contacts";
        vc.classType = @"contacts";
        // And reload the tableView with the new data
        [vc.tableView reloadData];
    }
}


// Update self.searchResults based on searchString, which is the argument in passed to this method
- (void)updateFilteredContentForAirlineName:(NSString *)airlineName
{
    if (airlineName == nil)
    {
        self.searchResults = [DistinctFriendsWhoUseApp mutableCopy];
    }
    else
    {
        NSMutableArray *newSearchResult = [[NSMutableArray alloc] init];
        int dictionaryIndex = 0;
        // Else if the airline's name is
        for (NSDictionary *airline in DistinctFriendsWhoUseApp)
        {
            dictionaryIndex ++;
            if (([[airline[@"fullName"] capitalizedString] containsString:airlineName]) || ([[airline[@"fullName"] uppercaseString] containsString:airlineName]) ||  ([[airline[@"fullName"] lowercaseString] containsString:airlineName]))
            {
                [airline setValue:[imagesArray objectAtIndex:dictionaryIndex-1] forKey:@"imageInNSData"];
                [newSearchResult addObject:airline];
            }
            self.searchResults = newSearchResult;
        }
    }
}

- (void)didDismissSearchController:(UISearchController *)searchController
{
    DistinctFriendsWhoUseApp = nil;
    [progress startAnimating];
    dispatch_queue_t myqueue = dispatch_queue_create("myqueue", NULL);
    
    dispatch_async(myqueue, ^(void) {
        [self sendingJSONArrayToServer];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update UI on main queue
            
            [self.myTable reloadData];
            [progress stopAnimating];
        });
    });
}

- (void)refreshTable
{
    [self.refresh endRefreshing];
    DistinctFriendsWhoUseApp = nil;
    [progress startAnimating];
    dispatch_queue_t myqueue = dispatch_queue_create("myqueue", NULL);
    
    dispatch_async(myqueue, ^(void) {
        [self sendingJSONArrayToServer];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update UI on main queue
            
            [self.myTable reloadData];
            [progress stopAnimating];
        });
    });
}

@end
