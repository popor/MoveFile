//
//  RootVCProtocol.h
//  MoveFile
//
//  Created by apple on 2018/3/12.
//  Copyright © 2018年 apple. All rights reserved.

#import <Foundation/Foundation.h>
#import "ColumnEntity.h"
#import "AcceptDragFileView.h"

static NSInteger TagTVTag  = 0;
static NSInteger folderTVTag = 1;

// 对外接口
@protocol RootVCProtocol <NSObject>

- (NSViewController *)vc;

// self   : 自己的
@property (nonatomic, strong) NSTableView  * tagTV;
@property (nonatomic, strong) NSScrollView * tagTV_CSV;
@property (nonatomic, strong) NSMenu       * tagTVClickMenu;

@property (nonatomic, strong) NSTableView  * folderTV;
@property (nonatomic, strong) NSScrollView * folderTV_CSV;
@property (nonatomic, strong) NSMenu       * folderTVClickMenu;

@property (nonatomic, strong) AcceptDragFileView * dragFileView;

// inject : 外部注入的

@end

// 数据来源
@protocol RootVCDataSource <NSObject>

- (NSArray *)columnFolderArray;
- (NSArray *)columnTagArray;

@end


// UI事件
@protocol RootVCEventHandler <NSObject>

- (void)tableViewClick:(NSTableView *)tableView;

- (void)addNewTagBTAction;
- (void)addNewFolderBTAction;
- (void)openDbFolderBTAction;

- (void)tagTVRightDeleteAction:(id)sender;
- (void)tagTVRightRenameAction:(id)sender;

- (void)folderTVUpdateOriginPathAction:(id)sender;
- (void)folderTVUpdateTargetPathAction:(id)sender;
- (void)folderTVOpenOriginPathAction:(id)sender;
- (void)folderTVOpenTargetPathAction:(id)sender;

- (void)folderTVRightDeleteAction:(id)sender;
- (void)folderTVClearAllAction:(id)sender;

- (void)moveAction:(id)sender;

- (void)resetTagTVWidth;

- (void)addFilePathArray:(NSArray *)pathArray;

@end
