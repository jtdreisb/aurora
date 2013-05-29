//
//  AUEffectView.m
//  Aurora
//
//  Created by Jason Dreisbach on 5/22/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AUEffectView.h"
#import "NSView+AUAdditions.h"
#import "AUEffect.h"
#import "AUChannelView.h"
#import "AUTimelineChannel.h"

#define AURectCenter(rect) CGPointMake(NSMidX(rect),NSMidY(rect))

@implementation AUEffectView
{
    NSPopover *_editPopover;
}

- (void)drawRect:(NSRect)dirtyRect
{
    NSRect drawingRect = [self bounds];
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
    
    CGContextSaveGState(context);
    
    CGContextSetAlpha(context, 0.9);
    
    CGPathRef clippingPath = [NSView clippingPathWithRect:drawingRect andRadius:2.0];
    CGContextAddPath(context, clippingPath);
    CGContextClip(context);
    CGPathRelease(clippingPath);
    
    NSColor *startColor = [NSColor colorWithCalibratedRed:0.1 green:0.9 blue:0.1 alpha:0.5];
    NSColor *endColor = [NSColor colorWithCalibratedRed:0.3 green:0.9 blue:0.3 alpha:0.5];
    CGGradientRef gradient = [NSView gradientFromColor:startColor toColor:endColor];
    

    CGContextDrawRadialGradient(context, gradient, AURectCenter(drawingRect), 0.0, AURectCenter(drawingRect), drawingRect.size.height/2.0, kCGGradientDrawsBeforeStartLocation|kCGGradientDrawsAfterEndLocation);
    
    CGGradientRelease(gradient);
    
//    CGRect strokeRect = NSInsetRect(drawingRect, 1.0, 1.0);
    
    CGContextRestoreGState(context);
    
    [super drawRect:dirtyRect];
}

- (void)mouseDown:(NSEvent *)theEvent
{
    if (_editPopover == nil) {
        _editPopover = [[NSPopover alloc] init];
    }
    if ([_editPopover isShown]) {
        [_editPopover close];
        _editPopover = nil;
    }
    else {
        AUEffectEditViewController *popoverViewController = [self.effect editViewController];
        popoverViewController.delegate = self;
        _editPopover.contentViewController = popoverViewController;
        [_editPopover showRelativeToRect:[self bounds]
                                  ofView:self
                           preferredEdge:NSMinYEdge];
    }
}

- (void)saveEffect:(id)sender
{
    if ([_editPopover isShown]) {
        [_editPopover close];
        _editPopover = nil;
    }
    NSLog(@"%s: %@",__PRETTY_FUNCTION__, [(AUEffect *)sender payloads]);
    [(AUChannelView *)self.superview layoutViews];
}

- (void)deleteEffect:(id)sender
{
    if ([_editPopover isShown]) {
        [_editPopover close];
        _editPopover = nil;
    }
    
    AUChannelView *channelView = (AUChannelView *)self.superview;
    [channelView.channel removeEffect:sender];
    [channelView layoutViews];
}

@end
