//
//  UIDevice+CoreTelephonyCategory.h
//  EquipmentInfo
//
//  Created by Ray Zhang on 13-1-29.
//  Copyright (c) 2013年 Ray Zhang. All rights reserved.
//
//  This Category Depand on Core Telephony Framework.
//

#import <UIKit/UIKit.h>

@interface UIDevice (CoreTelephony)

+ (NSString *)IMEI;
+ (NSString *)CMID; // Current Mobile Identifier. Genernally, it's same as IMEI, but CDMA carrier maybe not.
+ (NSString *)ICCID;

+ (NSString *)IMSI;
+ (NSString *)CSID; // Current Subscriber Identifier. Genernally, it is same as IMSI, but CDMA carrier is not.

+ (NSString *)MEID; // Just for CDMA carrier.

@end
