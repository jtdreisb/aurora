//
//  AUEffect.h
//  Aurora
//
//  Created by Jason Dreisbach on 4/5/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AUEffect : NSObject

#pragma mark - Readonly properties

- (NSString *)name;
- (NSString *)toolTip;
- (NSImage *)image;

#pragma mark - Settable Properties

@property (strong) NSNumber *duration;

#pragma mark - Actions

- (void)start;
- (void)stop;

@end
