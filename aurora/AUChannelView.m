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
#import "AUEffect.h"
#import "AUEffectView.h"

@implementation AUChannelView

- (id)initWithFrame:(NSRect)frameRect channel:(AUTimelineChannel *)channel
{
    self = [super initWithFrame:frameRect];
    if (self != nil) {
        _channel = channel;
        [_channel.timeline addObserver:self forKeyPath:@"zoomLevel" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
        [_channel addObserver:self forKeyPath:@"effects" options:0 context:NULL];
        [self layoutViews];
    }
    return self;
}

- (void)dealloc
{
    [_channel.timeline removeObserver:self forKeyPath:@"zoomLevel"];
    [_channel removeObserver:self forKeyPath:@"effects"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == _channel.timeline && [keyPath isEqualToString:@"zoomLevel"]) {
        [self layoutViews];
    }
    else if (object == _channel && [keyPath isEqualToString:@"effects"]) {
        [self layoutViews];
    }
}

- (void)layoutViews
{
    AUTimeline *timeline = self.channel.timeline;
    CGFloat width = timeline.duration * timeline.zoomLevel;
    [self setFrame:NSMakeRect(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height)];
    NSMutableArray *newSubViews = [NSMutableArray array];
    for (AUEffect *effect in _channel.effects) {
        AUEffectView *effectView = [[AUEffectView alloc] init];
        effectView.effect = effect;
        CGFloat x = effectView.effect.startTime * timeline.zoomLevel;
        CGFloat y = 2.0;
        CGFloat width = effectView.effect.duration * timeline.zoomLevel;
        CGFloat height = self.frame.size.height - 4.0;
        effectView.frame = NSMakeRect(x, y, width, height);
        [newSubViews addObject:effectView];
    }
    self.subviews = newSubViews;
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
    
    [super drawRect:dirtyRect];
}


- (void)mouseDown:(NSEvent *)theEvent
{
    NSLog(@"%@", theEvent);
    NSPoint point = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    
    AUEffect *newEffect = [[AUEffect alloc] init];
    
    newEffect.startTime = point.x / _channel.timeline.zoomLevel;
    newEffect.duration = 10;
    
    [_channel addEffect:newEffect];
    NSLog(@"%@", NSStringFromPoint(point));
}

@end
