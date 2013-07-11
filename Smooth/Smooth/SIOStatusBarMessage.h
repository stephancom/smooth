//
//  SIOStatusBarMessage.h
//  Smooth
//
//  Created by Neil Burchfield on 7/10/13.
//  Copyright (c) 2013 Smooth.IO. All rights reserved.
//

#import "MTStatusBarOverlay.h"

@interface SIOStatusBarMessage : NSObject <MTStatusBarOverlayDelegate>
+ (void)setStatusBarWithMessage:(NSDictionary *)payload onCompletion:(void (^)(BOOL done, NSError *error))completion;
@end
