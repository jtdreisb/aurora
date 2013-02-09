//
//  NSViewController+PushPopAnimations.m
//  aurora
//
//  Created by Jason Dreisbach on 2/6/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "NSViewController+PushPopAnimations.h"
#import "NSView+Animations.h"

@implementation NSViewController (PushPopAnimations)

//
//- (void)pushViewController:(NSViewController *)viewController animated:(BOOL)yesno
//{
//     _lastViewController = self;
//    NSView *superview = self.view.superview;
//    [self.view removeFromSuperviewAnimated:yesno];
//    [superview addSubview:viewController.view animated:yesno];
//}
//
//- (void)popViewControllerAnimated:(BOOL)yesno
//{
//    if (_lastViewController != nil) {
//        NSView *superview = self.view.superview;
//        [self.view removeFromSuperviewAnimated:yesno];
//        [superview addSubview:self.lastViewController.view animated:yesno];
//        _lastViewController = nil;
//    }
//}

@end
