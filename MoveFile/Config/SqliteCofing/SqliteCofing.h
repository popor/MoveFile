//
//  SqliteCofing.h
//  MoveFile
//
//  Created by apple on 2019/10/25.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SqliteCofing : NSObject

+ (void)updateTable;

+ (void)updateWindowFrame:(CGRect)rect;

+ (void)addWindowFrame:(CGRect)rect;

+ (NSString *)getWindowFrame;

@end

NS_ASSUME_NONNULL_END
