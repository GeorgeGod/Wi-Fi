//
//  WiFi.h
//  WiFiKey
//
//  Created by admin on 2017/11/22.
//  Copyright © 2017年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WiFi : NSObject


/**
 获取Wi-Fi的名称
 */
+ (nullable NSString*)getCurrentLocalIP;


/**
 获取Wi-Fi的IP地址
 */
+ (nullable NSString *)getCurreWiFiSsid;


+ (NSString *) hostname;


+ (NSString *) getIPAddressForHost: (NSString *) theHost;


/**
 在已知的Wi-Fi名称和密码的情况下，在应用内连接Wi-Fi。这种方式连接会在app内弹框。
 
 @param wifiname Wi-Fi名称
 @param password Wi-Fi密码
 */
+(void)connetWiFi:(NSString *)wifiname password:(NSString *)password;
@end
