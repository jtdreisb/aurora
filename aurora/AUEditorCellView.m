//
//  AUEditorCellView.m
//  Aurora
//
//  Created by Jason Dreisbach on 5/4/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AUEditorCellView.h"
#import "AULightCellView.h"
#import "AUTimelineCellView.h"

@implementation AUEditorCellView
{
    IBOutlet AULightCellView *_lightCellView;
    IBOutlet AUTimelineCellView *_timelineCellView;
}

- (void)setObjectValue:(id)objectValue
{
    NSLog(@"%@ %@", _lightCellView, _timelineCellView);
    [super setObjectValue:objectValue];
}

@end
