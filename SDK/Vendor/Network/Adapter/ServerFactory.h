
#import <UIKit/UIKit.h>
#import "ServerConnectionDelegate.h"

@interface ServerFactory : NSObject {
    
}

@property (nonatomic, strong) id<ServerConnectionDelegate> grpcFrameworkSDK;
/*
+ (ServerFactory *) initWithGosuSDK;
+ (ServerFactory *) initWithGamoSDK;
+ (ServerFactory *) sharedInstance;
- (id<ServerConnectionDelegate>) createConnection:(NSString *)apiType;
 */
- (id<ServerConnectionDelegate>) connection;
+ (ServerFactory *)sharedInstance;
+ (ServerFactory *)sharedInstance:(id<ServerConnectionDelegate>)apiFramework;
@end
