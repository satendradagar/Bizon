//
//  ActivateTabView.m
//  Bizon
//
//  Created by Satendra Singh on 10/09/16.
//  Copyright © 2016 Satendra Singh. All rights reserved.
//

#import "ActivateTabView.h"
#import "TaskManager.h"
#import "ProgressBarController.h"
#import "Utilities.h"
#import "Reachability.h"

@implementation ActivateTabView
{

    __block ProgressBarController *progressController;
    NSFileHandle *logFile ;
    NSDateFormatter *dateFormatter;
    BOOL isPerformingActivate;
    Reachability *nvidiaReach;

}
- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

-(void)awakeFromNib{
    [super awakeFromNib];
    isPerformingActivate = NO;
    logFile = [NSFileHandle fileHandleForWritingAtPath:[Utilities LogFilePath]];
    [logFile seekToEndOfFile];
    dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"dd MMM yyyy HH:mm:ss z"];
    nvidiaReach = [Reachability reachabilityWithHostName:@"www.nvidia.com"];
    [nvidiaReach startNotifier];
//    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
//    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
//    [dateFormatter setLocale:[NSLocale systemLocale]];

}

-(void)dealloc
{
    NSLog(@"Dealloc");
    [logFile synchronizeFile];
    [logFile closeFile];
    logFile = nil;
}
#pragma mark - User Actions

-(BOOL)isNvdiaReachable{
    NetworkStatus netStatus = [nvidiaReach currentReachabilityStatus];
    
    return !(netStatus == NotReachable);
}

-(IBAction)didClickActivate:(id)sender{
    isPerformingActivate = YES;
    NSLog(@"didClickActivate");
    if (NO == [Utilities isConnected]) {
        [self showNoInternetAlert];
        return;
    }

    if (NO == [self isNvdiaReachable]) {
        
        [self showErrrorMessage:[NSString stringWithFormat:@"3020:%@",[ActivateTabView localizedMessageForKey:@"3020"]]];
        
        return;
    }
    
    
    __block typeof(self) weakSelf = self;
    [self showActionSheet];
    progressController.progressBar.indeterminate = NO;
    
    
    [TaskManager runScript:@"fullScript" withArgs:nil ResponseHandling:^(NSString *message) {
        
//        progressController.label.stringValue = [NSString stringWithFormat:@"%@:%@",message,[self messageForServerMessage:message]];
        [weakSelf handleCriticalActions:message];

        
    } termination:^(STPrivilegedTask * task) {
        
        [weakSelf closeSheet];
//        [weakSelf LogMessage:[NSString stringWithFormat:@"\n%@  %@",[dateFormatter stringFromDate:[NSDate date]],@"Activation finished."]];

    }] ;
    
}

-(IBAction)didClickRestore:(id)sender{

    isPerformingActivate = NO;

    if (NO == [Utilities isConnected]) {
        [self showNoInternetAlert];
        return;
    }

    __block typeof(self) weakSelf = self;
    [self showActionSheet];
    
    [TaskManager runScript:@"fullScript" withArgs:@[@"-uninstall"] ResponseHandling:^(NSString *message) {
        
//        progressController.label.stringValue = [NSString stringWithFormat:@"%@:%@",message,[self messageForServerMessage:message]];

        [weakSelf handleCriticalActions:message];

    } termination:^(STPrivilegedTask * task) {
        
        [weakSelf closeSheet];
        [weakSelf LogMessage:[NSString stringWithFormat:@"\n%@  %@",[dateFormatter stringFromDate:[NSDate date]],@"Uninstallation finished."]];

    }] ;
    
}

-(IBAction)didClickAuto:(id)sender{
    
    isPerformingActivate = NO;

//    [self showRestartActionSheet];
//    return;
//    if (NO == [Utilities isConnected]) {
//        [self showNoInternetAlert];
//        return;
//    }
//
    __block typeof(self) weakSelf = self;
//    [self showActionSheet];
//
    [TaskManager runScript:@"fullScript" withArgs:@[@"-a"] ResponseHandling:^(NSString *message) {
        
//        progressController.label.stringValue = [NSString stringWithFormat:@"%@:%@",message,[self messageForServerMessage:message]];
        [weakSelf handleCriticalActions:message];

    } termination:^(STPrivilegedTask * task) {
        
        [weakSelf closeSheet];

    }] ;
    
//    NSString * output = nil;
//    NSString * processErrorDescription = nil;
//    [TaskManager runScriptAsAdministrator:@"fullScript" withArguments:nil output:&output errorDescription:&processErrorDescription];
//    BOOL success =[TaskManager runScriptAsAdministrator:@"fullScript" withArguments:@[@"-a"] output:&output errorDescription:&processErrorDescription];
//    
//    NSLog(@"[%d]output = %@",success,output);
//    NSLog(@"Error = %@",processErrorDescription);
//    
//    if (!success) // Process failed to run
//        {
//            // ...look at errorDescription
//        }
//    else
//        {
//            // ...process output
//        }
//
}

-(IBAction)didClickSkip:(id)sender{
    
    isPerformingActivate = NO;

    if (NO == [Utilities isConnected]) {
        [self showNoInternetAlert];
        return;
    }

    __block typeof(self) weakSelf = self;
    [self showActionSheet];
    
    [TaskManager runScript:@"fullScript" withArgs:@[@"-skipdriver"] ResponseHandling:^(NSString *message) {
        
//        progressController.label.stringValue = [NSString stringWithFormat:@"%@:%@",message,[self messageForServerMessage:message]];
        [weakSelf handleCriticalActions:message];

    } termination:^(STPrivilegedTask * task) {
        
        [weakSelf closeSheet];
        [weakSelf LogMessage:[NSString stringWithFormat:@"\n%@  %@",[dateFormatter stringFromDate:[NSDate date]],@"Skip Drive finished."]];

    }] ;
    

}

#pragma mark - Local methods

+ (NSString *)localizedMessageForKey:(NSString *)key{
    
    NSBundle *bundle  = [NSBundle bundleForClass:[self class]];
    
    NSString *localized = NSLocalizedStringFromTableInBundle(key, @"Localizable", bundle, nil);
    return localized;
}

- (NSString *)messageForServerMessage:(NSString *)msg
{
  
    if (msg.length) {
        
//        msg = [msg substringFromIndex:msg.length -1];
        NSString *panelMsg = [NSString stringWithFormat:@"%ld",(long)[msg integerValue]];
        NSLog(@"msg: %@, panel: %@",msg,panelMsg);
        if (nil == panelMsg || msg.integerValue == 0) {
            
            panelMsg = msg;
        }

        NSString *localized = [ActivateTabView localizedMessageForKey:panelMsg];
        
//        NSString *localized = NSLocalizedString([msg substringToIndex:msg.length - 1],nil);
        
        NSLog(@"%@:%@",panelMsg ,localized);

        if (nil != localized) {
            
//            [self LogMessage:[NSString stringWithFormat:@"\n%@ [%@]: %@",[dateFormatter stringFromDate:[NSDate date]],panelMsg,localized]];
            if ([localized isEqualToString:panelMsg]) {
                
                return nil;
            }
//            [self LogMessage:[NSString stringWithFormat:@"\n%@ [%@]: %@",[dateFormatter stringFromDate:[NSDate date]],panelMsg,localized]];

            return localized;
        }
        else{
            
//            [self LogMessage:[NSString stringWithFormat:@"\n%@ %@",[dateFormatter stringFromDate:[NSDate date]],msg]];
            return nil;
        }

    }
    
    return nil;
}
    
-(void)LogMessage:(NSString *)msg
{
    [logFile writeData: [msg dataUsingEncoding: NSUTF8StringEncoding]];
}

-(void)handleCriticalActions:(NSString *)message{
    
    message = [NSString stringWithFormat:@"%@",message];
    NSArray *msgs = [message componentsSeparatedByString:@"\n"];
    
    for (NSString *single in msgs) {
        NSLog(@"FORIN: %@",single);
        if (single.length <= 1) {
            NSLog(@"Continue");
            continue;
        }
        if ([single hasPrefix:@"4009"]) {//Restart case
            
            if (isPerformingActivate) {
                dispatch_async(dispatch_get_main_queue(), ^{

                progressController.progressBar.doubleValue = [self progressForCode:single];
                    
                });
                [self didClickAuto:nil];
                return;
            }
            [self LogMessage:[NSString stringWithFormat:@"\n%@  %@",[dateFormatter stringFromDate:[NSDate date]],@"Activation Completed."]];

            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self showRestartActionSheet];
                
            });
            
        }
        else if (NSNotFound != [message rangeOfString:@"Failed to connect to "].location){//Received failed to connect
            [self closeSheetWithDelay];
            [self showErrrorMessage:[NSString stringWithFormat:@"3020:%@",[ActivateTabView localizedMessageForKey:@"3020"]]];
            break;
        }
        else {
            
            NSUInteger msgValue = [single integerValue];
            if (msgValue > 3000 && msgValue < 4000) {//warning
                
                NSString *localized = [self messageForServerMessage:single];
                if (nil != localized) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                       [self closeSheetWithDelay];
//                        progressController.label.stringValue = [NSString stringWithFormat:@"%lu:%@",(unsigned long)msgValue,localized];
                        [self showErrrorMessage:[NSString stringWithFormat:@"%lu:%@",(unsigned long)msgValue,localized]];
                        
                    });
                    
                }
                
                progressController.warningImage.hidden = NO;
            }
            else{
                
                progressController.warningImage.hidden = YES;
                
                NSString *localized = [self messageForServerMessage:single];
                if (nil != localized) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        progressController.label.stringValue = localized;
                        progressController.progressBar.doubleValue = [self progressForCode:single];
                    });
                }
                
            }
            NSLog(@"MSG INT:%lu",(unsigned long)msgValue);
            
        }
    }
    
    
}

-(CGFloat)progressForCode:(NSString *)code{
    
    if ([code hasPrefix:@"4009"]) {//Restart case
        return 100.0;
    }
    else if([code hasPrefix:@"4007"]){
     
        return 10.0;
    }
    else if([code hasPrefix:@"4005"]){
        
        return 25.0;
    }
    else if([code hasPrefix:@"4008"]){
        
        return 65.0;
    }
    
    return 0.00;
}

-(void)showActionSheet{
    
    progressController = [[ProgressBarController alloc] initWithWindowNibName:@"ProgressBarController"];
    
    [[progressController window] center];

    [NSApp beginSheet:progressController.window
       modalForWindow:self.window
        modalDelegate:nil
       didEndSelector:NULL
          contextInfo:NULL];
//    [self.window makeFirstResponder:progressController.window];
    [progressController.window makeKeyWindow];
    [progressController.window orderFront:nil];
    [self.window makeFirstResponder:progressController.window];

    progressController.warningImage.hidden = YES;
    progressController.label.stringValue = @"Initiating....";
}

-(void)showRestartActionSheet{
    
    NSAlert *alert = [[NSAlert alloc] init];
    alert.messageText = @"Restart Your Mac";
    alert.informativeText = @"Please note that In order to complete the installation process, you need to restart Your Mac Machine";
    NSButton *button = [alert addButtonWithTitle:@"Restart Now"];
    [alert addButtonWithTitle:@"Restart Later"];
    [button becomeFirstResponder];
    
    NSBundle *bundle  = [NSBundle bundleForClass:[self class]];
    NSString *imagePath = [bundle pathForResource:@"BizonBox" ofType:@"png"];
    alert.icon = [[NSImage alloc] initWithContentsOfFile:imagePath];
    
    NSInteger answer = [alert runModal];
    
    if (answer == NSAlertFirstButtonReturn) {
        
        NSString *scriptAction = @"restart"; // @"restart"/@"shut down"/@"sleep"/@"log out"
        NSString *scriptSource = [NSString stringWithFormat:@"tell application \"Finder\" to %@", scriptAction];
        NSAppleScript *appleScript = [[NSAppleScript alloc] initWithSource:scriptSource];
        NSDictionary *errDict = nil;
        if (![appleScript executeAndReturnError:&errDict]) {
            NSLog(@"%@", errDict);
        }
        
    }
    
}

-(void)showErrrorMessage:(NSString *)message{
    
    NSAlert *alert = [[NSAlert alloc] init];
    alert.messageText = @"Error";
    alert.informativeText = message;
    NSButton *button = [alert addButtonWithTitle:@"OK"];
    [self LogMessage:[NSString stringWithFormat:@"\n%@  %@",[dateFormatter stringFromDate:[NSDate date]],message]];

    NSBundle *bundle  = [NSBundle bundleForClass:[self class]];
    NSString *imagePath = [bundle pathForResource:@"BizonBox" ofType:@"png"];
    alert.icon = [[NSImage alloc] initWithContentsOfFile:imagePath];
    

    alert.alertStyle = 2;
    NSInteger answer = [alert runModal];
    
    if (answer == NSAlertFirstButtonReturn) {
        
    }
    
}

-(void)closeSheetWithDelay{
    
    [NSApp endSheet:progressController.window];
    [progressController.window orderOut:self];
    
}

-(void)closeSheet
{
    [self performSelector:@selector(closeSheetWithDelay) withObject:nil afterDelay:5.0];
}

-(void)showNoInternetAlert{
    
//    [self showActionSheet];

//    progressController.label.stringValue = [NSString stringWithFormat:@"%d:%@",3000,@"No Internet Connection."];
//    [self closeSheetWithDelay];
    [self showErrrorMessage:[NSString stringWithFormat:@"%d:%@",3000,@"No Internet Connection."]];
    progressController.warningImage.hidden = NO;

//    [self closeSheet];
}

-(void)internetWentDown{
    
    if (isPerformingActivate) {
        
        [self showErrrorMessage:[NSString stringWithFormat:@"%d:%@",3000,@"Check your internet connection"]];

    }
}

@end
