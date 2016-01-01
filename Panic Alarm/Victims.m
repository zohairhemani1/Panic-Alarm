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

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

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
    int receivedStatus;
    NSMutableDictionary *imagesDictionary;
    UIImageView *imageView;
    
}
static NSArray *PanicFromArray;
static NSArray *PanicToArray;

@synthesize mytable = _tableView;

- (instancetype)initWithStyle:(UITableViewStyle)style
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
    
    (self.navigationController.navigationBar).titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
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
    if(self.segments.selectedSegmentIndex == 0)
    {
        return PanicFromArray.count;
    }
    else
    {
        return PanicToArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"myvictims";
    static NSString *simple = @"second";
    
    UITableViewCell *cell;
    
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(60, 3, 130, 15)];
    name.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.f];
    name.text = @"";
    
    UILabel *status = [[UILabel alloc]initWithFrame:CGRectMake(60, 18, 170, 13)];
    status.font = [UIFont fontWithName:@"Helvetica-Bold" size:11.f];
    status.textColor = [UIColor grayColor];
    status.text = @"";
    
    UILabel *message = [[UILabel alloc]initWithFrame:CGRectMake(60, 30, 160, 30)];
    message.font = [UIFont fontWithName:@"HelveticaNeue" size:11.f];
    message.textColor = [UIColor grayColor];
    [message setNumberOfLines:0];
    message.text = @"";

    UILabel *timestamp = [[UILabel alloc]initWithFrame:CGRectMake(220, 2, 80, 20)];
    timestamp.font = [UIFont fontWithName:@"HelveticaNeue" size:14.f];
    timestamp.text = @"";

    accept_location = [[UIButton alloc]initWithFrame:CGRectMake(225, 22, 70, 20)];
    [accept_location setTitleColor:[UIColor whiteColor] forState:normal];
//    accept_location.clipsToBounds = YES;
//    accept_location.layer.cornerRadius = 5;
//    accept_location.backgroundColor = [UIColor colorWithRed:89.0f/255 green:34.0f/255 blue:122.0f/255 alpha:1.0];
    accept_location.backgroundColor = [UIColor blueColor];
    
    timestamp.textColor = [UIColor grayColor];
    timestamp.textAlignment = NSTextAlignmentCenter;
    
    int calculatedDifference;
    
    image_loading = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(20,20,20,20)];
    image_loading.color = [UIColor blackColor];
    
    
    if(self.segments.selectedSegmentIndex == 0)
    {
        // Panic From table view
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:simpleTableIdentifier];
        }
        
        (self.segments.subviews)[0].backgroundColor = [UIColor whiteColor];
        
        profilePic = [PanicFromArray valueForKey:@"pic"][indexPath.row];
        name.text = [[PanicFromArray valueForKey:@"username"][indexPath.row] uppercaseString];
        message.text =[PanicFromArray valueForKey:@"pMessage" ][indexPath.row];
        receivedStatus = [[PanicFromArray valueForKey:@"received" ][indexPath.row]intValue];
        
        UIImage *retrievedImage = [imagesDictionary valueForKey:[PanicFromArray valueForKey:@"pic"][indexPath.row]];
        if (retrievedImage == nil) {
            dispatch_async(kBgQueue, ^{
                [image_loading startAnimating];
                NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://fajjemobile.info/iospanic/assets/upload/%@",[PanicFromArray valueForKey:@"pic"][indexPath.row]]]];
                
                UIImage *image;
                if([[PanicFromArray valueForKey:@"pic"][indexPath.row] isEqualToString:@""])
                {
                    image = [UIImage imageNamed:@"no_image"];
                }
                else
                {
                    image = [UIImage imageWithData:imgData];
                }
                if (image) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UITableViewCell *updateCell = (id)[tableView cellForRowAtIndexPath:indexPath];
                        if (updateCell)
                        {
                            imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10,10,40,40)];
                            imageView.image = image;
                            imageView.layer.cornerRadius = 20;
                            imageView.contentMode = UIViewContentModeScaleAspectFill;
                            [imageView setClipsToBounds:YES];
                            
                            imagesDictionary[[PanicFromArray valueForKey:@"pic"][indexPath.row]] = image;
                            [updateCell addSubview:imageView];
                            [image_loading stopAnimating];
                        }
                    });
                }
            });
        }
        else
        {
            imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10,5,40,40)];
            imageView.image = retrievedImage;
            [cell addSubview:imageView];
            
        }

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
        
        [cell addSubview:image_loading];
        [image_loading startAnimating];
        
    }
    else
    {
        (self.segments.subviews)[1].backgroundColor = [UIColor whiteColor];
        //PanicTo Table View
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:simple];
        }
        
        name.text = [[PanicToArray valueForKey:@"username" ][indexPath.row] uppercaseString];
        profilePic = [PanicToArray valueForKey:@"pic"][indexPath.row];
        message.text = [PanicToArray valueForKey:@"pMessage"][indexPath.row];
        receivedStatus = [[PanicToArray valueForKey:@"received"][indexPath.row]intValue];
        
        UIImage *retrievedImage = [imagesDictionary valueForKey:[PanicToArray valueForKey:@"pic"][indexPath.row]];
        if (retrievedImage == nil) {
            dispatch_async(kBgQueue, ^{
                [image_loading startAnimating];
                NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://fajjemobile.info/iospanic/assets/upload/%@",[PanicToArray valueForKey:@"pic"][indexPath.row]]]];
                
                UIImage *image;
                if([[PanicToArray valueForKey:@"pic"][indexPath.row] isEqualToString:@""])
                {
                    image = [UIImage imageNamed:@"no_image"];
                }
                else
                {
                    image = [UIImage imageWithData:imgData];
                }
                if (image) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UITableViewCell *updateCell = (id)[tableView cellForRowAtIndexPath:indexPath];
                        if (updateCell)
                        {
                            imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10,10,40,40)];
                            imageView.image = image;
                            imageView.layer.cornerRadius = 20;
                            imageView.contentMode = UIViewContentModeScaleAspectFill;
                            [imageView setClipsToBounds:YES];
                            
                            imagesDictionary[[PanicToArray valueForKey:@"pic"][indexPath.row]] = image;
                            [updateCell addSubview:imageView];
                            [image_loading stopAnimating];
                        }
                    });
                }
            });
        }
        else
        {
            imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10,5,40,40)];
            imageView.image = retrievedImage;
            [cell addSubview:imageView];
            
        }

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
        
    
        if([[PanicToArray valueForKey:@"type"][indexPath.row] isEqualToString:@"F"]){
            
            [cell addSubview:accept_location];
            
        }

        (cell.imageView).frame = CGRectMake(20,20,20,20);
        calculatedDifference = [self calculateDifference:indexPath.row FromArray:PanicToArray];
       
        [cell addSubview:image_loading];
        [image_loading startAnimating];
        
    }
    
    if(calculatedDifference == 0) {
        timestamp.text = hourWithMin;
    }
    else if(calculatedDifference < 7){
        timestamp.text = dayCurrent;
    }
    else{
        timestamp.text = [NSString stringWithFormat:@"%d",messageDay];
    }
    
    [cell addSubview:name];
    [cell addSubview:message];
    [message sizeToFit];
    [cell addSubview:timestamp];
    [cell addSubview:status];

    return cell;
}

-(int)calculateDifference:(int)index FromArray:(NSArray *)timeFromArray{
    
    NSString *dateFromJson = [timeFromArray valueForKey:@"timestamp"][index];
    NSDate *today = [NSDate date];
    
   // NSLog(@"Today: %@",today);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
   // [dateFormatter setDateFormat: @"EEEE"];
    
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate * JsonDateFormatted = [dateFormatter dateFromString:dateFromJson];
    dateFormatter.dateFormat = @"dd";
    messageDay = [dateFormatter stringFromDate:JsonDateFormatted].intValue;
    
    dateFormatter.dateFormat = @"HH:mm";
    hourWithMin = [dateFormatter stringFromDate:JsonDateFormatted];
    
    dateFormatter.dateFormat = @"HH";
    hour = [dateFormatter stringFromDate:JsonDateFormatted];
    
    if(hour.intValue > 12){
        
    }

    dateFormatter.dateFormat = @"dd";
    currentDay = [dateFormatter stringFromDate:today].intValue;

    int difference = messageDay - currentDay;
    
   // NSLog(@"the date difference is %d",difference);
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = difference;
    
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
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeStyle = NSDateFormatterNoStyle;
    
    // Initialize the calendar and flags.
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSWeekdayCalendarUnit;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // Create reference date for supplied date.
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    comps.hour = 0;
    comps.minute = 0;
    comps.second = 0;
    NSDate *suppliedDate = [calendar dateFromComponents:comps];
    
    // Iterate through the eight days (tomorrow, today, and the last six).
    int i;
    for (i = -1; i < 7; i++)
    {
        // Initialize reference date.
        comps = [calendar components:unitFlags fromDate:[NSDate date]];
        comps.hour = 0;
        comps.minute = 0;
        comps.second = 0;
        comps.day = comps.day - i;
        NSDate *referenceDate = [calendar dateFromComponents:comps];
        // Get week day (starts at 1).
        int weekday = [calendar components:unitFlags fromDate:referenceDate].weekday - 1;
        
        if ([suppliedDate compare:referenceDate] == NSOrderedSame && i == -1)
        {
            // Tomorrow
            return @"Tomorrow";
        }
        else if ([suppliedDate compare:referenceDate] == NSOrderedSame && i == 0)
        {
            // Today's time (a la iPhone Mail)
            formatter.dateStyle = NSDateFormatterNoStyle;
            formatter.timeStyle = NSDateFormatterShortStyle;
            //NSLog(@"the current dat is %@",[formatter stringFromDate:date]);
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
            NSString *day = formatter.weekdaySymbols[weekday];
            return day;
        }
    }
    
    // It's not in those eight days.
    NSString *defaultDate = [formatter stringFromDate:date];
    return defaultDate;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = (self.mytable).indexPathForSelectedRow;
    PanicFrom *panic = segue.destinationViewController;
    
    if ([segue.identifier isEqualToString:@"FromSegue"]) {
        
        panic.panicPersonId = indexPath.row;
        
        if(receivedStatus == 0)
        {
            NSLog(@"THE status is %d", receivedStatus);
            
            panic.panicStatus = 0;
        }
        else{
            panic.panicStatus = 1;
        }
    }
}

+(NSArray *)getPanicFromArray{
    return PanicFromArray;
}

+(NSArray *)getPanicToArray{
    return PanicToArray;
}

- (void)refreshTable{
    [self.refresh endRefreshing];
    if(self.segments.selectedSegmentIndex == 0)
    {
        PanicFromArray = nil;
        [self callThePanicFromArray];
    }
    else
    {
        PanicToArray = nil;
        [self callThePanicToArray];
    }
    
    [self.mytable reloadData];
}

-(void)AcceptToSendLocation:(id)sender
{
    if([[NSUserDefaults standardUserDefaults]valueForKey:@"latitude"] !=nil)
    {
        NSString *locationString = [NSString stringWithFormat:@"%@,%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"latitude"],[[NSUserDefaults standardUserDefaults]valueForKey:@"longitude"]];
        
        accept_location = (UIButton*) sender;
        WebService *AcceptToSendLocationRest = [[WebService alloc] init];
        AcceptToSendLocationJsonArray = [AcceptToSendLocationRest FilePath:BASEURL ACCEPT_TO_SEND_LOCATION parameterOne:[PanicToArray valueForKeyPath:@"friendsnumber"][accept_location.tag] parameterTwo:locationString parameterThree:[PanicToArray valueForKey:@"id"][accept_location.tag]];
        
        if([[AcceptToSendLocationJsonArray valueForKey:@"success"] isEqualToString:@"200"]){
            [accept_location setTitle:@"Sent" forState:normal];
            PFPush *push = [[PFPush alloc] init];
            //[push setChannel:@"X_090078601"];   // channels column in PARSE!
            [push setChannel:[@"X_" stringByAppendingString:[PanicToArray valueForKey:@"friendsnumber"][accept_location.tag]]];
            FindNotificationMessage = [[[NSUserDefaults standardUserDefaults] stringForKey:@"name"] stringByAppendingString:@" sent his location."];
            [push setMessage:FindNotificationMessage];
            //[push setData:data];
            [push sendPushInBackground];
        }
        else{
            // Alert value for key @"error" from acceptToSendLocationJsonArray
        }
    }
    else
    {
        if([[[UIDevice currentDevice] systemVersion] floatValue]<8.0)
        {
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"This app does not have access to Location service" message:@"You can enable access in Settings->Privacy->Location->Location Services" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"This app does not have access to Location service" message:@"You can enable access in Settings->Privacy->Location->Location Services" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Settings", nil];
            alert.tag=121;
            [alert show];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 121 && buttonIndex == 1)
    {
        [[UIApplication sharedApplication] openURL:[NSURL  URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.segments.selectedSegmentIndex == 0)
    {
        [self performSegueWithIdentifier:@"FromSegue" sender:self];
    }
}
@end
