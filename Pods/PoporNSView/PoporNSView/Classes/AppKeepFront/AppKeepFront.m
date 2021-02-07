//
//  AppKeepFront.m
//  PvtMac
//
//  Created by popor on 2021/2/6.
//  Copyright © 2021 popor. All rights reserved.
//

#import "AppKeepFront.h"
#import <Masonry/Masonry.h>

@interface AppKeepFront ()

@end

@implementation AppKeepFront

+ (instancetype)share {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
        
    });
    return instance;
}

- (void)showTitleBarFrontBT {
    [self addTitleBarFrontBT];
}

- (void)addTitleBarFrontBT {
    NSApplication * app     = [NSApplication sharedApplication];
    NSWindow * window       = app.windows.firstObject;
    NSButton * closeButton  = [window standardWindowButton:NSWindowCloseButton];
    NSView   * titleBarView = closeButton.superview;
    
    NSButton * button = ({
        NSButton * button = [NSButton checkboxWithTitle:@"置顶" target:self action:@selector(keepAtFrontAction:)];
        
        [titleBarView addSubview:button];
        button;
    });
    self.frontBT_titleBar = button;
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(-0);
        make.right.mas_equalTo(-5);
    }];
    
    // event
    NSString * front = [self get__keepFront];
    if (front.integerValue == 1) {
        button.state = NSControlStateValueOn;
        [self keepAtFront:YES];
    } else {
        button.state = NSControlStateValueOff;
        [self keepAtFront:NO];
    }
}

- (void)keepAtFrontAction:(NSButton *)bt {
    if (bt.state == NSControlStateValueOff) {
        bt.state = NSControlStateValueOff;
    } else {
        bt.state = NSControlStateValueOn;
    }
    //NSLog(@"%li", bt.state);
    [self updateKeepFrontStatus];
}

- (void)updateKeepFrontStatus {
    [self keepAtFront:self.frontBT_titleBar.state == NSControlStateValueOn];
}

- (void)keepAtFront:(BOOL)front {
    if (front) {
        [NSApp.windows[0] setLevel:NSFloatingWindowLevel];
    }else{
        [NSApp.windows[0] setLevel:NSNormalWindowLevel];
    }
    [self save__keepFront:[NSString stringWithFormat:@"%i", front]];
}

- (void)save__keepFront:(NSString *)__keepFront {
    [[NSUserDefaults standardUserDefaults] setObject:__keepFront forKey:@"PoporNSView_keepFront"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)get__keepFront {
    NSString * info = [[NSUserDefaults standardUserDefaults] objectForKey:@"PoporNSView_keepFront"];
    return info;
}

@end
