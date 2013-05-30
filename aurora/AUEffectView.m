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
#import "AUTimeline.h"
#import "AUPlaybackCoordinator.h"

#define AURectCenter(rect) CGPointMake(NSMidX(rect),NSMidY(rect))

@implementation AUEffectView
{
    NSPopover *_editPopover;
}

- (id)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self != nil) {
        [[AUPlaybackCoordinator sharedInstance] addObserver:self forKeyPath:@"trackPosition" options:0 context:NULL];
    }
    return self;
}

- (void)dealloc
{
    [[AUPlaybackCoordinator sharedInstance] removeObserver:self forKeyPath:@"trackPosition"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self layoutView];
}


- (void)layoutView
{
    AUTimeline *timeline = [[(AUChannelView *)self.superview channel] timeline];
    CGFloat x = self.effect.startTime * timeline.zoomLevel;
    CGFloat y = 2.0;
    CGFloat width = self.effect.duration * timeline.zoomLevel;
    CGFloat height = self.superview.frame.size.height - 4.0;
    self.frame = NSMakeRect(x, y, width, height);
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect
{
    NSRect drawingRect = [self bounds];
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
    
    CGContextSaveGState(context);
    
    CGContextSetAlpha(context, 0.7);
    
    CGContextBeginPath(context);
    CGContextAddRect(context, drawingRect);
    
    CGContextSetFillColorWithColor(context, [self.effect.backgroundColor CGColor]);
    CGContextFillPath(context);
    
    CGContextBeginPath(context);
    CGContextAddRect(context, NSInsetRect(drawingRect, 1.0, 1.0));
    CGContextSetLineWidth(context, 2.0);
    
    if (self.window.firstResponder == self) {
        CGContextSetStrokeColorWithColor(context, [[NSColor blueColor] CGColor]);
    }
    else {
        CGContextSetStrokeColorWithColor(context, [[NSColor clearColor] CGColor]);
    }
    CGContextStrokePath(context);
    
    CGContextRestoreGState(context);
    
    [super drawRect:dirtyRect];
}

- (void)keyDown:(NSEvent *)theEvent
{
    if (theEvent.modifierFlags & NSCommandKeyMask) {
        // Copy
        if (theEvent.keyCode == 8) {
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.effect];
            NSPasteboard *pb = [NSPasteboard generalPasteboard];
            [pb clearContents];
            [pb declareTypes:@[@"AUEffect"] owner:nil];
            
            if ([pb setData:data forType:@"AUEffect"] == NO) {
                NSLog(@"oops");
            }
        }
        // Paste
        else if (theEvent.keyCode == 9) {
            NSPasteboard *pb = [NSPasteboard generalPasteboard];
            NSData *data = [pb dataForType:@"AUEffect"];
            AUEffect *newEffect = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            newEffect.startTime = self.effect.startTime;
            [[(AUChannelView *)self.superview channel] addEffect:newEffect];
            [[(AUChannelView *)self.superview channel] removeEffect:self.effect];
            [(AUChannelView *)self.superview layoutView];
        }
    }
    else {
        // Delete
        if (theEvent.keyCode == 51) {
            [self deleteEffect:self.effect];
        }
        // Right
        if (theEvent.keyCode == 124) {
            if (theEvent.modifierFlags & NSShiftKeyMask) {
                self.effect.startTime += 0.2;
            }
            else {
                self.effect.startTime += 0.05;
            }
            
            [self layoutView];
        }
        // Left
        if (theEvent.keyCode == 123) {
            if (theEvent.modifierFlags & NSShiftKeyMask) {
                self.effect.startTime -= 0.2;
            }
            else {
                self.effect.startTime -= 0.05;
            }
            [self layoutView];
        }
    }
}

- (void)mouseDown:(NSEvent *)theEvent
{
    if (self.window.firstResponder != self) {
        [self.window makeFirstResponder:self];
        [(AUChannelView *)self.superview layoutView];
        // Hack to get the views to redraw
        [[AUPlaybackCoordinator sharedInstance] willChangeValueForKey:@"trackPosition"];
        [[AUPlaybackCoordinator sharedInstance] didChangeValueForKey:@"trackPosition"];
    }
    else {
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
}


- (void)saveEffect:(id)sender
{
    if ([_editPopover isShown]) {
        [_editPopover close];
        _editPopover = nil;
    }
    [(AUChannelView *)self.superview layoutView];
}

- (void)deleteEffect:(id)sender
{
    if ([_editPopover isShown]) {
        [_editPopover close];
        _editPopover = nil;
    }
    
    AUChannelView *channelView = (AUChannelView *)self.superview;
    [channelView.channel removeEffect:sender];
    [channelView layoutView];
}

@end
