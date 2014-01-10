//
//  UIDevice+EquipmentInfo.m
//
//  Created by Ray Zhang on 13-1-8.
//
//  This Device Category Depand on CoreTelephony, IOKit Frameworks and libMobileGestalt Dynamic Library
//

#import "UIDevice+EquipmentInfo.h"

@implementation UIDevice (EquipmentInfo)

// Core Telephony Device Information
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
typedef struct CTResult {
    int flag;
    int a;
} CTResult;

extern struct CTServerConnection *_CTServerConnectionCreate(CFAllocatorRef, int (*)(void *, CFStringRef, CFDictionaryRef, void *), int *);
extern void _CTServerConnectionCopyMobileEquipmentInfo(CTResult *status, CFTypeRef connection, CFMutableDictionaryRef *equipmentInfo);

static int callback(void *connection, CFStringRef string, CFDictionaryRef dictionary, void *data) {
    return 0;
}

extern const NSString * const kCTMobileEquipmentInfoERIVersion;
extern const NSString * const kCTMobileEquipmentInfoICCID;
extern const NSString * const kCTMobileEquipmentInfoIMEI;
extern const NSString * const kCTMobileEquipmentInfoMEID;
extern const NSString * const kCTMobileEquipmentInfoPRLVersion;
static const NSString * const kCTMobileEquipmentInfoIMSI;

+ (NSString *)mobileDeviceInfoForKey:(const NSString *)key {
    NSString *retVal = nil;
    CFTypeRef ctsc = _CTServerConnectionCreate(kCFAllocatorDefault, callback, NULL);
    if (ctsc) {
        struct CTResult result;
        CFMutableDictionaryRef equipmentInfo = nil;
        _CTServerConnectionCopyMobileEquipmentInfo(&result, ctsc, &equipmentInfo);
        if (equipmentInfo) {
            retVal = [NSString stringWithString:CFDictionaryGetValue(equipmentInfo, key)];
            CFRelease(equipmentInfo);
        }
        CFRelease(ctsc);
    }
    return retVal;
}

+ (NSString *)ERIVersion {
    return [self mobileDeviceInfoForKey:kCTMobileEquipmentInfoERIVersion];
}

+ (NSString *)ICCID {
    return [self mobileDeviceInfoForKey:kCTMobileEquipmentInfoICCID];
}

+ (NSString *)IMEI {
    return [self mobileDeviceInfoForKey:kCTMobileEquipmentInfoIMEI];
}

+ (NSString *)IMSI {
    return [self mobileDeviceInfoForKey:kCTMobileEquipmentInfoIMSI];
}

+ (NSString *)MEID {
    return [self mobileDeviceInfoForKey:kCTMobileEquipmentInfoMEID];
}

+ (NSString *)PRLVersion {
    return [self mobileDeviceInfoForKey:kCTMobileEquipmentInfoPRLVersion];
}

// UIKit Device Information
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
extern NSString *MGCopyAnswer(CFStringRef);
static const CFStringRef kMobileDeviceUniqueIdentifier = CFSTR("UniqueDeviceID");
static const CFStringRef kMobileDeviceCPUArchitecture = CFSTR("CPUArchitecture");
static const CFStringRef kMobileDeviceSerialNumber = CFSTR("SerialNumber");

+ (NSString *)UDID {
    return [MGCopyAnswer(kMobileDeviceUniqueIdentifier) autorelease];
}

+ (NSString *)CPUArchitecture {
    return [MGCopyAnswer(kMobileDeviceCPUArchitecture) autorelease];
}

+ (NSString *)serialNumber {
    return [MGCopyAnswer(kMobileDeviceSerialNumber) autorelease];
}

// IOKit Device Information
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#import <IOKit/IOKitKeys.h>
#import <IOKit/IOKitLib.h>
static const CFStringRef kIODeviceModel = CFSTR("model");

static const CFStringRef kIODeviceIMEI = CFSTR("device-imei");
static const CFStringRef kIODeviceSerialNumber = CFSTR("serial-number");

+ (NSString *)IODeviceInfoForKey:(CFStringRef)key {
    NSString *retVal = nil;
    io_registry_entry_t entry = IORegistryGetRootEntry(kIOMasterPortDefault);
    if (entry) {
        CFTypeRef property = IORegistryEntrySearchCFProperty(entry, kIODeviceTreePlane, key, kCFAllocatorDefault, kIORegistryIterateRecursively);
        if (property) {
            CFTypeID typeID = CFGetTypeID(property);
            if (CFStringGetTypeID() == typeID) {
                retVal = [NSString stringWithString:(NSString *)property];
            } else if (CFDataGetTypeID() == typeID) {
                CFStringRef modelString = CFStringCreateWithBytes(kCFAllocatorDefault,
                                                                  CFDataGetBytePtr(property),
                                                                  CFDataGetLength(property),
                                                                  kCFStringEncodingUTF8, NO);
                retVal = [NSString stringWithString:(NSString *)modelString];
                CFRelease(modelString);
            }
            CFRelease(property);
        }
        IOObjectRelease(entry);
    }
    return retVal;
}

+ (NSString *)platformModel {
    return [self IODeviceInfoForKey:kIODeviceModel];
}

+ (NSString *)deviceIMEI {
    return [self IODeviceInfoForKey:kIODeviceIMEI];
}

+ (NSString *)deviceSerialNumber {
    return [self IODeviceInfoForKey:kIODeviceSerialNumber];
}

+ (NSString *)platformUUID {
    return [self IODeviceInfoForKey:CFSTR(kIOPlatformUUIDKey)];
}

+ (NSString *)platformSerialNumber {
    return [self IODeviceInfoForKey:CFSTR(kIOPlatformSerialNumberKey)];
}

// System Control Device Information
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
+ (NSString *)macAddress {
    int mib[6] = {CTL_NET, AF_ROUTE, 0, AF_LINK, NET_RT_IFLIST};
    size_t len = 0;
    char *buf = NULL;
    unsigned char *ptr = NULL;
    struct if_msghdr *ifm = NULL;
    struct sockaddr_dl *sdl = NULL;
    
    mib[5] = if_nametoindex("en0");
    if (mib[5] == 0) return nil;
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) return nil;
        
    if ((buf = malloc(len)) == NULL) return nil;
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0)
    {
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    
    NSMutableString *outString = [[NSMutableString alloc] initWithCapacity:6];
    for (int i = 0; i < 6; i++) {
        if (i < 5) {
            [outString appendFormat:@"%02X:", ptr[i]];
        } else {
            [outString appendFormat:@"%02X", ptr[i]];
        }
    }
    NSString *retVal = [NSString stringWithString:outString];
    [outString release];
    free(buf);
    
    return retVal;
}

+ (NSString *)systemModel {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *answer = malloc(size);
	sysctlbyname("hw.machine", answer, &size, NULL, 0);
	NSString *results = [NSString stringWithCString:answer encoding:NSUTF8StringEncoding];
	free(answer);
	return results;
}

@end
