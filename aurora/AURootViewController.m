//
//  AURootViewController.m
//  Aurora
//
//  Created by Jason Dreisbach on 5/22/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AURootViewController.h"
#import "AUSpotifyViewController.h"
#import "AUEffectTestViewController.h"

@interface AURootViewController ()

@end

@implementation AURootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.au_view.customBackgroundColor = [NSColor greenColor];
}

- (IBAction)showMyPlaylists:(id)sender
{
    
}

- (IBAction)showSpotifyViewController:(id)sender
{
    AUSpotifyViewController *spotifyViewController = [[AUSpotifyViewController alloc] initWithNibName:@"AUSpotifyView" bundle:nil];
//    spotifyViewController.view.frame = self.view.bounds;
//    vc.au_view.customBackgroundColor = [NSColor blueColor];
    [self pushViewController:spotifyViewController animated:YES];
}


@end
