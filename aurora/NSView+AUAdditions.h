//
//  NSView+AUAdditions.h
//  Aurora
//
//  Created by Jason Dreisbach on 5/4/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSView (AUAdditions)

@property (strong) NSString *backgroundPatternImageName;

+ (CGPathRef)clippingPathWithRect:(NSRect)rect andRadius:(CGFloat)radius;
+ (CGGradientRef)gradientFromColor:(NSColor *)startingColor toColor:(NSColor *)endingColor;
- (void)drawNoiseWithOpacity:(CGFloat)opacity;

@end
