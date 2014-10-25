//
//  About.m
//  Panic Alarm
//
//  Created by Zainu Corporation on 26/07/2014.
//  Copyright (c) 2014 Zohair Hemani - Stanford Assignment. All rights reserved.
//

#import "About.h"
#import "checkInternet.h"

@implementation About{
    UIActivityIndicatorView *progress;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.myWebView loadRequest:[self getURLRequest]];
}

-(NSURLRequest *)getURLRequest{
    NSString *fullURL = @"http://facebook.com";
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    return requestObj;
}
@end
