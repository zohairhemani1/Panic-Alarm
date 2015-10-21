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

@interface GetLocation (){
checkInternet *c;
    NSArray *favArray;
    NSArray *favRestJsonArray;
    UIButton *button;
    UIActivityIndicatorView *progress;
}
@end

@implementation GetLocation

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    
    [self.myContacts setSeparatorColor:[UIColor lightGrayColor]];
    
    c = [[checkInternet alloc]init];
    [c viewWillAppear:YES];
    
    
    
    self.myContacts.delegate=self;
    self.myContacts.dataSource = self;
    
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
            // Update UI on main queue
            
            [self.myContacts reloadData];
            [progress stopAnimating];
            
        });
        
    });

    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [favArray count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section

{
    tableView.sectionHeaderHeight = 30.0;
    
    return @"    Ask Location To Freinds";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // NSLog(@"Index: %@ ",indexPath.row);
    static NSString *simpleTableIdentifierr = @"SimpleTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifierr];
    
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifierr];
    }
    
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(60, 8, 120, 19)];
    UILabel *phonenumber = [[UILabel alloc]initWithFrame:CGRectMake(60, 29, 80, 20)];
    NSString *pic = [[favArray valueForKey:@"pic"] objectAtIndex:indexPath.row];
    
    //name.textColor= [UIColor grayColor];
    [name setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17.f]];
    name.text = [[favArray valueForKey:@"username"]objectAtIndex:indexPath.row];
    [cell addSubview:name];
    [phonenumber setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:11.f]];
    phonenumber.textColor = [UIColor grayColor];
    phonenumber.text=[[favArray valueForKey:@"friendsnumber"]objectAtIndex:indexPath.row];
    [cell addSubview:phonenumber];
    
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
    [cell addSubview:imageView];
    
    button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //set the position of the button
    button.frame = CGRectMake(cell.frame.origin.x + 250, 10, 60, 30);
    [button setTitle:@"Find" forState:UIControlStateNormal];
    button.tag = indexPath.row;
    [button setBackgroundColor:[UIColor blackColor]];
    [button addTarget:self action:@selector(FindLocation:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.contentView addSubview:button];
    
    return cell;
    
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
    favRestJsonArray = [FindLocationRest FilePath:BASEURL FIND_REST parameterOne:@"F" parameterTwo:[[favArray valueForKey:@"friendsnumber"]objectAtIndex:button.tag] parameterThree:FIND_MESSAGE];
    
    NSLog(@"the returned value are: %@",[favRestJsonArray valueForKey:@"success"] );
    
    if([[favRestJsonArray valueForKey:@"success"] isEqualToString: @"200"])
    {
        NSLog(@"in code");
        
        [button setTitle:@"PENDING" forState:normal];
        
        PFPush *push = [[PFPush alloc] init];
        [push setChannel:@"X_090078601"];   // channels column in PARSE!
        NSString *FindNotificationMessage = [[[favArray valueForKey:@"username"]objectAtIndex:button.tag] stringByAppendingString:@" is requesting your Location."];
        [push setMessage:FindNotificationMessage];
        //[push setData:data];
        [push sendPushInBackground];
    }
}

@end
