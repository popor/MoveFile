//
//  AppDelegate.m
//  MoveFile
//
//  Created by apple on 2018/3/10.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "AppDelegate.h"
#import "SqliteCofing.h"
#import "WindowFrameTool.h"
#import "AppKeepFront.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationWillFinishLaunching:(NSNotification *)notification {
#if TARGET_OS_MAC//模拟器
    NSString * macOSInjectionPath = @"/Applications/InjectionIII.app/Contents/Resources/macOSInjection.bundle";
    if ([[NSFileManager defaultManager] fileExistsAtPath:macOSInjectionPath]) {
        [[NSBundle bundleWithPath:macOSInjectionPath] load];
    }
#endif
    
    [[AppKeepFront share] showTitleBarFrontBT];
    [SqliteCofing updateTable];
    
    NSWindow * window = [NSApplication sharedApplication].keyWindow;
    window.minSize = CGSizeMake(600, 400);
    
    window.title = @"Move File";
    self.window = window;
    
    [self resumeLastFrameOrigin];
    
    WindowFrameTool * tool = [WindowFrameTool share];
    __weak typeof(self) weakSelf = self;
    tool.blockResetWindow = ^(){
        NSScreen * screen = [NSScreen mainScreen];
        int w = MIN(1000, screen.frame.size.width*0.8);
        int h = MIN(600, screen.frame.size.height*0.6);;
        int x = (screen.frame.size.width - w)/2;
        int y = (screen.frame.size.height - h)/2;
        
        CGRect rect = CGRectMake(x, y, w, h);
        
        [SqliteCofing updateWindowFrame:rect];
        [weakSelf.window setFrame:rect display:YES];
    };
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    [SqliteCofing updateWindowFrame:self.window.frame];
}

- (void)resumeLastFrameOrigin {
    NSString * windowFrameString = [SqliteCofing getWindowFrame];
    if (windowFrameString) {
        // 计算合适x.
        CGRect frame      = NSRectFromString(windowFrameString);
        NSPoint point     = frame.origin;
        NSScreen * screen = [NSScreen mainScreen];
        CGFloat x         = MAX(point.x, 150);
        x                 = MIN(x, screen.frame.size.width - 150);
        point             = CGPointMake(x, point.y);
        
        [self.window setFrame:CGRectMake(point.x, point.y, frame.size.width, frame.size.height) display:YES];
        
    }else{
        [SqliteCofing addWindowFrame:self.window.frame];
    }
}

// 当点击了关闭window,再次点击Dock上的icon时候,执行以下代码可以再次显示window.
- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag{
    if (flag) {
        return NO;
    } else{
        [self.window makeKeyAndOrderFront:self];
        return YES;
    }
}

- (IBAction)resetWindowFrame:(id)sender {
    WindowFrameTool * tool = [WindowFrameTool share];
    if (tool.blockResetWindow) {
        tool.blockResetWindow();
    }
    if (tool.blockResetTv) {
        tool.blockResetTv();
    }
}

- (IBAction)keyboardDeleteAction:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:NcKey_keyboardDeleteAction object:nil];
}

@end
