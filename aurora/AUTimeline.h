//
//  AUEffectTimeline.h
//  Aurora
//
//  Created by Jason Dreisbach on 5/4/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AUTimelineChannel;

@interface AUTimeline : NSObject <NSCoding>

- (id)initWithContentsOfPath:(NSString *)filePath;
- (void)writeToFile:(NSString *)filePath;

- (NSArray *)channels;
- (void)addChannel:(AUTimelineChannel *)channel;
- (void)removeChannel:(AUTimelineChannel *)channel;

@end
