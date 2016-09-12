//
//  OverViewTabView.h
//  Bizon
//
//  Created by Satendra Singh on 10/09/16.
//  Copyright © 2016 Satendra Singh. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface OverViewTabView : NSView

@property (nonatomic, weak) IBOutlet NSTextField *overViewDetails;

-(IBAction)didClickRefreshDetails:(id)sender;

@end
