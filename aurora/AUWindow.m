//
//  AUWindow.m
//  Aurora
//
//  Created by Jason Dreisbach on 3/7/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AUWindow.h"

@implementation AUWindow
{
    CGFloat _contentHeight;
}

- (void)awakeFromNib
{
    _contentHeight = 0.0f;
}

- (void)expand
{
    NSRect expandedFrame = self.frame;
    expandedFrame.origin.y  -= _contentHeight;
    expandedFrame.size.height += _contentHeight;
    self.showsBaselineSeparator = YES;
    [self setFrame:expandedFrame display:YES animate:YES];
    
 
}

- (void)collapse
{
    _contentHeight = self.frame.size.height - self.titleBarHeight;
    
    NSRect collapsedFrame = self.frame;
    collapsedFrame.origin.y  += _contentHeight;
    collapsedFrame.size.height = self.titleBarHeight;
    [self setFrame:collapsedFrame display:YES animate:YES];
    self.showsBaselineSeparator = NO;
}


@end
