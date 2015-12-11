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
    
    if([checkInternetObj internetstatus] == true)
    {
        [self.webView loadRequest:[self getURLRequest]];
    }
    
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:YES];
//    progress = [checkInternetObj indicatorprogress:progress];
//    [self.view addSubview:progress];
//    
//    [progress bringSubviewToFront:self.view];
//    [progress startAnimating];
//    
//}
//
//-(void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:YES];
//    
//}

-(NSURLRequest *)getURLRequest
{
    NSString *fullURL = [BASEURL stringByAppendingString:self.pageName];
    NSLog(@"url: %@", fullURL);
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    return requestObj;
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
