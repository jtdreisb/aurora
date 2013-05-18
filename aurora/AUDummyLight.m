//
//  AUDummyLight.m
//  Aurora
//
//  Created by Jason Dreisbach on 5/17/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AUDummyLight.h"

@implementation AUDummyLight

- (NSString *)address
{
    return [NSString stringWithFormat:@"/api/%@/lights/%@", self.bridge.username, self.number];
}

@end
