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
    
    CGContextSetAlpha(context, 0.7);
    
    CGPathRef fillPath = [NSView clippingPathWithRect:drawingRect andRadius:4.0];
    CGContextBeginPath(context);
    CGContextAddPath(context, fillPath);
    
    CGContextSetFillColorWithColor(context, [self.effect.backgroundColor CGColor]);
    CGContextFillPath(context);
    
    CGPathRelease(fillPath);
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
