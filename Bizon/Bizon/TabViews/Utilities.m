//
//  Utilities.m
//  Bizon
//
//  Created by Satendra Singh on 18/09/16.
//  Copyright © 2016 Satendra Singh. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities

    
+(NSString *) LogFilePath
    {
            //write a NSString to a file
        NSString *filePath = [[[self applicationDocumentsDirectory] path] stringByAppendingPathComponent:@"Bizon.log"];
    if (NO == [[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        
        [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];

    }
        NSLog(@"write data at path: %@",filePath);
        return filePath;
    }
    
+ (NSURL *)applicationDocumentsDirectory {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.CoreBits.ScanLister" in the user's Application Support directory.
    NSURL *appSupportURL = [[[NSFileManager defaultManager] URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *finalUrl = [appSupportURL URLByAppendingPathComponent:@"com.corebits.Bizon"];
    if (NO == [[NSFileManager defaultManager] fileExistsAtPath:finalUrl.path]) {
        [[NSFileManager defaultManager] createDirectoryAtURL:finalUrl withIntermediateDirectories:NO attributes:nil error:nil];
        
    }
    return finalUrl;
}
    

@end
