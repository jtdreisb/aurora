//
//  AUEffectTestViewController.h
//  Aurora
//
//  Created by Jason Dreisbach on 4/5/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AUEffectTestViewController : NSViewController <NSTableViewDelegate>

@property (strong) IBOutlet NSArrayController *effectsArrayController;
@property (strong) IBOutlet NSCollectionView *effectCollectionView;

@property (strong) IBOutlet NSArrayController *lightsArrayController;
@property (strong) IBOutlet NSTableView *lightTableView;


- (void)addLights:(NSArray *)lights;

@end
