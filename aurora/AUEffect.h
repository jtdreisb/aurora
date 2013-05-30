//
//  AUEffect.h
//  Aurora
//
//  Created by Jason Dreisbach on 4/5/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AUEffectEditViewController.h"

@interface AUEffect : NSObject <NSCoding>

#pragma mark - Readonly properties

+ (NSString *)name;
+ (NSString *)toolTip;
+ (NSImage *)image;
+ (NSString *)editViewNibName;
- (NSColor *)backgroundColor;
- (AUEffectEditViewController *)editViewController;

#pragma mark - Settable Properties

@property NSTimeInterval startTime;
@property NSTimeInterval duration;

#pragma mark - Delegate

// Returns an NSDictionary of json payoloads keyed by their start time
- (NSDictionary *)payloads;

@end
