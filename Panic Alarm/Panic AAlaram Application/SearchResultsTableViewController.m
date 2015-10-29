//
//  SearchResultsTableViewController.m
//  UISearchControllerDemo
//
//  Created by Jason Hoffman on 1/13/15.
//  Copyright (c) 2015 JHM. All rights reserved.
//

#import "SearchResultsTableViewController.h"

@interface SearchResultsTableViewController ()

@property (nonatomic, strong) NSArray *array;

@end

@implementation SearchResultsTableViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.searchTableTitle;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        
    return (self.searchResults).count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifierr = @"SearchResultCell";
    UITableViewCell *cell ;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifierr];
    }
    
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(60, 8, 120, 19)];
    UILabel *phonenumber = [[UILabel alloc]initWithFrame:CGRectMake(60, 29, 80, 20)];
    
    NSString *fullName = [self.searchResults valueForKey:@"username"][indexPath.row];
    NSString *number = [self.searchResults valueForKey:@"mynumber"][indexPath.row];
    
    if(fullName !=nil)
    {
        name.text = fullName.uppercaseString;
        phonenumber.text = number;
    }
    
    phonenumber.textColor = [UIColor grayColor];
    
    name.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15.f];
    phonenumber.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:11.f];
    
    NSString *pic = [self.searchResults valueForKey:@"pic"][indexPath.row];
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
    
    [cell addSubview:name];
    [cell addSubview:phonenumber];
    [cell addSubview:imageView];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0f;
}

@end
