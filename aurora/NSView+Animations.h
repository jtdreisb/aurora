//
//  NSView+Animations.h
//  aurora
//
//  Created by Jason Dreisbach on 2/6/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSView (Animations)

- (void)addSubview:(NSView *)aView animated:(BOOL)animated;
- (void)removeFromSuperviewAnimated:(BOOL)animated;

@end
