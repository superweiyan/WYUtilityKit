//
//  WYTimer.m
//  WYTimer
//
//  Created by weiyan on 6/13/16.
//  Copyright © 2016 weiyan. All rights reserved.
//

#import "WYTimer.h"

@interface WeakTimerTarget : NSObject

@property (nonatomic, weak) id aTarget;
@property (nonatomic, assign) SEL selector;

@end

@implementation WeakTimerTarget

- (void)onTimeout
{
    if (self.aTarget && [self.aTarget respondsToSelector:_selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Warc-performSelector-leaks"
        [self.aTarget performSelector:_selector withObject:self];
#pragma clang diagnostic pop
    }
}

@end

@interface WYTimer()

@property (nonatomic, strong)  NSTimer *timer;

@end

@implementation WYTimer

- (void)scheduleWithTime:(NSTimeInterval)ti
{
    WeakTimerTarget *timeTarget = [[WeakTimerTarget alloc] init];
    timeTarget.aTarget = self;
    timeTarget.selector = @selector(onTimeout);
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:ti
                                             target:timeTarget
                                           selector:timeTarget.selector
                                           userInfo:nil
                                            repeats:YES];
}

- (void)fire
{
    [self.timer fire];
}

- (void)onTimeout
{
    NSLog(@"----------------");
}

@end
