//
//  Stopwatch.h
//  BreakReminder
//
//  Created by Cecilia Zhang on 3/30/13.
//  Copyright (c) 2013 Cecilia Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Stopwatch : NSObject {
    uint64_t startTime;  ///< Absolute time of last call to \c reset

}



/// \brief Get time interval in seconds


-(void) reset;
- (NSTimeInterval)elapsedTimeInterval;

@end
