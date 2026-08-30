//
// Copyright (c) 2026 Nightwind
//

#import <Foundation/Foundation.h>
#import "Firmware.h"

static NSString *s_firmwareVersion = nil;

NSString *getFirmwareVersion(void) {
    if (s_firmwareVersion == nil) {
        NSDictionary *const dictionary = [NSDictionary dictionaryWithContentsOfFile:@"/System/Library/CoreServices/SystemVersion.plist"];

        if (dictionary != nil) {
            id version = [dictionary objectForKey:@"ProductVersion"];
            
            if (version != nil) {
                s_firmwareVersion = [version retain];
            }
        }
    }
    
    return s_firmwareVersion;
}
