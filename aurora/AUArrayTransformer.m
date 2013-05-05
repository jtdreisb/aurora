//
//  AUArrayTransformer.m
//  Aurora
//
//  Created by Jason Dreisbach on 5/4/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AUArrayTransformer.h"
#import <CocoaLibSpotify/CocoaLibSpotify.h>

@implementation AUArrayTransformer

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
    if ([value isKindOfClass:[NSArray class]]) {
        for (SPArtist *artist in value) {
            if (transformedString == nil) {
                transformedString = artist.name;
            }
            else {
                transformedString = [transformedString stringByAppendingFormat:@", %@", artist.name];
            }
        }
    }
    return transformedString;
}

@end
