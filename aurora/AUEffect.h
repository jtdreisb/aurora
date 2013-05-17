//
//  AUEffect.h
//  Aurora
//
//  Created by Jason Dreisbach on 4/5/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AUEffect : NSObject <NSCoding>

#pragma mark - Readonly properties

@property (readonly) NSString *name;
@property (readonly) NSString *toolTip;
@property (readonly) NSImage *image;
@property (readonly) NSString *editViewNibName;

#pragma mark - Settable Properties

@property NSTimeInterval startTime;
@property NSTimeInterval duration;

#pragma mark - Delegate

// Returns an NSDictionary of json payoloads keyed by their start time
- (NSDictionary *)payloads;

@end
