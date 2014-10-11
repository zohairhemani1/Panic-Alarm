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
    NSArray *PanicFromArray;
    NSArray *PanicToArray;
    NSString *testing1;
    NSString *testing2;
    NSString *testing3;
    NSString *testing4;
    NSString *nameToAdd;
    
}

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
    
    UILabel *name;
    UILabel *message;
    
    
    if(self.segments.selectedSegmentIndex == 0)
    {
        if (cell == nil) {
            cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            
        }
        
        NSString *profilePic = [[PanicFromArray valueForKey:@"pic"] objectAtIndex:indexPath.row];
        NSString *imagePathString = @"http://www.bizsocialcard.com/iospanic/assets/upload/";
        imagePathString = [imagePathString stringByAppendingString:profilePic];
        
        NSURL *imagePathUrl = [NSURL URLWithString:imagePathString];
        NSData *data = [[NSData alloc]initWithContentsOfURL:imagePathUrl];
        UIImage *img = [[UIImage alloc]initWithData:data ];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:img];
        imageView.frame = CGRectMake(10, 5, 40, 40);
        imageView.layer.cornerRadius = 20;
        [imageView setClipsToBounds:YES];
        [cell addSubview:imageView];
        
        name = [[UILabel alloc]initWithFrame:CGRectMake(60, 6, 150, 20)];
        message = [[UILabel alloc]initWithFrame:CGRectMake(60, 28, 150, 20)];
        
        name.text = [[PanicFromArray valueForKey:@"username"]objectAtIndex:indexPath.row];
        [name setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17.f]];
        
        message.text = @"This is a dummy message";
        [message setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:11.f]];
        message.textColor = [UIColor grayColor];
        [cell addSubview:name];
        [cell addSubview:message];

    }
    else
    {
        if (cell == nil) {
            cell = [tableView dequeueReusableCellWithIdentifier:simple];

        }
//        UIImageView *imageView = [[UIImageView alloc] initWithImage:img];
//        imageView.frame = CGRectMake(10, 5, 40, 40);
//        imageView.layer.cornerRadius = 20;
//        [imageView setClipsToBounds:YES];
//        [cell addSubview:imageView];
        
        name = [[UILabel alloc]initWithFrame:CGRectMake(60, 6, 150, 20)];
        message = [[UILabel alloc]initWithFrame:CGRectMake(60, 28, 150, 20)];
        
        name.text = [[PanicToArray valueForKey:@"friendsnumber" ] objectAtIndex:indexPath.row];
        [name setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17.f]];
        
        message.text = @"This is a dummy message";
        [message setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:11.f]];
        message.textColor = [UIColor grayColor];
        
        [cell addSubview:name];
        [cell addSubview:message];
       
    }
    UIButton *test = [[UIButton alloc]initWithFrame:CGRectMake(200,10,50,20)];
    test.backgroundColor=[UIColor blackColor];
    [test setTitle:@"Pend" forState:UIControlStateNormal];
    [test addTarget:self action:@selector(acceptFriendRequest:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:test];
    return cell;
}

-(void)acceptFriendRequest:(id)sender{
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.mytable indexPathForSelectedRow];
    PanicFrom *destViewController = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"FromSegue"]) {
        destViewController.personName = [[PanicFromArray valueForKey:@"username"]objectAtIndex:indexPath.row];
    }
    else if([segue.identifier isEqualToString:@"ToSegue"]){
    
        destViewController.personName = [[PanicToArray valueForKey:@"friendsnumber" ] objectAtIndex:indexPath.row];
    }
        // Hide bottom tab bar in the detail view
        //   destViewController.hidesBottomBarWhenPushed = YES;
    
}

@end
