//
//  IdAppTracking.m
//  GameSDK
//
//  Created by Nero-Macbook on 11/11/21.
//
#import "IdAppTracking.h"
#import "ServerFactory.h"
#import "ServerConnectionDelegate.h"
#import <sys/utsname.h>

@interface IdAppTracking()
{
    
}

@end
static IdAppTracking *sharedInstance;
@implementation IdAppTracking
#pragma mark Singleton Methods
+ (IdAppTracking *)sharedInstance
{
    @synchronized(self) {
        if(sharedInstance == nil)
            sharedInstance = [[super alloc] init];
    }
    return sharedInstance;
}
- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    self->_logOpenURL = [url absoluteString];
    return YES;
}
- (void) idAppTrackingOpen:(NSString *)serverID roleID:(NSString *)roleID roleName:(NSString *)roleName
{
    NSLog(@"idAppTrackingOpen with multi params = %@", self->_logOpenURL);
    id<ServerConnectionDelegate> connect = [[SdkConfig sharedInstance] apiConnect];
    [connect idAppTrackingOpen:serverID roleID:roleID roleName:roleName andLogOpenUrl:self->_logOpenURL andDevideModel:[self deviceModel]];
}
- (void) idAppTrackingOpen
{
    NSLog(@"idAppTrackingOpen = %@", self->_logOpenURL);
    id<ServerConnectionDelegate> connect = [[SdkConfig sharedInstance] apiConnect];
    [connect idAppTrackingOpen];
}
- (void) idAppTrackingInstall:(UIApplication *)application
{
    NSLog(@"idAppTrackingOpen = %@", self->_logOpenURL);
    id<ServerConnectionDelegate> connect = [[SdkConfig sharedInstance] apiConnect];
    
    [connect idAppTrackingInstall:[SdkConfig sharedInstance] andAppVersion:[[SdkConfig sharedInstance] sdkVersion]];
}
- (void) idAppTrackingAllowNotification:(NSString *)devicetoken
{
    id<ServerConnectionDelegate> connect = [[SdkConfig sharedInstance] apiConnect];
    [connect idAppTrackingAllowNotification:devicetoken];
}
- (void) idTrackingInstallUser
{
    id<ServerConnectionDelegate> connect = [[SdkConfig sharedInstance] apiConnect];
    [connect idTrackingInstallUser:[self deviceModel]];
}
#pragma mark - check device model
- (NSString *) deviceModel
{
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}
@end

