//
//  RootVCInteractor.h
//  MoveFile
//
//  Created by apple on 2018/3/12.
//  Copyright © 2018年 apple. All rights reserved.

#import <Foundation/Foundation.h>

#import "MoveTagEntity.h"
#import "MoveFolderEntity.h"
#import "ColumnEntity.h"
#import "SqliteCofing.h"

// 处理Entity事件
@interface RootVCInteractor : NSObject

@property (nonatomic, strong) NSMutableArray * tagEntityArray;    // 标签数组
@property (nonatomic, strong) NSMutableArray * folderEntityArray; // 当前标签的folder数组

@property (nonatomic, strong) NSMutableArray * columnTagArray;
@property (nonatomic, strong) NSMutableArray * columnFolderArray;

- (void)updateMoveFolderArrayWith:(MoveTagEntity *)entity;
- (void)updateMoveFolderArrayWithTagId:(NSString *)tagID;

- (void)addMoveTagTitle:(NSString *)title;
- (void)deleteTagEntity:(MoveTagEntity *)entity;

- (void)addNewPath:(NSString *)path tagID:(NSString *)tagID;
- (void)deleteEntity:(MoveFolderEntity *)entity;

- (void)updateEntity:(MoveFolderEntity *)entity move:(BOOL)move;

- (void)updateTagEntity:(MoveTagEntity *)entity title:(NSString *)title;

- (void)updateEntity:(MoveFolderEntity *)entity tip:(NSString *)tip;
- (void)updateEntity:(MoveFolderEntity *)entity originPath:(NSString *)originPath;
- (void)updateEntity:(MoveFolderEntity *)entity targetPath:(NSString *)targetPath;


@end
