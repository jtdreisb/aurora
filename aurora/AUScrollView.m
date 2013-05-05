//
//  AUScrollView.m
//  Aurora
//
//  Created by Jason Dreisbach on 5/4/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AUScrollView.h"
#import "NSView+AUAdditions.h"

@implementation AUScrollView

- (void)awakeFromNib
{
    NSImage *patternImage = [NSImage imageNamed:self.backgroundPatternImageName];
    if (patternImage != nil) {
        self.drawsBackground = NO;
        self.customBackgroundColor = [NSColor colorWithPatternImage:patternImage];
    }
}

- (void)drawRect:(NSRect)dirtyRect
{
    NSGraphicsContext* theContext = [NSGraphicsContext currentContext];
    [theContext saveGraphicsState];
    [[NSGraphicsContext currentContext] setPatternPhase:NSMakePoint(0,[self frame].size.height)];
    [self.customBackgroundColor set];
    NSRectFill([self bounds]);
    [theContext restoreGraphicsState];
    [super drawRect:dirtyRect];
}


@end
