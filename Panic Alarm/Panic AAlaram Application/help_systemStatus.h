//
//  help_systemStatus.h
//  Panic Alarm
//
//  Created by Avialdo on 11/12/2015.
//  Copyright © 2015 Zohair Hemani - Stanford Assignment. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface help_systemStatus : UIViewController<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (strong, nonatomic) NSString *pageName;
@end
