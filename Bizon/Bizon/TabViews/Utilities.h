//
//  Utilities.h
//  Bizon
//
//  Created by Satendra Singh on 18/09/16.
//  Copyright © 2016 Satendra Singh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utilities : NSObject

+(NSString *) LogFilePath;

+(BOOL)isConnected;

+(void)showNoInternetAlert;

+ (NSURL *)applicationDocumentsDirectory;

@end

