//
//  AUPerformanceEditViewController.m
//  Aurora
//
//  Created by Jason Dreisbach on 3/7/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AUSongEditorViewController.h"

@interface AUSongEditorViewController ()
{
    IBOutlet NSArrayController *_timelineArrayController;
    IBOutlet NSScrollView *_scrollView;
}

@end

@implementation AUSongEditorViewController

#pragma mark - BFViewController Additions
/**
 *  Notifies the view controller that its view is about to be added to a view hierarchy.
 */
- (void)viewWillAppear: (BOOL)animated
{

    NSMutableDictionary *timelineDict = @{@"index": @88};
    [_timelineArrayController addObject:timelineDict];
    timelineDict = [timelineDict mutableCopy];
    timelineDict[@"index"] = @2;
    [_timelineArrayController addObject:timelineDict];
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
    [self popViewControllerAnimated:YES];
}


@end
