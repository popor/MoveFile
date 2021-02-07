//
//  NSBundle+tool.h
//  IpaTool
//
//  Created by 王凯庆 on 2017/3/1.
//  Copyright © 2017年 wanzi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBundle (Tool)

#pragma mark - APP Plist 版本
/**
 *  对外版本号
 */
+ (NSString *)getAppVersion_short;

/**
 *  对内build号
 */
+ (NSString *)getAppVersion_build;

//获取BundleID
+ (NSString*)getBundleID;

//获取app的名字
+ (NSString*)getAppName;

@end
