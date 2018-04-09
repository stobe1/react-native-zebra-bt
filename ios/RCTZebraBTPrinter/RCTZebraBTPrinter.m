//
//  RCTZebraBTPrinter.m
//  RCTZebraBTPrinter
//
//  Created by Jakub Martyčák on 17.04.16.
//  Copyright © 2016 Jakub Martyčák. All rights reserved.
//

#import "RCTZebraBTPrinter.h"

//ZEBRA
#import "ZebraPrinterConnection.h"
#import "ZebraPrinter.h"
#import "ZebraPrinterFactory.h"
#import "MfiBtPrinterConnection.h"


@implementation RCTZebraBTPrinter

RCT_EXPORT_MODULE();

- (dispatch_queue_t)methodQueue
{
    // run all module methods in main thread
    // if we don't no timer callbacks got called
    return dispatch_get_main_queue();
}

#pragma mark - Methods available form Javascript

RCT_EXPORT_METHOD(
    printLabel: (NSString *)userPrinterSerial 
    userPrintCount:(int)userPrintCount
    userText1:(NSString *)userText1
    userText2:(NSString *)userText2
    userText3:(NSString *)userText3
    resolve: (RCTPromiseResolveBlock)resolve
    rejector:(RCTPromiseRejectBlock)reject){
    
    //userPrinterSerial = userPrinterSerial;
    
    NSLog(@"IOS >> printLabel triggered");
    
    //NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSLog(@"IOS >> Connecting");
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^ {
        
        id<ZebraPrinterConnection, NSObject> thePrinterConn = [[MfiBtPrinterConnection alloc] initWithSerialNumber:userPrinterSerial];
        
        [((MfiBtPrinterConnection*)thePrinterConn) setTimeToWaitAfterWriteInMilliseconds:30];
        
        BOOL success = [thePrinterConn open];
        
        if(success == YES){
            
            NSLog(@"IOS >> Connected %@", userText1);
            //NSString *zplData = @"^XA^FO20,20^A0N,25,25^FDThis is a ZPL test.^FS^XZ";
            
            NSString *testLabel;
            
            // offset, dpi, dpi, label height dpi, qty
            
            testLabel = [NSString stringWithFormat:@"! 0 200 200 304 %d\r\nTEXT 0 3 10 10 CYC LABEL START\r\nTEXT 0 3 10 40 %@ %@ %@\r\nBARCODE 128 1 1 40 10 80 %@\r\nTEXT 0 3 10 150 CYC LABEL END\r\nFORM\r\nPRINT\r\n", userPrintCount, userText1, userText2, userText3, userText1];
            
            NSError *error = nil;
            // Send the data to printer as a byte array.
            //NSData *data = [NSData dataWithBytes:[testLabel UTF8String] length:[testLabel length]];
            //success = success && [thePrinterConn write:[zplData dataUsingEncoding:NSUTF8StringEncoding] error:&error];
            success = success && [thePrinterConn write:[testLabel dataUsingEncoding:NSUTF8StringEncoding] error:&error];
            
            NSLog(@"IOS >> Sending Data");
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success != YES || error != nil) {
                    
                    NSLog(@"IOS >> Failed to send");
                    
                    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                    [errorAlert show];
                    //[errorAlert release];
                }
            });
            // Close the connection to release resources.
            [thePrinterConn close];
            //[thePrinterConn release];
            resolve((id)kCFBooleanTrue);
        } else {
            
            NSLog(@"IOS >> Failed to connect");
            resolve((id)kCFBooleanFalse);
            
        }
    });
    
    /*
     id<ZebraPrinterConnection, NSObject> connection = nil;
     
     NSString *printerSerial = @"XXQPJ171800079";
     
     NSLog(@"SERIAL## IS %@", printerSerial);
     
     
     connection = [[MfiBtPrinterConnection alloc] initWithSerialNumber:printerSerial];
     
     [((MfiBtPrinterConnection*)connection) setTimeToWaitAfterWriteInMilliseconds:80];
     
     BOOL didOpen = [connection open];
     
     if(didOpen == YES){
     
     
     
     NSLog(@"IOS >> Connected");
     
     NSLog(@"IOS >> Determining Printer Language...");
     
     NSError *error;
     
     id<ZebraPrinter,NSObject> printer = [ZebraPrinterFactory getInstance:connection error:&error];
     
     PrinterLanguage language = [printer getPrinterControlLanguage];
     
     NSLog(@"IOS >> Printer Language %@",[self getLanguageName:language]);
     
     NSLog(@"IOS >> Sending Data");
     
     
     //Construct msg
     NSString *testLabel;
     
     NSString *userText = @"hahaha";
     
     NSLog(@"USER INPUT ## IS %@", userText);
     
     testLabel = [NSString stringWithFormat:@"! 0 200 200 210 1\r\nTEXT 4 0 30 40 Hello %@\r\nFORM\r\nPRINT\r\n", userText];
     
     NSData *data = [NSData dataWithBytes:[testLabel UTF8String] length:[testLabel length]];
     [connection write:data error:&error];
     
     NSLog(@"%@",error);
     
     //BOOL sentOK = [self printTestLabel:language onConnection:connection withError:&error];
     BOOL sentOK = 1;
     
     if (sentOK == 1) {
     NSLog(@"IOS >> Test Label Sent");
     
     } else {
     NSLog(@"IOS >> Test Label Failed to Print");
     
     }
     
     NSLog(@"IOS >> Disconnecting");
     
     [connection close];
     
     } else {
     NSLog(@"IOS >> Connection not open");
     }
     
     */
    
}


@end
