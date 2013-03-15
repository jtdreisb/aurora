//
//  AUPerformanceEditViewController.m
//  Aurora
//
//  Created by Jason Dreisbach on 3/7/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AUPerformanceEditViewController.h"

@interface AUPerformanceEditViewController ()

@end

@implementation AUPerformanceEditViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)awakeFromNib
{
    self.view.layer.backgroundColor = [[NSColor greenColor] CGColor];
}

- (void)mouseDown:(NSEvent *)theEvent
{
    NSLog(@"mouseDown!");
}

@end
