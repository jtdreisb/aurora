//
//  AUPerformanceEditViewController.h
//  Aurora
//
//  Created by Jason Dreisbach on 3/7/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AUViewController.h"

@class AUTimeline;

@interface AUSongEditorViewController : AUViewController <NSTableViewDelegate,NSTableViewDataSource>

@property (readonly) AUTimeline *timeline;

@end
