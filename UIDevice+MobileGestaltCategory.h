//
// UIDevice+MobileGestaltCategory.h
// EquipmentInfo
//
// Created by Ray Zhang on 13-1-28.
// Copyright (c) 2013年 Ray Zhang. All rights reserved.
//
// This Categroy Depaned on Mobile Gestalt Dynamic Library
//
#import <UIKit/UIKit.h>

@interface UIDevice (MobileGestalt)

- (NSString *)UDID;
- (NSString *)IMEI;
- (NSString *)ICCID;
- (NSString *)serialNumber;
- (NSString *)wifiAddress; // e.g. a1:0b:07:f4:e8:5a
- (NSString *)bluetoothAddress; // e.g. e1:09:c0:4d:b8:f6

- (NSString *)modelNumberWithRegionInfo; // e.g. MD239ZP/A

- (NSString *)cpuArchitecture; // e.g. @"armv6", @"armv7", @"i486"
- (NSString *)productType; // e.g. @"iPhone3,1", @"iPod4,1", @"x86_64"

- (BOOL)airplaneMode;

@end
