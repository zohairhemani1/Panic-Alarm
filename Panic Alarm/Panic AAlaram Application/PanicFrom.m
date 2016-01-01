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
    
    self.view.layer.cornerRadius = 10;
    
    c = [[checkInternet alloc]init];
    [c viewWillAppear:YES];
    
    if(self.panicStatus == 0)
    {
        self.findLocationButton.enabled = false;
    }
    self.panicView.backgroundColor = [UIColor whiteColor];
    
    UIImage *backgroundImage = [UIImage imageNamed:@"background.png"];
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:backgroundImage];
    (self.navigationController.navigationBar).titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    //NSLog(@"the panic person id is: %d",self.panicPersonId);
    
    panicPersonName.text = [[[Victims getPanicFromArray] valueForKey:@"username"][self.panicPersonId] uppercaseString];
    profilePic = [[Victims getPanicFromArray] valueForKey:@"pic"][self.panicPersonId];
    self.panicMessage.text = [[Victims getPanicFromArray] valueForKey:@"pMessage"][self.panicPersonId];
    self.panicNumber.text = [[Victims getPanicFromArray] valueForKey:@"mynumber"][self.panicPersonId];
    
    imagePathString = @"http://fajjemobile.info/iospanic/assets/upload/";
    imagePathString = [imagePathString stringByAppendingString:profilePic];
    
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
- (IBAction)findLocation:(id)sender
{
    if(self.panicStatus == 1)
    {
        [self performSegueWithIdentifier:@"goToMap" sender:self];
        WebService *locationReceived = [[WebService alloc] init];
        [locationReceived FilePath:BASEURL ACCEPT_LOCATION parameterOne:@"" parameterTwo:@"" parameterThree:@""];
    }
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
