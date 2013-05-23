//
//  AUViewController.h
//  Aurora
//
//  Created by Jason Dreisbach on 5/22/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BFViewController.h"
#import "AUView.h"

@interface AUViewController : NSViewController <BFViewController>

@property (weak) BFNavigationController *navigationController;

@property (strong) IBOutlet NSView *titleBarView;
@property (strong) IBOutlet NSView *bottomBarView;

@property (readonly) AUView *au_view;

- (void)pushViewController:(NSViewController *)viewController animated:(BOOL)animated;

- (NSViewController *)popViewControllerAnimated:(BOOL)animated;

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated;

- (NSArray *)popToViewController:(NSViewController *)viewController animated:(BOOL)animated;

@end
