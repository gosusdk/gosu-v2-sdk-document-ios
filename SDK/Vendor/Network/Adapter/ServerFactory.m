
#import "ServerFactory.h"

static ServerFactory *sharedInstance;

@implementation ServerFactory
#pragma mark Singleton Methods
+ (ServerFactory *)sharedInstance
{
    @synchronized(self) {
        if(sharedInstance == nil) {
            sharedInstance = [[super alloc] init];
        }
    }
    return sharedInstance;
}

#pragma mark Singleton Methods
+ (ServerFactory *)sharedInstance:(id<ServerConnectionDelegate>)apiFramework
{
    @synchronized(self) {
        if(sharedInstance == nil) {
            sharedInstance = [[super alloc] init];
            sharedInstance->_grpcFrameworkSDK = apiFramework;
        }
    }
    return sharedInstance;
}
- (id<ServerConnectionDelegate>) connection
{
    return _grpcFrameworkSDK;
}
@end
