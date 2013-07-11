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
#import "SIOAddressBook.h"
#import "SIOStatusBarMessage.h"
#import "SIOUserDefaults.h"

@interface SmoothViewController ()

@end

@implementation SmoothViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self refresh];
    
    ////////////////////////////////////////////////////////////////////
	// User Defaults
    [Smooth on:@"setUserDefault" perform: ^(NSDictionary *payload) {
        [SIOUserDefaults setUserDefaultWithObject:payload];
	}];
    
    [Smooth on:@"getUserDefault" perform: ^(NSDictionary *payload) {
        NSString *object = [SIOUserDefaults getUserDefaultWithKey:payload];
        [Smooth send:@"getUserDefault" withPayload:@{@"object":object} toWebView:_webView];
	}];
    
    [Smooth on:@"removeUserDefault" perform: ^(NSDictionary *payload) {
        [SIOUserDefaults removeUserDefaultWithKey:payload];
	}];
    ////////////////////////////////////////////////////////////////////

	[Smooth on:@"log" perform: ^(NSDictionary *payload) {
	    NSLog(@"\"log\" received, payload = %@", payload);
	}];
    
	[Smooth on:@"getcamera" perform: ^(NSDictionary *payload) {
	    [self getCamera];
	}];
    
	[Smooth on:@"getContacts" perform: ^(NSDictionary *payload) {
	    [[[SIOAddressBook alloc] init] fetchAllAddressBookContacts: ^(NSArray *results, NSError *error) {
	        [Smooth send:@"getContacts" withPayload:@{ @"array":results } toWebView:_webView];
		}];
	}];
    
	[Smooth on:@"presentAlert" perform: ^(NSDictionary *payload) {
	    self.alert = [[SIOAlertView alloc] init];
	    [self.alert setDelegate:self];
	    [self.alert setAlertViewWithPayload:payload];
	}];
    
	[Smooth on:@"statusMessage" perform: ^(NSDictionary *payload) {
	    [SIOStatusBarMessage setStatusBarWithMessage:payload onCompletion: ^(BOOL done, NSError *error) {
		}];
	}];
    
	[Smooth on:@"toggle-toolbar" perform: ^(NSDictionary *payload) {
	    [self toggleFullscreen:nil withDuration:0.3];
	}];
    
	[Smooth on:@"toggle-fullscreen-with-callback" performAsync: ^(NSDictionary *payload, void (^complete)()) {
	    NSTimeInterval duration = [[payload objectForKey:@"duration"] integerValue];
	    [self toggleFullscreen:complete withDuration:duration];
	}];
}

- (void)alertView:(SIOAlertView *)alertView didSelectValue:(int)value {
	[Smooth send:@"presentAlert" withPayload:@{ @"index":[NSNumber numberWithInt:value] } toWebView:_webView];
}

- (void)getCamera {
	UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
	imagePickerController = [[UIImagePickerController alloc] init];
	NSArray *sourceTypes = [UIImagePickerController
	                        availableMediaTypesForSourceType:imagePickerController.sourceType];
	imagePickerController.mediaTypes = sourceTypes;
	imagePickerController.delegate = self;
	imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
	[self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	[picker dismissViewControllerAnimated:NO completion: ^{
	    UIImage *origImage = [info objectForKey:UIImagePickerControllerOriginalImage];
	    NSString *send = [self copyImageToCache:origImage];
	    [Smooth send:@"getcamera" withPayload:@{ @"file":send } toWebView:_webView];
	}];
}

- (NSString *)copyImageToCache:(UIImage *)image {
	NSError *error = nil;
    
	// Convert
	NSData *imageData = UIImageJPEGRepresentation(image, .1);
    
	// Save
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *fullPathToFile = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"test.jpeg"];
    
	// Remove
	[[NSFileManager defaultManager] removeItemAtPath:fullPathToFile error:nil];
    
	// Write
	[imageData writeToFile:fullPathToFile options:NSDataWritingAtomic error:&error];
    
	// Check
	bool success = [[NSFileManager defaultManager] fileExistsAtPath:fullPathToFile];
    
	if (success && !error) {
		NSLog(@"File saved");
	}
	else {
		NSLog(@"File didn't save");
	}
    
	return [NSString stringWithFormat:@"file://%@", fullPathToFile];
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
