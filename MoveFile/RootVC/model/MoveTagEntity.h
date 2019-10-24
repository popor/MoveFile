//
//  MoveTagEntity.h
//  MoverCode
//
//  Created by apple on 2018/3/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * TagIDKey    = @"tagID";
static NSString * SortKey     = @"sort";

@interface MoveTagEntity : NSObject

@property (nonatomic        ) NSInteger sort;
@property (nonatomic, strong) NSString * tagID;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * color;


@end
