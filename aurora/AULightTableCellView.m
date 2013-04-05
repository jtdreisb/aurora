//
//  AULightTableCellView.m
//  Aurora
//
//  Created by Jason Dreisbach on 3/29/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AULightTableCellView.h"
#import "AULightColorView.h"

@implementation AULightTableCellView

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
    [super drawRect:dirtyRect];
    
}

- (void)setObjectValue:(id)objectValue
{
    [super setObjectValue:objectValue];
    NSColor *color = (NSColor *)[objectValue valueForKey:@"color"];
    if ([color isKindOfClass:[NSColor class]]) {
        self.colorView.color = color;
    }
}

@end
