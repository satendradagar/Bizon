//
//  LogTabView.m
//  Bizon
//
//  Created by Satendra Singh on 10/09/16.
//  Copyright © 2016 Satendra Singh. All rights reserved.
//

#import "LogTabView.h"
#import "Utilities.h"
#import "TaskManager.h"

@implementation LogTabView

-(void)awakeFromNib{
    
    [super awakeFromNib];
    self.logTextView.string = [NSString stringWithContentsOfFile:[Utilities LogFilePath] encoding:NSNEXTSTEPStringEncoding error:nil];
    
}

-(IBAction)didClickSaveSystemInfo:(id)sender{
    
    NSString *output = nil;
    [TaskManager runScript:@"SysInform" withArguments:nil output:&output errorDescription:nil];
    if (nil != output) {
        NSURL *finalUrl = [[self desktop] URLByAppendingPathComponent:@"systeminfo.txt"];
        [output writeToURL:finalUrl atomically:YES encoding:NSNEXTSTEPStringEncoding error:nil];
    }
    
    
}

-(IBAction)didClickSaveLog:(id)sender{
    
    NSURL *finalUrl = [[self desktop] URLByAppendingPathComponent:@"bizonboxlog.txt"];
    NSURL *sourceURL = [NSURL fileURLWithPath:[Utilities LogFilePath]];
    [[NSFileManager defaultManager] copyItemAtURL:sourceURL toURL:finalUrl error:nil];
}

-(NSURL *)desktop
{
    NSURL *desktop = [[[NSFileManager defaultManager] URLsForDirectory:NSDesktopDirectory inDomains:NSUserDomainMask] lastObject];
    return desktop;
}
- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

@end
