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

#define AlertToastTitleTimeTextColorBgColor(title, time, atView, textColor, bgColor) [iToast alertToastTitle:title duration:time view:atView t##extColor:textColor b##gColor:bgColor]

@class iToast;
@interface iToast : NSTextView

//- (id)initWithMessage:(NSString *)message;
//- (void)showAtView:(NSView *)view;

//@property (nonatomic, copy  ) NSColor * textColor;
@property (nonatomic        ) CGFloat maxWidth;// 默认为500
@property (nonatomic        ) CGFloat duration;
@property (nonatomic, copy  ) NSColor * _Nullable bgColor;

- (void)setTitleText:(NSString * _Nullable)text;
- (void)setTitleAtt:(NSAttributedString * _Nullable)att;

- (void)updateSize; // 更新size

- (void)showAtView:(NSView * _Nonnull)view;// 显示

+ (iToast * _Nonnull)alertToastTitle:(NSString * _Nullable)title view:(NSView * _Nonnull)view;
+ (iToast * _Nonnull)alertToastTitle:(NSString * _Nullable)title duration:(NSInteger)duration view:(NSView * _Nonnull)view;

+ (iToast * _Nonnull)alertToastTitle:(NSString * _Nullable)title
                            duration:(NSInteger)duration
                                view:(NSView * _Nonnull)view
                           textColor:(NSColor * _Nullable)textColor
                             bgColor:(NSColor * _Nullable)bgColor;

@end
