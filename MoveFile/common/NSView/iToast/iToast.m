//
//  iToast.m
//  MoveFile
//
//  Created by apple on 2018/3/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "iToast.h"
#import <PoporFoundation/NSString+pSize.h>
#import <PoporFoundation/NSAttributedString+pAtt.h>
#import <Masonry/Masonry.h>

@import QuartzCore;

@interface iToast ()

@end

@implementation iToast

- (instancetype)init {
    if (self = [super init]) {
        self.maxWidth   = 500;
        self.duration   = 3;
        self.editable   = NO;
        self.selectable = NO;
        self.backgroundColor = [NSColor colorWithRed:0 green:0 blue:0 alpha:0];
        self.textColor       = [NSColor whiteColor];
        self.font            = [NSFont systemFontOfSize:16];
        self.alignment       = NSTextAlignmentCenter;
        
        self.textContainerInset = CGSizeMake(10, 10);
    }
    
    return self;
}

- (id)initWithMessage:(NSString *)message duration:(float)duration {
    if (self = [self init]) {
        self.duration = duration;
        self.string   = message;
        
        [self updateSize];
    }
    
    return self;
}

- (void)setTitleText:(NSString * _Nullable)text {
    self.string = text;
}

- (void)setTitleAtt:(NSAttributedString * _Nullable)att {
    [[self textStorage] appendAttributedString:att];
}

- (void)updateSize {
    if (self.font) {
        CGSize size = CGSizeZero;
        if (self.string) {
            size = [self.string sizeInFont:self.font width:self.maxWidth];
        } else if (self.attributedString) {
            size = [self.attributedString sizeWithWidth:self.maxWidth];
        }
        self.frame  = CGRectMake(0, 0, MAX(size.width + self.textContainerInset.width*2, 320), size.height + self.textContainerInset.height*2);
    }
}

- (void)drawRect:(NSRect)dirtyRect {
    NSRect rect = [self bounds];
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:rect xRadius:10 yRadius:10];
    [path addClip];
    
    if (self.bgColor) {
        [self.bgColor set];
    } else {
        [[NSColor colorWithRed:0 green:0 blue:0 alpha:0.8] set];
    }
    
    
    NSRectFill(dirtyRect);
    
    [super drawRect:dirtyRect];
    
}

- (void)showAtView:(NSView * _Nonnull)view {
    // 移除之前的自己
    NSArray * array = [view subviews];
    for (NSView * subview in array) {
        if ([subview isKindOfClass:[self class]]) {
            [subview removeFromSuperview];
        }
    }
    
    [view addSubview:self];
    
    //self.frame = CGRectMake((view.frame.size.width - self.frame.size.width)/2, 40, self.frame.size.width, self.frame.size.height);
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(-40);
        make.width.mas_equalTo(self.frame.size.width);
        make.height.mas_equalTo(self.frame.size.height);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}

+ (iToast * _Nonnull)alertToastTitle:(NSString * _Nullable)title
                                view:(NSView * _Nonnull)view {
    return [self alertToastTitle:title duration:2 view:view];
}

+ (iToast * _Nonnull)alertToastTitle:(NSString * _Nullable)title
                            duration:(NSInteger)duration
                                view:(NSView * _Nonnull)view {
    return [self alertToastTitle:title duration:duration view:view textColor:nil bgColor:nil];
}

+ (iToast * _Nonnull)alertToastTitle:(NSString * _Nullable)title
                            duration:(NSInteger)duration
                                view:(NSView * _Nonnull)view
                           textColor:(NSColor * _Nullable)textColor
                             bgColor:(NSColor * _Nullable)bgColor
{
    iToast * i = [[iToast alloc] initWithMessage:title duration:duration];
    
    if (textColor) {
        i.textColor = textColor;
    }
    
    if (bgColor) {
        i.bgColor   = bgColor;
    }
    
    
    [i showAtView:view];
    return i;
}

#pragma mark - 点击事件
- (void)mouseDown:(NSEvent *)event {
    [self removeFromSuperview];
}

@end
