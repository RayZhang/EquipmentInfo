//
// UIDevice+MobileGestaltCategory.m
// EquipmentInfo
//
// Created by Ray Zhang on 13-1-28.
// Copyright (c) 2013年 Ray Zhang. All rights reserved.
//
// This Categroy Depaned on Mobile Gestalt Dynamic Library
//

#import "UIDevice+MobileGestaltCategroy.h"

@implementation UIDevice (MobileGestalt)

// Mobile Gestalt EquipmentInfo
extern CFTypeRef MGCopyAnswer(CFStringRef);

- (NSString *)UDID {
    NSString *retVal = nil;
    CFTypeRef tmp = MGCopyAnswer(CFSTR("UniqueDeviceID"));
    if (tmp) {
        retVal = [NSString stringWithString:tmp];
        CFRelease(tmp);
    }
    return retVal;
}

- (NSString *)IMEI {
    NSString *retVal = nil;
    CFTypeRef tmp = MGCopyAnswer(CFSTR("InternationalMobileEquipmentIdentity"));
    if (tmp) {
        retVal = [NSString stringWithString:tmp];
        CFRelease(tmp);
    }
    return retVal;
}

- (NSString *)ICCID {
    NSString *retVal = nil;
    CFArrayRef infoArray = MGCopyAnswer(CFSTR("CarrierBundleInfoArray"));
    if (infoArray) {
        CFDictionaryRef infoDic = CFArrayGetValueAtIndex(infoArray, 0);
        if (infoDic) {
            retVal = [NSString stringWithString:CFDictionaryGetValue(infoDic, CFSTR("IntegratedCircuitCardIdentity"))];
        }
        CFRelease(infoArray);
    }
    return retVal;
}

- (NSString *)serialNumber {
    NSString *retVal = nil;
    CFTypeRef tmp = MGCopyAnswer(CFSTR("SerialNumber"));
    if (tmp) {
        retVal = [NSString stringWithString:tmp];
        CFRelease(tmp);
    }
    return retVal;
}

- (NSString *)wifiAddress {
    NSString *retVal = nil;
    CFTypeRef tmp = MGCopyAnswer(CFSTR("WifiAddress"));
    if (tmp) {
        retVal = [NSString stringWithString:tmp];
        CFRelease(tmp);
    }
    return retVal;
}

- (NSString *)bluetoothAddress {
    NSString *retVal = nil;
    CFTypeRef tmp = MGCopyAnswer(CFSTR("BluetoothAddress"));
    if (tmp) {
        retVal = [NSString stringWithString:tmp];
        CFRelease(tmp);
    }
    return retVal;
}

- (NSString *)cpuArchitecture {
    NSString *retVal = nil;
    CFTypeRef tmp = MGCopyAnswer(CFSTR("CPUArchitecture"));
    if (tmp) {
        retVal = [NSString stringWithString:tmp];
        CFRelease(tmp);
    }
    return retVal;
}

- (NSString *)productType {
    NSString *retVal = nil;
    CFTypeRef tmp = MGCopyAnswer(CFSTR("ProductType"));
    if (tmp) {
        retVal = [NSString stringWithString:tmp];
        CFRelease(tmp);
    }
    return retVal;
}

- (BOOL)airplaneMode {
    BOOL retVal = NO;
    CFTypeRef tmp = MGCopyAnswer(CFSTR("AirplaneMode"));
    if (tmp) {
        if (tmp == kCFBooleanTrue) {
            retVal = YES;
        }
        CFRelease(tmp);
    }
    return retVal;
}

@end
