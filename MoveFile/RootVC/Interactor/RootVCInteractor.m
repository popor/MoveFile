//
//  RootVCInteractor.m
//  MoveFile
//
//  Created by apple on 2018/3/12.
//  Copyright © 2018年 apple. All rights reserved.

#import "RootVCInteractor.h"

#import <PoporFMDB/PoporFMDB.h>

@interface RootVCInteractor ()

@end

@implementation RootVCInteractor

- (id)init {
    if (self = [super init]) {
        [self initData];
    }
    return self;
}

- (void)initData {
    _tagEntityArray = [PDB arrayClass:[MoveTagEntity class] orderBy:SortKey asc:YES];

    if (_tagEntityArray.count > 0) {
        [self updateMoveFolderArrayWith: [_tagEntityArray firstObject]];
    }
    [self initColumnTagArray];
    [self initColumnFolderArray];
    
}

- (void)initColumnTagArray {
    _columnTagArray = [PDB arrayClass:[ColumnEntity class] where:@"type" equal:ColumnTypeTag orderBy:@"sort" asc:YES];
    if (_columnTagArray.count != 1) {
        [PDB deleteClass:[ColumnEntity class] where:@"type" equal:ColumnTypeTag];
        _columnTagArray = [NSMutableArray new];
        NSArray * IDArray        = @[TvColumnId_tag1];
        NSArray * titleArray     = @[TvColumnTitle_tag1];
        NSArray * tipArray       = @[TvColumnTip_tag1];
        
        NSArray * widthArray     = @[@(ColumnTagMiniWidth)];
        NSArray * miniWidthArray = @[@(ColumnTagMiniWidth)];
        
        for (int i=0; i<IDArray.count; i++) {
            ColumnEntity * entity = [ColumnEntity new];
            entity.uuid      = [self getUUID];
            entity.type      = ColumnTypeTag;
            
            entity.sort      = i;
            entity.columnID  = IDArray[i];
            entity.tip       = tipArray[i];
            entity.title     = titleArray[i];
            entity.width     = [widthArray[i] intValue];
            entity.miniWidth = [miniWidthArray[i] intValue];
            
            [_columnTagArray addObject:entity];
            
            [PDB addEntity:entity];
        }
    }
}

- (void)initColumnFolderArray {
    _columnFolderArray = [PDB arrayClass:[ColumnEntity class] where:@"type" equal:ColumnTypeFolder orderBy:@"sort" asc:YES];
    
    if (_columnFolderArray.count == 0 || _columnFolderArray.count != 5) {
        [PDB deleteClass:[ColumnEntity class] where:@"type" equal:ColumnTypeFolder];
        _columnFolderArray = [NSMutableArray new];
        NSArray * IDArray        = @[TvColumnId_folder0, TvColumnId_folder1, TvColumnId_folder2, TvColumnId_folder3, TvColumnId_folder4];
        NSArray * titleArray     = @[TvColumnTitle_folder0, TvColumnTitle_folder1, TvColumnTitle_folder2, TvColumnTitle_folder3, TvColumnTitle_folder4];
        NSArray * tipArray       = @[TvColumnTip_folder0, TvColumnTip_folder1, TvColumnTip_folder2, TvColumnTip_folder3, TvColumnTip_folder4];
        
        NSArray * widthArray     = @[@(30), @(30), @(400), @(400), @(50)];
        NSArray * miniWidthArray = @[@(30), @(30), @(100), @(100), @(50)];
        
        for (int i=0; i<IDArray.count; i++) {
            ColumnEntity * entity = [ColumnEntity new];
            entity.uuid      = [self getUUID];
            entity.type      = ColumnTypeFolder;
            
            entity.sort      = i;
            entity.columnID  = IDArray[i];
            entity.tip       = tipArray[i];
            entity.title     = titleArray[i];
            entity.width     = [widthArray[i] intValue];
            entity.miniWidth = [miniWidthArray[i] intValue];
            
            [_columnFolderArray addObject:entity];
            [PDB addEntity:entity];
        }
    }
}

- (void)updateMoveFolderArrayWith:(MoveTagEntity *)entity {
    if (entity) {
        _folderEntityArray = [PDB arrayClass:[MoveFolderEntity class] where:TagIDKey equal:entity.tagID orderBy:SortKey asc:YES];
        
    }else{
        [_folderEntityArray removeAllObjects];
    }
    
}

#pragma mark - VCDataSource
- (void)addMoveTagTitle:(NSString *)title {
    MoveTagEntity * entity = [MoveTagEntity new];
    entity.sort  = _tagEntityArray.count + 1;
    entity.tagID = [self getUUID];
    entity.title = title;
    entity.color = @"000000";
    
    [_tagEntityArray addObject:entity];
    [PDB addEntity:entity];
}

- (void)deleteTagEntity:(MoveTagEntity *)entity {
    [PDB deleteEntity:entity where:TagIDKey];
    [PDB deleteClass:[MoveFolderEntity class] where:TagIDKey equal:entity.tagID];
}

- (void)addNewPath:(NSString *)path tagID:(NSString *)tagID {
    MoveFolderEntity * entity = [MoveFolderEntity new];
    entity.sort       = self.folderEntityArray.count + 1;
    entity.folderID   = [self getUUID];
    entity.tagID      = tagID;
    entity.originPath = path;
    entity.targetPath = @"转移地址";
    entity.move       = YES;
    entity.tip        = @"备注信息";
    
    [self.folderEntityArray addObject:entity];
    [PDB addEntity:entity];
}

- (NSString *)getUUID {
    CFUUIDRef uuidObj = CFUUIDCreate(nil);
    NSString  * uuidString = (__bridge NSString*)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    return uuidString;
}

- (void)deleteEntity:(MoveFolderEntity *)entity {
    [PDB deleteEntity:entity where:FolderIDKey];
}

- (void)updateTagEntity:(MoveTagEntity *)entity title:(NSString *)title {
    [PDB updateEntity:entity key:@"title" equal:title where:TagIDKey];
}

- (void)updateEntity:(MoveFolderEntity *)entity move:(BOOL)move {
    [PDB updateEntity:entity key:@"move" equal:@(move) where:FolderIDKey];
}

- (void)updateEntity:(MoveFolderEntity *)entity tip:(NSString *)tip {
    [PDB updateEntity:entity key:@"tip" equal:tip where:FolderIDKey];
}

- (void)updateEntity:(MoveFolderEntity *)entity originPath:(NSString *)originPath {
    [PDB updateEntity:entity key:@"originPath" equal:originPath where:FolderIDKey];
}

- (void)updateEntity:(MoveFolderEntity *)entity targetPath:(NSString *)targetPath {
    [PDB updateEntity:entity key:@"targetPath" equal:targetPath where:FolderIDKey];
}

@end
