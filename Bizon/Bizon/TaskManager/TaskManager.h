//
//  TaskManager.h
//  Bizon
//
//  Created by Satendra Singh on 11/09/16.
//  Copyright © 2016 Satendra Singh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaskManager : NSObject

+ (void ) runScript:(NSString *) scriptName withArgs:(NSArray *)args;

+ (BOOL) runScriptAsAdministrator:(NSString*)scriptName
                    withArguments:(NSArray *)arguments
                           output:(NSString **)output
                 errorDescription:(NSString **)errorDescription;

@end
