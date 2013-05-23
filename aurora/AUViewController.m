//
//  AUViewController.m
//  Aurora
//
//  Created by Jason Dreisbach on 5/22/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AUViewController.h"


@interface AUViewController ()

@end

@implementation AUViewController

- (AUView *)au_view
{
    return [self.view isKindOfClass:[AUView class]] ? (AUView *)self.view : nil;
}

- (IBAction)back:(id)sender
{
    [self popViewControllerAnimated:YES];
}

- (void)pushViewController: (NSViewController *)viewController animated: (BOOL)animated
{
    [self.navigationController pushViewController:viewController animated:animated];
}

- (NSViewController *)popViewControllerAnimated: (BOOL)animated
{
    return [self.navigationController popViewControllerAnimated:animated];
}

- (NSArray *)popToRootViewControllerAnimated: (BOOL)animated
{
    return [self.navigationController popToRootViewControllerAnimated:animated];
}

- (NSArray *)popToViewController: (NSViewController *)viewController animated: (BOOL)animated
{
    return [self.navigationController popToViewController:viewController animated:animated];
}

@end
