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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    
    
    
    UIImage *backgroundImage = [UIImage imageNamed:@"background.png"];
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:backgroundImage];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    if(self.panicPersonType == 0){
        panicPersonName.text = [[[Victims getPanicToArray] valueForKey:@"username"] objectAtIndex:self.panicPersonId];
        
        profilePic = [[[Victims getPanicToArray] valueForKey:@"pic"] objectAtIndex:self.panicPersonId];
    }
    else{
        panicPersonName.text = [[[Victims getPanicFromArray] valueForKey:@"username"] objectAtIndex:self.panicPersonId];
        
        profilePic = [[[Victims getPanicFromArray] valueForKey:@"pic"] objectAtIndex:self.panicPersonId];
    }
    
    imagePathString = @"http://www.bizsocialcard.com/iospanic/assets/upload/";
    imagePathString = [imagePathString stringByAppendingString:profilePic];
    imagePathUrl = [NSURL URLWithString:imagePathString];
    data = [[NSData alloc]initWithContentsOfURL:imagePathUrl];
    img = [[UIImage alloc]initWithData:data ];
    [self.panicPersonImage setImage:img];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)findLocation:(id)sender {
    [self performSegueWithIdentifier:@"goToMap" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    Map *map = segue.destinationViewController;
    
    if ([segue.identifier isEqualToString:@"goToMap"]) {
        
        map.panicPersonId = self.panicPersonId;
        map.panicPersonType = self.panicPersonType;
    }
    
}

@end
