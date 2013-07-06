//
//  SmoothViewController.m
//  Smooth
//
//  Created by Neil Burchfield on 6/25/13.
//  Copyright (c) 2013 Smooth.IO. All rights reserved.
//

#import "SmoothViewController.h"
#import "Smooth.h"
#import "UIColor+Expanded.h"

@interface SmoothViewController ()

@end

@implementation SmoothViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self refresh];
    
	// Listen for a JS event.
	[Smooth on:@"log" perform: ^(NSDictionary *payload) {
	    NSLog(@"\"log\" received, payload = %@", payload);
	}];
    
	[Smooth on:@"toggle-toolbar" perform: ^(NSDictionary *payload) {
	    [self toggleFullscreen:nil withDuration:0.3];
	}];
    
	[Smooth on:@"toggle-fullscreen-with-callback" performAsync: ^(NSDictionary *payload, void (^complete)()) {
	    NSTimeInterval duration = [[payload objectForKey:@"duration"] integerValue];
	    [self toggleFullscreen:complete withDuration:duration];
	}];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	return [Smooth webView:_webView withUrl:[request URL]];
}

- (IBAction)colorButtonPressed:(UIBarButtonItem *)sender {
	NSDictionary *payload = @{ @"color": [[sender tintColor] hexStringValue] };
    
	[Smooth send:@"color-change" withPayload:payload toWebView:_webView];
}

- (IBAction)refreshButtonPressed:(UIBarButtonItem *)sender {
	[self refresh];
}

- (IBAction)showImageButtonPressed:(UIBarButtonItem *)sender {
	NSDictionary *payload = @{ @"feed": @"http://www.google.com/doodles/doodles.xml" };
    
	[Smooth send:@"show-image" withPayload:payload toWebView:_webView perform: ^{
	    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Image loaded"
	                                                    message:@"callback in iOS from JS event"
	                                                   delegate:self
	                                          cancelButtonTitle:@"Score!"
	                                          otherButtonTitles:nil];
        
	    [alert show];
	}];
}

- (void)refresh {
	NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"smooth" ofType:@"html"];
    
	NSString *path = [[NSBundle mainBundle] bundlePath];
    
	NSURL *baseURL = [NSURL fileURLWithPath:path];
    
	NSString *htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
	[_webView loadHTMLString:htmlString baseURL:baseURL];
}

- (void)toggleFullscreen:(void (^)())complete withDuration:(NSTimeInterval)duration {
	if (_fullscreenToggled) {
		[self exitFullscreen:complete withDuration:duration];
	}
	else {
		[self enterFullscreen:complete withDuration:duration];
	}
}

- (void)enterFullscreen:(void (^)())complete withDuration:(NSTimeInterval)duration {
	CGRect topFrame = _toolbar.frame;
    
	[UIView animateWithDuration:duration animations: ^{
	    _toolbar.frame = CGRectMake(topFrame.origin.x, topFrame.origin.y + topFrame.size.height, topFrame.size.width, topFrame.size.height);
	    _webView.frame = CGRectMake(0, 0, _webView.frame.size.width, self.view.frame.size.height);
	} completion: ^(BOOL finished) {
	    // Call Completion back to JS
	    if (complete != nil) {
	        complete();
		}
	}];
    
	_fullscreenToggled = YES;
}

- (void)exitFullscreen:(void (^)())complete withDuration:(NSTimeInterval)duration {
	CGRect topFrame = _toolbar.frame;
    
	[UIView animateWithDuration:duration animations: ^{
	    _toolbar.frame = CGRectMake(topFrame.origin.x, self.view.frame.size.height - topFrame.size.height, topFrame.size.width, topFrame.size.height);
	    _webView.frame = CGRectMake(0, 0, _webView.frame.size.width, _webView.frame.size.height - topFrame.size.height);
	} completion: ^(BOOL finished) {
	    // Call Completion back to JS
	    if (complete != nil) {
	        complete();
		}
	}];
    
	_fullscreenToggled = NO;
}

@end
