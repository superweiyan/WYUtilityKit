//
//  WYTimer.h
//  WYTimer
//
//  Created by weiyan on 6/13/16.
//  Copyright © 2016 weiyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYTimer : NSObject

- (void)scheduleWithTime:(NSTimeInterval)ti;

- (void)fire;

@end
