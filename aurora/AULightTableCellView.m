//
//  AULightTableCellView.m
//  Aurora
//
//  Created by Jason Dreisbach on 3/29/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AULightTableCellView.h"
#import "AULightColorView.h"
#import <DPHueLight.h>

@implementation AULightTableCellView
{
    IBOutlet AULightColorView *_colorView;
}

- (IBAction)change:(id)sender
{
    DPHueLight *light = self.objectValue;
    light.on = NO;
    [light write];
}

- (void)setObjectValue:(id)objectValue
{
    [self.objectValue removeObserver:self forKeyPath:@"color"];
    
    [super setObjectValue:objectValue];
    [objectValue addObserver:self forKeyPath:@"color" options:0 context:nil];
    NSColor *color = (NSColor *)[objectValue valueForKey:@"color"];
    if ([color isKindOfClass:[NSColor class]]) {
        _colorView.color = color;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ((object == self.objectValue) && [keyPath isEqualToString:@"color"]) {
        NSColor *color = (NSColor *)[object valueForKey:@"color"];
        if ([color isKindOfClass:[NSColor class]]) {
            _colorView.color = color;
        }
    }
}

@end
