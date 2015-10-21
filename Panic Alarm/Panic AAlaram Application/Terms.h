//
//  Terms.h
//  Panic AAlaram Application
//
//  Created by Zainu Corporation on 17/05/2014.
//  Copyright (c) 2014 Zohair Hemani - Stanford Assignment. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface Terms : UIViewController<ABNewPersonViewControllerDelegate>{

    BOOL checkboxSelected;
    
    IBOutlet UIButton *checkboxButton;
}
- (IBAction)checkboxButton:(id)sender;
-(void)fetchContactList;
- (IBAction)PROCEED:(id)sender;

@end
