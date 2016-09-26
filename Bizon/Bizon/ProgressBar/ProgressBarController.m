//
//  ProgressBarController.m
//  Premium Fonts
//
//  Created by Satendra Singh on 06/09/16.
//  Copyright © 2016 ahmed lotfy. All rights reserved.
//

#import "ProgressBarController.h"

typedef void (^CancelDownload )(void);

@interface ProgressBarController ()

@property (nonatomic, copy) CancelDownload cancelBlock;

@end

@implementation ProgressBarController

- (IBAction)userDidClicCancel:(id)sender {
    
    if (nil != _cancelBlock) {
        _cancelBlock();
    }
}

-(void)awakeFromNib{
    
    [super awakeFromNib];
    [_progressBar setUsesThreadedAnimation:true];

}

- (void)windowDidLoad {
    [super windowDidLoad];
    [_progressBar startAnimation:nil];

    [_warningImage setHidden:YES];
//    [_progressBar setDoubleValue:0.0];
    _label.stringValue = @"Initiating";
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

-(BOOL)acceptsFirstMouse:(NSEvent *)theEvent {
    return YES;
}

-(void)setupCancelBlock:(void (^)())block{

    self.cancelBlock = block;
    
}

-(void)updateBarForDownloded:(NSUInteger)current ofTotal:(NSUInteger)total{
   
    CGFloat currentValue = 100.00*current/total;
    [_progressBar setDoubleValue:currentValue];
    self.label.stringValue = [NSString stringWithFormat:@"Downloading WebFonts %@ of %@",[NSByteCountFormatter stringFromByteCount:current countStyle:NSByteCountFormatterCountStyleDecimal],[NSByteCountFormatter stringFromByteCount:total countStyle:NSByteCountFormatterCountStyleDecimal]];
}

 @end
