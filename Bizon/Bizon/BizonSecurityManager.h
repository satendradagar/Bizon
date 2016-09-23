//
//  BizonSecurityManager.h
//  Bizon
//
//  Created by Satendra Singh on 23/09/16.
//  Copyright © 2016 Satendra Singh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BizonSecurityManager : NSObject

+(NSString *)decryptedPathForResourceName:(NSString *)resource;

+(NSString *)resouceURLForScript:(NSString *)scriptName;

+(void) decryptScriptAndSave:(NSString *)scriptName;

+(void) deleteScript:(NSString *)scriptName;

+(void)startAccess;

+(void)stopAccess;

@end
