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
#import "checkInternet.h"
#import "Constants.h"
#import <Parse/Parse.h>

@interface Victims ()

@end

@implementation Victims{

    UIActivityIndicatorView *image_loading;
    NSString *nameToAdd;
    UIImage *img;
    NSString *profilePic ;
    NSString *imagePathString ;
    NSURL *imagePathUrl;
    NSData *data ;
    NSString *hourWithMin;
    NSString *hour;
    int messageDay;
    int currentDay;
    NSString *dayCurrent;
    UIActivityIndicatorView *pageLoading;
    checkInternet *c;
    WebService *panicFromRestObj;
    NSArray *AcceptToSendLocationJsonArray;
    UIButton *accept_location;
    NSString *FindNotificationMessage;
    int receivedStatus ;
    
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

    panicFromRestObj = [[WebService alloc] init];
    
    self.refresh = [[UIRefreshControl alloc] init];
    [self.refresh addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    [self.mytable addSubview:self.refresh];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    c = [[checkInternet alloc]init];
    [c viewWillAppear:YES];

    pageLoading = [c indicatorprogress:pageLoading];
    [self.view addSubview:pageLoading];
    [pageLoading bringSubviewToFront:self.view];
    
    dispatch_queue_t myqueue = dispatch_queue_create("myqueue", NULL);
    dispatch_async(myqueue, ^(void) {
        
        [pageLoading startAnimating];
        
        [self callThePanicFromArray];
        [self callThePanicToArray];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update UI on main queue
            
            [self.tableView reloadData];
            [pageLoading stopAnimating];
            
        });
        
    });

  }


-(void)callThePanicFromArray{
    PanicFromArray = [[NSArray alloc] initWithArray:[panicFromRestObj FilePath:@"http://fajjemobile.info/iospanic/panicFrom.php" parameterOne:nil]];
}

-(void)callThePanicToArray{
    PanicToArray = [[NSArray alloc] initWithArray:[panicFromRestObj FilePath:@"http://fajjemobile.info/iospanic/panicTo.php" parameterOne:nil]];
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
    
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(60, 3, 130, 15)];
    [name setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.f]];
    name.text = @"";
    
    UILabel *status = [[UILabel alloc]initWithFrame:CGRectMake(60, 20, 170, 13)];
    [status setFont:[UIFont fontWithName:@"HelveticaNeue" size:11.f]];
    status.textColor = [UIColor grayColor];
    status.text = @"";
    
    UILabel *message = [[UILabel alloc]initWithFrame:CGRectMake(60, 34, 160, 13)];
    [message setFont:[UIFont fontWithName:@"HelveticaNeue" size:11.f]];
    message.textColor = [UIColor grayColor];
    message.numberOfLines = 2;
    message.text = @"";

    UILabel *timestamp = [[UILabel alloc]initWithFrame:CGRectMake(220, 2, 80, 20)];
    [timestamp setFont:[UIFont fontWithName:@"HelveticaNeue" size:14.f]];
    timestamp.text = @"";

    accept_location = [[UIButton alloc]initWithFrame:CGRectMake(220, 22, 80, 20)];
    //[accept_location setTitle:@"Accept" forState:normal];
    [accept_location setTitleColor:[UIColor whiteColor] forState:normal];
    [accept_location setBackgroundColor:[UIColor blackColor]];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(10, 5, 40, 40);
    imageView.layer.cornerRadius = 20;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [imageView setClipsToBounds:YES];
    
    timestamp.textColor = [UIColor grayColor];
    timestamp.textAlignment = NSTextAlignmentCenter;
    
    int calculatedDifference;
    
    if(self.segments.selectedSegmentIndex == 0)
    {
        // Panic From table view
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:simpleTableIdentifier];
        }
        
        [[self.segments.subviews objectAtIndex:0] setBackgroundColor:[UIColor whiteColor]];
        
        profilePic = [[PanicFromArray valueForKey:@"pic"] objectAtIndex:indexPath.row];

        name.text = [[PanicFromArray valueForKey:@"username"]objectAtIndex:indexPath.row];
        message.text = [[PanicFromArray valueForKey:@"pMessage" ] objectAtIndex:indexPath.row];
        receivedStatus = [[[PanicFromArray valueForKey:@"received" ] objectAtIndex:indexPath.row]intValue];
        
        if(receivedStatus == 0)
        {
            //[accept_location setTitle:@"Accept" forState:normal];
            status.text = @"Status: Pending";
            //[accept_location addTarget:self action:@selector(AcceptToSendLocation:) forControlEvents:UIControlEventTouchUpInside];
           // accept_location.tag = indexPath.row;
            
        }
        else
        {
            //[accept_location setTitle:@"Sent" forState:normal];
            status.text = @"Status: Received";
        }
        
        calculatedDifference = [self calculateDifference:indexPath.row FromArray:PanicFromArray];
        
        if(calculatedDifference == 0)
        {
            timestamp.text = hourWithMin;
        }
        else if(calculatedDifference < 7)
        {
            timestamp.text = dayCurrent;
        }
        else
        {
            timestamp.text = [NSString stringWithFormat:@"%d",messageDay];
        }
        
    }
    else
    {
        [[self.segments.subviews objectAtIndex:1] setBackgroundColor:[UIColor whiteColor]];
        //PanicTo Table View
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:simple];
        }
        
        name.text = [[PanicToArray valueForKey:@"username" ] objectAtIndex:indexPath.row];
        profilePic = [[PanicToArray valueForKey:@"pic"] objectAtIndex:indexPath.row];
        message.text = [[PanicToArray valueForKey:@"pMessage"] objectAtIndex:indexPath.row];
        receivedStatus = [[[PanicToArray valueForKey:@"received" ] objectAtIndex:indexPath.row]intValue];
        if(receivedStatus == 0)
        {
            [accept_location setTitle:@"Accept" forState:normal];
            status.text = @"Status: Pending";
            [accept_location addTarget:self action:@selector(AcceptToSendLocation:) forControlEvents:UIControlEventTouchUpInside];
            accept_location.tag = indexPath.row;
            
        }
        else
        {
            [accept_location setTitle:@"Sent" forState:normal];
            status.text = @"Status: Received";
        }
        
    
        if([[[PanicToArray valueForKey:@"type"] objectAtIndex:indexPath.row] isEqualToString:@"F"]){
            
            [cell addSubview:accept_location];
            
        }
        
        image_loading = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(20,20,20,20)];
        [image_loading setColor:[UIColor blackColor]];
        [cell addSubview:image_loading];
        
        [image_loading startAnimating];
        
        [cell.imageView setFrame:CGRectMake(20,20,20,20)];
        calculatedDifference = [self calculateDifference:indexPath.row FromArray:PanicToArray];
        
        if(calculatedDifference == 0) {
            timestamp.text = hourWithMin;
        }
        else if(calculatedDifference < 7){
            timestamp.text = dayCurrent;
        }
        else{
            timestamp.text = [NSString stringWithFormat:@"%d",messageDay];
        }
       
    }
    
    imagePathString = @"http://fajjemobile.infofajjemobile.info/iospanic/assets/upload/";
    imagePathString = [imagePathString stringByAppendingString:profilePic];
    
    imagePathUrl = [NSURL URLWithString:imagePathString];
    
    dispatch_queue_t myqueue = dispatch_queue_create("myqueue", NULL);
    dispatch_async(myqueue, ^(void) {
        
        data = [[NSData alloc]initWithContentsOfURL:imagePathUrl];
        img = [[UIImage alloc]initWithData:data];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            imageView.image = img;
            [cell addSubview:imageView];
            [image_loading stopAnimating];
        });
        
    });
    
    [cell addSubview:name];
    [cell addSubview:message];
    [cell addSubview:timestamp];
    [cell addSubview:status];

    return cell;
}

-(int)calculateDifference:(int)index FromArray:(NSArray *)timeFromArray{
    
    NSString *dateFromJson = [[timeFromArray valueForKey:@"timestamp"]objectAtIndex:index];
    NSDate *today = [NSDate date];
    
   // NSLog(@"Today: %@",today);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
   // [dateFormatter setDateFormat: @"EEEE"];
    
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * JsonDateFormatted = [dateFormatter dateFromString:dateFromJson];
    [dateFormatter setDateFormat:@"dd"];
    messageDay = [[dateFormatter stringFromDate:JsonDateFormatted] intValue];
    
    [dateFormatter setDateFormat:@"HH:mm"];
    hourWithMin = [dateFormatter stringFromDate:JsonDateFormatted];
    
    [dateFormatter setDateFormat:@"HH"];
    hour = [dateFormatter stringFromDate:JsonDateFormatted];
    
    if([hour intValue] > 12){
        
    }

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
            NSLog(@"the current dat is %@",[formatter stringFromDate:date]);
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

- (void)refreshTable{
    [self.refresh endRefreshing];
    PanicToArray = nil;
    PanicFromArray = nil;
    [self callThePanicToArray];
    [self callThePanicFromArray];
    [self.mytable reloadData];
}

-(void)AcceptToSendLocation:(id)sender
{
    accept_location = (UIButton*) sender;
    WebService *AcceptToSendLocationRest = [[WebService alloc] init];
    AcceptToSendLocationJsonArray = [AcceptToSendLocationRest FilePath:BASEURL ACCEPT_TO_SEND_LOCATION parameterOne:[[PanicToArray valueForKeyPath:@"friendsnumber"] objectAtIndex:accept_location.tag] parameterTwo:@"20" parameterThree:[[PanicToArray valueForKey:@"id"] objectAtIndex:accept_location.tag]];
    
    if([[AcceptToSendLocationJsonArray valueForKey:@"success"] isEqualToString:@"200"]){
        [accept_location setTitle:@"Sent" forState:normal];
        PFPush *push = [[PFPush alloc] init];
        //[push setChannel:@"X_090078601"];   // channels column in PARSE!
        [push setChannel:[@"X_" stringByAppendingString:[[PanicToArray valueForKey:@"friendsnumber"] objectAtIndex:accept_location.tag]]];
        FindNotificationMessage = [[[NSUserDefaults standardUserDefaults] stringForKey:@"name"] stringByAppendingString:@" sent his location."];
        [push setMessage:FindNotificationMessage];
        //[push setData:data];
        [push sendPushInBackground];
    }
    else{
        // Alert value for key @"error" from acceptToSendLocationJsonArray
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"FromSegue" sender:self];
}
@end
