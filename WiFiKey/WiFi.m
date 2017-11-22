//
//  WiFi.m
//  WiFiKey
//
//  Created by admin on 2017/11/22.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "WiFi.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <SystemConfiguration/CaptiveNetwork.h>

#import <NetworkExtension/NEHotspotConfigurationManager.h>

@implementation WiFi

+ (nullable NSString*)getCurrentLocalIP
{
    NSString *address = nil;
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

+ (nullable NSString *)getCurreWiFiSsid {
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    NSLog(@"Supported interfaces: %@", ifs);
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        NSLog(@"%@ => %@", ifnam, info);
        if (info && [info count]) { break; }
    }
    return [(NSDictionary*)info objectForKey:@"SSID"];
}



+ (NSString *) hostname{
    char baseHostName[255];
    int success = gethostname(baseHostName, 255);
    if (success != 0) return nil;
    baseHostName[255] = '\0';
    
#if !TARGET_IPHONE_SIMULATOR
    return [NSString stringWithFormat:@"%s.local", baseHostName];
#else
    return [NSString stringWithFormat:@"%s", baseHostName];
#endif
}

// Direct from Apple. Thank you Apple
//+ (BOOL)addressFromString:(NSString *)IPAddress address:(struct sockaddr_in *)address{
//    if (!IPAddress || ![IPAddress length]) {
//        return NO;
//    }
//
//    memset((char *) address,sizeof(struct sockaddr_in), 0);
//    address->sin_family = AF_INET;
//    address->sin_len = sizeof(struct sockaddr_in);
//
//    int conversionResult = inet_aton([IPAddress UTF8String], &address->sin_addr);
//    if (conversionResult == 0) {
//        NSAssert1(conversionResult !=1, @"Failed to convert the IP address string into a sockaddr_in: %@", IPAddress);
//        return NO;
//    }
//
//    return YES;
//}



/**
 在已知的Wi-Fi名称和密码的情况下，在应用内连接Wi-Fi。这种方式连接会在app内弹框。
 
 @param wifiname Wi-Fi名称
 @param password Wi-Fi密码
 */
+(void)connetWiFi:(NSString *)wifiname password:(NSString *)password {
#if TARGET_IPHONE_SIMULATOR
    NSLog(@"请在真机中运行");
#else
    if (@available(iOS 11.0, *)) {
        NEHotspotConfiguration *hotspotConfig = [[NEHotspotConfiguration alloc] initWithSSID:wifiname passphrase:password isWEP:NO];
        
        [[NEHotspotConfigurationManager sharedManager] applyConfiguration:hotspotConfig completionHandler:^(NSError * _Nullable error) {
            NSLog(@"error:%@", error);
        }];
    } else {
        // Fallback on earlier versions
        NSLog(@"请在iOS 11之后的版本中运行");
    }
#endif
}


@end
