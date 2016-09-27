//
//  BizonSecurityManager.m
//  Bizon
//
//  Created by Satendra Singh on 23/09/16.
//  Copyright © 2016 Satendra Singh. All rights reserved.
//

#import "BizonSecurityManager.h"
#import "Utilities.h"
#import "NSData+CommonCrypto.h"

#define kEncryptKey @"BIZON.CoreBits"

@implementation BizonSecurityManager

+(NSString *)decryptedPathForResourceName:(NSString *)resource{
    
    NSURL *documentPath = [Utilities applicationDocumentsDirectory];
    NSString *filePath = [[documentPath path] stringByAppendingPathComponent:resource];
    filePath = [filePath stringByAppendingPathExtension:@"sh"];
    NSLog(@"Decryption Path : %@",filePath);
    return filePath;
    
}

+(NSString *)resouceURLForScript:(NSString *)scriptName{
    
    NSString  * scriptPath = [[NSBundle bundleForClass:[self class]] pathForResource:scriptName ofType:@"dump"];
    return scriptPath;
}

+(void) decryptScriptAndSave:(NSString *)scriptName{
    NSString *encryptedPath = [self resouceURLForScript:scriptName];
    NSString *decryptedPath = [self decryptedPathForResourceName:scriptName];
    NSData *scriptData = [NSData dataWithContentsOfFile:encryptedPath];
    NSError *error = nil;
    NSData *converted = [scriptData decryptedAES256DataUsingKey:kEncryptKey error:&error];
    
//    scriptData = [NSData dataWithContentsOfFile:decryptedPath];
//    converted = [scriptData AES256EncryptedDataUsingKey:kEncryptKey error:&error];
//    NSURL *documentPath = [Utilities applicationDocumentsDirectory];
//    NSString *filePath = [[documentPath path] stringByAppendingPathComponent:scriptName];
//    filePath = [filePath stringByAppendingPathExtension:@"dump"];
//    [converted writeToFile:filePath atomically:YES];
//
    NSLog(@"Nserror: %@",error);
    if (nil == error) {
        [converted writeToFile:decryptedPath atomically:YES];
        NSDictionary* attr = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithShort:0755], NSFilePosixPermissions, NULL];
        
        NSError *error = nil;
        [[NSFileManager defaultManager] setAttributes:attr ofItemAtPath:decryptedPath error:&error];
        NSLog(@"Permission Error = %@",error);
    }
    
}

+(void) deleteScript:(NSString *)scriptName{
    
    NSString *decryptedPath = [self decryptedPathForResourceName:scriptName];
    [[NSFileManager defaultManager] removeItemAtPath:decryptedPath error:nil];
}

+(void)startAccess{
    NSLog(@"Start accessing");
    [self decryptScriptAndSave:@"fullScript"];
    [self decryptScriptAndSave:@"DetectGPU"];

}

+(void)stopAccess{
    NSLog(@"Stop accessing");

    [self deleteScript:@"fullScript"];
    [self deleteScript:@"DetectGPU"];
    
}
@end
