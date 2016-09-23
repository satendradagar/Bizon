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

@implementation ActivateTabView
{

    __block ProgressBarController *progressController;
    NSFileHandle *logFile ;
    NSDateFormatter *dateFormatter;

}
- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    logFile = [NSFileHandle fileHandleForWritingAtPath:[Utilities LogFilePath]];
    dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"dd MMM yyyy HH:mm:ss z"];

//    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
//    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
//    [dateFormatter setLocale:[NSLocale systemLocale]];

}

#pragma mark - User Actions

-(IBAction)didClickActivate:(id)sender{
    
    NSLog(@"didClickActivate");
    if (NO == [Utilities isConnected]) {
        [self showNoInternetAlert];
        return;
    }

    __block typeof(self) weakSelf = self;
    [self showActionSheet];
    
    [TaskManager runScript:@"fullScript" withArgs:nil ResponseHandling:^(NSString *message) {
        
//        progressController.label.stringValue = [NSString stringWithFormat:@"%@:%@",message,[self messageForServerMessage:message]];
        [weakSelf handleCriticalActions:message];

        
    } termination:^(STPrivilegedTask * task) {
        
        [weakSelf closeSheet];
        
    }] ;
    
}

-(IBAction)didClickRestore:(id)sender{

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

    }] ;
    
}

-(IBAction)didClickAuto:(id)sender{
    
//    [self showRestartActionSheet];
//    return;
    if (NO == [Utilities isConnected]) {
        [self showNoInternetAlert];
        return;
    }

    __block typeof(self) weakSelf = self;
    [self showActionSheet];

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
        
    }] ;
    

}

#pragma mark - Local methods

- (NSString *)messageForServerMessage:(NSString *)msg
{
  
    if (msg.length) {
        
        NSBundle *bundle  = [NSBundle bundleForClass:[self class]];
        NSString *panelMsg = [NSString stringWithFormat:@"%ld",(long)[msg integerValue]];
        if (nil == panelMsg) {
            panelMsg = [msg substringFromIndex:msg.length -1];
        }
        NSString *localized = NSLocalizedStringFromTableInBundle(panelMsg, @"Localizable", bundle, nil);
//        NSString *localized = NSLocalizedString([msg substringToIndex:msg.length - 1],nil);
        
        NSLog(@"%@:%@",panelMsg ,localized);

        if (nil != localized) {
            
            [self LogMessage:[NSString stringWithFormat:@"\n%@ [%@]: %@",[dateFormatter stringFromDate:[NSDate date]],panelMsg,localized]];

            return localized;
        }
        else{
            
            [self LogMessage:[NSString stringWithFormat:@"\n%@ %@",[dateFormatter stringFromDate:[NSDate date]],msg]];
            return nil;
        }

    }
    
    return nil;
}
    
-(void)LogMessage:(NSString *)msg
{
    [logFile writeData: [msg dataUsingEncoding: NSNEXTSTEPStringEncoding]];
}

-(void)handleCriticalActions:(NSString *)message{
    
    if ([message hasPrefix:@"4009"]) {//Restart case
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self showRestartActionSheet];
            
        });
        
    }
    else{
        NSUInteger msgValue = [message integerValue];
        if (msgValue > 3000 && msgValue < 4000) {//warning
            
            NSString *localized = [NSString stringWithFormat:@"%@",[self messageForServerMessage:message]];
            if (nil != localized) {
                
            }
            progressController.label.stringValue = [NSString stringWithFormat:@"%lu:%@",(unsigned long)msgValue,localized];

            progressController.warningImage.hidden = NO;
        }
        else{
            
            NSString *localized = [NSString stringWithFormat:@"%@",[self messageForServerMessage:message]];
            if (nil != localized) {
                progressController.label.stringValue = localized;

            }

        }
        NSLog(@"MSG INT:%lu",(unsigned long)msgValue);
    }
    
    
}


-(void)showActionSheet{
    
    progressController = [[ProgressBarController alloc] initWithWindowNibName:@"ProgressBarController"];
    
    [[progressController window] center];
    [NSApp beginSheet:progressController.window
       modalForWindow:self.window
        modalDelegate:nil
       didEndSelector:NULL
          contextInfo:NULL];
    [progressController.window makeKeyWindow];
    [progressController.window orderFront:nil];
    progressController.warningImage.hidden = YES;
    progressController.label.stringValue = @"Loading Script";
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

-(void)closeSheetWithDelay{
    
    [NSApp endSheet:progressController.window];
    [progressController.window orderOut:self];
    
}

-(void)closeSheet
{
    [self performSelector:@selector(closeSheetWithDelay) withObject:nil afterDelay:5.0];
}

-(void)showNoInternetAlert{
    
    [self showActionSheet];

    progressController.label.stringValue = [NSString stringWithFormat:@"%d:%@",3000,@"No Internet Connection."];
    progressController.warningImage.hidden = NO;

    [self closeSheet];
}

@end
