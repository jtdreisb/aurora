//
//  AUSpotifyViewController.m
//  Aurora
//
//  Created by Jason Dreisbach on 2/6/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AUSpotifyViewController.h"
#import "Spotify.h"
#import "AUDraggableView.h"
#import <DPHue/DPHueBridge.h>
#import <DPHue/DPHueLight.h>

@interface AUSpotifyViewController ()
@property (nonatomic, strong) SpotifyApplication *spotifyApp;
@property (nonatomic, strong) NSArray *lightImageViews;
@end

@implementation AUSpotifyViewController


- (void)update:(NSTimer *)timer
{
    self.albumImageView.image =  self.spotifyApp.currentTrack.artwork;
    self.trackNameLabel.stringValue = self.spotifyApp.currentTrack.name;
    self.artistNameLabel.stringValue = self.spotifyApp.currentTrack.artist;
    
    if (self.spotifyApp.currentTrack.artwork == nil) {
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(update:) userInfo:nil repeats:NO];
    }
    else {
        for (AUDraggableView *view in self.lightImageViews) {
            DPHueLight *light = (DPHueLight *)view.representedObject;
            
            NSPoint location = view.frame.origin ;//[self.view convertPointToBase:view.frame.origin];
            location.y = self.view.frame.size.height - view.frame.origin.y;
            // Grab the display for said mouse location.
            uint32_t count = 0;
            CGDirectDisplayID displayForPoint;
            if (CGGetDisplaysWithPoint(NSPointToCGPoint(location), 1, &displayForPoint, &count) != kCGErrorSuccess)
            {
                NSLog(@"Oops.");
            }
            
            // Grab the color on said display at location.
            CGImageRef image = CGDisplayCreateImageForRect(displayForPoint, CGRectMake(location.x, location.y, 1, 1));
            NSBitmapImageRep* bitmap = [[NSBitmapImageRep alloc] initWithCGImage:image];
            CGImageRelease(image);
            NSColor *pixelColor = [bitmap colorAtX:0 y:0];
            
            light.hue = [NSNumber numberWithDouble:[pixelColor hueComponent] * 65535];
            light.saturation = [NSNumber numberWithDouble:[pixelColor saturationComponent] * 255];
            light.brightness = [NSNumber numberWithDouble:[pixelColor brightnessComponent] * 255];
            
            [light write];
        }
    }
    
    if (self.spotifyApp.playerState == SpotifyEPlSPlaying) {
//        self.
    }
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        self.view.layer.backgroundColor = [[NSColor colorWithPatternImage:[NSImage imageNamed:@"AULinenDark"]] CGColor];
        //[[NSColor blackColor] CGColor];
        self.spotifyApp = [SBApplication applicationWithBundleIdentifier:@"com.spotify.client"];
        if (self.spotifyApp.isRunning == NO) {
            NSLog(@"Spotify must be running");
        }
        
//        NSMutableArray *lights = [NSMutableArray array];
//        for (DPHueLight *light in self.lightsArrayController.arrangedObjects) {
//            NSArray *topLevelObject = nil;
//            [[NSBundle mainBundle] loadNibNamed:@"AUDraggableLight" owner:nil topLevelObjects:&topLevelObject];
//            
//            AUDraggableView *draggableView = nil;
//            for (NSObject *object in topLevelObject) {
//                if ([object isKindOfClass:[AUDraggableView class]]) {
//                    draggableView = (AUDraggableView *)object;
//                    draggableView.representedObject = light;
//                    draggableView.label.stringValue = light.name;
//                    [self.view addSubview:draggableView];
//                    [lights addObject:draggableView];
//                }
//            }
//        }
//        self.lightImageViews = lights;
        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lightDidMove:) name:DraggableImageDidDragNotification object:nil];
        [self update:nil];
    }
    return self;
}


- (void)lightDidMove:(NSNotification *)notification
{
    [self update:nil];
}

- (IBAction)exit:(id)sender
{
    [self.lightImageViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.lightImageViews = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DraggableImageDidDragNotification object:nil];
    [self.view exitFullScreenModeWithOptions:nil];

}

- (IBAction)playPause:(id)sender
{
    if (self.spotifyApp) {
        if (self.spotifyApp.playerState == SpotifyEPlSPlaying) {
            [self.spotifyApp pause];
        }
        else {
            [self.spotifyApp play];
        }
        [self update:nil];
    }
}

- (IBAction)nextSong:(id)sender
{
    [self.spotifyApp nextTrack];
    [self update:nil];
}

- (IBAction)lastSong:(id)sender
{
    [self.spotifyApp previousTrack];
    [self update:nil];
}

@end
