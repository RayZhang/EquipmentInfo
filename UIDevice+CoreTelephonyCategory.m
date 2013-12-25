//
//  UIDevice+CoreTelephonyCategory.m
//  EquipmentInfo
//
//  Created by Ray Zhang on 13-1-29.
//  Copyright (c) 2013年 Ray Zhang. All rights reserved.
//
//  This Category Depand on Core Telephony Framework.
//

#import "UIDevice+CoreTelephonyCategory.h"

typedef struct CTResult {
    int flag;
    int a;
} CTResult;

extern CFTypeRef _CTServerConnectionCreate(CFAllocatorRef, int (*)(void *, CFStringRef, CFDictionaryRef, void *), int *);
extern void _CTServerConnectionCopyMobileEquipmentInfo(CTResult *status, CFTypeRef connection, CFMutableDictionaryRef *equipmentInfo);

static int callback(void *connection, CFStringRef string, CFDictionaryRef dictionary, void *data) {
    return 0;
}

@implementation UIDevice (CoreTelephony)

// Core Telephony Device Information

+ (NSString *)coreTelephonyInfoForKey:(const NSString *)key {
    NSString *retVal = nil;
    CFTypeRef ctsc = _CTServerConnectionCreate(kCFAllocatorDefault, callback, NULL);
    if (ctsc) {
        struct CTResult result;
        CFMutableDictionaryRef equipmentInfo = nil;
        _CTServerConnectionCopyMobileEquipmentInfo(&result, ctsc, &equipmentInfo);
        if (equipmentInfo) {
            CFStringRef value = CFDictionaryGetValue(equipmentInfo, key);
            if (value) {
                retVal = [NSString stringWithString:(id)value];
            }
            CFRelease(equipmentInfo);
        }
        CFRelease(ctsc);
	}	
    return retVal;
}

+ (NSString *)IMEI {
    return [self coreTelephonyInfoForKey:@"kCTMobileEquipmentInfoIMEI"];
}

+ (NSString *)CMID {
    return [self coreTelephonyInfoForKey:@"kCTMobileEquipmentInfoCurrentMobileId"];
}

+ (NSString *)ICCID {
    return [self coreTelephonyInfoForKey:@"kCTMobileEquipmentInfoICCID"];
}

+ (NSString *)MEID {
    return [self coreTelephonyInfoForKey:@"kCTMobileEquipmentInfoMEID"];
}

+ (NSString *)IMSI {
    return [self coreTelephonyInfoForKey:@"kCTMobileEquipmentInfoIMSI"];
}

+ (NSString *)CSID {
    return [self coreTelephonyInfoForKey:@"kCTMobileEquipmentInfoCurrentSubscriberId"];
}

@end
