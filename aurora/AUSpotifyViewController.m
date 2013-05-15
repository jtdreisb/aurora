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

@interface AUSpotifyViewController ()
{
    IBOutlet NSTableView *_playlistTableView;
    IBOutlet NSArrayController *_playlistArrayController;
    IBOutlet NSTableView *_trackTableView;
    IBOutlet NSArrayController *_trackArrayController;
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
            NSLog(@"%@", playlist);
            [SPAsyncLoading waitUntilLoaded:playlist timeout:kSPAsyncLoadingDefaultTimeout then:^(NSArray *loadedPlaylist, NSArray *notLoadedPlaylist) {
                NSArray *tracks = [self tracksFromPlaylistItems:playlist.items];
                [SPAsyncLoading waitUntilLoaded:tracks timeout:kSPAsyncLoadingDefaultTimeout then:^(NSArray *loadedTracks, NSArray *notLoadedTracks) {
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

- (void)viewWillAppear: (BOOL)animated
{
    [self willChangeValueForKey:@"spotifySession"];
    
    [SPAsyncLoading waitUntilLoaded:self.spotifySession timeout:kSPAsyncLoadingDefaultTimeout then:^(NSArray *loadedItems, NSArray *notLoadedItems) {
        
        [SPAsyncLoading waitUntilLoaded:self.spotifySession.userPlaylists timeout:kSPAsyncLoadingDefaultTimeout then:^(NSArray *loadedPlaylists, NSArray *notLoadedPlaylists) {
        
            [self tableView:_playlistTableView shouldSelectRow:0];
        }];
    }];
    [self didChangeValueForKey:@"spotifySession"];
    
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        [SPAsyncLoading waitUntilLoaded:[SPSession sharedSession] timeout:kSPAsyncLoadingDefaultTimeout then:^(NSArray *loadedItems, NSArray *notLoadedItems) {
//            [SPAsyncLoading waitUntilLoaded:[SPSession sharedSession].userPlaylists timeout:kSPAsyncLoadingDefaultTimeout then:^(NSArray *loadedContainers, NSArray *notLoadedContainers) {
//                NSLog(@"%@", loadedContainers);
//                NSMutableArray *playlists = [NSMutableArray array];
//                [playlists addObjectsFromArray:[SPSession sharedSession].userPlaylists.flattenedPlaylists];
//
//                [_playlistArrayController setContent:playlists];
//                [self tableView:_playlistTableView shouldSelectRow:0];
//            }];
//        }];
//    });
}

- (void)editSong:(id)sender
{
    AUPlaybackCoordinator *playbackCoordinator = [AUPlaybackCoordinator sharedInstance];
    
    [playbackCoordinator playTrack:(SPTrack *)[sender lastObject] callback:^(NSError *error) {
        if (error != nil)
            NSLog(@"%s: %@", __PRETTY_FUNCTION__, error);
        else {
            NSLog(@"playback did end");
        }
    }];
    
    AUSongEditorViewController *songEditorViewController = [[AUSongEditorViewController alloc] initWithNibName:@"AUSongEditorView" bundle:nil];
    songEditorViewController.track = [sender lastObject];
    [self pushViewController:songEditorViewController animated:YES];
}

- (NSArray *)tracksFromPlaylistItems:(NSArray *)items {
	
	NSMutableArray *tracks = [NSMutableArray arrayWithCapacity:items.count];
	
	for (SPPlaylistItem *anItem in items) {
		if (anItem.itemClass == [SPTrack class]) {
			[tracks addObject:anItem.item];
		}
	}
	
	return [NSArray arrayWithArray:tracks];
}


#pragma mark -
#pragma mark Playback

- (void)playbackManagerWillStartPlayingAudio:(SPPlaybackManager *)aPlaybackManager
{
    
    
    
    
}


@end
