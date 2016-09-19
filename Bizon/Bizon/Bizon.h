//
//  Bizon.h
//  Bizon
//
//  Created by Satendra Singh on 10/09/16.
//  Copyright © 2016 Satendra Singh. All rights reserved.
//

#import <PreferencePanes/PreferencePanes.h>

@interface Bizon : NSPreferencePane

- (void)mainViewDidLoad;

+(BOOL)isInternetAvailable;

+(instancetype)sharedInstance;

@end
