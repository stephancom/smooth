//
//  SIOUserDefaults.m
//  Smooth
//
//  Created by Neil Burchfield on 7/10/13.
//  Copyright (c) 2013 Smooth.IO. All rights reserved.
//

#import "SIOUserDefaults.h"

@implementation SIOUserDefaults
+ (void)setUserDefaultWithObject:(NSDictionary *)payload {
    id object = [payload safeObjectForKey:@"object"];
    NSString *key = [payload safeObjectForKey:@"key"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:object forKey:key];
    [defaults synchronize];
}
+ (void)removeUserDefaultWithKey:(NSDictionary *)payload {
    NSString *key = [payload safeObjectForKey:@"key"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:key];
    [defaults synchronize];
}
+ (NSString *)getUserDefaultWithKey:(NSDictionary *)payload {
    NSString *key = [payload safeObjectForKey:@"key"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSString *returned = [defaults objectForKey:key];
    
    if (!returned) {
        returned = @"null";
    }
    
    return returned;
}
@end
