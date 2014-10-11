//
//  Victims.m
//  Panic Alarm
//
//  Created by Zainu Corporation on 18/07/2014.
//  Copyright (c) 2014 Zohair Hemani - Stanford Assignment. All rights reserved.
//

#import "Victims.h"
#import "PanicFrom.h"
#import "WebService.h"

@interface Victims ()

@end

@implementation Victims{

    NSString *nameToAdd;
    UIImage *img;
    NSString *profilePic ;
    NSString *imagePathString ;
    NSURL *imagePathUrl;
    NSData *data ;
    UIImageView *imageView;
}
static NSArray *PanicFromArray;
static NSArray *PanicToArray;

@synthesize mytable = _tableView;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    WebService *panicFromRestObj = [[WebService alloc] init];
    
    PanicFromArray = [[NSArray alloc] initWithArray:[panicFromRestObj FilePath:@"http://www.bizsocialcard.com/iospanic/panicFrom.php" parameterOne:nil]];
    
    PanicToArray = [[NSArray alloc] initWithArray:[panicFromRestObj FilePath:@"http://www.bizsocialcard.com/iospanic/panicTo.php" parameterOne:nil]];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
}

- (IBAction)SegmentAction:(id)sender {
    [self.mytable reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
        if(self.segments.selectedSegmentIndex == 0){
        return [PanicFromArray count];
    }
        else {
        return [PanicToArray count];
        }
    
    }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"myvictims";
    
    static NSString *simple = @"second";
    UITableViewCell *cell;
    
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(60, 6, 150, 20)];
    [name setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17.f]];
    
    UILabel *message = [[UILabel alloc]initWithFrame:CGRectMake(60, 28, 150, 20)];
    [message setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:11.f]];
    message.textColor = [UIColor grayColor];

    UILabel *timestamp = [[UILabel alloc]initWithFrame:CGRectMake(210, 29, 50, 13)];
    [timestamp setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:11.f]];

    
    
    if(self.segments.selectedSegmentIndex == 0)
    {
        // Panic From table view
        
        if (cell == nil) {
            cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            
        }
        
        profilePic = [[PanicFromArray valueForKey:@"pic"] objectAtIndex:indexPath.row];
        imagePathString = @"http://www.bizsocialcard.com/iospanic/assets/upload/";
        imagePathString = [imagePathString stringByAppendingString:profilePic];
        
        imagePathUrl = [NSURL URLWithString:imagePathString];
        data = [[NSData alloc]initWithContentsOfURL:imagePathUrl];
        img = [[UIImage alloc]initWithData:data ];
        
        imageView = [[UIImageView alloc] initWithImage:img];
        imageView.frame = CGRectMake(10, 5, 40, 40);
        imageView.layer.cornerRadius = 20;
        [imageView setClipsToBounds:YES];
        [cell addSubview:imageView];
        
        
        name.text = [[PanicFromArray valueForKey:@"username"]objectAtIndex:indexPath.row];
        message.text = @"This is a dummy message";
        timestamp.text = [[PanicFromArray valueForKey:@"timestamp"]objectAtIndex:indexPath.row];
        
    }
    else
    {
        
        //PanicTo Table View
        
        if (cell == nil) {
            cell = [tableView dequeueReusableCellWithIdentifier:simple];

        }
//        UIImageView *imageView = [[UIImageView alloc] initWithImage:img];
//        imageView.frame = CGRectMake(10, 5, 40, 40);
//        imageView.layer.cornerRadius = 20;
//        [imageView setClipsToBounds:YES];
//        [cell addSubview:imageView];
        
        name.text = [[PanicToArray valueForKey:@"friendsnumber" ] objectAtIndex:indexPath.row];
        
        message.text = @"This is a dummy message";
        timestamp.text = [[PanicToArray valueForKey:@"timestamp"]objectAtIndex:indexPath.row];
       
    }
    UIButton *status_button = [[UIButton alloc]initWithFrame:CGRectMake(210,7,50,20)];
    status_button.backgroundColor=[UIColor blackColor];
    [status_button setTitle:@"Pend" forState:UIControlStateNormal];
    [status_button addTarget:self action:@selector(acceptFriendRequest:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell addSubview:status_button];
    [cell addSubview:name];
    [cell addSubview:message];
    [cell addSubview:timestamp];
    
    return cell;
}

-(void)acceptFriendRequest:(id)sender{
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSIndexPath *indexPath = [self.mytable indexPathForSelectedRow];
    PanicFrom *panic = segue.destinationViewController;
    
    if ([segue.identifier isEqualToString:@"FromSegue"]) {
        
        panic.panicPersonId = indexPath.row;
        panic.panicPersonType = 1; // 1 means Panic From Tab
    }
    else if([segue.identifier isEqualToString:@"ToSegue"]){
        panic.panicPersonId = indexPath.row;
        panic.panicPersonType = 0; // 0 means Panic To Tab
        
    }
        // Hide bottom tab bar in the detail view
        //   destViewController.hidesBottomBarWhenPushed = YES;
    
}

+(NSArray *)getPanicFromArray{
    return PanicFromArray;
}

+(NSArray *)getPanicToArray{
    return PanicToArray;
}

@end
