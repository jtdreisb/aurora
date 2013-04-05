//
//  AULightColorView.m
//  Aurora
//
//  Created by Jason Dreisbach on 3/29/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AULightColorView.h"

@implementation AULightColorView


- (void)drawRect:(NSRect)dirtyRect
{
    NSRect circleRect = NSInsetRect(self.bounds, 2.0, 2.0);
    NSBezierPath *path = [NSBezierPath bezierPathWithOvalInRect:circleRect];
    [path setLineWidth:2.0];
    _strokeColor ? [_strokeColor setStroke] : [[NSColor darkGrayColor] setStroke];
    [path stroke];
    
    _color ? [_color setFill] : [[NSColor clearColor] setFill];
    [path fill];
}

@end
