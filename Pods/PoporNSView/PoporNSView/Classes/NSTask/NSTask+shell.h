//
//  NSTask+shell.h
//  IpaTool
//
//  Created by 王凯庆 on 2017/3/6.
//  Copyright © 2017年 wanzi. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 执行不需要权限的shell没问题
 */
@interface NSTask (shell)

+ (NSString *)shell:(NSString *)shellStr;

@end
