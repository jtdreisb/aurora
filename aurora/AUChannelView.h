//
//  AUTimelineCellView.h
//  Aurora
//
//  Created by Jason Dreisbach on 5/4/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class AUTimelineChannel;

@interface AUChannelView : NSView

- (id)initWithFrame:(NSRect)frameRect channel:(AUTimelineChannel *)channel;

@property (strong) AUTimelineChannel *channel;

@end
