//
//  AppDelegate.h
//  MoveFile
//
//  Created by apple on 2018/12/12.
//  Copyright © 2018 apple. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic, weak  ) NSWindow * window;

- (IBAction)resetWindowFrame:(id)sender;

- (IBAction)keyboardDeleteAction:(id)sender;

@end

