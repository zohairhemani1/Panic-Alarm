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

@interface GetLocation (){
checkInternet *c;
    NSArray *favArray;
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
    
    Favorites *myObj = [[Favorites alloc] init];
    favArray = [[NSArray alloc] initWithArray:[myObj favouritesArray]];
    
    self.myContacts.delegate=self;
    self.myContacts.dataSource = self;
    
    self.refresh = [[UIRefreshControl alloc] init];
    [self.refresh addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    [self.myContacts addSubview:self.refresh];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
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
    
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(60, 10, 120, 13)];
    UILabel *phonenumber = [[UILabel alloc]initWithFrame:CGRectMake(60, 28, 80, 20)];
    
    //name.textColor= [UIColor grayColor];
    [name setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17.f]];
    name.text = [[favArray valueForKey:@"username"]objectAtIndex:indexPath.row];
    [cell addSubview:name];
    [phonenumber setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:11.f]];
    phonenumber.textColor = [UIColor grayColor];
    phonenumber.text=[[favArray valueForKey:@"friendsnumber"]objectAtIndex:indexPath.row];
    [cell addSubview:phonenumber];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //set the position of the button
    button.frame = CGRectMake(cell.frame.origin.x + 250, 10, 60, 30);
    [button setTitle:@"Find" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor blackColor]];
    [button addTarget:self action:@selector(FindLocation:) forControlEvents:UIControlEventTouchUpInside];
    
    //[button setBackgroundImage:[UIImage imageNamed:@"cross.png"] forState:UIControlStateNormal];
    
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
    
}

@end
