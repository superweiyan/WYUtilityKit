//
//  WYTimer.m
//  WYTimer
//
//  Created by weiyan on 6/13/16.
//  Copyright © 2016 weiyan. All rights reserved.
//

#import "WYTimer.h"

@interface WeakTimerTarget : NSObject

@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL selector;

@end

@implementation WeakTimerTarget

- (void)onTimeout
{
    if (self.target && [self.target respondsToSelector:_selector]) {
        [self.target performSelector:_selector withObject:self];
    }
}

@end

@interface WYTimer()
{
    NSTimer *timer;
}
@end

@implementation WYTimer

- (void)scheduleWithTime:(NSTimeInterval)ti
{
    WeakTimerTarget *timeTarget = [[WeakTimerTarget alloc] init];
    timeTarget.target = self;
    timeTarget.selector = @selector(onTimeout);
    
    timer = [NSTimer scheduledTimerWithTimeInterval:ti
                                             target:timeTarget
                                           selector:timeTarget.selector
                                           userInfo:nil
                                            repeats:YES];
}

- (void)fire
{
    [timer fire];
}

- (void)onTimeout
{
    NSLog(@"----------------");
}

@end
