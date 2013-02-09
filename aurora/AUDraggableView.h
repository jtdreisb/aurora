//
//  AUDraggableImage.h
//  Aurora
//
//  Created by Jason Dreisbach on 2/6/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import <Cocoa/Cocoa.h>

extern NSString *const DraggableImageDidDragNotification;

@interface AUDraggableView : NSView

@property (strong) id representedObject;
@property (weak) IBOutlet NSTextField *label;

@end
