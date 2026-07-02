//
//  CrashlyticsManager.h
//  GinSDK
//
//  Created by Sơn Lê on 30/7/24.
//
#import <Foundation/Foundation.h>
#import <FirebaseCore/FirebaseCore.h>
#import <FirebaseAnalytics/FirebaseAnalytics.h>
#import <FirebaseCrashlytics/FIRCrashlytics.h>
#import <FirebaseCrashlytics/FIRExceptionModel.h>
#import <FirebaseCrashlytics/FIRStackFrame.h>


@interface CrashlyticsManager : NSObject {
    
}

+ (CrashlyticsManager *) sharedInstance;
- (void) setUserId:(NSString *)userId;
- (void) crashLog:(NSError *)error;
- (void) crashLog:(NSError *)error andLogMessage:(NSString *)message;
- (void) crashLog:(NSError *)error andLogMessage:(NSString *)message andData:(NSDictionary *)data;
- (void) crashLogModel:(FIRExceptionModel *)exceptionModel;
- (FIRCrashlytics *) FIR;

@end
