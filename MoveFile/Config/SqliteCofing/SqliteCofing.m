//
//  SqliteCofing.m
//  MoveFile
//
//  Created by apple on 2019/10/25.
//  Copyright © 2019 apple. All rights reserved.
//

#import "SqliteCofing.h"

#import "MoveFolderEntity.h"
#import "MoveTagEntity.h"
#import "ColumnEntity.h"

#import <PoporFMDB/PoporFMDB.h>

static NSString * const WindowFrameKey = @"WindowFrame";

@implementation SqliteCofing

+ (void)updateTable {
    // 更新PoporFMDB
    [PoporFMDB injectTableArray:@[[MoveFolderEntity class], [MoveTagEntity class], [ColumnEntity class]]];
    
}

+ (void)updateWindowFrame:(CGRect)rect {
    [PoporFMDB updatePlistKey:WindowFrameKey value:NSStringFromRect(rect)];
}

+ (void)addWindowFrame:(CGRect)rect {
    [PoporFMDB addPlistKey:WindowFrameKey value:NSStringFromRect(rect)];
}

+ (NSString *)getWindowFrame {
    return [PoporFMDB getPlistKey:WindowFrameKey];
}

@end
