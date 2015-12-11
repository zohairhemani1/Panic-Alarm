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
#import "help_systemStatus.h"

@interface Settings (){
    checkInternet *c;
    NSString *internet;
}
@end

@implementation Settings

NSMutableArray *about;
NSMutableArray *profile;
NSMutableArray *network;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    
    if(c.internetstatus == TRUE){
        internet = @"Connected";
    }
    else{
        internet = @"Not Connected";
    }
    
    (self.settingsTable).separatorColor = [UIColor lightGrayColor];
    
    (self.navigationController.navigationBar).titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    about = [[NSMutableArray alloc] initWithObjects:@"about",@"tell",@"help",nil];
    profile = [[NSMutableArray alloc] initWithObjects:@"profile",@"notification",nil];
    network = [[NSMutableArray alloc] initWithObjects:@"system",nil];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    if(c.internetstatus == TRUE)
    {
        internet = @"Connected";
    }
    else
    {
        internet = @"Not Connected";
    }
    
    [self.tableView reloadData];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return about.count;
    }
    else if(section == 1)
    {
        return profile.count;
    }
    else
    {
        return network.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 0)
    {
        NSString *CellIdentifier = about[indexPath.row];
        
        if(CellIdentifier == @"tell")
        {
            self.activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[@"hello"] applicationActivities:nil];
            [self presentViewController:self.activityViewController animated:YES completion:nil];
        }
        else if(CellIdentifier == @"help")
        {
            [self performSegueWithIdentifier:@"help_systemStatus_segue" sender:self];
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @" ";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier;
    if(indexPath.section == 0)
    {
        CellIdentifier = about[indexPath.row];
    }
    else if(indexPath.section == 1)
    {
        CellIdentifier = profile[indexPath.row];
    }
    else
    {
        CellIdentifier = network[indexPath.row];
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

- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];

    if ([segue.identifier isEqualToString:@"help_systemStatus_segue"])
    {
        help_systemStatus *h = segue.destinationViewController;
        if(indexPath.section == 0)
        {
            h.pageName = @"FAQ.php";
        }
        else
        {
            
        }
    }
}

@end
