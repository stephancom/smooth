//
//  main.m
//  Smooth
//
//  Created by Neil Burchfield on 6/25/13.
//  Copyright (c) 2013 Smooth.IO. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SmoothAppDelegate.h"

int main(int argc, char *argv[])
{
    int retVal;
    
    @autoreleasepool {
        @try {
            retVal = UIApplicationMain(argc, argv, nil, NSStringFromClass([SmoothAppDelegate class]));
        }
        @catch (NSException *exception) {
            NSLog(@"[Smooth] Crash: %@", exception);
            NSLog(@"[Smooth] Stack Trace: %@", [exception callStackSymbols]);
        }
    }
    
    return retVal;
}