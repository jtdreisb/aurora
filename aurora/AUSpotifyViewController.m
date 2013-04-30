//
//  AUSpotifyViewController.m
//  Aurora
//
//  Created by Jason Dreisbach on 2/6/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AUSpotifyViewController.h"
#import <DPHue/DPHueBridge.h>
#import <DPHue/DPHueLight.h>

@interface AUSpotifyViewController ()
@end

@implementation AUSpotifyViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        self.view.layer.backgroundColor = [[NSColor colorWithPatternImage:[NSImage imageNamed:@"AULinenDark"]] CGColor];
//        self.view.layer.sublayerTransform = CATransform3DMakeScale(1.0f, -1.0f, 1.0f);
        
    }
    return self;
}


#pragma mark - BFViewController additions

- (void)viewWillAppear: (BOOL)animated
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        self.playbackManager = [[SPPlaybackManager alloc] initWithPlaybackSession:[SPSession sharedSession]];
        self.playbackManager.delegate = self;
        
        [SPAsyncLoading waitUntilLoaded:[SPSession sharedSession] timeout:kSPAsyncLoadingDefaultTimeout then:^(NSArray *loadedItems, NSArray *notLoadedItems) {
            
            [SPAsyncLoading waitUntilLoaded:[SPSession sharedSession].userPlaylists timeout:kSPAsyncLoadingDefaultTimeout then:^(NSArray *loadedContainers, NSArray *notLoadedContainers) {
                
                NSMutableArray *playlists = [NSMutableArray array];
                [playlists addObject:[SPSession sharedSession].starredPlaylist];
                [playlists addObject:[SPSession sharedSession].inboxPlaylist];
                [playlists addObjectsFromArray:[SPSession sharedSession].userPlaylists.flattenedPlaylists];
                
                [SPAsyncLoading waitUntilLoaded:playlists timeout:kSPAsyncLoadingDefaultTimeout then:^(NSArray *loadedPlaylists, NSArray *notLoadedPlaylists) {
                    [self.playlistArrayController setContent:loadedPlaylists];
                    SPPlaylist *playlist = [loadedPlaylists lastObject];
                    
                    NSArray *tracks = [self tracksFromPlaylistItems:playlist.items];
                    [self startPlaybackOfTrack:[tracks objectAtIndex:0]];

                }];
                
            }];
        }];
    });
}

- (void)viewDidAppear: (BOOL)animated
{
    //    NSLog(@"%@ - viewDidAppear: %i", self, animated);
}

- (void)viewWillDisappear: (BOOL)animated
{
    //    NSLog(@"%@ - viewWillDisappear: %i", self, animated);
}

- (void)viewDidDisappear: (BOOL)animated
{
    //    NSLog(@"%@ - viewDidDisappear: %i", self, animated);
}

- (IBAction)playPause:(id)sender
{
    
}

- (IBAction)nextSong:(id)sender
{
    
}

- (IBAction)lastSong:(id)sender
{
    
}

-(NSArray *)tracksFromPlaylistItems:(NSArray *)items {
	
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
