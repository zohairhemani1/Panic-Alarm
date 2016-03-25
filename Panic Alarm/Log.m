//
//  Log.m
//  Panic Alarm
//
//  Created by Zainu Corporation on 18/07/2014.
//  Copyright (c) 2014 Zohair Hemani - Stanford Assignment. All rights reserved.
//

#import "Log.h"
#import "PanicFrom.h"
#import "WebService.h"
#import "checkInternet.h"
#import "Constants.h"
#import <Parse/Parse.h>
#import "UIImageView+WebCache.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface Log ()

@end

@implementation Log
{
    UIActivityIndicatorView *image_loading;
    NSString *nameToAdd;
    UIImage *img;
    NSString *profilePic;
    NSURL *imagePathUrl;
    NSData *data;
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
    UIImageView *imageView;
    
    float longitude;
    float latitude;
    BOOL sendLocation;
    
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
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestAlwaysAuthorization];
    
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
    PanicFromArray = [panicFromRestObj FilePath:@"http://steve-jones.co/iospanic/panicFrom.php" parameterOne:nil];
    
    if(!PanicFromArray)
    {
        [self showAlertBoxWithTitle:@"Internet Issue" message:@"It seems your Internet connection is Down"];
    }
}

-(void)callThePanicToArray{
    PanicToArray = [panicFromRestObj FilePath:@"http://steve-jones.co/iospanic/panicTo.php" parameterOne:nil];
    if(!PanicToArray)
    {
        [self showAlertBoxWithTitle:@"Internet Issue" message:@"It seems your Internet connection is Down"];
    }
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.segments.selectedSegmentIndex == 0)
    {
        if (PanicFromArray.count == 0)
        {
            return 1;
        }
        else
        {
            return PanicFromArray.count;
        }
    }
    else
    {
        if (PanicToArray.count == 0)
        {
            return 1;
        }
        else
        {
            return PanicToArray.count;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *panicFromIdentifier = @"myvictims";
    static NSString *panicToIdentifier = @"second";
    
    NSString *type;
    NSString *imagePathString;
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

    accept_location = [[UIButton alloc]initWithFrame:CGRectMake(220, 26, 80, 24)];
    [accept_location setTitleColor:[UIColor whiteColor] forState:normal];
    accept_location.clipsToBounds = YES;
    accept_location.layer.cornerRadius = 5;
    accept_location.backgroundColor = [UIColor colorWithRed:89.0f/255 green:34.0f/255 blue:122.0f/255 alpha:1.0];
    
    timestamp.textColor = [UIColor grayColor];
    timestamp.textAlignment = NSTextAlignmentCenter;
    
    //int calculatedDifference;
    
    image_loading = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(20,20,20,20)];
    image_loading.color = [UIColor blackColor];
    
    if(self.segments.selectedSegmentIndex == 0)
    {
        cell = [[UITableViewCell alloc] init];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:panicFromIdentifier];
        }
        
        
                                                    ////////     Panic From table view      //////////
        
        
        if(PanicFromArray.count == 0)
        {
            UILabel *noData;
            
            if(PanicFromArray == nil)
            {
                noData = [[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width / 2 - 40, 25, 180, 20)];
                noData.text = @"Loading...";
            }
            else
            {
                noData = [[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width / 2 - 65, 25, 180, 20)];
                noData.text = @"No Data to Show";
            }
            noData.font = [UIFont fontWithName:@"HelveticaNeue" size:17.f];
            [self.view addSubview:noData];
            [cell addSubview:noData];
        }
        else{

            (self.segments.subviews)[0].backgroundColor = [UIColor whiteColor];
            
            profilePic = [PanicFromArray valueForKey:@"pic"][indexPath.row];
            name.text = [[PanicFromArray valueForKey:@"username"][indexPath.row] uppercaseString];
            message.text =[PanicFromArray valueForKey:@"pMessage" ][indexPath.row];
            receivedStatus = [[PanicFromArray valueForKey:@"received"][indexPath.row]intValue];
            type = [PanicFromArray valueForKey:@"type" ][indexPath.row];
            imagePathString = [NSString stringWithFormat:@"http://steve-jones.co/iospanic/assets/upload/%@",[PanicFromArray valueForKey:@"pic"][indexPath.row]];
            
            imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10,5,40,40)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:imagePathString] placeholderImage:[UIImage imageNamed:@"no_image"] options:SDWebImageCacheMemoryOnly];
            imageView.layer.cornerRadius = 20;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            [imageView setClipsToBounds:YES];
            [cell addSubview:imageView];
            
            if(receivedStatus == 0)
            {
                if([type isEqualToString:@"P"])
                {
                    status.text = @"Status: Received";
                }
                else
                {
                    status.text = @"Status: Pending";
                }
            }
            else
            {
                status.text = @"Status: Received";
            }
            
            //calculatedDifference = [self calculateDifference:indexPath.row FromArray:PanicFromArray];
            
            NSString *newtimeStamp = [PanicFromArray valueForKey:@"timestamp"][indexPath.row];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *newDate = [dateFormat dateFromString:newtimeStamp];
            
            //NSLog(@"the date is %@",[self stringDatePartOf:newDate]);
            [cell addSubview:image_loading];
            
            timestamp.text = [self stringDatePartOf:newDate];
            
            [cell addSubview:image_loading];
            
        }
    }
                                                        /////////////    Panic To Table View     ////////////
    else
    {
        (self.segments.subviews)[1].backgroundColor = [UIColor whiteColor];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:panicToIdentifier];
        }
        if(PanicToArray.count == 0)
        {
            UILabel *noData;
            
            if(PanicToArray == nil)
            {
                noData = [[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width / 2 - 40, 25, 180, 20)];
                noData.text = @"Loading...";
            }
            else
            {
                noData = [[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width / 2 - 65, 25, 180, 20)];
                noData.text = @"No Data to Show";
            }
            noData.font = [UIFont fontWithName:@"HelveticaNeue" size:17.f];
            [self.view addSubview:noData];
            [cell addSubview:noData];
        }
        else
        {
            name.text = [[PanicToArray valueForKey:@"username"][indexPath.row] uppercaseString];
            profilePic = [PanicToArray valueForKey:@"pic"][indexPath.row];
            message.text = [PanicToArray valueForKey:@"pMessage"][indexPath.row];
            receivedStatus = [[PanicToArray valueForKey:@"received"][indexPath.row]intValue];
            type = [PanicToArray valueForKey:@"type"][indexPath.row];
            imagePathString = [NSString stringWithFormat:@"http://steve-jones.co/iospanic/assets/upload/%@",[PanicToArray valueForKey:@"pic"][indexPath.row]];
            
            
            imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10,5,40,40)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:imagePathString] placeholderImage:[UIImage imageNamed:@"no_image"] options:SDWebImageCacheMemoryOnly];
            imageView.layer.cornerRadius = 20;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            [imageView setClipsToBounds:YES];
            [cell addSubview:imageView];
            
            
            if(receivedStatus == 0)
            {
                status.text = @"Status: Pending";                      //////// CASE 4 ////////
                
                [accept_location setTitle:@"Accept" forState:normal];
                [accept_location addTarget:self action:@selector(AcceptToSendLocation:) forControlEvents:UIControlEventTouchUpInside];
                accept_location.tag = indexPath.row;
                
                if([type isEqualToString:@"F"])
                {
                    [cell addSubview:accept_location];
                }
            }
            else
            {
                if([type isEqualToString:@"F"])                        //////// CASE 3 ///////
                {
                    status.text = @"Status: Sent";
                }
                else
                {
                    status.text = @"Status: Received";
                }
            }
            
            (cell.imageView).frame = CGRectMake(20,20,20,20);
            
            NSString *newtimeStamp = [PanicToArray valueForKey:@"timestamp"][indexPath.row];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *newDate = [dateFormat dateFromString:newtimeStamp];

            [cell addSubview:image_loading];
            
            timestamp.text = [self stringDatePartOf:newDate];
        }
    }
        
    
//    if(calculatedDifference == 0) {
//        timestamp.text = hourWithMin;
//    }
//    else if(calculatedDifference < 7){
//        timestamp.text = dayCurrent;
//    }
//    else{
//        timestamp.text = [NSString stringWithFormat:@"%d",messageDay];
//    }
    
    [cell addSubview:name];
    [cell addSubview:message];
    [message sizeToFit];
    [cell addSubview:timestamp];
    [cell addSubview:status];

    return cell;
}

-(void)AcceptToSendLocation:(id)sender
{
    accept_location = (UIButton*) sender;
    
    if([CLLocationManager locationServicesEnabled])
    {
        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied)
        {
            [self showLocationPopUp];
        }
        else
        {
            [pageLoading startAnimating];
            sendLocation = YES;
            [self.locationManager startUpdatingLocation];
        }
    }
    else
    {
        [self showLocationPopUp];
    }
}

-(void) showLocationPopUp
{
    if([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)
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

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [manager stopUpdatingLocation];
    CLLocation *location = locations.lastObject;
    
    if(sendLocation == YES)
    {
        sendLocation = NO;
        latitude = location.coordinate.latitude;
        longitude = location.coordinate.longitude;
        
        [self callWebService];
        
        NSLog(@"latitude %f",latitude);
        NSLog(@"longitude %f",longitude);
    }
}

-(void)callWebService
{
    if(!([[NSString stringWithFormat:@"%f",longitude] isEqualToString:@"0.000000"]))
    {
        NSString *locationString = [NSString stringWithFormat:@"%f,%f",latitude,longitude];
        
        WebService *AcceptToSendLocationRest = [[WebService alloc] init];
        AcceptToSendLocationJsonArray = [AcceptToSendLocationRest FilePath:BASEURL ACCEPT_TO_SEND_LOCATION parameterOne:[PanicToArray valueForKeyPath:@"friendsnumber"][accept_location.tag] parameterTwo:locationString parameterThree:[PanicToArray valueForKey:@"id"][accept_location.tag]];
        
        if([[AcceptToSendLocationJsonArray valueForKey:@"success"] isEqualToString:@"200"])
        {
            //here
            
            [pageLoading stopAnimating];
            [self sendPush];
        }
        else
        {
            [self showAlertBoxWithTitle:@"Internet Issue" message:@"It seems your Internet connection is Down"];
            [pageLoading stopAnimating];
        }
    }
}

-(void)sendPush
{
    NSString *msg = [NSString stringWithFormat:@"%@ has sent you his location",[[NSUserDefaults standardUserDefaults]valueForKey:@"username"]];
    
    NSDictionary *panicData = @{
                                @"alert": msg,
                                @"name": [PanicToArray valueForKey:@"username"][accept_location.tag],
                                @"number": [PanicToArray valueForKeyPath:@"friendsnumber"][accept_location.tag],
                                @"sound":@"cheering.caf"
                                };
    
    [accept_location setHidden:true];
    accept_location.enabled = false;
    
    [[PanicToArray objectAtIndex:accept_location.tag]setValue:@"1" forKey:@"received"];
    [self.mytable reloadData];
    
    
    //[PanicToArray setValue:@"1" forKey:@"received"];
    //[[PanicToArray valueForKey:@"received"][indexPath.row]
    
    NSString *friendsNumber = @"X_";
    friendsNumber = [friendsNumber stringByAppendingString:[[PanicToArray valueForKeyPath:@"friendsnumber"][accept_location.tag] substringFromIndex:1]];
    
    PFPush *push = [[PFPush alloc] init];
    [push setChannel:friendsNumber];
    [push setMessage:msg];
    [push setData:panicData];
    [push sendPushInBackground];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 121 && buttonIndex == 1)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.segments.selectedSegmentIndex == 0)
    {
        [self performSegueWithIdentifier:@"FromSegue" sender:self];
    }
}

-(void)showAlertBoxWithTitle:(NSString*)title message:(NSString*)message
{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"Okay"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                         }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}


-(NSString*) stringDatePartOf:(NSDate*)date
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    return [formatter stringFromDate:date];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = (self.mytable).indexPathForSelectedRow;
    PanicFrom *panic = segue.destinationViewController;
    
    if ([segue.identifier isEqualToString:@"FromSegue"])
    {
        int received = [[PanicFromArray valueForKey:@"received"][indexPath.row]intValue];
        NSString *type = [PanicFromArray valueForKey:@"type"][indexPath.row];
        panic.panicPersonId = indexPath.row;
        
        if([type isEqualToString:@"P"])
        {
            panic.canGoToMap = true;
        }
        else if(received == 1 && [type isEqualToString:@"F"])
        {
            panic.canGoToMap = true;
        }
        else
        {
            panic.canGoToMap = false;
        }
    }
}

+(NSArray *)getPanicFromArray{
    return PanicFromArray;
}

+(NSArray *)getPanicToArray{
    return PanicToArray;
}

- (void)refreshTable
{
    [self.refresh endRefreshing];
    
    [pageLoading startAnimating];
    dispatch_queue_t myqueue = dispatch_queue_create("myqueue", NULL);
    
    dispatch_async(myqueue, ^(void) {
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
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update UI on main queue
            
            [self.mytable reloadData];
            [pageLoading stopAnimating];
        });
    });
    
}




//-(int)calculateDifference:(int)index FromArray:(NSArray *)timeFromArray{
//
//    NSString *dateFromJson = [timeFromArray valueForKey:@"timestamp"][index];
//    NSDate *today = [NSDate date];
//
//   // NSLog(@"Today: %@",today);
//
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//   // [dateFormatter setDateFormat: @"EEEE"];
//
//    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//    NSDate * JsonDateFormatted = [dateFormatter dateFromString:dateFromJson];
//    dateFormatter.dateFormat = @"dd";
//    messageDay = [dateFormatter stringFromDate:JsonDateFormatted].intValue;
//
//    dateFormatter.dateFormat = @"HH:mm";
//    hourWithMin = [dateFormatter stringFromDate:JsonDateFormatted];
//
//    dateFormatter.dateFormat = @"HH";
//    hour = [dateFormatter stringFromDate:JsonDateFormatted];
//
//    if(hour.intValue > 12){
//
//    }
//
//    dateFormatter.dateFormat = @"dd";
//    currentDay = [dateFormatter stringFromDate:today].intValue;
//
//    int difference = messageDay - currentDay;
//
//   // NSLog(@"the date difference is %d",difference);
//
//    NSDateComponents *components = [[NSDateComponents alloc] init];
//    components.day = difference;
//
//    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//
//    NSDate *differeneDay = [gregorian dateByAddingComponents:components toDate:today options:0];
//   // NSLog(@"Difference Day: %@", differeneDay);
//
//    dayCurrent = [self transformedValue:differeneDay];
//
//    return difference;
//
//}
//- (id)transformedValue:(NSDate *)date
//{
//    // Initialize the formatter.
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.dateStyle = NSDateFormatterShortStyle;
//    formatter.timeStyle = NSDateFormatterNoStyle;
//
//    // Initialize the calendar and flags.
//    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSWeekdayCalendarUnit;
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//
//    // Create reference date for supplied date.
//    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
//    comps.hour = 0;
//    comps.minute = 0;
//    comps.second = 0;
//    NSDate *suppliedDate = [calendar dateFromComponents:comps];
//
//    // Iterate through the eight days (tomorrow, today, and the last six).
//    int i;
//    for (i = -1; i < 7; i++)
//    {
//        // Initialize reference date.
//        comps = [calendar components:unitFlags fromDate:[NSDate date]];
//        comps.hour = 0;
//        comps.minute = 0;
//        comps.second = 0;
//        comps.day = comps.day - i;
//        NSDate *referenceDate = [calendar dateFromComponents:comps];
//        // Get week day (starts at 1).
//        int weekday = [calendar components:unitFlags fromDate:referenceDate].weekday - 1;
//
//        if ([suppliedDate compare:referenceDate] == NSOrderedSame && i == -1)
//        {
//            // Tomorrow
//            return @"Tomorrow";
//        }
//        else if ([suppliedDate compare:referenceDate] == NSOrderedSame && i == 0)
//        {
//            // Today's time (a la iPhone Mail)
//            formatter.dateStyle = NSDateFormatterNoStyle;
//            formatter.timeStyle = NSDateFormatterShortStyle;
//            //NSLog(@"the current dat is %@",[formatter stringFromDate:date]);
//            return [formatter stringFromDate:date];
//
//        }
//        else if ([suppliedDate compare:referenceDate] == NSOrderedSame && i == 1)
//        {
//            // Today
//            return @"Yesterday";
//        }
//        else if ([suppliedDate compare:referenceDate] == NSOrderedSame)
//        {
//            // Day of the week
//            NSString *day = formatter.weekdaySymbols[weekday];
//            return day;
//        }
//    }
//
//    // It's not in those eight days.
//    NSString *defaultDate = [formatter stringFromDate:date];
//    return defaultDate;
//}


@end
