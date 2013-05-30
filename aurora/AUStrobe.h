//
//  AUStrobeEffect.h
//  Aurora
//
//  Created by Jason Dreisbach on 4/5/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AUEffect.h"

@interface AUStrobe : AUEffect

@property (strong) NSColor *color;

@property NSTimeInterval frequency;
@property NSTimeInterval transitionTime;
@property BOOL fullOff;

@end
