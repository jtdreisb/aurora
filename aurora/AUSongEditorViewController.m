//
//  AUPerformanceEditViewController.m
//  Aurora
//
//  Created by Jason Dreisbach on 3/7/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AUSongEditorViewController.h"
#import "AUPlaybackCoordinator.h"
#import "SPTrack+AUAdditions.h"
#import "AUTimeline.h"
#import "AUTimelineChannel.h"
#import <DPHue.h>
#import "AUDummyLight.h"

@implementation AUSongEditorViewController
{
    IBOutlet NSTableView *_tableView;
    NSArray *_lights;
    NSInteger _maxLightNumber;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) {
        [[AUPlaybackCoordinator sharedInstance] addObserver:self forKeyPath:@"currentTrack" options:0 context:NULL];
        [[DPHue sharedInstance] addObserver:self forKeyPath:@"lights" options:0 context:NULL];
    }
    return self;
}

- (void)dealloc
{
    [[AUPlaybackCoordinator sharedInstance] removeObserver:self forKeyPath:@"currentTrack"];
    [[DPHue sharedInstance] removeObserver:self forKeyPath:@"lights"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == [AUPlaybackCoordinator sharedInstance] && [keyPath isEqualToString:@"currentTrack"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self == self.navigationController.visibleViewController) {
                [self popViewControllerAnimated:YES];
                [self pushViewController:self animated:YES];
            }
        });
        
    }
    else if (object == [DPHue sharedInstance] && [keyPath isEqualToString:@"lights"]) {
        [self getLights];
    }
}

- (void)getLights
{

    if ([[DPHue sharedInstance] isSearching]) {
        [self performSelector:_cmd withObject:nil afterDelay:1.0];
        return;
    }
    _lights = [[DPHue sharedInstance] lights];
    _maxLightNumber = -1;
    for (DPHueLight *light in _lights) {
        if ([light.number integerValue] > _maxLightNumber) {
            _maxLightNumber = [light.number integerValue];
        }
    }
    
    NSMutableArray *lightArray = [NSMutableArray array];
    
    for (DPHueLight *light in _lights) {
        for (NSInteger i = lightArray.count; i < ([light.number integerValue] - 1); i++) {
            AUDummyLight *dummyLight = [[AUDummyLight alloc] init];
            dummyLight.name = [NSString stringWithFormat:@"Dummy %ld", i];
            [lightArray addObject:dummyLight];
        }
        [lightArray addObject:light];
    }
    _lights = lightArray;
    
    NSInteger newChannelCount = (_maxLightNumber) - [self.timeline.channels count];
    for (int i = 0; i < newChannelCount; i++) {
        [self.timeline addChannel:[[AUTimelineChannel alloc] init]];
    }
    [_tableView reloadData];
}

- (AUTimeline *)timeline
{
    return [[[AUPlaybackCoordinator sharedInstance] currentTrack] timeline];
}

#pragma mark - Actions

- (IBAction)back:(id)sender
{
    [[[AUPlaybackCoordinator sharedInstance] currentTrack] saveTimeline];
    [super back:sender];
}

- (IBAction)addRemoveLight:(id)sender
{
    if ([sender isKindOfClass:[NSSegmentedControl class]]) {
        NSSegmentedControl *segmentedControl = sender;
        
        // Add
        if (segmentedControl.selectedSegment == 0) {
            AUTimelineChannel *channel = [[AUTimelineChannel alloc] init];
            _lights = [_lights arrayByAddingObject:[[AUDummyLight alloc] init]];
            [self.timeline addChannel:channel];
            [_tableView reloadData];
        }
        // Remove
        else {
            // whats the right thing to do here?
//            NSArray *selectedObjects = 
//            [self.timeline removeObjects:self.timeline.channelArrayController.selectedObjects];
        }
    }
}

#pragma mark - BFViewController Additions

- (void)viewWillAppear:(BOOL)animated
{
    [self timeline];
    [self getLights];
}


#pragma mark - NSTableViewDelegate
// TODO: dragging support

#pragma mark - NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView;
{
    return self.timeline.channels.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;
{
    if ([tableColumn.identifier isEqualToString:@"lights"]) {
        return [_lights objectAtIndex:row];
    }
    else if ([tableColumn.identifier isEqualToString:@"channels"]) {
        return [self.timeline.channels objectAtIndex:row];
    }
    return nil;
}

@end
