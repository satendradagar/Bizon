//
//  ProgressBarController.h
//  Premium Fonts
//
//  Created by Satendra Singh on 06/09/16.
//  Copyright © 2016 ahmed lotfy. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ProgressBarController : NSWindowController

@property (unsafe_unretained) IBOutlet NSProgressIndicator *progressBar;

@property (unsafe_unretained) IBOutlet NSTextField *label;

-(void)updateBarForDownloded:(NSUInteger)current ofTotal:(NSUInteger)total;
@property (unsafe_unretained) IBOutlet NSButton *cancelButton;

- (IBAction)userDidClicCancel:(id)sender;

- (void)setupCancelBlock:(void (^)())block;

@end
