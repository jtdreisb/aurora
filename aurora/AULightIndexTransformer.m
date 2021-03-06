//
//  AULightIndexTransformer.m
//  Aurora
//
//  Created by Jason Dreisbach on 5/4/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AULightIndexTransformer.h"

@implementation AULightIndexTransformer

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
    if ([value isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = value;
        transformedString = [NSString stringWithFormat:@"%@:", dict[@"index"]];
    }
    return transformedString;
}

@end
