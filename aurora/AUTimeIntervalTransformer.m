//
//  AUTimeIntervalTransformer.m
//  Aurora
//
//  Created by Jason Dreisbach on 5/16/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AUTimeIntervalTransformer.h"

@implementation AUTimeIntervalTransformer

+ (Class)transformedValueClass
{
    return [NSString class];
}

+ (BOOL)allowsReverseTransformation
{
    return NO;
}

- (id)transformedValue:(id)value
{
    NSString *transformedString = nil;
    if ([value isKindOfClass:[NSValue class]]) {
        int msec = (int)([value doubleValue] * 1000.0) % 1000;
        int sec = (int)([value doubleValue]) % 60;
        int min = (int)([value doubleValue]/60) % (60);
        transformedString =  [NSString stringWithFormat:@"%02d:%02d:%03d", min, sec, msec];
    }
    return transformedString;
}

@end
