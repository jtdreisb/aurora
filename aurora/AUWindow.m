//
//  AUWindow.m
//  Aurora
//
//  Created by Jason Dreisbach on 3/2/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AUWindow.h"

@implementation AUWindow

- (void)awakeFromNib
{
    NSLog(@"Hello");
    self.titleBarHeight = 80;
    self.centerFullScreenButton = NO;
    self.centerTrafficLightButtons = NO;
}

@end
