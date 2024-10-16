#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "GosuMobileGateway.pbobjc.h"
#import "GosuMobileGateway.pbrpc.h"

FOUNDATION_EXPORT double GameSDKGrpcServerVersionNumber;
FOUNDATION_EXPORT const unsigned char GameSDKGrpcServerVersionString[];

