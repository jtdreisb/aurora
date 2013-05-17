//
//  SPPlaylist+AUAdditions.m
//  Aurora
//
//  Created by Jason Dreisbach on 5/16/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "SPPlaylist+AUAdditions.h"

@implementation SPPlaylist (AUAdditions)

+ (NSSet *)keyPathsForValuesAffectingTracks
{
    return [NSSet setWithArray:@[@"items"]];
}

- (NSArray *)tracks
{
	NSMutableArray *tracks = [NSMutableArray arrayWithCapacity:self.items.count];
	
	for (SPPlaylistItem *anItem in self.items) {
		if (anItem.itemClass == [SPTrack class]) {
			[tracks addObject:anItem.item];
		}
	}
	
	return [NSArray arrayWithArray:tracks];
}

@end
