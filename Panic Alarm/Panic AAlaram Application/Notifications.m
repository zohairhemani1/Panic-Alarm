//
//  Notifications.m
//  Panic Alarm
//
//  Created by Zainu Corporation on 04/08/2014.
//  Copyright (c) 2014 Zohair Hemani - Stanford Assignment. All rights reserved.
//

#import "Notifications.h"

@interface Notifications ()

@end

@implementation Notifications{
    NSMutableArray *appNotifications;
    NSMutableArray *panicNotifications;
    UISwitch *switchView;
}

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
    self.notificationstable.delegate = self;
    self.notificationstable.dataSource = self;
    
    panicNotifications = [[NSMutableArray alloc] initWithObjects:@"Receive Notifications",@"Panic",nil];
    appNotifications = [[NSMutableArray alloc] initWithObjects:@"In-app vibrate",@"In-app sound",nil];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
    {
        return panicNotifications.count;
    }
    else
    {
        return appNotifications.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
        return 30;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if(section == 0){
        return @" Panic Notifications ";
    }
    else
    {
        return @" In app Notifications ";
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    
    if(indexPath.section == 0)
        cell.textLabel.text = panicNotifications[indexPath.row];
    
    if(indexPath.section == 1)
    {
        cell.textLabel.text = appNotifications[indexPath.row];
    }
    
    switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
    switchView.tag = indexPath.row;
    [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    cell.accessoryView = switchView;
    [switchView setOn:YES animated:NO];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 250, 280, 40)];
    [btn setTitle:@"Reset All notifications" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor clearColor];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    btn.layer.borderWidth = 2.0f;
    btn.layer.backgroundColor = [UIColor blackColor].CGColor;
    
    [btn addTarget:self action:@selector(reset:) forControlEvents:UIControlEventTouchUpInside];
    [self.notificationstable addSubview:btn];
    
    return cell;
    
}

-(void) switchChanged:(UISwitch *)sender{
    switchView = (UISwitch *)sender;
    NSLog(@"switch changed %i",switchView.tag);
}

-(void)reset:(id)sender{
    [switchView setOn:YES animated:NO];
    [self.notificationstable reloadData];
    NSLog(@"pressed");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
