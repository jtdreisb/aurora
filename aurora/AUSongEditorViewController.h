//
//  AUPerformanceEditViewController.h
//  Aurora
//
//  Created by Jason Dreisbach on 3/7/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include <CocoaLibSpotify/CocoaLibSpotify.h>

@interface AUSongEditorViewController : NSViewController <NSTableViewDataSource>

@property (strong) SPTrack *track;

@end
