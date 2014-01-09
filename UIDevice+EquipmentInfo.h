//
//  UIDevice+EquipmentInfo.h
//
//  Created by Ray Zhang on 13-1-8.
//
//  This Device Category Depand on CoreTelephony, IOKit Frameworks and libMobileGestalt Dynamic Library
//

#import <UIKit/UIKit.h>

@interface UIDevice (EquipmentInfo)

// Core Telephony Device Information
+ (NSString *)ERIVersion;
+ (NSString *)ICCID;
+ (NSString *)IMEI;
+ (NSString *)IMSI;
+ (NSString *)MEID;
+ (NSString *)PRLVersion;

// UIKit Device Inforation
+ (NSString *)UDID;
+ (NSString *)CPUArchitecture;
+ (NSString *)serialNumber;

// IOKit Device Information
+ (NSString *)deviceIMEI;
+ (NSString *)deviceSerialNumber;

+ (NSString *)platformModel;
+ (NSString *)platformUUID;
+ (NSString *)platformSerialNumber;

// System Control Device Information
+ (NSString *)systemModel;
+ (NSString *)macAddress;

@end
