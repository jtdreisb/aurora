//
//  AUNavigationController.m
//  Aurora
//
//  Created by Jason Dreisbach on 5/22/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AUNavigationController.h"
#import "AUViewController.h"
#import "AUTitlebarView.h"
#import "AUBottomBarView.h"

@interface BFNavigationController ()

- (void)_setViewControllers:(NSArray *)controllers animated:(BOOL)animated;
- (void)_navigateFromViewController:(NSViewController *)lastController
                   toViewController:(NSViewController *)newController
                           animated:(BOOL)animated
                               push:(BOOL)push;
@end

@implementation AUNavigationController

- (id)initWithFrame:(NSRect)aFrame rootViewController:(NSViewController *)controller
{
    self = [super initWithFrame:aFrame rootViewController:controller];
    if (self != nil) {
        if ([controller respondsToSelector:@selector(setNavigationController:)]) {
            [(id)controller setNavigationController:self];
        }
    }
    return self;
}

- (void)pushViewController:(NSViewController *)viewController animated:(BOOL)animated
{
    if ([viewController respondsToSelector:@selector(setNavigationController:)]) {
        [(id)viewController setNavigationController:self];
    }
    [super pushViewController:viewController animated:animated];
}

- (void)_setViewControllers:(NSArray *)controllers animated:(BOOL)animated
{
    [super _setViewControllers:controllers animated:animated];
    for (id viewController in self.viewControllers) {
        if ([viewController respondsToSelector:@selector(setNavigationController:)]) {
            [(id)viewController setNavigationController:self];
        }
    }
}

- (void)_navigateFromViewController:(NSViewController *)lastController
                   toViewController:(NSViewController *)newController
                           animated:(BOOL)animated
                               push:(BOOL)push
{
    [self.titleBarView setSubviews:@[]];
    [self.bottomBarView setSubviews:@[]];
    [super _navigateFromViewController:lastController toViewController:newController animated:animated push:push];
    if ([newController isKindOfClass:[AUViewController class]]) {
        AUViewController *controller = (AUViewController *)newController;
        if (controller.titleBarView != nil) {
            [controller.titleBarView setFrame:self.titleBarView.bounds];
            [self.titleBarView addSubview:controller.titleBarView];
        }
        if (controller.bottomBarView != nil) {
            [controller.bottomBarView setFrame:self.bottomBarView.bounds];
            [self.bottomBarView addSubview:controller.bottomBarView];
        }

    }
}

@end
