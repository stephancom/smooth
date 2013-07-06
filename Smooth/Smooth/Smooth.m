//
//  Smooth.m
//  Smooth
//
//  Created by Neil Burchfield on 6/25/13.
//  Copyright (c) 2013 Smooth.IO. All rights reserved.
//

#import "Smooth.h"

@interface Smooth ()
+ (id)sharedInstance;
- (void)triggerEventFromWebView:(UIWebView *)webView withData:(NSDictionary *)envelope;
- (void)triggerCallbackOnWebView:(UIWebView *)webView forMessage:(NSString *)messageId;
- (void)triggerCallbackForMessage:(NSNumber *)messageId;
@end

@implementation Smooth


+ (id)sharedInstance {
	static dispatch_once_t once;
	static Smooth *sharedInstance;
	dispatch_once(&once, ^{
	    sharedInstance = [[self alloc] init];
	    sharedInstance.messageCount = @0;
	    sharedInstance.listeners = [[NSMutableDictionary alloc] init];
	    sharedInstance.callbacks = [[NSMutableDictionary alloc] init];
	});
	return sharedInstance;
}

+ (void)on:(NSString *)type perform:(SmoothHandler)handler {
	void (^extended)(NSDictionary *payload, void (^complete)()) = ^(NSDictionary *payload, void (^complete)()) {
		handler(payload);
		complete();
	};
    
	[self on:type performAsync:extended];
}

+ (void)on:(NSString *)type performAsync:(SmoothAsyncHandler)handler {
	Smooth *instance = [Smooth sharedInstance];
    
	NSDictionary *listeners = [instance listeners];
    
	NSMutableArray *listenerList = [listeners objectForKey:type];
    
	if (listenerList == nil) {
		listenerList = [[NSMutableArray alloc] init];
        
		[instance.listeners setValue:listenerList forKey:type];
	}
    
	[listenerList addObject:handler];
}

+ (void)off:(NSString *)type {
	Smooth *instance = [Smooth sharedInstance];
    
	NSMutableDictionary *listeners = [instance listeners];
	[listeners removeObjectForKey:type];
}

+ (void)send:(NSString *)type withPayload:(id)payload toWebView:(UIWebView *)webView {
	[self send:type withPayload:payload toWebView:webView perform:nil];
}

+ (void)send:(NSString *)type withPayload:(id)payload toWebView:(UIWebView *)webView perform:(void (^)())complete {
	Smooth *smooth = [Smooth sharedInstance];
    
	NSNumber *messageId = smooth.messageCount;
    
	if (complete != nil) {
		[smooth.callbacks setValue:complete forKey:[messageId stringValue]];
	}
    
	NSError *err;
	NSData *jsonData = [NSJSONSerialization dataWithJSONObject:payload options:NSJSONWritingPrettyPrinted error:&err];
	NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
	NSString *javascript = [NSString stringWithFormat:@"Smooth.trigger(\"%@\", %i, %@);", type, [messageId integerValue], jsonString];
    
	[webView stringByEvaluatingJavaScriptFromString:javascript];
    
	smooth.messageCount = @([smooth.messageCount integerValue] + 1);
}

+ (BOOL)webView:(UIWebView *)webView withUrl:(NSURL *)url {
	if ([[url scheme] isEqualToString:@"smooth"]) {
		NSString *eventType = [url host];
		NSString *messageId = [[url path] substringFromIndex:1];
		NSString *query = [url query];
		NSString *jsonString = [query stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
		NSError *error;
		NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]
		                                                     options:NSJSONReadingMutableContainers
		                                                       error:&error];
        
		if ([eventType isEqualToString:@"event"]) {
			[[self sharedInstance] triggerEventFromWebView:webView withData:JSON];
		}
		else if ([eventType isEqualToString:@"callback"]) {
			[[self sharedInstance] triggerCallbackForMessage:@([messageId integerValue])];
		}
        
		return NO;
	}
	return YES;
}

- (void)triggerEventFromWebView:(UIWebView *)webView withData:(NSDictionary *)envelope {
	NSDictionary *listeners = [[Smooth sharedInstance] listeners];
    
	NSString *messageId = [envelope objectForKey:@"id"];
	NSString *type = [envelope objectForKey:@"type"];
    
	NSDictionary *payload = [envelope objectForKey:@"payload"];
    
	NSArray *listenerList = (NSArray *)[listeners objectForKey:type];
    
	__block NSInteger executedCount = 0;
    
	void (^complete)() = ^() {
		executedCount += 1;
        
		if (executedCount >= [listenerList count]) {
			[[Smooth sharedInstance] triggerCallbackOnWebView:webView forMessage:messageId];
		}
	};
    
	for (SmoothAsyncHandler handler in listenerList) {
		handler(payload, complete);
	}
}

- (void)triggerCallbackOnWebView:(UIWebView *)webView forMessage:(NSString *)messageId {
	NSString *javascript = [NSString stringWithFormat:@"Smooth.triggerCallback(\"%@\");", messageId];
    
	[webView stringByEvaluatingJavaScriptFromString:javascript];
}

- (void)triggerCallbackForMessage:(NSNumber *)messageId {
	NSString *messageIdString = [messageId stringValue];
    
	void (^callback)() = [_callbacks objectForKey:messageIdString];
    
	if (callback != nil) {
		callback();
	}
    
	[_callbacks removeObjectForKey:messageIdString];
}

@end
