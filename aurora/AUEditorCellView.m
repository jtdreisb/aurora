//
//  AUEditorCellView.m
//  Aurora
//
//  Created by Jason Dreisbach on 5/4/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AUEditorCellView.h"
#import "AULightCellView.h"
#import "AUTimelineView.h"
#import "AULinkedScrollView.h"
@implementation AUEditorCellView
{
    IBOutlet AULightCellView *_lightCellView;
    IBOutlet AULinkedScrollView *_timelineScrollView;
}

- (void)setObjectValue:(id)objectValue
{
    [super setObjectValue:objectValue];
    
//    AUTimelineView *timelineView = [[AUTimelineView alloc] initWithFrame:self.bounds];
//    timelineView.effectTimeline = objectValue[@"channel"];
}

@end
