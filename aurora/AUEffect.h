//
//  AUEffect.h
//  Aurora
//
//  Created by Jason Dreisbach on 4/5/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AUEffect : NSObject

@property (strong) NSNumber *duration;

- (void)start;
- (void)stop;

- (NSImage *)image;

@end
