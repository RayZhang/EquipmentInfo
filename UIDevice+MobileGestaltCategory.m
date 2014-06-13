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
        retVal = [NSString stringWithString:(__bridge NSString *)tmp];
        CFRelease(tmp);
    }
    return retVal;
}

- (NSString *)modelNumberWithRegionInfo {
	NSString *retVal = nil;
	CFTypeRef modelNumber = MGCopyAnswer(CFSTR("ModelNumber"));
	if(modelNumber) {
		CFTypeRef regionInfo = MGCopyAnswer(CFSTR("RegionInfo"));
		if(regionInfo) {
			retVal = [NSString stringWithFormat:@"%@%@", (__bridge NSString *)modelNumber, (__bridge NSString *)regionInfo];
			CFRelease(regionInfo);
		}
		CFRelease(modelNumber);
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

/*

All Keys:

DieId
SerialNumber
UniqueChipID
WifiAddress
CPUArchitecture
BluetoothAddress
EthernetMacAddress
FirmwareVersion
MLBSerialNumber
ModelNumber
RegionInfo
RegionCode
DeviceClass
ProductType
DeviceName
UserAssignedDeviceName
HWModelStr
SigningFuse
SoftwareBehavior
SupportedKeyboards
BuildVersion
ProductVersion
ReleaseType
InternalBuild
CarrierInstallCapability
IsUIBuild
InternationalMobileEquipmentIdentity
MobileEquipmentIdentifier
DeviceColor
HasBaseband
SupportedDeviceFamilies
SoftwareBundleVersion
SDIOManufacturerTuple
SDIOProductInfo
UniqueDeviceID
InverseDeviceID
ChipID
PartitionType
ProximitySensorCalibration
CompassCalibration
WirelessBoardSnum
BasebandBoardSnum
HardwarePlatform
RequiredBatteryLevelForSoftwareUpdate
IsThereEnoughBatteryLevelForSoftwareUpdate
BasebandRegionSKU
encrypted-data-partition
BasebandKeyHashInformation
SysCfg
DiagData
BasebandFirmwareManifestData
SIMTrayStatus
CarrierBundleInfoArray
AirplaneMode
IsProductTypeValid
BoardId
AllDeviceCapabilities
wi-fi
SBAllowSensitiveUI
green-tea
not-green-tea
AllowYouTube
AllowYouTubePlugin
SBCanForceDebuggingInfo
AppleInternalInstallCapability
HasAllFeaturesCapability
ScreenDimensions
IsSimulator
BasebandSerialNumber
BasebandChipId
BasebandCertId
BasebandSkeyId
BasebandFirmwareVersion
cellular-data
contains-cellular-radio
RegionalBehaviorGoogleMail
RegionalBehaviorVolumeLimit
RegionalBehaviorShutterClick
RegionalBehaviorNTSC
RegionalBehaviorNoWiFi
RegionalBehaviorChinaBrick
RegionalBehaviorNoVOIP
RegionalBehaviorGB18030
RegionalBehaviorAll
ApNonce
*/
