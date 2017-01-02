//
//  SupportTabView.m
//  Bizon
//
//  Created by Satendra Singh on 10/09/16.
//  Copyright © 2016 Satendra Singh. All rights reserved.
//

#import "SupportTabView.h"
#import "Utilities.h"

@implementation SupportTabView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}


-(IBAction)didClickShowUserManual:(id)sender{
    
    if (NO == [Utilities isConnected]) {
        [Utilities showNoInternetAlert];
        return;
    }
    
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://bizon-tech.com/bizonbox3_guide.pdf"]];
}

-(IBAction)didClickKnowledgeBase:(id)sender{
    
    if (NO == [Utilities isConnected]) {
        [Utilities showNoInternetAlert];
        return;
    }
    

    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://support.bizon-tech.com/hc/en-us"]];

}

-(IBAction)didClickShowSupport:(id)sender{

    if (NO == [Utilities isConnected]) {
        [Utilities showNoInternetAlert];
        return;
    }
    
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"mailto:support@bizon-tech.com?Subject=Bizon%20Mac%20Support"]];
    
}

-(IBAction)didClickOpenLicence:(id)sender{
    NSString  * pdfPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"licence" ofType:@"pdf"];
    [[NSWorkspace sharedWorkspace] openFile:pdfPath];
    
}

@end
