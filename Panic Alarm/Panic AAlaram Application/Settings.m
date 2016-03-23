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
#import "websiteWebview.h"
#import <DigitsKit/DigitsKit.h>
#import <Parse/Parse.h>

@interface Settings (){
    checkInternet *c;
    NSString *internet;
}
@end

@implementation Settings

NSMutableArray *about;
NSMutableArray *profile;

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
    self.settingsTable.tableFooterView = [UIView new];
    (self.navigationController.navigationBar).titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    about = [[NSMutableArray alloc] initWithObjects:@"about",@"tell",@"help",nil];
    profile = [[NSMutableArray alloc] initWithObjects:@"profile",@"system",@"logout",nil];
    
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
    else
    {
        return profile.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if(indexPath.section == 0)
    {
        NSString *CellIdentifier = about[indexPath.row];
        
        if([CellIdentifier isEqualToString:@"tell"])
        {
            self.activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[@"I would like to add you on E~Alarm app. You can download the app from here: https://itunes.apple.com/us/app/e-alarm/id1089147886?ls=1&mt=8"] applicationActivities:nil];
            [self presentViewController:self.activityViewController animated:YES completion:nil];
        }
//        else if([CellIdentifier isEqualToString:@"help"])
//        {
//            [self performSegueWithIdentifier:@"help_systemStatus_segue" sender:self];
//        }
    }
    
    else if(indexPath.section == 1)
    {
        NSString *CellIdentifier = profile[indexPath.row];
        
//        if([CellIdentifier isEqualToString:@"system"])
//        {
//            [self performSegueWithIdentifier:@"help_systemStatus_segue" sender:self];
//        }
        
        if([CellIdentifier isEqualToString:@"logout"])
        {
            [self showAlertBox:@"" message:@"Are you sure you want to logout?"];
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
    else
    {
        CellIdentifier = profile[indexPath.row];
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
//    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//
//    if ([segue.identifier isEqualToString:@"help_systemStatus_segue"])
//    {
//        help_systemStatus *h = segue.destinationViewController;
//        if(indexPath.section == 0)
//        {
//            NSString *CellIdentifier = about[indexPath.row];
//            
//            if([CellIdentifier isEqualToString:@"help"])
//            {
//                h.pageName = @"FAQ.php";
//            }
//        }
//        else
//        {
//            h.pageName = @"system_status.php";
//        }
//    }
//}

-(void)showAlertBox:(NSString*)title message:(NSString*)message
{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"Yes"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                             PFInstallation *currentInstallation = [PFInstallation currentInstallation];
                             currentInstallation.channels = [NSArray array];
                             [currentInstallation saveEventually];
                             
                             [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"loggedIn"];
                             [[Digits sharedInstance]logOut];
                             
                             UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                             UIViewController *secondView = [storyboard instantiateViewControllerWithIdentifier:@"termScreen"];
                             
                             [self presentViewController:secondView animated:YES completion:nil];
                             
                         }];
    [alert addAction:ok];
    
    UIAlertAction* no = [UIAlertAction
                         actionWithTitle:@"No"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    [alert addAction:no];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
