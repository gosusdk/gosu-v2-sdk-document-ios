//
//  UserRequireData.m
//  GameSDK
//
//  Created by Nero-Macbook on 3/21/22.
//

#import "UserRequireData.h"

static UserRequireData *shared;
@implementation UserRequireData

#pragma mark Singleton Methods
+ (UserRequireData *)sharedInstance
{
    @synchronized(self) {
        if(shared == nil || shared.isNotEmpty){
            shared = [[super alloc] init];
            shared.OTPNetwork = @"email";
        }
    }
    return shared;
}

+ (UserRequireData *)sharedInstance:(BOOL)newObject
{
    @synchronized(self) {
        if(newObject == YES){
            shared = [[super alloc] init];
            shared.OTPNetwork = @"email";
        } else {
            shared = [self sharedInstance];
        }
    }
    return shared;
}

- (int) getActionTypeNumber
{
    int actionTypeNumber = 1;
    if ([_actionType isEqual:@"register"]) {
        actionTypeNumber = 1;
    } else if([_actionType isEqual:@"forgotpassword"]) {
        actionTypeNumber = 2;
    } else if([_actionType isEqual:@"linkaccount"])
    {
        actionTypeNumber = 3;
    }
    return actionTypeNumber;
}
- (void)clear
{
    _isNotEmpty = YES;
}
@end
