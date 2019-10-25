//
//  EditableTextField.m
//  MoveFile
//
//  Created by apple on 2018/3/24.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "EditableTextField.h"

@interface EditableTextField () <NSTextFieldDelegate>

@end

@implementation EditableTextField

- (id)init {
    if (self = [super init]) {
        self.delegate = self;
    }
    return self;
}

- (id)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {
        //self.delegate        = self;
        
        // 使用系统自动的文字和背景颜色
        self.backgroundColor = [NSColor textBackgroundColor];
        self.textColor       = [NSColor textColor];
        
    }
    return self;
}

// 识别系统主题颜色
//    NSString *osxMode = [[NSUserDefaults standardUserDefaults] stringForKey:@"AppleInterfaceStyle"];
//    if (osxMode) {
//        self.backgroundColor = [NSColor whiteColor];
//        self.textColor       = [NSColor blackColor];
//        // NSLog(@"osxMode : %@",osxMode);  //黑暗模式打印：Dark  非黑暗模式: (null)
//    } else {
//        self.backgroundColor = [NSColor grayColor];
//        self.textColor       = [NSColor whiteColor];
//    }

//- (BOOL)becomeFirstResponder {
//    return [super becomeFirstResponder];
//}

//- (void)controlTextDidEndEditing:(NSNotification *)obj {
//    NSString *osxMode = [[NSUserDefaults standardUserDefaults] stringForKey:@"AppleInterfaceStyle"];
//    if (osxMode) {
//        self.backgroundColor = [NSColor clearColor];
//        self.textColor       = [NSColor whiteColor];
//        // NSLog(@"osxMode : %@",osxMode);  //黑暗模式打印：Dark  非黑暗模式: (null)
//    } else {
//        self.backgroundColor = [NSColor clearColor];
//        self.textColor       = [NSColor blackColor];
//    }
//
//}

@end
