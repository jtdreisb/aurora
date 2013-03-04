//
//  SPAppDelegate.h
//  aurora
//
//  Created by Jason Dreisbach on 2/6/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <DPHue/DPHue.h>

@class AUWindow;
@interface AUAppDelegate : NSObject <NSApplicationDelegate, DPHueDiscoverDelegate>

@property (strong, nonatomic) IBOutlet AUWindow *window;

@end
