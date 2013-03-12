//
//  SPAppDelegate.h
//  aurora
//
//  Created by Jason Dreisbach on 2/6/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class AUWindowController;

@interface AUAppDelegate : NSObject <NSApplicationDelegate>

@property (strong, nonatomic) AUWindowController *windowController;

@end
