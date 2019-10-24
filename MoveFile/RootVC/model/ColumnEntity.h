//
//  ColumnEntity.h
//  MoverCode
//
//  Created by apple on 2018/3/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * ColumnTypeTag    = @"tag";
static NSString * ColumnTypeFolder = @"folder";

static NSInteger ColumnTagMiniWidth = 100;

@interface ColumnEntity : NSObject

@property (nonatomic, strong) NSString * uuid;
@property (nonatomic, strong) NSString * type;
@property (nonatomic        ) NSInteger  sort;

@property (nonatomic, strong) NSString * columnID;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * tip;
@property (nonatomic        ) NSInteger  width;
@property (nonatomic        ) NSInteger  miniWidth;

@end
