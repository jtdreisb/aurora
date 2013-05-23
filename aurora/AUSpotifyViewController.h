//
//  AUSpotifyViewController.h
//  Aurora
//
//  Created by Jason Dreisbach on 2/6/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AUViewController.h"
#import <CocoaLibSpotify/CocoaLibSpotify.h>

@interface AUSpotifyViewController : AUViewController <NSTableViewDelegate, SPSessionDelegate>

- (void)editSong:(id)sender;

- (SPSession *)spotifySession;

@end
