//
//  NSDictionary+SIOAdditions.m
//  Smooth
//
//  Created by Neil Burchfield on 7/10/13.
//  Copyright (c) 2013 Smooth.IO. All rights reserved.
//

#import "NSDictionary+SIOAdditions.h"

@implementation NSDictionary (SIOAdditions)
- (id)safeObjectForKey:(id)aKey
{
    if ([[self objectForKey:aKey] isKindOfClass:[NSNull class]]) {
        return nil;
    }
    return [self objectForKey:aKey];
}
@end
