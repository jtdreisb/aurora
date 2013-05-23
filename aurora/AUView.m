//
//  AUView.m
//  Aurora
//
//  Created by Jason Dreisbach on 5/4/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AUView.h"
#import "NSView+AUAdditions.h"

@implementation AUView

- (void)awakeFromNib
{
    NSImage *patternImage = [NSImage imageNamed:self.backgroundPatternImageName];
    if (patternImage != nil) {
        self.customBackgroundColor = [NSColor colorWithPatternImage:patternImage];
    }
    else {
        self.customBackgroundColor = [NSColor whiteColor];
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
