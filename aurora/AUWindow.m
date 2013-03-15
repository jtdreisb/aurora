//
//  AUWindow.m
//  Aurora
//
//  Created by Jason Dreisbach on 3/7/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AUWindow.h"

@implementation AUWindow
{
    CAAnimation *_animation;
}

@synthesize view = _view;


- (void)setView:(NSView *)aView
{
    @synchronized(self) {
        NSRect collapsedFrame = self.frame;
        collapsedFrame.origin.y += self.frame.size.height - self.titleBarHeight;
        collapsedFrame.size.height = self.titleBarHeight;
        NSRect viewFrame = _view.frame;
        
        [self.animator setFrame:collapsedFrame display:YES animate:YES];
        
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            
            [context setDuration:[self animationResizeTime:collapsedFrame]];
            [[(NSView *)self.contentView animator] setAlphaValue:0.0];
            
            
        } completionHandler:^{
            
            [_view removeFromSuperview];
            [_view setFrame:viewFrame];
            
            _view = aView;
            
            if (_view != nil) {
                
                NSRect expandedFrame = self.frame;
                expandedFrame.origin.y -= aView.frame.size.height;
                expandedFrame.size.height = aView.frame.size.height + self.titleBarHeight;
                
                [aView setTranslatesAutoresizingMaskIntoConstraints:NO];
                
                [self.contentView addSubview:aView];
                
                NSDictionary *views = NSDictionaryOfVariableBindings(aView);
                
                [self.contentView addConstraints:
                 [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[aView]|"
                                                         options:0
                                                         metrics:nil
                                                           views:views]];
                
                [self.contentView addConstraints:
                 [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[aView]|"
                                                         options:0
                                                         metrics:nil
                                                           views:views]];
                
                [self.animator setFrame:expandedFrame display:YES animate:YES];
                
                [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
                    
                    [context setDuration:[self animationResizeTime:expandedFrame]];
                    [[(NSView *)self.contentView animator] setAlphaValue:1.0];

                } completionHandler:nil];
            }
            
         }];
        
        
    }
}

- (id)view
{
    @synchronized(self) {
        return _view;
    }
}


- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    
}

@end
