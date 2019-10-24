//
//  RootVCPresenter.h
//  MoverCode
//
//  Created by apple on 2018/3/12.
//  Copyright © 2018年 apple. All rights reserved.

#import <Foundation/Foundation.h>
#import "RootVCProtocol.h"

// 处理和View事件
@interface RootVCPresenter : NSObject <RootVCEventHandler, RootVCDataSource, NSTableViewDelegate, NSTableViewDataSource>

- (void)setMyInteractor:(id)interactor;

- (void)setMyView:(id)view;

// 开始执行事件,比如获取网络数据
- (void)startEvent;


@end
