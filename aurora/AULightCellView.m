//
//  AULightCellView.m
//  Aurora
//
//  Created by Jason Dreisbach on 5/4/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AULightCellView.h"
#import "NSView+AUAdditions.h"

@implementation AULightCellView

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
    
    NSColor *startColor = [NSColor colorWithDeviceWhite:0.6 alpha:1.0];
    NSColor *endColor = [NSColor colorWithDeviceWhite:0.9 alpha:1.0];
    CGGradientRef gradient = [NSView gradientFromColor:startColor toColor:endColor];
    
    CGContextDrawLinearGradient(context, gradient, CGPointMake(NSMidX(drawingRect), NSMinY(drawingRect)),
                                CGPointMake(NSMidX(drawingRect), NSMaxY(drawingRect)), 0);
    CGGradientRelease(gradient);
    
    
    CGRect noiseRect = NSInsetRect(drawingRect, 1.0, 1.0);
    
    CGPathRef noiseClippingPath = [NSView clippingPathWithRect:noiseRect andRadius:0.0];
    CGContextAddPath(context, noiseClippingPath);
    CGContextClip(context);
    CGPathRelease(noiseClippingPath);
    
    [self drawNoiseWithOpacity:0.01];
    
    [[NSColor lightGrayColor] setStroke];
    NSBezierPath *borderPath = [NSBezierPath bezierPathWithRect:NSInsetRect(self.bounds, 1.0, 1.0)];
    [borderPath setLineWidth:2.0];
    [borderPath stroke];
    
    CGContextRestoreGState(context);
    
    
    
    [super drawRect:dirtyRect];
}

@end
