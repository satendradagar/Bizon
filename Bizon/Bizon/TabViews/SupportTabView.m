//
//  SupportTabView.m
//  Bizon
//
//  Created by Satendra Singh on 10/09/16.
//  Copyright © 2016 Satendra Singh. All rights reserved.
//

#import "SupportTabView.h"

@implementation SupportTabView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}


-(IBAction)didClickShowUserManual:(id)sender{
    
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://bizon-tech.com/bizonbox2_manual.pdf"]];
}

-(IBAction)didClickKnowledgeBase:(id)sender{
    
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://bizon-tech.com/us/faq-egpu/"]];

}

-(IBAction)didClickShowSupport:(id)sender{

    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"mailto:support@bizon-tech.com?Subject=Bizon%20Mac%20Support"]];
    
}

@end
