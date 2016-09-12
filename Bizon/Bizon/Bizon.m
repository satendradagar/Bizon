//
//  Bizon.m
//  Bizon
//
//  Created by Satendra Singh on 10/09/16.
//  Copyright © 2016 Satendra Singh. All rights reserved.
//

#import "Bizon.h"
#import "Reachability.h"

/*
 NSDictionary *prefs=[[NSUserDefaults standardUserDefaults]
 persistentDomainForName:[[NSBundle bundleForClass:[self class]]
 bundleIdentifier]];
 if(prefs) {
 [website setStringValue:[prefs objectForKey:@"website"]];
 [author setState:1 atRow:[[prefs objectForKey:@"author"] intValue]
 column:0];
 [rating setFloatValue:[[prefs objectForKey:@"rating"] floatValue]];
 }
 }
 
 [[NSNotificationCenter defaultCenter] addObserver:self
 selector:@selector(saveChanges:)
 name:NSApplicationWillTerminateNotification
 object:nil];
 
 
 - (void) saveChanges:(NSNotification*)aNotification {
 NSDictionary *prefs;
 int selauthor;
 
 // get selected radio button from matrix
 for(selauthor=[author numberOfRows];selauthor;selauthor--)
 if([[author cellAtRow:selauthor-1 column:0] intValue])
 break;
 selauthor--;
 
 prefs=[[NSDictionary alloc] initWithObjectsAndKeys:
 [website stringValue], 	dX23W		@"website",
 [NSNumber numberWithInt:selauthor],	@"author",
 [NSNumber numberWithFloat:[rating floatValue]],	@"rating",
 nil];MBV 6FF HGB
 
 [[NSUserDefaults standardUserDefaults]
 removePersistentDomainForName:[[NSBundle bundleForClass:
 [self class]] bundleIdentifier]];
 [[NSUserDefaults standardUserDefaults] setPersistentDomain:prefs
 forName:[[NSBundle bundleForClass:[self class]] bundleIdentifier]];
 
 [prefs release];
 }
 */

Bizon *lastLoadedInstance;

@interface Bizon()

@property (nonatomic, strong) Reachability *reachability;

@end

@implementation Bizon

- (void)mainViewDidLoad
{
    lastLoadedInstance = self;
    [super mainViewDidLoad];
    lastLoadedInstance.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];

}

+(BOOL)isInternetAvailable{
    
    NetworkStatus netStatus = [lastLoadedInstance.reachability currentReachabilityStatus];

    return !(netStatus == NotReachable);

}

@end
