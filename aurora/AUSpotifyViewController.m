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
        self.view.layer.sublayerTransform = CATransform3DMakeScale(1.0f, -1.0f, 1.0f);

    }
    return self;
}


#pragma mark - BFViewController additions

- (void)viewWillAppear: (BOOL)animated
{
    
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


@end
