//
//  Settings.m
//  Panic Alarm
//
//  Created by Zainu Corporation on 10/07/2014.
//  Copyright (c) 2014 Zohair Hemani - Stanford Assignment. All rights reserved.
//

#import "Settings.h"
#import "PanicFrom.h"
#import "checkInternet.h"

@interface Settings (){
    checkInternet *c;
    NSString *internet;
}
@end

@implementation Settings

NSMutableArray *about;
NSMutableArray *profile;
NSMutableArray *network;

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
    
    c = [[checkInternet alloc]init];
    [c viewWillAppear:YES];
    
    if([c internetstatus] == TRUE){
        internet = @"Connected";
    }
    else{
        internet = @"Not Connected";
    }
    
    [self.settingsTable setSeparatorColor:[UIColor lightGrayColor]];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    about = [[NSMutableArray alloc] initWithObjects:@"about",@"tell",@"help",nil];
    profile = [[NSMutableArray alloc] initWithObjects:@"profile",@"account",@"notification",nil];
    network = [[NSMutableArray alloc] initWithObjects:@"network",@"system",nil];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
    if([c internetstatus] == TRUE){
        internet = @"Connected";
    }
    else{
        internet = @"Not Connected";
    }
    
    [self.tableView reloadData];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
    {
        return [about count];
    }
    else if(section==1)
    {
        return [profile count];
    }
    else
    {
        return [network count];
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = [about objectAtIndex:indexPath.row];
    
    NSString *freind = @"tell";
    if(CellIdentifier == freind){
        self.activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[@"hello"] applicationActivities:nil];
        [self presentViewController:self.activityViewController animated:YES completion:nil];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if(section == 0){
        return @" ";
    }
    else if(section == 1)
    {
        return @" ";
    }
    else
    {
        return @" ";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier;
    if(indexPath.section == 0)
    {
        CellIdentifier = [about objectAtIndex:indexPath.row];
    }
    else if(indexPath.section == 1)
    {
        CellIdentifier = [profile objectAtIndex:indexPath.row];
    }
    else
    {
        CellIdentifier = [network objectAtIndex:indexPath.row];
    }
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
        cell.detailTextLabel.text =internet;
    
    return cell;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
//{
//    // Set the title of navigation bar by using the menu items
//    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//    UINavigationController *destViewController = (UINavigationController*)segue.destinationViewController;
//    destViewController.title = [[about objectAtIndex:indexPath.row] capitalizedString];
//    
//    // Set the photo if it navigates to the PhotoView
////    if ([segue.identifier isEqualToString:@"showPhoto"]) {
////        PhotoViewController *photoController = (PhotoViewController*)segue.destinationViewController;
////        NSString *photoFilename = [NSString stringWithFormat:@"%@_photo.jpg", [_menuItems objectAtIndex:indexPath.row]];
////        photoController.photoFilename = photoFilename;
////    }
//    
//    
//}
@end
