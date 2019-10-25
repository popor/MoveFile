//
//  SqlitePrifix.h
//  MoveFile
//
//  Created by apple on 2019/10/25.
//  Copyright © 2019 apple. All rights reserved.
//

#ifndef SqlitePrifix_h
#define SqlitePrifix_h

// MARK: key window
static NSString * const WindowFrameKey = @"WindowFrame";

// MARK: key tv
static NSString * TvColumnId_tag1       = @"tag1";
static NSString * TvColumnTitle_tag1    = @"标签";
static NSString * TvColumnTip_tag1      = @"";

static NSString * TvColumnId_folder0    = @"folder0";
static NSString * TvColumnId_folder1    = @"folder1";
static NSString * TvColumnId_folder2    = @"folder2";
static NSString * TvColumnId_folder3    = @"folder3";
static NSString * TvColumnId_folder4    = @"folder4";

static NSString * TvColumnTitle_folder0 = @"序号";
static NSString * TvColumnTitle_folder1 = @"选择";
static NSString * TvColumnTitle_folder2 = @"源文件或文件夹";
static NSString * TvColumnTitle_folder3 = @"转移到文件夹";
static NSString * TvColumnTitle_folder4 = @"备注";

static NSString * TvColumnTip_folder0   = @"";
static NSString * TvColumnTip_folder1   = @"如果未勾选，转移的时候将忽略该选项";
static NSString * TvColumnTip_folder2   = @"需要转移文件夹的地址";
static NSString * TvColumnTip_folder3   = @"文件夹转移到的地址";
static NSString * TvColumnTip_folder4   = @"描述信息";


#endif /* SqlitePrifix_h */
