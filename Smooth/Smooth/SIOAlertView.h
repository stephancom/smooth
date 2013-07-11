//
//  SIOAlertView.h
//  Smooth
//
//  Created by Neil Burchfield on 7/10/13.
//  Copyright (c) 2013 Smooth.IO. All rights reserved.
//

@protocol SIOAlertViewDelegate;

@interface SIOAlertView : NSObject <UIAlertViewDelegate>
@property (nonatomic, retain) UIAlertView *alertView;
@property (nonatomic, weak) id<SIOAlertViewDelegate> delegate;
- (void)setAlertViewWithPayload:(NSDictionary *)payload;
@end

@protocol SIOAlertViewDelegate <NSObject>
@optional
- (void)alertView:(SIOAlertView *)alertView didSelectValue:(int)value;
@end
