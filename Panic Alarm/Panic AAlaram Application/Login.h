//
//  FirstViewController.h
//  Panic AAlaram Application
//
//  Created by Zohair Hemani on 30/04/2014.
//  Copyright (c) 2014 Zohair Hemani - Stanford Assignment. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Login : UIViewController<UITextFieldDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate>

- (IBAction)backgroundTouched:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *insertusername;
@property (weak, nonatomic) IBOutlet UITextField *insertpassword;
- (IBAction)login:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)upload:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *animationView;

@property (strong, nonatomic) IBOutletCollection (UITextField) NSArray *myTextFieldsCollection;
@end

