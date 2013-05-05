//
//  AUSpotifyViewController.h
//  Aurora
//
//  Created by Jason Dreisbach on 2/6/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CocoaLibSpotify/CocoaLibSpotify.h>

@interface AUSpotifyViewController : NSViewController <NSTableViewDelegate, SPSessionDelegate, SPPlaybackManagerDelegate>

- (void)editSong:(id)sender;


@end
