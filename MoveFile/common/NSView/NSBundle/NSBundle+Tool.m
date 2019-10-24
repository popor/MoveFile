//
//  NSBundle+tool.m
//  IpaTool
//
//  Created by 王凯庆 on 2017/3/1.
//  Copyright © 2017年 wanzi. All rights reserved.
//

#import "NSBundle+Tool.h"

@implementation NSBundle (Tool)

#pragma mark - APP Plist 版本
/**
 *  对外版本号
 */
+ (NSString *)getAppVersion_short {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

/**
 *  对内build号
 */
+ (NSString *)getAppVersion_build {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
}

//获取BundleID
+ (NSString*)getBundleID {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
}

//获取app的名字
+ (NSString*)getAppName {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
}

@end
