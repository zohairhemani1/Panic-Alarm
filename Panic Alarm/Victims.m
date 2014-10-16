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
    NSString *hour;
    int messageDay;
    int currentDay;
    NSString *dayCurrent;

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

    UILabel *timestamp = [[UILabel alloc]initWithFrame:CGRectMake(210, 32, 50, 13)];
    [timestamp setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:11.f]];

    imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(10, 5, 40, 40);
    imageView.layer.cornerRadius = 20;
    [imageView setClipsToBounds:YES];
    
    timestamp.textColor = [UIColor grayColor];
    timestamp.textAlignment = NSTextAlignmentCenter;
    
    int calculatedDifference;
    
    if(self.segments.selectedSegmentIndex == 0)
    {
        // Panic From table view
        
        if (cell == nil) {
            cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            
        }
        
        profilePic = [[PanicFromArray valueForKey:@"pic"] objectAtIndex:indexPath.row];

        name.text = [[PanicFromArray valueForKey:@"username"]objectAtIndex:indexPath.row];
        message.text = [[PanicFromArray valueForKey:@"panicMessage" ] objectAtIndex:indexPath.row];
        
        calculatedDifference = [self calculateDifference:indexPath.row];
        
        if(calculatedDifference == 0) {
            timestamp.text = hour;
        }
        else if(calculatedDifference < 7){
            timestamp.text = dayCurrent;
        }
        else{
            timestamp.text = [NSString stringWithFormat:@"%d",messageDay];
        }

    }
    else
    {
        
        //PanicTo Table View
        
        if (cell == nil) {
            cell = [tableView dequeueReusableCellWithIdentifier:simple];

        }
        
        name.text = [[PanicToArray valueForKey:@"username" ] objectAtIndex:indexPath.row];
        //profilePic = [[PanicToArray valueForKey:@"pic"] objectAtIndex:indexPath.row];
       // message.text = [[PanicToArray valueForKey:@"panicMessage" ] objectAtIndex:indexPath.row];
        
       calculatedDifference = [self calculateDifference:indexPath.row];
        
        if(calculatedDifference == 0) {
            timestamp.text = hour;
        }
        else if(calculatedDifference < 7){
            timestamp.text = dayCurrent;
        }
        else{
            timestamp.text = [NSString stringWithFormat:@"%d",messageDay];
        }
       
    }
    UIButton *status_button = [[UIButton alloc]initWithFrame:CGRectMake(210,7,50,20)];
    status_button.backgroundColor=[UIColor blackColor];
    [status_button setTitle:@"Pending" forState:UIControlStateNormal];
    [status_button addTarget:self action:@selector(acceptFriendRequest:) forControlEvents:UIControlEventTouchUpInside];
    
    imagePathString = @"http://www.bizsocialcard.com/iospanic/assets/upload/";
    imagePathString = [imagePathString stringByAppendingString:profilePic];
    
    imagePathUrl = [NSURL URLWithString:imagePathString];
    data = [[NSData alloc]initWithContentsOfURL:imagePathUrl];
    img = [[UIImage alloc]initWithData:data ];
    
    imageView.image = img;
    
    [cell addSubview:imageView];
    [cell addSubview:status_button];
    [cell addSubview:name];
    [cell addSubview:message];
    [cell addSubview:timestamp];
    
    return cell;
}

-(void)acceptFriendRequest:(id)sender{
    
}

-(int)calculateDifference:(int)index{
    
    NSString *dateFromJson = [[PanicToArray valueForKey:@"timestamp"]objectAtIndex:index];
    NSDate *today = [NSDate date];
    
   // NSLog(@"Today: %@",today);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
   // [dateFormatter setDateFormat: @"EEEE"];
    
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * JsonDateFormatted = [dateFormatter dateFromString:dateFromJson];
    [dateFormatter setDateFormat:@"dd"];
    messageDay = [[dateFormatter stringFromDate:JsonDateFormatted] intValue];
    
    
    [dateFormatter setDateFormat:@"HH:mm"];
    hour = [dateFormatter stringFromDate:JsonDateFormatted];

    
    [dateFormatter setDateFormat:@"dd"];
    currentDay = [[dateFormatter stringFromDate:today] intValue];

    int difference = messageDay - currentDay;
    
   // NSLog(@"the date difference is %d",difference);
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:difference];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDate *differeneDay = [gregorian dateByAddingComponents:components toDate:today options:0];
   // NSLog(@"Difference Day: %@", differeneDay);
    
    dayCurrent = [self transformedValue:differeneDay];

    return difference;

}
- (id)transformedValue:(NSDate *)date
{
    // Initialize the formatter.
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    
    // Initialize the calendar and flags.
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSWeekdayCalendarUnit;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // Create reference date for supplied date.
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    [comps setHour:0];
    [comps setMinute:0];
    [comps setSecond:0];
    NSDate *suppliedDate = [calendar dateFromComponents:comps];
    
    // Iterate through the eight days (tomorrow, today, and the last six).
    int i;
    for (i = -1; i < 7; i++)
    {
        // Initialize reference date.
        comps = [calendar components:unitFlags fromDate:[NSDate date]];
        [comps setHour:0];
        [comps setMinute:0];
        [comps setSecond:0];
        [comps setDay:[comps day] - i];
        NSDate *referenceDate = [calendar dateFromComponents:comps];
        // Get week day (starts at 1).
        int weekday = [[calendar components:unitFlags fromDate:referenceDate] weekday] - 1;
        
        if ([suppliedDate compare:referenceDate] == NSOrderedSame && i == -1)
        {
            // Tomorrow
            return @"Tomorrow";
        }
        else if ([suppliedDate compare:referenceDate] == NSOrderedSame && i == 0)
        {
            // Today's time (a la iPhone Mail)
            [formatter setDateStyle:NSDateFormatterNoStyle];
            [formatter setTimeStyle:NSDateFormatterShortStyle];
            return [formatter stringFromDate:date];
        }
        else if ([suppliedDate compare:referenceDate] == NSOrderedSame && i == 1)
        {
            // Today
            return @"Yesterday";
        }
        else if ([suppliedDate compare:referenceDate] == NSOrderedSame)
        {
            // Day of the week
            NSString *day = [[formatter weekdaySymbols] objectAtIndex:weekday];
            return day;
        }
    }
    
    // It's not in those eight days.
    NSString *defaultDate = [formatter stringFromDate:date];
    return defaultDate;
}








- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSIndexPath *indexPath = [self.mytable indexPathForSelectedRow];
    PanicFrom *panic = segue.destinationViewController;
    
    if ([segue.identifier isEqualToString:@"FromSegue"]) {
        
        panic.panicPersonId = indexPath.row;
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
