//
// Copyright (c) 2026 Nightwind
//

#include <Foundation/Foundation.h>
#include <CydiaSubstrate.h>
#include "Firmware/Firmware.h"

@interface FIL_NSArray : NSArray
@end

@implementation FIL_NSArray

- (BOOL)containsObject:(id)object {
    return YES;
}

@end

static NSArray *SBPlatformController_disallowedDisplayIdentifiers_hook(__unused id self, __unused SEL _cmd) {
    return @[];
}

static NSArray *(*SBPlatformController_allowedDisplayIdentifiers_orig)(id, SEL) = NULL;
static NSArray *SBPlatformController_allowedDisplayIdentifiers_hook(id self, SEL _cmd) {
    NSArray *orig = SBPlatformController_allowedDisplayIdentifiers_orig(self, _cmd);
    object_setClass(orig, [FIL_NSArray class]);
    return orig;
}

__attribute__((constructor)) static void init(void) {
    if (FIRMWARE_AT_LEAST(@"1.1.3")) {
        MSHookMessageEx(NSClassFromString(@"SBPlatformController"), sel_getUid("disallowedDisplayIdentifiers"), (IMP)SBPlatformController_disallowedDisplayIdentifiers_hook, NULL);
    } else {
        MSHookMessageEx(NSClassFromString(@"SBPlatformController"), sel_getUid("allowedDisplayIdentifiers"), (IMP)SBPlatformController_allowedDisplayIdentifiers_hook, (IMP *)&SBPlatformController_allowedDisplayIdentifiers_orig);
    }
}
