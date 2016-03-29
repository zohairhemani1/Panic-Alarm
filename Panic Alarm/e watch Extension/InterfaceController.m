//
//  InterfaceController.m
//  e watch Extension
//
//  Created by Avialdo on 28/03/2016.
//  Copyright © 2016 Zohair Hemani - Stanford Assignment. All rights reserved.
//

#import "InterfaceController.h"



@interface InterfaceController()

@end

@implementation InterfaceController
{
    
}

- (void)awakeWithContext:(id)context
{
    [super awakeWithContext:context];
}

- (void)willActivate
{
    [super willActivate];
    
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"myPhoneNumber"]);
    
    [self.panicButtonGroup setBackgroundImageNamed:@"eButton3"];
    
}

- (void)didDeactivate
{
    [super didDeactivate];
}

- (IBAction)sendPanic
{
    
    // Sound and animation work //
    [self.panicButtonGroup setBackgroundImageNamed:@"eButton"];
    [self.panicButtonGroup startAnimating];

    [NSTimer scheduledTimerWithTimeInterval:3.0
                                     target:self
                                   selector:@selector(stopSoundAndAnimation)
                                   userInfo:nil
                                    repeats:YES];
    // Sound and animation work //
}

-(void)stopSoundAndAnimation
{
    [self.panicButtonGroup stopAnimating];
    [self.panicButtonProperties setBackgroundImageNamed:@"eButton3"];
}

@end



