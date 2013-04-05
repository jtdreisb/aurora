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

@property (readonly) NSString *name;
@property (readonly) NSString *toolTip;
@property (readonly) NSImage *image;
@property (readonly) NSString *editViewNibName;

#pragma mark - Settable Properties

@property (strong) NSNumber *duration;

#pragma mark - Actions

- (void)start;
- (void)stop;

@end
