//
//  AUEditorCellView.m
//  Aurora
//
//  Created by Jason Dreisbach on 5/17/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AUEditorCellView.h"
#import "AULinkedScrollView.h"
#import "AUChannelView.h"
#import "AUTimelineChannel.h"

@implementation AUEditorCellView
{
    IBOutlet AULinkedScrollView *_scrollView;
}

- (void)setObjectValue:(id)objectValue
{
    if ([objectValue isKindOfClass:[AUTimelineChannel class]]) {
        AUChannelView *channelView = [[AUChannelView alloc] initWithFrame:NSMakeRect(0, 0, 1000, self.frame.size.height) channel:objectValue];
        _scrollView.documentView = channelView;
    }
}

@end
