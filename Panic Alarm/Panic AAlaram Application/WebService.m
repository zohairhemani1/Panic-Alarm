//
//  WebService.m
//  Panic AAlaram Application
//
//  Created by Zohair Hemani on 04/05/2014.
//  Copyright (c) 2014 Zohair Hemani - Stanford Assignment. All rights reserved.
//

#import "WebService.h"

@implementation WebService

-(NSMutableArray*)FilePath:(NSString*)filepath parameterOne:(NSString*)parameterOne parameterTwo:(NSString*)parameterTwo parameterThree:(NSString*)parameterThree
{
    NSURL *jsonFileUrl = [NSURL URLWithString:filepath];
    
    // Create the NSURLConnection
    //NSString * username = [[NSUserDefaults standardUserDefaults] stringForKey:@"name"];
    NSString * storedNumber = [[NSUserDefaults standardUserDefaults]valueForKey:@"myPhoneNumber"];
    //NSString *number = @"03432637576";
    
    // Posting the values of edit text field to database to query the results.
    
    NSString *myRequestString = [NSString stringWithFormat:@"parameterOne=%@&parameterTwo=%@&parameterThree=%@&username=%@",parameterOne,parameterTwo,parameterThree,storedNumber];
    
    myRequestString = [myRequestString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@" \"#%/+:<>?@[\\]^`{|}"].invertedSet];
    // Create Data from request
    NSData *myRequestData = [NSData dataWithBytes: myRequestString.UTF8String length: myRequestString.length];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: jsonFileUrl];
    // set Request Type
    NSError *err = nil;
    request.HTTPMethod = @"POST";
    // Set content-type
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    // Set Request Body
    request.HTTPBody = myRequestData;
    // Now send a request and get Response
    NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil];
    // Log Response
    NSString *response = [[NSString alloc] initWithBytes:returnData.bytes length:returnData.length encoding:NSUTF8StringEncoding];
    
    NSMutableArray *jsonArray;
    if (returnData != nil) {
        jsonArray = [NSJSONSerialization JSONObjectWithData: returnData options: NSJSONReadingMutableContainers error: &err];
    }
   
  //  NSLog(@"%@",response);
   // NSLog(@"JsonArray %@", jsonArray);
    //[NSURLConnection connectionWithRequest:request delegate:self];
    // return response;
    
    return jsonArray;
}

-(NSMutableArray*)FilePath:(NSString*)filepath parameterOne:(NSString*)parameterOne
{
    
    NSMutableArray * responseArray = [self FilePath:filepath parameterOne:parameterOne parameterTwo:nil parameterThree:nil];
    return responseArray;
}

-(NSMutableArray*)FilePath:(NSString*)filepath parameterOne:(NSString*)parameterOne parameterTwo:(NSString*)parameterTwo
{
    NSMutableArray * responseArray = [self FilePath:filepath parameterOne:parameterOne parameterTwo:parameterTwo parameterThree:nil];
    return responseArray;
}

@end
