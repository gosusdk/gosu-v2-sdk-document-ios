//
//  CrashlyticsManager.m
//  GinSDK
//
//  Created by Sơn Lê on 30/7/24.
//

#import "CrashlyticsManager.h"

@interface CrashlyticsManager()
{
    
}

@end
static CrashlyticsManager *sharedInstance;
@implementation CrashlyticsManager
#pragma mark Singleton Methods
+ (CrashlyticsManager *)sharedInstance
{
    @synchronized(self) {
        if(sharedInstance == nil){
            sharedInstance = [[super alloc] init];
        }
    }
    return sharedInstance;
}


- (void) setUserId:(NSString *)userId
{
    @try {
        [[FIRCrashlytics crashlytics] setUserID:userId];
    } @catch (NSException *exception) {
        
    }
}
- (void) crashLog:(NSError *)error
{
    [self crashLog:error andLogMessage:@"" andData:NULL];
}

- (void) crashLog:(NSError *)error andLogMessage:(NSString *)message
{
    [self crashLog:error andLogMessage:message andData:NULL];
}
- (void) crashLog:(NSError *)error andLogMessage:(NSString *)message andData:(NSDictionary *)data
{
    @try {
        if (message !=NULL && [message length] > 0) {
            [[FIRCrashlytics crashlytics] log:message];
        }
        if (data != NULL) {
            [[FIRCrashlytics crashlytics] setCustomKeysAndValues:data];
        }
        [[FIRCrashlytics crashlytics] recordError:error];
    } @catch (NSException *exception) {
        
    }
}
- (void) crashLogModel:(FIRExceptionModel *)exceptionModel
{
    @try {
        [[FIRCrashlytics crashlytics] recordExceptionModel:exceptionModel];
    } @catch (NSException *exception) {
        
    }
}
- (FIRCrashlytics *) FIR
{
    return [FIRCrashlytics crashlytics];
}

@end
