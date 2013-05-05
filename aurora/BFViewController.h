//
//  BFViewController.h
//
//  Created by Heiko Dreyer on 11.05.12.
//  Copyright (c) 2012 boxedfolder.com. All rights reserved.
//

#import "BFNavigationController.h"

@interface NSViewController (BFViewController)
@property (weak) BFNavigationController *navigationController;
-(void)pushViewController: (NSViewController *)viewController animated: (BOOL)animated;
-(NSViewController *)popViewControllerAnimated: (BOOL)animated;
-(NSArray *)popToRootViewControllerAnimated: (BOOL)animated;
-(NSArray *)popToViewController: (NSViewController *)viewController animated: (BOOL)animated;
@end

@protocol BFViewController <NSObject>

///---------------------------------------------------------------------------------------
/// @name Responding to View Events
///---------------------------------------------------------------------------------------

@optional

/**
 *  Notifies the view controller that its view is about to be added to a view hierarchy.
 */
-(void)viewWillAppear: (BOOL)animated;

/**
 *  Notifies the view controller that its view was added to a view hierarchy.
 */
-(void)viewDidAppear: (BOOL)animated;

/**
 *  Notifies the view controller that its view is about to be removed from a view hierarchy.
 */
-(void)viewWillDisappear: (BOOL)animated;

/**
 *  Notifies the view controller that its view was removed from a view hierarchy.
 */
-(void)viewDidDisappear: (BOOL)animated;

@end
