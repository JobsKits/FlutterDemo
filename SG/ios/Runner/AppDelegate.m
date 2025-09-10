#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
//#import <TikTokBusinessSDK/TikTokBusinessSDK.h>
#import "FlutterPluginName.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [FlutterPluginName registerWithRegistrar:[self registrarForPlugin:@"FlutterPluginName"]];

  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.

    
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
