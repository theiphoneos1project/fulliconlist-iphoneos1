//
// Copyright (c) 2026 Nightwind
//

#import <Foundation/NSString.h>

NSString *getFirmwareVersion(void);

#define FIRMWARE_AT_LEAST(v)    ([getFirmwareVersion() compare:(v) options:NSNumericSearch] != NSOrderedAscending)
#define FIRMWARE_BEFORE(v)      ([getFirmwareVersion() compare:(v) options:NSNumericSearch] == NSOrderedAscending)
#define FIRMWARE_AFTER(v)       ([getFirmwareVersion() compare:(v) options:NSNumericSearch] == NSOrderedDescending)
#define FIRMWARE_IS(v)          ([getFirmwareVersion() compare:(v) options:NSNumericSearch] == NSOrderedSame)
