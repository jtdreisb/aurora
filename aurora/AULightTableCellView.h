//
//  AULightTableCellView.h
//  Aurora
//
//  Created by Jason Dreisbach on 3/29/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class AULightColorView;

@interface AULightTableCellView : NSTableCellView

@property (weak) IBOutlet NSTextField *lightName;

@property (weak) IBOutlet AULightColorView *colorView;

@end
