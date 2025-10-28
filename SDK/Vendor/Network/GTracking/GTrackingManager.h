//
//  GTrackingManager.h
//  GameSDK
//
//  Created by Nero-Macbook on 8/9/23.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "CrashlyticsManager.h"

@interface GTrackingManager : NSObject {
    
}

+ (GTrackingManager *) sharedInstance;
- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
- (void) setCustomerUserID:(NSString *)customerUserID;

//deprecated, uses verifySDK() instead
- (void) showSignInSDK;
- (void) verifySDK;
//------//

- (void) verifyLogin;

//deprecated, use login() instead
- (void) trackingSignIn:(NSString *)userId andUsername:(NSString *)username andEmail:(NSString *)email;
- (void) login:(NSString *)userId andUsername:(NSString *)username andEmail:(NSString *)email;
//------//

- (void) checkout:(NSString *)orderId andProductId:(NSString *)productId andAmount:(NSString *)amount andCurrency:(NSString *)currency andUsername:(NSString *)username;
- (void) purchase:(NSString *)orderId andProductId:(NSString *)productId andAmount:(NSString *)amount andCurrency:(NSString *)currency andUsername:(NSString *)username;
- (void) purchase:(NSString *)orderId andProductId:(NSString *)productId andAmount:(NSString *)amount andCurrency:(NSString *)currency andUsername:(NSString *)username andIsIAP:(BOOL) isIAP;

//deprecated, use trackCusomEvent
- (void) trackingEvent:(NSString *)eventName;
- (void) trackingEvent:(NSString *)eventName withValues:(NSDictionary*)values;
- (void) trackingCustomEvent:(NSString *)eventName withValues:(NSDictionary*)values;
//------//

- (void) registerForRemoteNotifications:(NSData *)deviceToken;

//deprecated, uses createNewCharacter() instead
- (void)doneNRU:(NSString *)serverId andRoleId:(NSString *)roleId andRoleName:(NSString *)roleName;
- (void)createNewCharacter:(NSString *)serverId andRoleId:(NSString *)roleId andRoleName:(NSString *)roleName;
//------//

//--deprecated, use startTutorial instead;
- (void)trackingStartTrial;
- (void)startTutorial:(NSString *)userID andCharacterID:(NSString *)characterID andCharacterName:(NSString *)characterName andServerInfo:(NSString *)serverID;
//------//

//deprecated, use completeTutorial() instead
- (void)trackingTurialCompleted;
- (void)completeTutorial:(NSString *)userID andCharacterID:(NSString *)characterID andCharacterName:(NSString *)characterName andServerInfo:(NSString *)serverID;
//------//

//Add new
- (void)completeRegistration:(NSString *)userID;
- (void)enterGame:(NSString *)userID
                 characterID:(NSString *)characterID
               characterName:(NSString *)characterName
                  serverInfo:(NSString *)serverInfo;
- (void)levelUp:(NSString *)userID
              characterID:(NSString *)characterID
               serverInfo:(NSString *)serverInfo
                    level:(NSInteger)level;

- (void)vipUp:(NSString *)userID
            characterID:(NSString *)characterID
             serverInfo:(NSString *)serverInfo
                vipLevel:(NSInteger)vipLevel;

- (void)useItem:(NSString *)userID
              characterID:(NSString *)characterID
               serverInfo:(NSString *)serverInfo
                   itemID:(NSString *)itemID
                 quantity:(NSInteger)quantity;

- (void)trackActivityResult:(NSString *)userID
                          characterID:(NSString *)characterID
                           serverInfo:(NSString *)serverInfo
                           activityID:(NSString *)activityID
                      activityResult:(NSString *)activityResult;

- (void)logout;

+ (CrashlyticsManager *) crashlytics;
@end
