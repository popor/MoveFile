//
//  AppKeepFront.h
//  PvtMac
//
//  Created by popor on 2021/2/6.
//  Copyright © 2021 popor. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define AppKeepFrontResume [[AppKeepFront share] updateKeepFrontStatus];
#define AppKeepFrontYES    [[AppKeepFront share] keepAtFront:YES];
#define AppKeepFrontNO     [[AppKeepFront share] keepAtFront:NO];

@interface AppKeepFront : NSObject

@property (nonatomic, strong) NSButton * frontBT_titleBar;

+ (instancetype)share;

- (void)showTitleBarFrontBT;

- (void)updateKeepFrontStatus;

- (void)keepAtFront:(BOOL)front;

@end

NS_ASSUME_NONNULL_END
