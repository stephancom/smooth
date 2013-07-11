//
//  SIOUserDefaults.h
//  Smooth
//
//  Created by Neil Burchfield on 7/10/13.
//  Copyright (c) 2013 Smooth.IO. All rights reserved.
//

@interface SIOUserDefaults : NSObject
+ (void)setUserDefaultWithObject:(NSDictionary *)payload;
+ (void)removeUserDefaultWithKey:(NSDictionary *)payload;
+ (NSString *)getUserDefaultWithKey:(NSDictionary *)payload;
@end
