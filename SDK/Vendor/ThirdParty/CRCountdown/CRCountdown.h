//
//  CRCountdown.h
//  GinSDK
//
//  Created by Nero-Macbook on 4/8/22.
//
#import <Foundation/Foundation.h>
typedef void (^CRCountdownCompletion)(void);
typedef void (^CRCountdownUpdate)(NSUInteger);

@interface CRCountdown : NSObject

- (void)startCountdownWithInterval:(NSTimeInterval)interval ticks:(NSUInteger)ticks completion:(CRCountdownCompletion)completion update:(CRCountdownUpdate)update;
@property (readonly) NSUInteger ticksRemaining;
@property (readonly) NSTimeInterval interval;

@property (nonatomic, assign) BOOL isCompleted;
- (void)stopCountdown;

@end
