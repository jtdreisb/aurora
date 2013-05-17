//
//  AUPerformanceEditViewController.m
//  Aurora
//
//  Created by Jason Dreisbach on 3/7/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AUSongEditorViewController.h"
#import "AUPlaybackCoordinator.h"

@interface AUSongEditorViewController ()
{
    IBOutlet NSArrayController *_timelineArrayController;
    IBOutlet NSArrayController *_lightArrayController;
}
@end

@implementation AUSongEditorViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) {
        [[AUPlaybackCoordinator sharedInstance] addObserver:self forKeyPath:@"currentTrack" options:0 context:nil];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)dealloc
{
    [[AUPlaybackCoordinator sharedInstance] removeObserver:self forKeyPath:@"currentTrack"];
}

#pragma mark - BFViewController Additions
/**
 *  Notifies the view controller that its view is about to be added to a view hierarchy.
 */
- (void)viewWillAppear: (BOOL)animated
{

}

- (IBAction)addRemoveLight:(id)sender
{
    if ([sender isKindOfClass:[NSSegmentedControl class]]) {
        NSSegmentedControl *segmentedControl = sender;
        
        // Add
        if (segmentedControl.selectedSegment == 0) {
//            SPTrack
            NSMutableDictionary *timelineDict = [NSMutableDictionary dictionary];
            timelineDict[@"index"] = @([_timelineArrayController.arrangedObjects count]);
            [_timelineArrayController addObject:timelineDict];
        }
        // Remove
        else {
            [_timelineArrayController removeObjects:_timelineArrayController.selectedObjects];
            for (NSMutableDictionary *timelineDict in _timelineArrayController.arrangedObjects) {
                timelineDict[@"index"] = @([_timelineArrayController.arrangedObjects indexOfObject:timelineDict]);
            }
        }
    }
}

/**
 *  Notifies the view controller that its view was added to a view hierarchy.
 */
- (void)viewDidAppear: (BOOL)animated;
{
    
}

/**
 *  Notifies the view controller that its view is about to be removed from a view hierarchy.
 */
- (void)viewWillDisappear: (BOOL)animated;
{
    
}

/**
 *  Notifies the view controller that its view was removed from a view hierarchy.
 */
- (void)viewDidDisappear: (BOOL)animated;
{
    
}

- (IBAction)goBack:(id)sender
{
    // save the state
    [self popViewControllerAnimated:YES];
}


@end
