//
//  help_systemStatus.m
//  Panic Alarm
//
//  Created by Avialdo on 11/12/2015.
//  Copyright © 2015 Zohair Hemani - Stanford Assignment. All rights reserved.
//

#import "help_systemStatus.h"
#import "checkInternet.h"
#import "Constants.h"

@interface help_systemStatus ()
{
    checkInternet *checkInternetObj;
    UIActivityIndicatorView *progress;
}

@end

@implementation help_systemStatus

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    checkInternetObj = [[checkInternet alloc] init];
    [checkInternetObj viewWillAppear:YES];
    
    progress = [checkInternetObj indicatorprogress:progress];
    [self.view addSubview:progress];
    [progress bringSubviewToFront:self.view];

    [progress startAnimating];
    self.webView.scrollView.bounces = false;
    self.webView.delegate = self;
    if([checkInternetObj internetstatus] == true)
    {
        [self.webView loadRequest:[self getURLRequest]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(NSURLRequest *)getURLRequest
{
    NSString *fullURL = [BASEURL stringByAppendingString:self.pageName];
    NSLog(@"url: %@", fullURL);
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    return requestObj;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [progress stopAnimating];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
