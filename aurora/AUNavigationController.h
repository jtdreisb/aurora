//
//  AUNavigationController.h
//  Aurora
//
//  Created by Jason Dreisbach on 5/22/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "BFNavigationController.h"

@class AUTitlebarView;
@class AUBottomBarView;

@interface AUNavigationController : BFNavigationController

@property (strong) IBOutlet AUTitlebarView *titleBarView;
@property (strong) IBOutlet AUBottomBarView *bottomBarView;

@end
