//
//  OverViewTabView.h
//  Bizon
//
//  Created by Satendra Singh on 10/09/16.
//  Copyright © 2016 Satendra Singh. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface OverViewTabView : NSView

@property (nonatomic, weak) IBOutlet NSTextField *connectionState;

@property (nonatomic, weak) IBOutlet NSTextField *graphicsCard;

@property (nonatomic, weak) IBOutlet NSTextField *macVersion;

@property (nonatomic, weak) IBOutlet NSTextField *macModel;

-(IBAction)didClickRefreshDetails:(id)sender;

-(void)reloadContent;

@end
