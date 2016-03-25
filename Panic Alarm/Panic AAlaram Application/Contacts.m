//
//  Contacts.m
//  Panic AAlaram Application
//
//  Created by Zohair Hemani on 30/04/2014.
//  Copyright (c) 2014 Zohair Hemani - Stanford Assignment. All rights reserved.
//

#import "Contacts.h"
#import "WebService.h"
#import <Parse/Parse.h>
#import "checkInternet.h"
#import "UIImageView+WebCache.h"


@interface Contacts ()
{
    checkInternet *c;
    UIRefreshControl *refreshControl;
    UIButton *button;
    UIActivityIndicatorView *progress;
    NSMutableArray *resultArray;
    NSMutableArray *searchResults;
    NSMutableArray *imagesArray;
    NSString *numberToAccept;
    NSString *nameToAccept;
}

@end

@implementation Contacts
@synthesize myTable;

static NSMutableArray *friendsWhoUseApp;
static NSMutableArray *finalArray;

NSMutableArray *DistinctFriendsWhoUseApp;

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
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    
    self.searchController.searchResultsUpdater = self;
    self.searchController.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x,
                                                       self.searchController.searchBar.frame.origin.y,
                                                       self.searchController.searchBar.frame.size.width, 44.0);
    
    self.myTable.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = YES;
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = searchController.searchBar.text;
    [self filterContentForSearchText:searchString scope:nil];
    [self.myTable reloadData];
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
        if([searchText isEqualToString:@""])
        {
            searchResults = [DistinctFriendsWhoUseApp mutableCopy];
        }
        else
        {
            NSMutableArray *newSearchResult = [[NSMutableArray alloc] init];
            int dictionaryIndex = 0;
            for (NSDictionary *insideObject in DistinctFriendsWhoUseApp)
            {
                dictionaryIndex ++;
                if ([[insideObject[@"fullName"] capitalizedString] containsString:[searchText capitalizedString]]) 
                {
                    [newSearchResult addObject:insideObject];
                }
            }
            searchResults = newSearchResult;
        }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchController.active)
    {
        return (searchResults).count;
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
    label.text = @"Friends Who Use E~Alarm";
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
    NSString *fullName;
    NSString *number;
    NSString *profilePic;
    NSString *accReq;
    NSString *activate;
    
    if (self.searchController.active) {
        fullName = [searchResults valueForKey:@"fullName"][indexPath.row];
        number = [searchResults valueForKey:@"password"][indexPath.row];
        profilePic = [searchResults valueForKey:@"picture"][indexPath.row];
        accReq = [searchResults valueForKey:@"accReq"][indexPath.row];
        activate = [searchResults valueForKey:@"activate"][indexPath.row];
    }
    else
    {
        fullName = [DistinctFriendsWhoUseApp valueForKey:@"fullName"][indexPath.row];
        number = [DistinctFriendsWhoUseApp valueForKey:@"password"][indexPath.row];
        profilePic = [DistinctFriendsWhoUseApp valueForKey:@"picture"][indexPath.row];
        accReq = [DistinctFriendsWhoUseApp valueForKey:@"accReq"][indexPath.row];
        activate = [DistinctFriendsWhoUseApp valueForKey:@"activate"][indexPath.row];
    }
    
    NSString *imagePathString = @"http://steve-jones.co/iospanic/assets/upload/";
    imagePathString = [imagePathString stringByAppendingString:profilePic];
    

    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(10, 5, 40, 40);
    imageView.layer.cornerRadius = 20;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [imageView setClipsToBounds:YES];
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:imagePathString] placeholderImage:[UIImage imageNamed:@"no_image"] options:SDWebImageCacheMemoryOnly];
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
        }
    }
    
    button.tag = indexPath.row;
    [cell addSubview:button];
    [cell addSubview:phonenumber];
    [cell addSubview:name];
    return cell;
}

- (void)acceptFriendRequest:(id)sender
{
    [progress startAnimating];
    
    button = (UIButton*) sender;
    button.enabled = false;
    
    if(self.searchController.active)
    {
        numberToAccept = [searchResults valueForKey:@"password"][button.tag];
        nameToAccept = [searchResults valueForKey:@"fullName"][button.tag];
    }
    else
    {
        numberToAccept = [DistinctFriendsWhoUseApp valueForKey:@"password"][button.tag];
        nameToAccept = [DistinctFriendsWhoUseApp valueForKey:@"fullName"][button.tag];
    }
    
    NSString * storedNumber = [[NSUserDefaults standardUserDefaults] valueForKey:@"myPhoneNumber"];
    
    WebService *acceptRequest = [[WebService alloc] init];
    NSMutableArray *acceptRequestResultArray = [acceptRequest FilePath:@"http://steve-jones.co/iospanic/accept-button.php" parameterOne:storedNumber parameterTwo:numberToAccept];
    
    if([[acceptRequestResultArray valueForKey:@"status"] isEqualToString: @"1"])
    {
        [progress stopAnimating];
        [self sendingPush];
        
        if(self.searchController.active)
        {
            for(int i =0; i<DistinctFriendsWhoUseApp.count; i++)
            {
                if([[DistinctFriendsWhoUseApp valueForKey:@"password"][i] isEqualToString:[searchResults valueForKey:@"password"][[sender tag]]])
                {
                    [searchResults removeObjectAtIndex:[sender tag]];
                    [DistinctFriendsWhoUseApp removeObjectAtIndex:i];
                    [self.myTable reloadData];
                }
            }
        }
        else
        {
            [DistinctFriendsWhoUseApp removeObjectAtIndex:button.tag];
            [self.myTable reloadData];
        }
    }
    else
    {
        [self showAlertBoxWithTitle:@"Internet Issue" message:@"It seems your Internet connection is Down"];
        [progress stopAnimating];
        button.enabled = true;
    }
}

- (void) sendingPush
{
    NSString *msg = [NSString stringWithFormat:@"%@ accepted your friend request",[[NSUserDefaults standardUserDefaults]valueForKey:@"username"]];
    
    NSDictionary *data = @{
                           @"alert": msg,
                           @"name": nameToAccept,
                           @"number": numberToAccept,
                           @"sound":@"cheering.caf"
                           };
    
    PFPush *push = [[PFPush alloc] init];
    
    NSString *friendsNumber = @"X_";
    friendsNumber = [friendsNumber stringByAppendingString:[numberToAccept substringFromIndex:1]];
    
    
    [push setChannel:friendsNumber];
    [push setMessage:msg];
    [push setData:data];
    [push sendPushInBackground];
}

- (void)addFriend:(id)sender
{
    button = (UIButton*) sender;
        button.enabled = false;

    [progress startAnimating];
    
    NSString *numberToAdd;
    NSString *nameToAdd;
    
    if(self.searchController.active)
    {
        numberToAdd = [searchResults valueForKey:@"password"][button.tag];
        nameToAdd = [searchResults valueForKey:@"fullName"][button.tag];
    }
    else
    {
        numberToAdd = [DistinctFriendsWhoUseApp valueForKey:@"password"][button.tag];
        nameToAdd = [DistinctFriendsWhoUseApp valueForKey:@"fullName"][button.tag];
    }


    WebService *addFriend = [[WebService alloc] init];
    NSMutableArray *addFriendResultArray = [addFriend FilePath:@"http://steve-jones.co/iospanic/add_friends.php" parameterOne:numberToAdd parameterTwo:@""];
    
    if([[addFriendResultArray valueForKey:@"status"] isEqualToString: @"1"])
    {
        [progress stopAnimating];
        
                                            // sending notification work start //
        
        
        [button setBackgroundImage:[UIImage imageNamed:@"req_sent"] forState:normal];
        
        NSString *msg = [NSString stringWithFormat:@"%@ has sent you friend request",[[NSUserDefaults standardUserDefaults]valueForKey:@"username"]];
        
        NSDictionary *data = @{
                               @"alert": msg,
                               @"name": nameToAdd,
                               @"number": numberToAdd,
                               @"sound":@"cheering.caf"
                               };
        
        NSString *friendsNumber = @"X_";
        friendsNumber = [friendsNumber stringByAppendingString:[numberToAdd substringFromIndex:1]];
        
        PFPush *push = [[PFPush alloc] init];
        
        [push setChannel:friendsNumber];
        [push setMessage:msg];
        [push setData:data];
        [push sendPushInBackground];
        
                                            // sending notification work finished //
        
        if(self.searchController.active)
        {
            for(int i =0; i<DistinctFriendsWhoUseApp.count; i++)
            {
                if([[DistinctFriendsWhoUseApp valueForKey:@"password"][i] isEqualToString:[searchResults valueForKey:@"password"][[sender tag]]])
                {
                    [[DistinctFriendsWhoUseApp objectAtIndex:i]setValue:@"0" forKey:@"activate"];
                    [[DistinctFriendsWhoUseApp objectAtIndex:i]setValue:@"1" forKey:@"accReq"];
                }
            }
        }
        else
        {
            [[DistinctFriendsWhoUseApp objectAtIndex:[sender tag]]setValue:@"0" forKey:@"activate"];
            [[DistinctFriendsWhoUseApp objectAtIndex:[sender tag]]setValue:@"1" forKey:@"accReq"];
        }
    }
    else
    {
        [self showAlertBoxWithTitle:@"Internet Issue" message:@"It seems your Internet connection is Down"];
        [progress stopAnimating];
        button.enabled  = true;
    }
}

-(void)sendingJSONArrayToServer
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:Contacts.finalArrayStaticFunction
                        options:NSJSONWritingPrettyPrinted
                        error:&error];
    if (jsonData.length > 0 &&
        error == nil)
    {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                     encoding:NSUTF8StringEncoding];

        WebService *myWebService = [[WebService alloc] init];
        resultArray = [myWebService FilePath:@"http://steve-jones.co/iospanic/json-contacts.php" parameterOne:jsonString parameterTwo:[[NSUserDefaults standardUserDefaults]valueForKey:@"myPhoneNumber"]];
        
        if (!resultArray)
        {
            [self showAlertBoxWithTitle:@"Internet Issue" message:@"It seems your Internet connection is Down"];
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
    
    DistinctFriendsWhoUseApp = [Contacts.friendWhoUseAppStaticFunction mutableCopy];
    
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
}

- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}

- (void)didDismissSearchController:(UISearchController *)searchController
{
    [self.myTable reloadData];
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
