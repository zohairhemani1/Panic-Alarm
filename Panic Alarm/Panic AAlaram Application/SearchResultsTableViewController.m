//
//  SearchResultsTableViewController.m
//  UISearchControllerDemo
//
//  Created by Jason Hoffman on 1/13/15.
//  Copyright (c) 2015 JHM. All rights reserved.
//

#import "SearchResultsTableViewController.h"
#import "WebService.h"
#import "Constants.h"
#import <Parse/Parse.h>
#import "NSDataAdditions.h"
#import <CommonCrypto/CommonDigest.h>

@interface SearchResultsTableViewController ()

@property (nonatomic, strong) NSArray *array;

@end

@implementation SearchResultsTableViewController
{
    NSArray *favRestJsonArray;
    UIButton *button;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"the class type is: %@",self.classType);
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    NSLog(@"the class type in viewdidappear is: %@",self.classType);
    self.title = self.searchTableTitle;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        
    return (self.searchResults).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    UITableViewCell *cell ;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    if ([self.classType isEqualToString:@"contacts"])
    {
        NSString *fullName = [self.searchResults valueForKey:@"fullName"][indexPath.row];
        NSString *number = [self.searchResults valueForKey:@"password"][indexPath.row];
    
        NSData *data = [self.searchResults valueForKey:@"imageInNSData"][indexPath.row];
        UIImage *image = [UIImage imageWithData:data];
    
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
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
    
        name.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17.f];
        phonenumber.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:11.f];
        phonenumber.textColor = [UIColor grayColor];
    
        NSString *accReq = [self.searchResults valueForKey:@"accReq"][indexPath.row];
        NSString *activate = [self.searchResults valueForKey:@"activate"][indexPath.row];
        
        button = [[UIButton alloc]initWithFrame:CGRectMake(cell.frame.origin.x + 250, 07, 45, 36)];
    
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
    
        button.tag = indexPath.row;
        [cell addSubview:button];
        [cell addSubview:phonenumber];
        [cell addSubview:name];
        return cell;
    }
    else
    {
        NSString *storedNumber = [[NSUserDefaults standardUserDefaults]valueForKey:@"myPhoneNumber"];
        NSString *number;
        
        if(![[self.searchResults valueForKey:@"friendsnumber"][indexPath.row] isEqualToString:storedNumber])
            number = [self.searchResults valueForKey:@"friendsnumber"][indexPath.row];
        else if (![[self.searchResults valueForKey:@"mynumber"][indexPath.row] isEqualToString:storedNumber])
            number = [self.searchResults valueForKey:@"mynumber"][indexPath.row];
        else
            NSLog(@"No Number.");
        
        UILabel *name;
        
        NSString * fullName = [self.searchResults valueForKey:@"username"][indexPath.row];
        
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
        
        if (cell.subviews){
            for (UIView *subview in (cell.contentView).subviews) {
                [subview removeFromSuperview];
            }
        }
        
        NSData *data = [self.searchResults valueForKey:@"imageInNSData"][indexPath.row];
        UIImage *image = [UIImage imageWithData:data];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(10,5,40,40); //set these variables as you want
        imageView.layer.cornerRadius = 20;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [imageView setClipsToBounds:YES];
        
        button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(cell.frame.origin.x + 235, 07, 60, 36);
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
}

-(void)FindLocation:(id)sender{
    button = (UIButton *) sender;
    
    WebService *FindLocationRest = [[WebService alloc] init];
    favRestJsonArray = [FindLocationRest FilePath:BASEURL FIND_REST parameterOne:@"F" parameterTwo:[self.searchResults valueForKey:@"friendsnumber"][button.tag] parameterThree:FIND_MESSAGE];
    
    NSLog(@"the returned value are: %@",[favRestJsonArray valueForKey:@"success"] );
    
    if([[favRestJsonArray valueForKey:@"success"] isEqualToString: @"200"])
    {
        NSLog(@"in code");
        
        [button setTitle:@"PENDING" forState:normal];
        
        PFPush *push = [[PFPush alloc] init];
        [push setChannel:@"090078601"];   // channels column in PARSE!
        NSString *FindNotificationMessage = [[self.searchResults valueForKey:@"username"][button.tag] stringByAppendingString:@" is requesting your Location."];
        [push setMessage:FindNotificationMessage];
        //[push setData:data];
        [push sendPushInBackground];
    }
}

- (void)acceptFriendRequest:(id)sender
{
    button = (UIButton*) sender;
    [button setBackgroundImage:[UIImage imageNamed:@"tick.png"] forState:UIControlStateNormal];
    
    NSString *numberToAccept = [self.searchResults valueForKey:@"phoneNumber"][button.tag];
    NSString *nameToAccept = [self.searchResults valueForKey:@"fullName"][button.tag];
    NSLog(@"Tapped Tag %ld: %@ %@", (long)button.tag, numberToAccept, nameToAccept);
    
    NSString *friendsNumber = @"090078601";
    
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
    
    // NSString *numberToAdd = [DistinctFriendsWhoUseApp valueForKey:@"password"][button.tag];
    // NSString *nameToAdd = [DistinctFriendsWhoUseApp valueForKey:@"fullName"][button.tag];
    
    [button setBackgroundImage:[UIImage imageNamed:@"req_sent"] forState:normal];
    
    NSLog(@"Tapped Tag %ld: %@ %@", (long)button.tag, [self.searchResults valueForKey:@"password"][button.tag],[self.searchResults valueForKey:@"fullName"][button.tag] );
    
    //    NSString *friendsNumber = @"03432637576";
    //
    //    PFPush *push = [[PFPush alloc] init];
    //    [push setChannel:friendsNumber];   // channels column in PARSE!
    
   // NSString * storedName = [[NSUserDefaults standardUserDefaults] valueForKey:@"username"];
    
   // NSString *message = @"You have been added by ";
    //message = [message stringByAppendingString:storedName];
    
    //    [push setMessage:message];
    //
    //    [push sendPushInBackground];
    
    WebService *addFriend = [[WebService alloc] init];
    [addFriend FilePath:@"http://fajjemobile.info/iospanic/friends.php" parameterOne:[[NSUserDefaults standardUserDefaults]valueForKey:@"myPhoneNumber"]
           parameterTwo:@""];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0f;
}

@end
