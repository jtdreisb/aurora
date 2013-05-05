//
//  AULightIndexTransformer.m
//  Aurora
//
//  Created by Jason Dreisbach on 5/4/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AULightIndexTransformer.h"

//NSString * const AULightIndexTransformerName = @"AULightIndexTransformer";

@implementation AULightIndexTransformer

//+ (void)initialize
//{
//    [NSValueTransformer setValueTransformer:[[AULightIndexTransformer alloc] init] forName:AULightIndexTransformerName];
//}

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
