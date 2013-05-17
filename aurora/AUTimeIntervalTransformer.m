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
        int min = [value doubleValue]/60;
        int sec = [value doubleValue] - (min * 60);
        transformedString =  [NSString stringWithFormat:@"%02d:%02d", min, sec];
    }
    return transformedString;
}

@end
