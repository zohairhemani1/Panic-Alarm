//
//  Terms.m
//  Panic AAlaram Application
//
//  Created by Zainu Corporation on 17/05/2014.
//  Copyright (c) 2014 Zohair Hemani - Stanford Assignment. All rights reserved.
//

#import "Terms.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "checkInternet.h"

@interface Terms (){
    checkInternet *c;
}

@end

@implementation Terms
bool loadCondition = NO;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    checkboxSelected = 0;
    loadCondition = YES;
    
    c = [[checkInternet alloc]init];
    [c viewWillAppear:YES];
    
    UIView *statusBarbg = [[UIView alloc] init];
    statusBarbg.frame = CGRectMake(0, 0, 320, 20);
    statusBarbg.backgroundColor = [UIColor blackColor];
    [self.view addSubview:statusBarbg];
    
    UIImage *backgroundImage = [UIImage imageNamed:@"background_tabone.png"];
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:backgroundImage];
    
}

- (IBAction)PROCEED:(id)sender {
    
    if (checkboxSelected == 1)
    {
        [self performSegueWithIdentifier:@"userLogin" sender:self];
	}
    else
    {
        [self showAlertBox:NO title:@"Have'nt agreed" message:@"It seems you have not checked the conditions box"];
    }
}

- (IBAction)checkboxButton:(id)sender{
	if (checkboxSelected == 0){
		[checkboxButton setSelected:YES];
		checkboxSelected = 1;
	} else {
		[checkboxButton setSelected:NO];
		checkboxSelected = 0;
	}
}


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// View did load method. This method runs everytime the view is viewed.

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.navigationItem.hidesBackButton = NO;
    if(loadCondition)
    {
        loadCondition = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)fetchContactList
{
    
    CFErrorRef *error = NULL;
    
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
    
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            if (granted)
            {
                // First time access has been granted, add the contact
                
                
            } else {
                // User denied access
                // Display an alert telling user the contact could not be added
            }
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized)
    {
        // The user has previously given access, add the contact
        
        
        
        CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
        CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBook);
        
        
        for(int i = 0; i < numberOfPeople; i++)
        {
            ABRecordRef person = CFArrayGetValueAtIndex( allPeople, i );
            
            NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
            NSString *lastName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
            
            
            NSString *phoneNumber;
            if(firstName==nil){firstName=@"";}
            if(lastName==nil){lastName=@"";}
            NSString * fullName = [firstName stringByAppendingString:@" "];
            fullName = [fullName stringByAppendingString:lastName];
           // NSLog(@"Name:%@", fullName);
            
            ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
            

            
            // printing all numbers for each contact ( if more than one numbers saved )
            for (CFIndex j = 0; j < ABMultiValueGetCount(phoneNumbers); j++)
            {
                phoneNumber = (__bridge_transfer NSString *) ABMultiValueCopyValueAtIndex(phoneNumbers, j);
                //NSLog(@"Phone:%@", phoneNumber);
                
                // Removing special charachter from phone number
                
                
                NSMutableString *result = [NSMutableString stringWithCapacity:phoneNumber.length];
                
                NSScanner *scanner = [NSScanner scannerWithString:phoneNumber];
                NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
                
                while (scanner.atEnd == NO)
                {
                    NSString *buffer;
                    if ([scanner scanCharactersFromSet:numbers intoString:&buffer])
                    {
                        [result appendString:buffer];
                    } 
                    else 
                    {
                        scanner.scanLocation = (scanner.scanLocation + 1);
                    }
                }
                
                //NSLog(@"%@", result);
                
                // Result contains phonenumber without any special charachters.
                
                
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                
                [dict setValue:[NSString stringWithFormat:@"%i",i] forKey:@"id"];
                [dict setValue:result forKey:@"phoneNumber"];
                [dict setValue:fullName forKeyPath:@"fullName"];
                [SecondViewController.finalArrayStaticFunction addObject:dict];
            }
        }
    }
    else
    {

    }
}

-(void)showAlertBox:(BOOL)moveBack title:(NSString*)title message:(NSString*)message
{
    UIAlertController * alert = [UIAlertController
                                  alertControllerWithTitle:title
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"Okay"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             if(moveBack == true)
                             {
                                 [self.navigationController popToRootViewControllerAnimated:YES];
                             }
                         }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
