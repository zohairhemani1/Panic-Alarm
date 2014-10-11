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
#import "checkInternet.h"

@interface Favorites (){
    checkInternet *c;
    NSString *storedNumber;
}
@end

@implementation Favorites
@synthesize favoritesTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_favouritesArray count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section

{
    tableView.sectionHeaderHeight = 30.0;
    
    return @"Friends Who Have Added Me";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // NSLog(@"Index: %@ ",indexPath.row);
    static NSString *simpleTableIdentifierr = @"SimpleTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifierr];
    
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifierr];
    }
    storedNumber = [[NSUserDefaults standardUserDefaults] stringForKey:@"password"];
    NSString *number;
    
    if(![[[_favouritesArray valueForKey:@"friendsnumber"] objectAtIndex:indexPath.row] isEqualToString:storedNumber])
        number = [[_favouritesArray valueForKey:@"friendsnumber"] objectAtIndex:indexPath.row];
    else if (![[[_favouritesArray valueForKey:@"mynumber"] objectAtIndex:indexPath.row] isEqualToString:storedNumber])
        number = [[_favouritesArray valueForKey:@"mynumber"] objectAtIndex:indexPath.row];
    else
        NSLog(@"No Number.");
    
    NSString *fullName = [[_favouritesArray valueForKey:@"username"] objectAtIndex:indexPath.row];
    NSString *pic = [[_favouritesArray valueForKey:@"pic"] objectAtIndex:indexPath.row];
    
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(60, 10, 80, 13)];
    UILabel *phonenumber = [[UILabel alloc]initWithFrame:CGRectMake(60, 28, 80, 20)];
    if(fullName !=nil){
        
        name.text = fullName;
        phonenumber.text = number;
        //cell.detailTextLabel.text = number;
        //cell.textLabel.text = fullName;
    }
    
    
    //name.textColor= [UIColor grayColor];
    [name setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17.f]];
    [cell addSubview:name];
    [phonenumber setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:11.f]];
    phonenumber.textColor = [UIColor grayColor];
    [cell addSubview:phonenumber];
    
    NSLog(@"Full Name: %@", fullName);
    // if(fullName !=nil){cell.textLabel.text = fullName;}
    NSString *imagePathString = @"http://www.bizsocialcard.com/iospanic/assets/upload/";
    imagePathString = [imagePathString stringByAppendingString:pic];
    
    NSURL *imagePathUrl = [NSURL URLWithString:imagePathString];
    NSData *data = [[NSData alloc]initWithContentsOfURL:imagePathUrl];
    UIImage *img = [[UIImage alloc]initWithData:data ];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:img];
    imageView.frame = CGRectMake(10,5,40,40); //set these variables as you want
    imageView.layer.cornerRadius = 20;
    [imageView setClipsToBounds:YES];
    [cell addSubview:imageView];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //set the position of the button
    button.frame = CGRectMake(cell.frame.origin.x + 250, 10, 60, 30);
    [button setTitle:@"Delete" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor blackColor]];
    [button addTarget:self action:@selector(deleteFriend:) forControlEvents:UIControlEventTouchUpInside];
    
    //[button setBackgroundImage:[UIImage imageNamed:@"cross.png"] forState:UIControlStateNormal];
    
    [cell.contentView addSubview:button];
    
    return cell;
    
}

- (void)deleteFriend:(id)sender
{
    //    [self.favouritesArray removeObjectsAtIndexes:sender];
    //    [self.favoritesTable deleteRowsAtIndexPaths:self.favouritesArray withRowAnimation:UITableViewRowAnimationAutomatic];
    //    [self favouritesList];
    //    [self.favoritesTable reloadData];
}

- (void)refreshTable{
    //TODO: refresh your data
    
    [self.refresh endRefreshing];
    [self favouritesList];
    [self.favoritesTable reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.favoritesTable setSeparatorColor:[UIColor lightGrayColor]];
    
    c = [[checkInternet alloc]init];
    [c viewWillAppear:YES];
    
    self.favoritesTable.delegate=self;
    self.favoritesTable.dataSource = self;
    
    self.refresh = [[UIRefreshControl alloc] init];
    [self.refresh addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    [self.favoritesTable addSubview:self.refresh];
    
    //UIImage *backgroundImage = [UIImage imageNamed:@"background"];
    //self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:backgroundImage];
    [self.view setBackgroundColor:[UIColor blackColor]];
    [self favouritesList];
    
}


// ----- swipe to delete ----- //

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [_favouritesArray removeObjectAtIndex:indexPath.row];
        [tableView reloadData];
    }
}

- (NSMutableArray*)favouritesList
{
    WebService *favouritesService = [[WebService alloc] init];
    NSArray * favJson = [[NSArray alloc] init];
    NSString *storedNumber = [[NSUserDefaults standardUserDefaults] stringForKey:@"password"];
    favJson = [favouritesService FilePath:@"http://bizsocialcard.com/iospanic/favourites.php" parameterOne:storedNumber];
    _favouritesArray = [[NSMutableArray alloc] init];
    for(NSDictionary *item in favJson)
    {
        
        [_favouritesArray addObject:item];
        NSLog(@" favouritesArray: %@", _favouritesArray);
        
    }
    return  _favouritesArray;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
