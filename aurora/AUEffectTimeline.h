//
//  AUEffectTimeline.h
//  Aurora
//
//  Created by Jason Dreisbach on 5/4/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AUEffect;

@interface AUEffectTimeline : NSObject

- (void)addEffect:(AUEffect *)effect atTime:(NSTimeInterval)trackPosition;

@end
