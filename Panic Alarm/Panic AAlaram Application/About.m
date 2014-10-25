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
    UIActivityIndicatorView *pageLoading;
    checkInternet *c;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    c = [[checkInternet alloc]init];
    [c viewWillAppear:YES];
    
    pageLoading = [c indicatorprogress:pageLoading];
    [self.view addSubview:pageLoading];
    [pageLoading bringSubviewToFront:self.view];
    
    dispatch_queue_t myqueue = dispatch_queue_create("myqueue", NULL);
    dispatch_async(myqueue, ^(void) {
        
        [pageLoading startAnimating];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update UI on main queue
            
            [self.myWebView loadRequest:[self getURLRequest]];
            [pageLoading stopAnimating];
            
        });
        
    });

}

-(NSURLRequest *)getURLRequest{
    NSString *fullURL = @"http://facebook.com";
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    return requestObj;
}
@end
