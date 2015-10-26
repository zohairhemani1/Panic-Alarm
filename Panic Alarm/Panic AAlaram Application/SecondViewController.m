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

@interface SecondViewController (){
    checkInternet *c;
    UIRefreshControl *refreshControl;
    UIButton *button;
    UIActivityIndicatorView *progress;
    NSMutableArray *resultArray;
    NSArray *searchResults;
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
    
    (self.myTable).separatorColor = [UIColor lightGrayColor];
    
    c= [[checkInternet alloc]init];
    [c viewWillAppear:YES];
    
    self.myTable.delegate=self;
    self.myTable.dataSource = self;
    
    progress = [c indicatorprogress:progress];
    [self.view addSubview:progress];
    
    [progress bringSubviewToFront:self.view];
    
    dispatch_queue_t myqueue = dispatch_queue_create("myqueue", NULL);
    dispatch_async(myqueue, ^(void) {
        
        [progress startAnimating];
        [self sendingJSONArrayToServer];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update UI on main queue
            
            [self.myTable reloadData];
            [progress stopAnimating];
        });
        
    });
    
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = self.myTable;
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    tableViewController.refreshControl = refreshControl;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return searchResults.count;
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
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 18)];
    label.font = [UIFont boldSystemFontOfSize:15];
    label.text = @"Friends Who Use Panic Alarm";
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    
    view.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSString *fullName;
    NSString *number;
    NSString *profilePic;
    
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    UITableViewCell *cell ;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        NSLog(@"in search text");
        NSLog(@"search count: %d",searchResults.count);
        fullName = [searchResults valueForKey:@"fullName"][indexPath.row];
        number = [searchResults valueForKey:@"password"][indexPath.row];
        profilePic = [searchResults valueForKey:@"picture"][indexPath.row];
    } else {
        fullName = [DistinctFriendsWhoUseApp valueForKey:@"fullName"][indexPath.row];
        number = [DistinctFriendsWhoUseApp valueForKey:@"password"][indexPath.row];
        profilePic = [DistinctFriendsWhoUseApp valueForKey:@"picture"][indexPath.row];
    }
    
    NSString *imagePathString = @"http://fajjemobile.info/iospanic/assets/upload/";
    imagePathString = [imagePathString stringByAppendingString:profilePic];
    
    NSURL *imagePathUrl = [NSURL URLWithString:imagePathString];
    NSData *data = [[NSData alloc]initWithContentsOfURL:imagePathUrl];
    UIImage *img = [[UIImage alloc]initWithData:data ];

    UIImageView *imageView = [[UIImageView alloc] initWithImage:img];
    imageView.frame = CGRectMake(10, 5, 40, 40);
    imageView.layer.cornerRadius = 20;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [imageView setClipsToBounds:YES];
    [cell addSubview:imageView];

    /*
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^(void) {
       
        
        if (img) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
        }
    });
    */
    
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(60, 6, 150, 20)];
    UILabel *phonenumber = [[UILabel alloc]initWithFrame:CGRectMake(60, 28, 80, 20)];
    if(fullName !=nil){
        
        name.text = fullName;
        phonenumber.text = number;
    }

    name.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17.f];
    [cell addSubview:name];
    phonenumber.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:11.f];
    phonenumber.textColor = [UIColor grayColor];
    [cell addSubview:phonenumber];
    
    button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    //set the position of the button
    
    NSString *activateValue = [DistinctFriendsWhoUseApp valueForKey:@"activate"][indexPath.row];
    button.frame = CGRectMake(cell.frame.origin.x + 250, 10, 60, 30);
    button.backgroundColor= [UIColor blackColor];
    if(activateValue != nil && [activateValue isEqual: @"0"])
    {
        NSLog(@"activate: --> %@, %ld",activateValue, (long)indexPath.row);
        
        [button setTitle:@"Accept" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(acceptFriendRequest:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if(activateValue != nil && [activateValue isEqual: @"00"])
    {
        NSLog(@"activate: --> %@, %ld",activateValue, (long)indexPath.row);
        
        [button setTitle:@"Pending" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(acceptFriendRequest:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        [button setTitle:@"ADD" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(addFriend:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    button.tag = indexPath.row;
   // NSLog(@"Button Tag: %ld", (long)button.tag);
    [cell.contentView addSubview:button];
    
    
    return cell;
    
}

- (void)acceptFriendRequest:(id)sender
{
    button = (UIButton*) sender;
    [button setBackgroundImage:[UIImage imageNamed:@"tick.png"] forState:UIControlStateNormal];
    
    NSString *numberToAccept = [DistinctFriendsWhoUseApp valueForKey:@"phoneNumber"][button.tag];
    NSString *nameToAccept = [DistinctFriendsWhoUseApp valueForKey:@"fullName"][button.tag];
    NSLog(@"Tapped Tag %ld: %@ %@", (long)button.tag, numberToAccept, nameToAccept);
    
    NSString *friendsNumber = @"X_090078601";
    
    PFPush *push = [[PFPush alloc] init];
    [push setChannel:friendsNumber];   // channels column in PARSE!
    [push setMessage:@"Zohair Hemani accepted your friend request"];  // Zohair Hemani will be replaced by sharedpreference name.
    [push sendPushInBackground];
    
    NSString * storedNumber = [[NSUserDefaults standardUserDefaults] valueForKey:@"myPhoneNumber"];
    
    NSLog(@"Stored Number: %@", storedNumber);
    NSLog(@"Number To Accept %@", numberToAccept);
    
    WebService *acceptRequest = [[WebService alloc] init];
    [acceptRequest FilePath:@"http://fajjemobile.info/iospanic/accept-button.php" parameterOne:storedNumber parameterTwo:numberToAccept];
    
    //03432637576 will be replaced by shared preference number
    
}

- (void)addFriend:(id)sender
{
    button = (UIButton*) sender;
    //[button setBackgroundImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateNormal];
    
   // NSString *numberToAdd = [DistinctFriendsWhoUseApp valueForKey:@"password"][button.tag];
   // NSString *nameToAdd = [DistinctFriendsWhoUseApp valueForKey:@"fullName"][button.tag];

    [button setTitle:@"Pending" forState:UIControlStateNormal];

    NSLog(@"Tapped Tag %ld: %@ %@", (long)button.tag, [DistinctFriendsWhoUseApp valueForKey:@"password"][button.tag],[DistinctFriendsWhoUseApp valueForKey:@"fullName"][button.tag] );
    
//    NSString *friendsNumber = @"X_03432637576";
//    
//    PFPush *push = [[PFPush alloc] init];
//    [push setChannel:friendsNumber];   // channels column in PARSE!
    
    NSString * storedName = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];

    NSString *message = @"You have been added by ";
    message = [message stringByAppendingString:storedName];
    
//    [push setMessage:message];
//    
//    [push sendPushInBackground];
    
    WebService *addFriend = [[WebService alloc] init];
    [addFriend FilePath:@"http://fajjemobile.info/iospanic/friends.php" parameterOne:@"+923152151511"
           parameterTwo:@""];
    
}

- (void)refreshTable
{
    [self sendingJSONArrayToServer];
    [self.myTable reloadData];
    [refreshControl endRefreshing];
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
    else if (jsonData.length == 0 && error == nil){
        NSLog(@"No data was returned after serialization.");
    }
    else if (error != nil){
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

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
   // [searchResults removeAllObjects];
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@", searchText];
    searchResults = [DistinctFriendsWhoUseApp filteredArrayUsingPredicate:resultPredicate];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
        [self filterContentForSearchText:searchString
                               scope:(self.searchDisplayController.searchBar).scopeButtonTitles[(self.searchDisplayController.searchBar).selectedScopeButtonIndex]];
    return YES;
}

@end
