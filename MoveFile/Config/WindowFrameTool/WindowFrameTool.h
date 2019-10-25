//
//  WindowFrameTool.h
//  MoveFile
//
//  Created by apple on 2019/10/25.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WindowFrameTool : NSObject

+ (instancetype)share;

@property (nonatomic, copy  ) BlockPVoid blockResetWindow;
@property (nonatomic, copy  ) BlockPVoid blockResetTv;

@end

NS_ASSUME_NONNULL_END
