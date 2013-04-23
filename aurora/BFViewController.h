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

@implementation NSViewController (BFViewController)

+ (NSMutableDictionary *)bf_propertyDictionary
{
    static NSMutableDictionary *propertyDictionary = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        propertyDictionary = [NSMutableDictionary dictionary];
    });
    return propertyDictionary;
}

-(BFNavigationController *)navigationController
{
    return [[[self class] bf_propertyDictionary] objectForKey:[NSValue valueWithPointer:(__bridge const void *)(self)]];
}

-(void)setNavigationController:(BFNavigationController *)navigationController
{
    [[[self class] bf_propertyDictionary] setObject:navigationController forKey:[NSValue valueWithPointer:(__bridge const void *)(self)]];
}

-(void)pushViewController: (NSViewController *)viewController animated: (BOOL)animated
{
    [self.navigationController pushViewController:viewController animated:animated];
}

-(NSViewController *)popViewControllerAnimated: (BOOL)animated
{
    return [self.navigationController popViewControllerAnimated:animated];
}

-(NSArray *)popToRootViewControllerAnimated: (BOOL)animated
{
    return [self.navigationController popToRootViewControllerAnimated:animated];
}

-(NSArray *)popToViewController: (NSViewController *)viewController animated: (BOOL)animated
{
    return [self.navigationController popToViewController:viewController animated:animated];
}
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
