//
//  AUWindowController.h
//  Aurora
//
//  Created by Jason Dreisbach on 2/8/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <DPHue/DPHue.h>

@interface AUWindowController : NSWindowController <DPHueDiscoverDelegate>

@property (strong, readonly) NSMutableArray *hueBridgeArray;

@property (strong, nonatomic) IBOutlet NSViewController *performanceViewController;

// TODO: delete after debugging
@property (strong, nonatomic) IBOutlet NSViewController *effectTestViewController;

@end
