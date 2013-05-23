//
//  AUSpotifyViewController.m
//  Aurora
//
//  Created by Jason Dreisbach on 2/6/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AUSpotifyViewController.h"
#import "AUSongEditorViewController.h"
#import "AUPlaybackCoordinator.h"
#import "SPPlaylist+AUAdditions.m"
#import <CocoaLibSpotify/CocoaLibSpotify.h>
#import "SPTrack+AUAdditions.h"

@interface AUSpotifyViewController ()
{
    IBOutlet NSTableView *_playlistTableView;
    IBOutlet NSArrayController *_playlistArrayController;
    IBOutlet NSTableView *_trackTableView;
    IBOutlet NSArrayController *_trackArrayController;
    AUSongEditorViewController *_songEditorViewController; 
}
@end

@implementation AUSpotifyViewController

- (SPSession *)spotifySession
{
    return [SPSession sharedSession];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        self.view.layer.backgroundColor = [[NSColor colorWithPatternImage:[NSImage imageNamed:@"AULinenDark"]] CGColor];
    }
    return self;
}

#pragma mark - NSTableViewDelegate

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row
{
    if (tableView == _playlistTableView) {
        if ([_playlistArrayController.arrangedObjects count] > 0) {
            SPPlaylist *playlist = [_playlistArrayController.arrangedObjects objectAtIndex:row];
            [SPAsyncLoading waitUntilLoaded:playlist timeout:kSPAsyncLoadingDefaultTimeout then:^(NSArray *loadedPlaylist, NSArray *notLoadedPlaylist) {
                [SPAsyncLoading waitUntilLoaded:playlist.tracks timeout:kSPAsyncLoadingDefaultTimeout then:^(NSArray *loadedTracks, NSArray *notLoadedTracks) {
                    [_trackArrayController setContent:loadedTracks];
                    if ([notLoadedTracks count] > 0) {
                        NSLog(@"Unloaded tracks from playlist: %@", notLoadedTracks);
                    }
                }];
            }];
        }
    }
    return YES;
}

- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    if (tableView == _playlistTableView) {
        SPPlaylist *shownPlaylist = [_playlistArrayController.arrangedObjects objectAtIndex:row];
        [shownPlaylist startLoading];
    }
}

#pragma mark - BFViewController additions

- (void)viewWillAppear:(BOOL)animated
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [SPAsyncLoading waitUntilLoaded:self.spotifySession timeout:kSPAsyncLoadingDefaultTimeout then:^(NSArray *loadedItems, NSArray *notLoadedItems) {
            [SPAsyncLoading waitUntilLoaded:self.spotifySession.userPlaylists timeout:kSPAsyncLoadingDefaultTimeout then:^(NSArray *loadedPlaylists, NSArray *notLoadedPlaylists) {
                [self tableView:_playlistTableView shouldSelectRow:0];
                [_playlistTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
                double delayInSeconds = 0.1;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [self selectPlaylist:_playlistArrayController.selectedObjects];
                });
                
            }];
        }];
    });
}

- (void)selectPlaylist:(id)sender
{
    SPPlaylist *playlist = [sender lastObject];
    if (playlist != nil) {
        [[AUPlaybackCoordinator sharedInstance] setCurrentPlaylist:playlist];
    }
}

- (void)editSong:(id)sender
{
    AUPlaybackCoordinator *playbackCoordinator = [AUPlaybackCoordinator sharedInstance];
    playbackCoordinator.currentPlaylist = [_playlistArrayController.selectedObjects lastObject];
    [playbackCoordinator playTrack:[sender lastObject] callback:^(NSError *error) {
        playbackCoordinator.isPlaying = NO;
        if (error != nil) {
            NSLog(@"%s:playTrack:%@", __PRETTY_FUNCTION__, error);
        }
    }];
    if (_songEditorViewController == nil) {
        _songEditorViewController = [[AUSongEditorViewController alloc] initWithNibName:@"AUSongEditorView" bundle:nil];
    }
    [self pushViewController:_songEditorViewController animated:YES];
}

- (IBAction)backButton:(id)sender
{
    [self popViewControllerAnimated:YES];
}

@end
