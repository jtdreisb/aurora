//
//  AULinkedScrollView.m
//  celltest
//
//  Created by Jason Dreisbach on 5/10/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AULinkedScrollView.h"

static NSString *const kAULinkedScrollViewFrameChange = @"AULinkedScrollViewFrameChange";

@implementation AULinkedScrollView


- (id)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self != nil) {
        [[NSNotificationCenter defaultCenter] addObserverForName:kAULinkedScrollViewFrameChange object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
            AULinkedScrollView *changedView = note.object;
            [self.contentView scrollToPoint:[changedView.contentView bounds].origin];
            [self reflectScrolledClipView:self.contentView];
        }];
    }
    return self;
}
- (void)awakeFromNib
{
    [self setHasHorizontalScroller:YES];
    [self setHorizontalScrollElasticity:NSScrollElasticityAutomatic];
    [self setVerticalScrollElasticity:NSScrollElasticityNone];
    [self setBorderType:NSNoBorder];
    [self.contentView setCopiesOnScroll:YES];
    
    double delayInSeconds = 0.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.horizontalScroller setHidden:YES];
    });
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)scrollWheel:(NSEvent *)theEvent
{
    [super scrollWheel:theEvent];
    [self.horizontalScroller setHidden:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:kAULinkedScrollViewFrameChange object:self];
}

@end
