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

@implementation AUSpotifyViewController {
    SMKSpotifyContentSource *_source;
    SMKSpotifyPlayer *_audioPlayer;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil contentSource:(SMKSpotifyContentSource *)source
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) {
        self.view.layer.backgroundColor = [[NSColor colorWithPatternImage:[NSImage imageNamed:@"AULinenDark"]] CGColor];
        
        _source = source;
        _audioPlayer = [[SMKSpotifyPlayer alloc] initWithPlaybackSession:_source];
        _audioPlayer.volume = 0.5f;
        [_audioPlayer setFinishedTrackBlock:^(id<SMKPlayer> player, id<SMKTrack> track, NSError *error) {
            NSLog(@"Player %@ finished track %@ with error %@", player, track, error);
        }];
    }
    return self;
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

#pragma mark - SPSessionDelegate
-(void)sessionDidLoginSuccessfully:(SPSession *)aSession
{
    NSLog(@"Successful login.");
}

- (void)session:(SPSession *)aSession didFailToLoginWithError:(NSError *)error
{
    NSLog(@"Failed login: %@ %@", error, [error userInfo]);
}

@end
