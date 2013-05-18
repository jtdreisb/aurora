//
//  AUEffectTimeline.h
//  Aurora
//
//  Created by Jason Dreisbach on 5/4/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AUTimelineChannel;
@class AUEffect;

@interface AUTimeline : NSObject <NSCoding>

- (id)initWithContentsOfPath:(NSString *)filePath;
- (void)writeToFile:(NSString *)filePath;

@property (readonly) NSArray *channels;

- (void)addNewChannel;
- (void)removeChannel:(AUTimelineChannel *)channelToRemove;

@end
