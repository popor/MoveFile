//
//  AppKeepFront.h
//  PvtMac
//
//  Created by popor on 2021/2/6.
//  Copyright © 2021 popor. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppKeepFront : NSObject

@property (nonatomic, strong) NSButton * frontBT_titleBar;

+ (instancetype)share;

- (void)showTitleBarFrontBT;

- (void)addMgjRouterEvent;

@end

NS_ASSUME_NONNULL_END
