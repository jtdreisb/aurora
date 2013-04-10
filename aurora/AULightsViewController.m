//
//  AULightsViewController.m
//  aurora
//
//  Created by Jason Dreisbach on 2/6/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AULightsViewController.h"
#import <DPHue/DPHueLight.h>
#import "AULightEditViewController.h"
#import "AUSpotifyViewController.h"

@interface AULightsViewController ()

@end

@implementation AULightsViewController

#pragma mark - NSTableViewDelegate

- (void)awakeFromNib
{
    self.view.layer.backgroundColor = [[NSColor darkGrayColor] CGColor];
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
    if (self.tableView.selectedRow != -1) {
        DPHueLight *hueLight = [self.lightArrayController.arrangedObjects objectAtIndex:self.tableView.selectedRow];
        self.lightEditViewController.light = hueLight;
        self.lightEditViewController.view.frame = self.view.frame;
        [self.view.superview addSubview:self.lightEditViewController.view];
        [self.view removeFromSuperview];
    }
}

- (IBAction)launchSpotify:(id)sender
{
    [self.spotifyViewController showView];
}

@end
