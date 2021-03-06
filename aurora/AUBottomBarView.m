//
//  AUBottomBarView.m
//  Aurora
//
//  Created by Jason Dreisbach on 5/22/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AUBottomBarView.h"
#import "NSView+AUAdditions.h"

#define IN_COLOR_MAIN_START_L [NSColor colorWithDeviceWhite:0.66 alpha:1.0]
#define IN_COLOR_MAIN_END_L [NSColor colorWithDeviceWhite:0.9 alpha:1.0]

#define IN_COLOR_MAIN_BOTTOM_L [NSColor colorWithDeviceWhite:0.608 alpha:1.0]

#define IN_COLOR_NOTMAIN_START_L [NSColor colorWithDeviceWhite:0.878 alpha:1.0]
#define IN_COLOR_NOTMAIN_END_L [NSColor colorWithDeviceWhite:0.976 alpha:1.0]
#define IN_COLOR_NOTMAIN_BOTTOM_L [NSColor colorWithDeviceWhite:0.855 alpha:1.0]

@implementation AUBottomBarView

- (id)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self != nil) {
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(_updateBottomBarView) name:NSApplicationDidBecomeActiveNotification object:nil];
        [nc addObserver:self selector:@selector(_updateBottomBarView) name:NSApplicationDidResignActiveNotification object:nil];
    }
    return self;
}

- (void)_updateBottomBarView
{
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect
{
    BOOL drawsAsMainWindow = ([self.window isMainWindow] && [[NSApplication sharedApplication] isActive]);
    
    NSRect drawingRect = [self bounds];
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
    
    CGContextSaveGState(context);
    
    NSRect clippingRect = drawingRect;
    clippingRect.size.height -= 1;
    
    CGPathRef clippingPath = [NSView clippingPathWithRect:drawingRect andRadius:0.0];
    CGContextAddPath(context, clippingPath);
    CGContextClip(context);
    CGPathRelease(clippingPath);
    
    NSColor *startColor = drawsAsMainWindow ? IN_COLOR_MAIN_START_L : IN_COLOR_NOTMAIN_START_L;
    NSColor *endColor = drawsAsMainWindow ? IN_COLOR_MAIN_END_L : IN_COLOR_NOTMAIN_END_L;
    
    CGGradientRef gradient = [NSView gradientFromColor:startColor toColor:endColor];
    CGContextDrawLinearGradient(context, gradient, CGPointMake(NSMidX(drawingRect), NSMinY(drawingRect)),
                                CGPointMake(NSMidX(drawingRect), NSMaxY(drawingRect)), 0);
    CGGradientRelease(gradient);
    
    NSColor *topColor = drawsAsMainWindow ? IN_COLOR_MAIN_BOTTOM_L : IN_COLOR_NOTMAIN_BOTTOM_L;
    
    NSRect topRect = NSMakeRect(0.0, NSMaxY(drawingRect)-1.0, NSWidth(drawingRect), 1.0);
    [topColor set];
    NSRectFill(topRect);
    
    topRect.origin.y -= 1.0;
    [[NSColor colorWithDeviceWhite:1.0 alpha:0.12] setFill];
    [[NSBezierPath bezierPathWithRect:topRect] fill];
    
    CGRect noiseRect = NSInsetRect(drawingRect, 1.0, 1.0);
    CGPathRef noiseClippingPath = [NSView clippingPathWithRect:noiseRect andRadius:0.0];
    CGContextAddPath(context, noiseClippingPath);
    CGContextClip(context);
    CGPathRelease(noiseClippingPath);
    
    [self drawNoiseWithOpacity:0.1];
    
    
    CGContextRestoreGState(context);
    
    [super drawRect:dirtyRect];
}

@end
