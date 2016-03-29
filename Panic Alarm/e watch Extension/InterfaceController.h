//
//  InterfaceController.h
//  e watch Extension
//
//  Created by Avialdo on 28/03/2016.
//  Copyright © 2016 Zohair Hemani - Stanford Assignment. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface InterfaceController : WKInterfaceController
@property (strong, nonatomic) IBOutlet WKInterfaceGroup *panicButtonGroup;

@property (strong, nonatomic) IBOutlet WKInterfaceButton *panicButtonProperties;
- (IBAction)sendPanic;
@end
