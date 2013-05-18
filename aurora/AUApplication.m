//
//  AUApplication.m
//  Aurora
//
//  Created by Jason Dreisbach on 5/17/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AUApplication.h"
#import "AUAppDelegate.h"
#import "SPMediaKeyTap.h"

@implementation AUApplication
{
    SPMediaKeyTap *keyTap;
}

+ (void)initialize;
{
	if([self class] != [AUApplication class]) return;
	
	// Register defaults for the whitelist of apps that want to use media keys
	[[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
                                                             [SPMediaKeyTap defaultMediaKeyUserBundleIdentifiers], kMediaKeyUsingBundleIdentifiersDefaultsKey,
                                                             nil]];
}

- (id)init
{
    self = [super init];
    if (self != nil) {
        keyTap = [[SPMediaKeyTap alloc] initWithDelegate:self];
        if([SPMediaKeyTap usesGlobalMediaKeyTap])
            [keyTap startWatchingMediaKeys];
    }
    return self;
}

- (void)sendEvent:(NSEvent *)theEvent
{
	// If event tap is not installed, handle events that reach the app instead
	BOOL shouldHandleMediaKeyEventLocally = ![SPMediaKeyTap usesGlobalMediaKeyTap];
    
	if(shouldHandleMediaKeyEventLocally && [theEvent type] == NSSystemDefined && [theEvent subtype] == SPSystemDefinedEventMediaKeys) {
		[self mediaKeyTap:nil receivedMediaKeyEvent:theEvent];
	}
	[super sendEvent:theEvent];
}

- (void)mediaKeyTap:(SPMediaKeyTap*)keyTap receivedMediaKeyEvent:(NSEvent*)event;
{
	assert([event type] == NSSystemDefined && [event subtype] == SPSystemDefinedEventMediaKeys);
    
	int keyCode = (([event data1] & 0xFFFF0000) >> 16);
	int keyFlags = ([event data1] & 0x0000FFFF);
	int keyState = (((keyFlags & 0xFF00) >> 8)) == 0xA;
	int keyRepeat = (keyFlags & 0x1);
    NSLog(@"isRepeat: %@", keyRepeat ? @"YES":@"NO");
    
	if (keyState == 1 && keyRepeat == 0) {
		switch (keyCode) {
			case NX_KEYTYPE_PLAY:
                [(AUAppDelegate *)[self delegate] playPause:self];
                break;
			case NX_KEYTYPE_FAST:
                [(AUAppDelegate *)[self delegate] nextTrack:self];
                break;
			case NX_KEYTYPE_REWIND:
                [(AUAppDelegate *)[self delegate] previousTrack:self];
                break;
		}
	}
}

@end
