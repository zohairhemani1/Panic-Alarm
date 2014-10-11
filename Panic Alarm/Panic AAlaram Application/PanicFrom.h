//
//  PanicFrom.h
//  Panic Alarm
//
//  Created by Zainu Corporation on 05/07/2014.
//  Copyright (c) 2014 Zohair Hemani - Stanford Assignment. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PanicFrom : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *panicPersonName;
@property (weak, nonatomic) IBOutlet UIImageView *panicPersonImage;
@property (nonatomic, strong) NSString *personName;


@end
