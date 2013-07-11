//
//  Smooth.h
//  Smooth
//
//  Created by Neil Burchfield on 6/25/13.
//  Copyright (c) 2013 Smooth.IO. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SmoothHandler)(NSDictionary *payload);
typedef void (^SmoothAsyncHandler)(NSDictionary *payload, void(^ complete) ());
typedef void (^SmoothAsyncHandlerPayload)(NSDictionary *payload, void(^ complete) (NSDictionary *));

@interface Smooth : NSObject

+ (void)on:(NSString *)type perform:(SmoothHandler)handler;
+ (void)on:(NSString *)type performAsync:(SmoothAsyncHandler)handler;
+ (void)on:(NSString *)type performAsyncPayload:(SmoothAsyncHandlerPayload)handler;
+ (void)off:(NSString *)type;
+ (void)send:(NSString *)type withPayload:(id)payload toWebView:(UIWebView *)webView;
+ (void)send:(NSString *)type withPayload:(id)payload toWebView:(UIWebView *)webView perform:(void(^) ())complete;
+ (void)send:(NSString *)type withPayload:(id)payload toWebView:(UIWebView *)webView performPayload:(void(^) (NSDictionary *))complete;
+ (BOOL)webView:(UIWebView *)webView withUrl:(NSURL *)url;

@property (strong, atomic) NSNumber *messageCount;
@property (strong, nonatomic) NSMutableDictionary *listeners;
@property (strong, nonatomic) NSMutableDictionary *callbacks;

@end
