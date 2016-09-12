//
//  ActivateTabView.m
//  Bizon
//
//  Created by Satendra Singh on 10/09/16.
//  Copyright © 2016 Satendra Singh. All rights reserved.
//

#import "ActivateTabView.h"
#import "TaskManager.h"

@implementation ActivateTabView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}


-(IBAction)didClickActivate:(id)sender{
    
    NSLog(@"didClickActivate");
    [TaskManager runScript:@"fullScript" withArgs:nil];
    
    return;

    NSString * output = nil;
    NSString * processErrorDescription = nil;
    [TaskManager runScriptAsAdministrator:@"fullScript" withArguments:nil output:&output errorDescription:&processErrorDescription];
    BOOL success =[TaskManager runScriptAsAdministrator:@"fullScript" withArguments:nil output:&output errorDescription:&processErrorDescription];
    
    NSLog(@"[%d]output = %@",success,output);
    NSLog(@"Error = %@",processErrorDescription);
    
    if (!success) // Process failed to run
        {
            // ...look at errorDescription
        }
    else
        {
            // ...process output
        }

}

-(IBAction)didClickRestore:(id)sender{

    [TaskManager runScript:@"fullScript" withArgs:@[@"-uninstall"]];
    return;
    
    
    NSString * output = nil;
    NSString * processErrorDescription = nil;
    [TaskManager runScriptAsAdministrator:@"fullScript" withArguments:@[@"-uninstall"] output:&output errorDescription:&processErrorDescription];
    BOOL success =[TaskManager runScriptAsAdministrator:@"fullScript" withArguments:nil output:&output errorDescription:&processErrorDescription];
    
    NSLog(@"[%d]output = %@",success,output);
    NSLog(@"Error = %@",processErrorDescription);
    
    if (!success) // Process failed to run
        {
            // ...look at errorDescription
        }
    else
        {
            // ...process output
        }

}

-(IBAction)didClickAuto:(id)sender{
    
    [TaskManager runScript:@"fullScript" withArgs:@[@"-a"]];
    return;
    
    NSString * output = nil;
    NSString * processErrorDescription = nil;
    [TaskManager runScriptAsAdministrator:@"fullScript" withArguments:nil output:&output errorDescription:&processErrorDescription];
    BOOL success =[TaskManager runScriptAsAdministrator:@"fullScript" withArguments:@[@"-a"] output:&output errorDescription:&processErrorDescription];
    
    NSLog(@"[%d]output = %@",success,output);
    NSLog(@"Error = %@",processErrorDescription);
    
    if (!success) // Process failed to run
        {
            // ...look at errorDescription
        }
    else
        {
            // ...process output
        }

}

@end
