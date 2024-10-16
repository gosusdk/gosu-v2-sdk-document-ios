//
//  CRCountdown.m
//  GinSDK
//
//  Created by Nero-Macbook on 4/8/22.
//

#import "CRCountdown.h"

@interface CRCountdown()

@property NSTimer *timer;
@property NSTimer *updateTimer;
@property (readwrite) NSTimeInterval interval;
@property (copy) CRCountdownCompletion completion;
@property (copy) CRCountdownUpdate update;
@end

@implementation CRCountdown

- (void)startCountdownWithInterval:(NSTimeInterval)interval ticks:(NSUInteger)ticks completion:(CRCountdownCompletion)completion update:(CRCountdownUpdate)update {
    self.completion = completion;
    self.update = update;
    self.interval = interval;
    self.isCompleted = NO;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:(interval * ticks) target:self selector:@selector(countdownComplete:) userInfo:nil repeats:NO];
    if (self.update) {
        self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(countdownUpdate:) userInfo:nil repeats:YES];
    }
}

- (void)stopCountdown {
    [self.updateTimer invalidate];
    [self.timer invalidate];
}

- (NSUInteger)ticksRemaining {
    if (self.timer.isValid) {
        NSTimeInterval timeRemaining = [self.timer.fireDate timeIntervalSinceDate:[NSDate date]];
        return timeRemaining / self.interval;
    } else {
        return 0;
    }
}

- (void)countdownUpdate:(NSTimer *)timer {
    if (self.update) {
        self.update(self.ticksRemaining);
//        NSString *s = [NSString stringWithFormat:@"%lu", (unsigned long)self.ticksRemaining];
    }
}

- (void)countdownComplete:(NSTimer *)timer {
    NSLog(@"countdownComplete");
    [self.updateTimer invalidate];
    if (self.completion) {
        self.completion();
    }
    self.isCompleted = YES;
    self.update = nil;
    self.completion = nil;
}

@end
