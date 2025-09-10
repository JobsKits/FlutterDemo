//
//  FlutterPluginName.m
//  Runner
//
//  Created by Admin on 2023/8/24.
//  Copyright © 2023 The Chromium Authors. All rights reserved.
//

#import "FlutterPluginName.h"
//#import <TikTokBusinessSDK/TikTokBusinessSDK.h>

@implementation FlutterPluginName

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {

    
//    TikTokConfig *config = [TikTokConfig configWithAccessToken: @"2G5mNa4aBzewKN7WyhtLbYtqiu1Qz0ES" appId: @375380948 tiktokAppId: @7313694430087890950];
//    [config enableDebugMode];
//  [TikTokBusiness initializeSdk:config];

    
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"tiktok_events"
            binaryMessenger:[registrar messenger]];

  FlutterPluginName* instance = [[FlutterPluginName alloc] init];

  [registrar addMethodCallDelegate:instance channel:channel];
    
    
    
    FlutterMethodChannel* channel1 = [FlutterMethodChannel
        methodChannelWithName:@"udid_events"
              binaryMessenger:[registrar messenger]];

    FlutterPluginName* instance1 = [[FlutterPluginName alloc] init];

    [registrar addMethodCallDelegate:instance1 channel:channel1];

    

}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {

  if ([@"tiktok_events_ios" isEqualToString:call.method]) {
      NSString *name = call.arguments[@"name"];
      NSDictionary *params = call.arguments[@"params"];

//    if(!params){
//        [TikTokBusiness trackEvent:name];
//    }else{
//        [TikTokBusiness trackEvent:name withProperties:params];
//    }

      NSLog(@"事件触发成功!%@",name);

  } else if([@"udid_events_ios" isEqualToString:call.method]){
      NSString * DEVICE_UUID = [self loadPassword];
      if(DEVICE_UUID == nil){
          DEVICE_UUID = [[[UIDevice currentDevice] identifierForVendor] UUIDString] ?: [[NSUUID UUID] UUIDString];
          [self savePassword:DEVICE_UUID];
          NSLog(@"cun udid");
      }
      else{
          DEVICE_UUID =  [self loadPassword];
          NSLog(@"qu udid %@",DEVICE_UUID);

      }
      
      
      result(DEVICE_UUID);
  }else{
    result(FlutterMethodNotImplemented);

  }

}
NSString *const serviceName = @"com.tggroup.fb4748"; // 修改为你的应用的服务名
NSString *const accountName = @"userAccount";    // 修改为你的用户帐户名

// 存储密码到钥匙串
- (void)savePassword:(NSString *)password {
    NSData *passwordData = [password dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *query = @{
        (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
        (__bridge id)kSecAttrService: serviceName,
        (__bridge id)kSecAttrAccount: accountName,
        (__bridge id)kSecValueData: passwordData
    };
    
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)query, NULL);
    if (status != errSecSuccess) {
        NSLog(@"Failed to save password to keychain with status: %d", (int)status);
    }
}

// 从钥匙串中检索密码
- (NSString *)loadPassword {
    NSDictionary *query = @{
        (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
        (__bridge id)kSecAttrService: serviceName,
        (__bridge id)kSecAttrAccount: accountName,
        (__bridge id)kSecReturnData: @YES
    };
    
    CFTypeRef result = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, &result);
    if (status == errSecSuccess) {
        NSData *passwordData = (__bridge_transfer NSData *)result;
        NSString *password = [[NSString alloc] initWithData:passwordData encoding:NSUTF8StringEncoding];
        return password;
    } else {
        NSLog(@"Failed to load password from keychain with status: %d", (int)status);
        return nil;
    }
}

// 删除密码从钥匙串中
- (void)deletePassword {
    NSDictionary *query = @{
        (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
        (__bridge id)kSecAttrService: serviceName,
        (__bridge id)kSecAttrAccount: accountName
    };
    
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)query);
    if (status != errSecSuccess) {
        NSLog(@"Failed to delete password from keychain with status: %d", (int)status);
    }
}
@end
