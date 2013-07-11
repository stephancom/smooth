//
//  SIOAlertView.m
//  Smooth
//
//  Created by Neil Burchfield on 7/10/13.
//  Copyright (c) 2013 Smooth.IO. All rights reserved.
//

#import "SIOAlertView.h"

@implementation SIOAlertView

- (void)setAlertViewWithPayload:(NSDictionary *)payload {
	NSMutableArray *buttons = [NSMutableArray array];
    
	NSString *title = [payload safeObjectForKey:@"title"];
	NSString *message = [payload safeObjectForKey:@"message"];
	NSString *firstIndexTitle = [payload safeObjectForKey:@"firstIndex"];
	NSString *secondIndexTitle = [payload safeObjectForKey:@"secondIndex"];
	NSString *thirdIndexTitle = [payload safeObjectForKey:@"thirdIndex"];
	NSString *cancelTitle = [payload safeObjectForKey:@"cancelTitle"];
    
    
	if ((NSNull *)firstIndexTitle != [NSNull null]) {
		[buttons addObject:firstIndexTitle];
	}
	if ((NSNull *)secondIndexTitle != [NSNull null]) {
		[buttons addObject:secondIndexTitle];
	}
	if ((NSNull *)thirdIndexTitle != [NSNull null]) {
		[buttons addObject:thirdIndexTitle];
	}
    
	if ((NSNull *)cancelTitle != [NSNull null]) {
		[buttons addObject:cancelTitle];
	}
	else {
		[buttons addObject:@"Cancel"];
	}
    
	self.alertView = [[UIAlertView alloc] init];
	self.alertView.title = title;
	self.alertView.message = message;
	self.alertView.delegate = self;
	self.alertView.cancelButtonIndex = [buttons count] - 1;
    
	for (NSString *t in buttons) {
		[self.alertView addButtonWithTitle:t];
	}
    
	[self.alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	[alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
	if ([self.delegate respondsToSelector:@selector(alertView:didSelectValue:)]) {
		[self.delegate alertView:self didSelectValue:buttonIndex];
	}
}

@end
