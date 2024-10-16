//
//  GosuSDK.m
//  GosuSDK
//
//  Created by Nero-Macbook on 2/15/23.
//

#import "GosuSDK.h"
#import "GSGrpcApi.h"
#import "ServerFactory.h"

@implementation GosuSDK
static GosuSDK *sharedInstance;

#pragma mark Singleton Methods
+ (GosuSDK *)sharedInstance
{
    @synchronized(self) {
        if(sharedInstance == nil){
            sharedInstance = [[super alloc] init];
            [ServerFactory sharedInstance:[[GSGrpcApi alloc] init]];
        }
    }
    return sharedInstance;
}

@end
