//
//  Stopwatch.m
//  BreakReminder
//
//  Created by Cecilia Zhang on 3/30/13.
//  Copyright (c) 2013 Cecilia Zhang. All rights reserved.
//

#import "Stopwatch.h"
#include <mach/mach_time.h>

@implementation Stopwatch

- (void)reset {
    startTime = mach_absolute_time();
}

- (NSTimeInterval)elapsedTimeInterval {
    double interval = (double)[self elapsedNanoseconds] * 1.0e-9;
    return interval;
}



- (uint64_t)elapsedNanoseconds {
    // See http://developer.apple.com/qa/qa2004/qa1398.html for details about this code
    
    const uint64_t now = mach_absolute_time();
    const uint64_t elapsed = now - startTime;
    
    Nanoseconds elapsedNano = AbsoluteToNanoseconds(*(AbsoluteTime *)&elapsed);
    return *(uint64_t *)&elapsedNano;
}

@end
