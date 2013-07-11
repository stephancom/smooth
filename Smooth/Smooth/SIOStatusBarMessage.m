//
//  SIOStatusBarMessage.m
//  Smooth
//
//  Created by Neil Burchfield on 7/10/13.
//  Copyright (c) 2013 Smooth.IO. All rights reserved.
//

#import "SIOStatusBarMessage.h"

@implementation SIOStatusBarMessage

+ (void)setStatusBarWithMessage:(NSDictionary *)payload onCompletion:(void (^)(BOOL done, NSError *error))completion {
    MTStatusBarOverlay *overlay = [MTStatusBarOverlay sharedInstance];
    overlay.animation = MTStatusBarOverlayAnimationFallDown;
    overlay.detailViewMode = MTDetailViewModeHistory;
    overlay.progress = 0.0;
    [overlay postMessage:[payload objectForKey:@"message"]
                duration:[[payload objectForKey:@"duration"] floatValue]];
}

@end
