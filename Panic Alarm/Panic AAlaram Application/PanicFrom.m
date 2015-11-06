//
//  PanicFrom.m
//  Panic Alarm
//
//  Created by Zainu Corporation on 05/07/2014.
//  Copyright (c) 2014 Zohair Hemani - Stanford Assignment. All rights reserved.
//

#import "PanicFrom.h"
#import "checkInternet.h"
#import "Map.h"
#import "Victims.h"
#import "WebService.h"
#import "Constants.h"

@interface PanicFrom (){
checkInternet *c;
    UIImage *img;
    NSString *profilePic ;
    NSString *imagePathString ;
    NSURL *imagePathUrl;
    NSData *data ;
}
@end
@implementation PanicFrom

@synthesize panicPersonName;

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
    
    self.panicView.backgroundColor = [UIColor whiteColor];
    
    UIImage *backgroundImage = [UIImage imageNamed:@"background.png"];
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:backgroundImage];
    (self.navigationController.navigationBar).titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    NSLog(@"the panic person id is: %d",self.panicPersonId);
    
    
    panicPersonName.text = [[Victims getPanicFromArray] valueForKey:@"username"][self.panicPersonId];
    profilePic = [[Victims getPanicFromArray] valueForKey:@"pic"][self.panicPersonId];
    self.panicMessage.text = [[Victims getPanicFromArray] valueForKey:@"panicMessage"][self.panicPersonId];
    self.panicNumber.text = [[Victims getPanicFromArray] valueForKey:@"friendsnumber"][self.panicPersonId];
    
    imagePathString = @"http://fajjemobile.info/iospanic/assets/upload/";
    imagePathString = [imagePathString stringByAppendingString:profilePic];
    
    NSLog(@"image path string is: %@",imagePathString);
    imagePathUrl = [NSURL URLWithString:imagePathString];
    data = [[NSData alloc]initWithContentsOfURL:imagePathUrl];
    img = [[UIImage alloc]initWithData:data ];
    (self.panicPersonImage).image = img;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)findLocation:(id)sender {
    [self performSegueWithIdentifier:@"goToMap" sender:self];
    WebService *locationReceived = [[WebService alloc] init];
    [locationReceived FilePath:BASEURL ACCEPT_LOCATION parameterOne:@""];
    
    //parameter1 : id
    //2: panicvictim_id
    //3: friendsnumber
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    Map *map = segue.destinationViewController;
    
    if ([segue.identifier isEqualToString:@"goToMap"]) {
        
        map.panicPersonId = self.panicPersonId;
    }
    
}

@end
