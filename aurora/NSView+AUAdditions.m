//
//  NSView+AUAdditions.m
//  Aurora
//
//  Created by Jason Dreisbach on 5/4/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "NSView+AUAdditions.h"

@implementation NSView (AUAdditions)

+ (NSMutableDictionary *)au_propertyDictionary
{
    static NSMutableDictionary *propertyDictionary = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        propertyDictionary = [NSMutableDictionary dictionary];
    });
    return propertyDictionary;
}

- (NSString *)backgroundPatternImageName
{
    return [[[self class] au_propertyDictionary] objectForKey:[NSValue valueWithPointer:(__bridge const void *)(self)]];
}

- (void)setBackgroundPatternImageName:(NSString *)backgroundPatternImageName
{
    [[[self class] au_propertyDictionary] setObject:backgroundPatternImageName forKey:[NSValue valueWithPointer:(__bridge const void *)(self)]];
}

+ (CGPathRef)clippingPathWithRect:(NSRect)rect andRadius:(CGFloat)radius
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, NSMinX(rect), NSMinY(rect));
    CGPathAddLineToPoint(path, NULL, NSMinX(rect), NSMaxY(rect)-radius);
    CGPathAddArcToPoint(path, NULL, NSMinX(rect), NSMaxY(rect), NSMinX(rect)+radius, NSMaxY(rect), radius);
    CGPathAddLineToPoint(path, NULL, NSMaxX(rect)-radius, NSMaxY(rect));
    CGPathAddArcToPoint(path, NULL,  NSMaxX(rect), NSMaxY(rect), NSMaxX(rect), NSMaxY(rect)-radius, radius);
    CGPathAddLineToPoint(path, NULL, NSMaxX(rect), NSMinY(rect));
    CGPathCloseSubpath(path);
    return path;
}

+ (CGGradientRef)gradientFromColor:(NSColor *)startingColor toColor:(NSColor *)endingColor
{
    CGFloat locations[2] = {0.0f, 1.0f, };
	CGColorRef cgStartingColor = [startingColor CGColor];
	CGColorRef cgEndingColor = [endingColor CGColor];
#if __has_feature(objc_arc)
    CFArrayRef colors = (__bridge CFArrayRef)[NSArray arrayWithObjects:(__bridge id)cgStartingColor, (__bridge id)cgEndingColor, nil];
#else
    CFArrayRef colors = (CFArrayRef)[NSArray arrayWithObjects:(id)cgStartingColor, (id)cgEndingColor, nil];
#endif
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, colors, locations);
    CGColorSpaceRelease(colorSpace);
    return gradient;
}


- (void)drawNoiseWithOpacity:(CGFloat)opacity
{
    static CGImageRef noiseImageRef = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        NSUInteger width = 124, height = width;
        NSUInteger size = width*height;
        char *rgba = (char *)malloc(size); srand(120);
        for(NSUInteger i=0; i < size; ++i){rgba[i] = rand()%256;}
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
        CGContextRef bitmapContext =
        CGBitmapContextCreate(rgba, width, height, 8, width, colorSpace, kCGImageAlphaNone);
        CFRelease(colorSpace);
        noiseImageRef = CGBitmapContextCreateImage(bitmapContext);
        CFRelease(bitmapContext);
        free(rgba);
    });
    
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
    CGContextSaveGState(context);
    CGContextSetAlpha(context, opacity);
    CGContextSetBlendMode(context, kCGBlendModeScreen);
    
    if ( [[self window] respondsToSelector:@selector(backingScaleFactor)] ) {
        CGFloat scaleFactor = [[self window] backingScaleFactor];
        CGContextScaleCTM(context, 1/scaleFactor, 1/scaleFactor);
    }
    
    CGRect imageRect = (CGRect){CGPointZero, CGImageGetWidth(noiseImageRef), CGImageGetHeight(noiseImageRef)};
    CGContextDrawTiledImage(context, imageRect, noiseImageRef);
    CGContextRestoreGState(context);
}


@end
