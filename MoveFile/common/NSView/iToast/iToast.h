//
//  iToast.h
//  MoveFile
//
//  Created by apple on 2018/3/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define AlertToastTitle(title, atView)           [iToast alertToastTitle:title view:atView]
#define AlertToastTitleTime(title, time, atView) [iToast alertToastTitle:title duration:time view:atView]

@interface iToast : NSTextView

//- (id)initWithMessage:(NSString *)message;
//- (void)showAtView:(NSView *)view;

+ (void)alertToastTitle:(NSString *)title view:(NSView *)view;
+ (void)alertToastTitle:(NSString *)title duration:(NSInteger)duration view:(NSView *)view;

@end
