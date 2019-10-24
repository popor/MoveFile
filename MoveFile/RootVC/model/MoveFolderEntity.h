//
//  MoveFolderEntity.h
//  MoverCode
//
//  Created by apple on 2018/3/13.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * FolderIDKey = @"folderID";

@interface MoveFolderEntity : NSObject

@property (nonatomic, strong) NSString * tagID;   // 所属tag
@property (nonatomic, strong) NSString * folderID;

@property (nonatomic        ) NSInteger  sort;
@property (nonatomic, strong) NSString * originPath;
@property (nonatomic, strong) NSString * targetPath;
@property (nonatomic, strong) NSString * tip;

@property (nonatomic, getter=isMove) BOOL move;

@end

