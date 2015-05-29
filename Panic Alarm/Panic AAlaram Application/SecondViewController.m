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
}

@end

@implementation SecondViewController
@synthesize myTable;

static NSMutableArray *friendsWhoUseApp;
static NSMutableArray *finalArray;
NSArray *searchResults;
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResults count];
        
    } else {
        return [DistinctFriendsWhoUseApp count];
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section

{
    tableView.sectionHeaderHeight = 30.0;
    
    return @"Friends Who Use Panic Alarm";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSString *fullName;
    NSString *number;
    NSString *profilePic;
    
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        fullName = [[searchResults valueForKey:@"fullName"] objectAtIndex:indexPath.row];
        number = [[searchResults valueForKey:@"phoneNumber"] objectAtIndex:indexPath.row];
        profilePic = [[searchResults valueForKey:@"0"] objectAtIndex:indexPath.row];
    } else {
        fullName = [[DistinctFriendsWhoUseApp valueForKey:@"fullName"] objectAtIndex:indexPath.row];
        number = [[DistinctFriendsWhoUseApp valueForKey:@"phoneNumber"] objectAtIndex:indexPath.row];
        profilePic = [[DistinctFriendsWhoUseApp valueForKey:@"0"] objectAtIndex:indexPath.row];
    }
    NSLog(@"Profile Picture %@ for Username %@",profilePic,fullName);
    
    
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

    [name setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17.f]];
    [cell addSubview:name];
    [phonenumber setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:11.f]];
    phonenumber.textColor = [UIColor grayColor];
    [cell addSubview:phonenumber];
    
    button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    //set the position of the button
    
    NSString *activateValue = [[DistinctFriendsWhoUseApp valueForKey:@"activate"] objectAtIndex:indexPath.row];
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
    NSLog(@"Button Tag: %ld", (long)button.tag);
    [cell.contentView addSubview:button];
    
    
    return cell;
    
}

- (void)acceptFriendRequest:(id)sender
{
    button = (UIButton*) sender;
    [button setBackgroundImage:[UIImage imageNamed:@"tick.png"] forState:UIControlStateNormal];
    
    NSString *numberToAccept = [[DistinctFriendsWhoUseApp valueForKey:@"phoneNumber"] objectAtIndex:button.tag];
    NSString *nameToAccept = [[DistinctFriendsWhoUseApp valueForKey:@"fullName"] objectAtIndex:button.tag];
    NSLog(@"Tapped Tag %ld: %@ %@", (long)button.tag, numberToAccept, nameToAccept);
    
    NSString *friendsNumber = @"X_090078601";
    
    PFPush *push = [[PFPush alloc] init];
    [push setChannel:friendsNumber];   // channels column in PARSE!
    [push setMessage:@"Zohair Hemani accepted your friend request"];  // Zohair Hemani will be replaced by sharedpreference name.
    [push sendPushInBackground];
    
    NSString * storedNumber = [[NSUserDefaults standardUserDefaults] stringForKey:@"password"];
    
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
    
    NSString *numberToAdd = [[DistinctFriendsWhoUseApp valueForKey:@"phoneNumber"] objectAtIndex:button.tag];
    NSString *nameToAdd = [[DistinctFriendsWhoUseApp valueForKey:@"fullName"] objectAtIndex:button.tag];

    [button setTitle:@"Pending" forState:UIControlStateNormal];

    NSLog(@"Tapped Tag %ld: %@ %@", (long)button.tag, [[DistinctFriendsWhoUseApp valueForKey:@"phoneNumber"] objectAtIndex:button.tag],[[DistinctFriendsWhoUseApp valueForKey:@"fullName"] objectAtIndex:button.tag] );
    
    NSString *friendsNumber = @"X_03432637576";
    
    PFPush *push = [[PFPush alloc] init];
    [push setChannel:friendsNumber];   // channels column in PARSE!
    
    NSString * storedName = [[NSUserDefaults standardUserDefaults] stringForKey:@"name"];

    
    NSString *message = @"You have been added by ";
    message = [message stringByAppendingString:storedName];
    
    [push setMessage:message];
    
    [push sendPushInBackground];
    
    WebService *addFriend = [[WebService alloc] init];
    [addFriend FilePath:@"http://fajjemobile.info/iospanic/friends.php" parameterOne:numberToAdd
           parameterTwo:@""];
    
}

- (void)refreshTable {
    //TODO: refresh your data
    
    [self sendingJSONArrayToServer];
    [self.myTable reloadData];
    [refreshControl endRefreshing];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.myTable setSeparatorColor:[UIColor lightGrayColor]];
    
    c= [[checkInternet alloc]init];
    [c viewWillAppear:YES];
    
    self.myTable.delegate=self;
    self.myTable.dataSource = self;

    [self.view setBackgroundColor:[UIColor blackColor]];
    
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

-(void)sendingJSONArrayToServer
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:SecondViewController.finalArrayStaticFunction
                        options:NSJSONWritingPrettyPrinted
                        error:&error];
    if ([jsonData length] > 0 &&
        error == nil)
    {
        //NSLog(@"Successfully serialized the dictionary into data = %@", jsonData);
        NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                     encoding:NSUTF8StringEncoding];
        //NSLog(@"JSON String = %@", jsonString);
        //NSLog(@"String: %@",jsonString);
        WebService *myWebService = [[WebService alloc] init];
        resultArray = [myWebService FilePath:@"http://fajjemobile.info/iospanic/json-contacts.php" parameterOne:jsonString];
        
        if (!resultArray) {
            NSLog(@"Error parsing JSON: %@", error);
        } else {
            for(NSDictionary *item in resultArray)
            {
                NSLog(@" Contact: %@", item);
                
                bool foundMatch = NO;
                
                for (int i=0; i<[friendsWhoUseApp count]; i++)
                {
                    
                    NSString *p = [friendsWhoUseApp[i] valueForKey:@"friendsnumber"];
                    NSString *q = [friendsWhoUseApp[i] valueForKey:@"phoneNumber"];
                    
                    if([[item valueForKey:@"phoneNumber"] isEqualToString:p] || [[item valueForKey:@"phoneNumber"] isEqualToString:q])
                    {
                        //[SecondViewController.friendWhoUseAppStaticFunction removeObject:item];
                        NSLog(@"Found Object that needs to be removed! %@", item);
                        foundMatch = YES;
                        
                    }
                }
                
                if (foundMatch==NO)
                {
                    [SecondViewController.friendWhoUseAppStaticFunction addObject:item];
                    
                }

            }
        }
        
        
    }
    else if ([jsonData length] == 0 &&
             error == nil){
        NSLog(@"No data was returned after serialization.");
    }
    else if (error != nil){
        NSLog(@"An error happened = %@", error);
    }
    
    
    DistinctFriendsWhoUseApp = [SecondViewController.friendWhoUseAppStaticFunction copy];
    
    NSInteger index = [DistinctFriendsWhoUseApp count] - 1;
    
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
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", searchText];
    searchResults = [DistinctFriendsWhoUseApp filteredArrayUsingPredicate:resultPredicate];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

@end
