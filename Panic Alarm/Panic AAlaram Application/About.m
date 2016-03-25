//
//  About.m
//  Panic Alarm
//
//  Created by Zainu Corporation on 26/07/2014.
//  Copyright (c) 2014 Zohair Hemani - Stanford Assignment. All rights reserved.
//

#import "About.h"
#import "websiteWebview.h"

@implementation About

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage *backgroundImage = [UIImage imageNamed:@"background_tabone"];
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:backgroundImage];
}
- (IBAction)aboutButtonClicked:(id)sender
{
    [self performSegueWithIdentifier:@"avialdoSegue" sender:self];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    websiteWebview *w = segue.destinationViewController;
    w.pageName = @"http://avialdo.com/";
}

@end
