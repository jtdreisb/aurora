//
//  AUSetupViewController.h
//  aurora
//
//  Created by Jason Dreisbach on 2/6/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <DPHue/DPHueDiscover.h>

@class AULightsViewController;

@interface AUSetupViewController : NSViewController <DPHueDiscoverDelegate>

@property (weak) IBOutlet AULightsViewController *lightsViewController;
@end
