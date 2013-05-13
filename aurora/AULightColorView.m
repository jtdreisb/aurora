//
//  AULightColorView.m
//  Aurora
//
//  Created by Jason Dreisbach on 3/29/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AULightColorView.h"

@implementation AULightColorView

- (id)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self != nil) {
        [self addObserver:self forKeyPath:@"color" options:0 context:nil];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self addObserver:self forKeyPath:@"color" options:0 context:nil];
    }
    return self;
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"color"];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self setNeedsDisplay:YES];
}


- (void)drawRect:(NSRect)dirtyRect
{
    NSRect insetRect = NSInsetRect(self.bounds, 2.0, 2.0);
    NSBezierPath *path = [NSBezierPath bezierPathWithRect:insetRect];
    [path setLineWidth:1.0];
    _strokeColor ? [_strokeColor setStroke] : [[NSColor darkGrayColor] setStroke];
    [path stroke];
    
    _color ? [_color setFill] : [[NSColor clearColor] setFill];
    [path fill];
}

@end
