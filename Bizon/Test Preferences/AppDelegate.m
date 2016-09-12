//
//  AppDelegate.m
//  Test Preferences
//
//  Created by Satendra Singh on 10/09/16.
//  Copyright © 2016 Satendra Singh. All rights reserved.
//

#import "AppDelegate.h"
#import <PreferencePanes/PreferencePanes.h>
#import "Bizon.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    NSString *pathToPrefPaneBundle = [[NSBundle mainBundle]
                                      pathForResource: @"Bizon" ofType: @"prefPane"
                                      inDirectory: @"PreferencePanes"];
    NSBundle *prefBundle = [NSBundle bundleWithPath: pathToPrefPaneBundle];
    Class prefPaneClass = [prefBundle principalClass];
    NSPreferencePane *prefPaneObject = [[prefPaneClass alloc]
                                        initWithBundle:prefBundle];
    
    NSView *prefView;
    if ( [prefPaneObject loadMainView] ) {
        [prefPaneObject willSelect];
        prefView = [prefPaneObject mainView];
        /* Add view to window */
        [prefPaneObject didSelect];
    } else {
        /* loadMainView failed -- handle error */
    }
    [self.window.contentView addSubview:prefView];
    
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
