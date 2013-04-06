//
//  AUEffectTestViewController.h
//  Aurora
//
//  Created by Jason Dreisbach on 4/5/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AUEffectTestViewController : NSViewController <NSCollectionViewDelegate>

@property (strong, nonatomic) IBOutlet NSArrayController *effectsArrayController;
@property (strong, nonatomic) IBOutlet NSArrayController *lightsArrayController;

- (void)addLights:(NSArray *)lights;

@end
