//
//  AUEffectCollectionViewItem.h
//  Aurora
//
//  Created by Jason Dreisbach on 4/5/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class  AUEffectViewController;

@interface AUEffectCollectionViewItem : NSCollectionViewItem

@property (strong, nonatomic) AUEffectViewController *effectViewController;

@end
