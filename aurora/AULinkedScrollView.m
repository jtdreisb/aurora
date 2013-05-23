//
//  AULinkedScrollView.m
//  celltest
//
//  Created by Jason Dreisbach on 5/10/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AULinkedScrollView.h"

@interface AUInvisibleScroller : NSScroller @end
@implementation AUInvisibleScroller
+ (BOOL)isCompatibleWithOverlayScrollers {return self == [AUInvisibleScroller class];}
- (BOOL)isHidden {return YES;}
@end

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
    [self setHorizontalScroller:[[AUInvisibleScroller alloc] init]];
    [self setHorizontalScrollElasticity:NSScrollElasticityAutomatic];
    [self setVerticalScroller:[[AUInvisibleScroller alloc] init]];
    [self setVerticalScrollElasticity:NSScrollElasticityNone];
    [self setBorderType:NSNoBorder];
    [self.contentView setCopiesOnScroll:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)scrollWheel:(NSEvent *)theEvent
{
    [super scrollWheel:theEvent];
    [self.nextResponder scrollWheel:theEvent];
    [[NSNotificationCenter defaultCenter] postNotificationName:kAULinkedScrollViewFrameChange object:self];
}

@end
