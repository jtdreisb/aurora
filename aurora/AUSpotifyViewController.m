//
//  AUSpotifyViewController.m
//  Aurora
//
//  Created by Jason Dreisbach on 2/6/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AUSpotifyViewController.h"
#import "AUSongEditorViewController.h"

@interface AUSpotifyViewController ()
{
    IBOutlet NSTableView *_playlistTableView;
    IBOutlet NSArrayController *_playlistArrayController;
    IBOutlet NSTableView *_trackTableView;
    IBOutlet NSArrayController *_trackArrayController;
}
@end

@implementation AUSpotifyViewController

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
                NSArray *tracks = [self tracksFromPlaylistItems:playlist.items];
                [SPAsyncLoading waitUntilLoaded:tracks timeout:kSPAsyncLoadingDefaultTimeout then:^(NSArray *loadedTracks, NSArray *notLoadedTracks) {
                    NSLog(@"Playlist %@ has %ld tracks", playlist, [tracks count]);
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
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [tableView reloadData];
        });
        
    }
}

#pragma mark - BFViewController additions

- (void)viewWillAppear: (BOOL)animated
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        self.playbackManager = [[SPPlaybackManager alloc] initWithPlaybackSession:[SPSession sharedSession]];
        self.playbackManager.delegate = self;
        
        [SPAsyncLoading waitUntilLoaded:[SPSession sharedSession] timeout:kSPAsyncLoadingDefaultTimeout then:^(NSArray *loadedItems, NSArray *notLoadedItems) {
            NSLog(@"%@", [SPSession sharedSession].userPlaylists);
            
            [SPAsyncLoading waitUntilLoaded:[SPSession sharedSession].userPlaylists timeout:kSPAsyncLoadingDefaultTimeout then:^(NSArray *loadedContainers, NSArray *notLoadedContainers) {
                
                NSMutableArray *playlists = [NSMutableArray array];
                [playlists addObjectsFromArray:[SPSession sharedSession].userPlaylists.flattenedPlaylists];
                NSLog(@"Loaded %ld playlists", [playlists count]);
                [_playlistArrayController setContent:playlists];
                [self tableView:_playlistTableView shouldSelectRow:0];
                
            }];
        }];
    });
}

- (void)editSong:(id)sender
{
    NSLog(@"%@", sender);
    
    AUSongEditorViewController *songEditorViewController = [[AUSongEditorViewController alloc] initWithNibName:@"AUSongEditorView" bundle:nil];
    songEditorViewController.track = [sender lastObject];
    [self pushViewController:songEditorViewController animated:YES];
}


- (IBAction)nextSong:(id)sender
{
    
}

- (IBAction)lastSong:(id)sender
{
    
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

- (void)startPlaybackOfTrack:(SPTrack *)aTrack {
    
    [SPAsyncLoading waitUntilLoaded:aTrack timeout:5.0 then:^(NSArray *loadedItems, NSArray *notLoadedItems) {
        [self.playbackManager playTrack:aTrack callback:^(NSError *error) {
            if (error) [self.view.window presentError:error];
        }];
    }];
}

- (void)playbackManagerWillStartPlayingAudio:(SPPlaybackManager *)aPlaybackManager
{
    
    
    
    
}


@end
