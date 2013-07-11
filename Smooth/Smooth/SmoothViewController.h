//
//  SIORootViewController.h
//  Smooth
//
//  Created by Neil Burchfield on 6/25/13.
//  Copyright (c) 2013 Smooth.IO. All rights reserved.
//

#import "SIOAlertView.h"

@interface SmoothViewController : UIViewController <UIWebViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, SIOAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, retain) SIOAlertView *alert;

- (IBAction)refreshButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)showImageButtonPressed:(UIBarButtonItem *)sender;

- (void)refresh;
- (void)toggleFullscreen:(void(^) ()) complete withDuration:(NSTimeInterval)duration;

@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@property (nonatomic, assign) BOOL fullscreenToggled;

@end
