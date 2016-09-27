//
//  OverViewTabView.m
//  Bizon
//
//  Created by Satendra Singh on 10/09/16.
//  Copyright © 2016 Satendra Singh. All rights reserved.
//

#import "OverViewTabView.h"
#import "TaskManager.h"

@implementation OverViewTabView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

-(void)awakeFromNib{

    [super awakeFromNib];
}

-(void)setInfo{
/*
 BIZON BOX Status: Connected/Not Connected
 Graphics card: NVIDIA GTX xxx OS X Version: xxxx (
 Mac: xxxx (MacBook Mid-2014)
 */
//    NSString *finalDetails = [NSString stringWithFormat:@"BIZON BOX Status  %@\nGraphics card   %@\nOS X Version    %@\nModel   Mac %@",/* DISABLES CODE */ (1)?@"Connected":@"Not Connected",[OverViewTabView videoCardInfo],[OverViewTabView osVersion],[OverViewTabView macModelName]];
    self.connectionState.stringValue = ([self getConnectedState])?@"Connected":@"Not Connected";
    self.graphicsCard.stringValue = [OverViewTabView videoCardInfo];
    self.macVersion.stringValue = [OverViewTabView osVersion];
    self.macModel.stringValue = [OverViewTabView macModelName];
    
}

-(void)reloadContent{
    
    [self setInfo];

}

-(BOOL)getConnectedState{
    
    NSString *output = nil;
    [TaskManager runScript:@"DetectGPU" withArguments:nil output:&output errorDescription:nil];
    if (nil != output) {
        NSLog(@"output = %@",output);
        return [output boolValue];
    }
    
    return NO;
}
-(IBAction)didClickRefreshDetails:(id)sender{
    
    [self setInfo];
}

+(NSString *)videoCardInfo{
    
    NSString *s = @"";
        // Check the PCI devices for video cards.
    CFMutableDictionaryRef match_dictionary = IOServiceMatching("IOPCIDevice");
    
        // Create a iterator to go through the found devices.
    io_iterator_t entry_iterator;
    if (IOServiceGetMatchingServices(kIOMasterPortDefault,
                                     match_dictionary,
                                     &entry_iterator) == kIOReturnSuccess)
        {
            // Actually iterate through the found devices.
        io_registry_entry_t serviceObject;
        while ((serviceObject = IOIteratorNext(entry_iterator))) {
                // Put this services object into a dictionary object.
            CFMutableDictionaryRef serviceDictionary;
            if (IORegistryEntryCreateCFProperties(serviceObject,
                                                  &serviceDictionary,
                                                  kCFAllocatorDefault,
                                                  kNilOptions) != kIOReturnSuccess)
                {
                    // Failed to create a service dictionary, release and go on.
                IOObjectRelease(serviceObject);
                continue;
                }
            
                // If this is a GPU listing, it will have a "model" key
                // that points to a CFDataRef.
            const void *model = CFDictionaryGetValue(serviceDictionary, @"model");
            if (model != nil) {
                if (CFGetTypeID(model) == CFDataGetTypeID()) {
                        // Create a string from the CFDataRef.
                    s = [[NSString alloc] initWithData:(__bridge NSData *)model
                                              encoding:NSASCIIStringEncoding];
                        //                    NSLog(@"Found GPU: %@", s);
                }
            }
            
                // Release the dictionary created by IORegistryEntryCreateCFProperties.
            CFRelease(serviceDictionary);
            
                // Release the serviceObject returned by IOIteratorNext.
            IOObjectRelease(serviceObject);
        }
        
            // Release the entry_iterator created by IOServiceGetMatchingServices.
        IOObjectRelease(entry_iterator);
        }
    return s;
}

+(NSString *)osVersion{
     NSString * operatingSystemVersionString = [[NSProcessInfo processInfo] operatingSystemVersionString];
    return operatingSystemVersionString;

}

+(NSString *)macModelName{
    size_t len = 0;
    NSString *modelName = nil;
    sysctlbyname("hw.model", NULL, &len, NULL, 0);
    if (len) {
        char *model = malloc(len*sizeof(char));
        sysctlbyname("hw.model", model, &len, NULL, 0);
        printf("%s\n", model);
        modelName = [NSString stringWithFormat:@"%s",model];
        free(model);
    }
    return modelName;
}
@end
