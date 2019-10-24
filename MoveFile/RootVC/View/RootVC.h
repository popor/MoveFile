//
//  RootVC.h
//  MoverCode
//
//  Created by apple on 2018/3/12.
//  Copyright © 2018年 apple. All rights reserved.

#import <Cocoa/Cocoa.h>
#import "RootVCProtocol.h"

@interface RootVC : NSViewController <RootVCProtocol>

- (instancetype)initWithDic:(NSDictionary *)dic;

- (void)addViews;

// 开始执行事件,比如获取网络数据
- (void)startEvent;

@end

