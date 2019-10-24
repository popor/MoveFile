//
//  AppDelegate.m
//  MoverCode
//
//  Created by apple on 2018/3/10.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "AppDelegate.h"
#import <PoporFMDB/PoporFMDB.h>

static NSString * const WindowFrameKey = @"WindowFrame";

#import "MoveFolderEntity.h"
#import "MoveTagEntity.h"
#import "ColumnEntity.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationWillFinishLaunching:(NSNotification *)notification {
    
    // 更新PoporFMDB
    [PoporFMDB injectTableArray:@[[MoveFolderEntity class], [MoveTagEntity class], [ColumnEntity class]]];
    
    NSWindow * window = [NSApplication sharedApplication].keyWindow;
    window.minSize = CGSizeMake(600, 400);
    
    window.title = @"MoverFile";
    self.window = window;
    
    [self resumeLastFrameOrigin];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
    [PDB updatePlistKey:WindowFrameKey value:NSStringFromRect(self.window.frame)];
}

- (void)resumeLastFrameOrigin {
    NSString * windowFrameString = [PDB getPlistKey:WindowFrameKey];
    if (windowFrameString) {
        // 计算合适x.
        CGRect frame = NSRectFromString(windowFrameString);
        
        NSPoint point = frame.origin;
        NSScreen * screen = [NSScreen mainScreen];
        CGFloat x = MAX(point.x, 150);
        x         = MIN(x, screen.frame.size.width - 150);
        point     = CGPointMake(x, point.y);
        [self.window setFrame:CGRectMake(point.x, point.y, frame.size.width, frame.size.height) display:YES];
        
    }else{
        [PDB addPlistKey:WindowFrameKey value:NSStringFromRect(self.window.frame)];
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

@end
