//
//  AUTimelineCellView.m
//  Aurora
//
//  Created by Jason Dreisbach on 5/4/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AUChannelView.h"
#import "NSView+AUAdditions.h"
#import "AUTimeline.h"
#import "AUTimelineChannel.h"

@implementation AUChannelView

- (id)initWithFrame:(NSRect)frameRect channel:(AUTimelineChannel *)channel
{
    self = [super initWithFrame:frameRect];
    if (self != nil) {
        _channel = channel;
        [_channel.timeline addObserver:self forKeyPath:@"zoomLevel" options:0 context:NULL];
    }
    return self;
}

- (void)dealloc
{
    [_channel.timeline removeObserver:self forKeyPath:@"zoomLevel"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.channel.timeline && [keyPath isEqualToString:@"zoomLevel"]) {
        [self calculateFrame];
    }
}

- (void)calculateFrame
{
    AUTimeline *timeline = self.channel.timeline;
    CGFloat width = timeline.duration * timeline.zoomLevel;
    [self setFrame:NSMakeRect(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height)];
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect
{
    NSRect drawingRect = [self bounds];
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
    
    CGContextSaveGState(context);
    
    CGContextSetAlpha(context, 0.9);
    
    NSRect clippingRect = drawingRect;
    clippingRect.size.height -= 1;
    
    CGPathRef clippingPath = [NSView clippingPathWithRect:drawingRect andRadius:0.0];
    CGContextAddPath(context, clippingPath);
    CGContextClip(context);
    CGPathRelease(clippingPath);
    
        NSColor *startColor = [NSColor colorWithDeviceWhite:0.4 alpha:1.0];
        NSColor *endColor = [NSColor colorWithDeviceWhite:0.55 alpha:1.0];
    CGGradientRef gradient = [NSView gradientFromColor:startColor toColor:endColor];
    
    CGContextDrawLinearGradient(context, gradient, CGPointMake(NSMinX(drawingRect), NSMidY(drawingRect)),
                                CGPointMake(NSMaxX(drawingRect), NSMidY(drawingRect)), 0);
    CGGradientRelease(gradient);
    
    
    
    CGRect noiseRect = NSInsetRect(drawingRect, 1.0, 1.0);
    
    CGPathRef noiseClippingPath = [NSView clippingPathWithRect:noiseRect andRadius:0.0];
    CGContextAddPath(context, noiseClippingPath);
    CGContextClip(context);
    CGPathRelease(noiseClippingPath);
    
    [self drawNoiseWithOpacity:0.01];
    
    CGContextRestoreGState(context);
}

@end
