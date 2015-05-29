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
    UIActivityIndicatorView *progress;
}
@end

@implementation Favorites
static NSMutableArray* favouritesArray;
@synthesize favoritesTable;

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
    

    UIImage *backgroundImage = [UIImage imageNamed:@"background_tabone"];
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:backgroundImage];

    [self.favoritesTable setSeparatorColor:[UIColor lightGrayColor]];
    
    c = [[checkInternet alloc]init];
    [c viewWillAppear:YES];
    
    self.favoritesTable.delegate=self;
    self.favoritesTable.dataSource = self;
    
    self.refresh = [[UIRefreshControl alloc] init];
    [self.refresh addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    [self.favoritesTable addSubview:self.refresh];
    
    progress = [c indicatorprogress:progress];
    [self.view addSubview:progress];
    [progress bringSubviewToFront:self.view];
    
    dispatch_queue_t myqueue = dispatch_queue_create("myqueue", NULL);
    dispatch_async(myqueue, ^(void) {
        
        [progress startAnimating];
        [Favorites favouritesList];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update UI on main queue
            
    self.searchResult = [NSMutableArray arrayWithCapacity:[favouritesArray count]];

            [self.favoritesTable reloadData];
            [progress stopAnimating];
            
        });
        
    });
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    [self.searchResult removeAllObjects];
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@", searchText];
    
    self.searchResult = [NSMutableArray arrayWithArray: [favouritesArray filteredArrayUsingPredicate:resultPredicate]];
}


-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return [self.searchResult count];
    }
    else
    {
        return [favouritesArray count];
    }
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
    UITableViewCell *cell ;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifierr];
    }
    storedNumber = [[NSUserDefaults standardUserDefaults] stringForKey:@"password"];
    NSString *number;
    
    if(![[[favouritesArray valueForKey:@"friendsnumber"] objectAtIndex:indexPath.row] isEqualToString:storedNumber])
        number = [[favouritesArray valueForKey:@"friendsnumber"] objectAtIndex:indexPath.row];
    else if (![[[favouritesArray valueForKey:@"mynumber"] objectAtIndex:indexPath.row] isEqualToString:storedNumber])
        number = [[favouritesArray valueForKey:@"mynumber"] objectAtIndex:indexPath.row];
    else
        NSLog(@"No Number.");
    
    NSString *fullName = [[favouritesArray valueForKey:@"username"] objectAtIndex:indexPath.row];
    NSString *pic = [[favouritesArray valueForKey:@"pic"] objectAtIndex:indexPath.row];
    
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(60, 8, 120, 19)];
    UILabel *phonenumber = [[UILabel alloc]initWithFrame:CGRectMake(60, 29, 80, 20)];
    if(fullName !=nil){
        
        name.text = fullName;
        phonenumber.text = number;

    }
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        phonenumber.textColor = [UIColor blackColor];
    }
    else
    {
        phonenumber.textColor = [UIColor grayColor];
    }
    //name.textColor= [UIColor grayColor];
    [name setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17.f]];
    [cell addSubview:name];
    [phonenumber setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:11.f]];
    
    [cell addSubview:phonenumber];
    
    NSLog(@"Full Name: %@", fullName);
    // if(fullName !=nil){cell.textLabel.text = fullName;}
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
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //set the position of the button
    button.frame = CGRectMake(cell.frame.origin.x + 250, 10, 60, 30);
    
    [button setTitle:@"Delete" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor blackColor]];
    [button addTarget:self action:@selector(deleteFriend:) forControlEvents:UIControlEventTouchUpInside];
    
    //[button setBackgroundImage:[UIImage imageNamed:@"cross.png"] forState:UIControlStateNormal];
    
    [cell addSubview:button];
    
    if ([cell subviews]){
        for (UIView *subview in [cell.contentView subviews]) {
            [subview removeFromSuperview];
        }
    }
    
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
    favouritesArray = nil;
    [Favorites favouritesList];
    [self.favoritesTable reloadData];
    
}

// ----- swipe to delete ----- //

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSLog(@"the delete array object is %@",[[favouritesArray valueForKey:@"username"]objectAtIndex:indexPath.row]);
        
       // [favouritesArray removeObjectAtIndex:indexPath.row];
       // [favouritesArray removeAllObjects];
        
//        for(int i =0;i<[favouritesArray count];i++){
//            NSLog(@"the favourites array object is %@",[[favouritesArray valueForKey:@"username"]objectAtIndex:i]);
//        }
        
        
        WebService *updateMessage = [[WebService alloc] init];
        [updateMessage FilePath:@"http://fajjemobile.info/iospanic/deleteFriend.php" parameterOne:[[favouritesArray valueForKey:@"mynumber"] objectAtIndex:indexPath.row] parameterTwo:[[favouritesArray valueForKey:@"friendsnumber"] objectAtIndex:indexPath.row]];
        
        [favouritesArray removeObjectAtIndex:indexPath.row];
        [tableView reloadData];
    }
}

+ (NSMutableArray*)favouritesList
{
    WebService *favouritesService = [[WebService alloc] init];
    NSArray * favJson = [[NSArray alloc] init];
    NSString *storedNumber = [[NSUserDefaults standardUserDefaults] stringForKey:@"password"];
    
    if(favouritesArray == nil){
    favJson = [favouritesService FilePath:@"http://fajjemobile.info/iospanic/favourites.php" parameterOne:storedNumber];
    favouritesArray = [[NSMutableArray alloc] init];
        for(NSDictionary *item in favJson)
        {
        
            [favouritesArray addObject:item];
            NSLog(@" favouritesArray: %@", favouritesArray);
        
        }
    }
    return favouritesArray;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
