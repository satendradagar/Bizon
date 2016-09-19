//
//  LogTabView.h
//  Bizon
//
//  Created by Satendra Singh on 10/09/16.
//  Copyright © 2016 Satendra Singh. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface LogTabView : NSView


@property (nonatomic, strong) IBOutlet NSTextView *logTextView;

-(IBAction)didClickSaveSystemInfo:(id)sender;

-(IBAction)didClickSaveLog:(id)sender;

-(void)reloadContent;

@end
