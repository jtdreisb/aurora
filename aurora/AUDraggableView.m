//
//  AUDraggableImage.m
//  Aurora
//
//  Created by Jason Dreisbach on 2/6/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AUDraggableView.h"

NSString *const DraggableImageDidDragNotification = @"DraggableImageDidDragNotification";

@implementation AUDraggableView
{
    NSPoint initialLocation;
    NSPoint initialDragLocation;
}
- (void)awakeFromNib
{
    self.layer.backgroundColor = [[NSColor grayColor] CGColor];
    self.layer.opacity = 0.5f;
}
- (BOOL)acceptsFirstMouse:(NSEvent *)e
{
    return YES;
}

- (void)mouseDown:(NSEvent *) e
{
    initialLocation = self.frame.origin;
    initialDragLocation = [[self superview] convertPoint:[e locationInWindow] fromView:nil];
}

- (void)mouseUp:(NSEvent *)theEvent
{
    [[NSNotificationCenter defaultCenter] postNotificationName:DraggableImageDidDragNotification object:self];
}

- (void)mouseDragged:(NSEvent *)theEvent
{
    // We're working only in the superview's coordinate space, so we always convert.
    NSPoint newDragLocation = [[self superview] convertPoint:[theEvent locationInWindow] fromView:nil];
    CGFloat dX = initialDragLocation.x - newDragLocation.x;
    CGFloat dY = initialDragLocation.y - newDragLocation.y;
    [self setFrameOrigin:NSMakePoint(initialLocation.x-dX, initialLocation.y-dY)];
}

@end
