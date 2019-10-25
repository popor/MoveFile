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
        self.delegate = self;
    }
    return self;
}

- (BOOL)becomeFirstResponder {
    self.backgroundColor = [NSColor whiteColor];
    return [super becomeFirstResponder];
}

- (void)controlTextDidEndEditing:(NSNotification *)obj {
    self.backgroundColor = [NSColor clearColor];
}

@end
