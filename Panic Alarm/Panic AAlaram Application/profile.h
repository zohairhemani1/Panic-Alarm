//
//  profile.h
//  Panic Alarm
//
//  Created by Zainu Corporation on 25/08/2014.
//  Copyright (c) 2014 Zohair Hemani - Stanford Assignment. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface profile : UIViewController <UITextViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *personImage;
@property (weak, nonatomic) IBOutlet UITextField *personName;
@property (weak, nonatomic) IBOutlet UIButton *uploadedImage;
- (IBAction)upload:(id)sender;
@property (strong, nonatomic) IBOutlet UITextView *messageText;
@property (weak, nonatomic) IBOutlet UIButton *save;
- (IBAction)save_action:(id)sender;
@end
