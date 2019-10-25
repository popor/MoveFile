//
//  NSTextField+Address.m
//  MoveFile
//
//  Created by apple on 2018/3/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "NSTextField+Address.h"
#import <objc/runtime.h>

@implementation NSTextField (Address)
@dynamic weakEntity;


#pragma mark - set get
//- (void)setUuid:(NSString *)uuid {
//    objc_setAssociatedObject(self, @"uuid", uuid, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//
//- (NSString *)uuid {
//    return objc_getAssociatedObject(self, @"uuid");
//}

- (void)setWeakEntity:(id)weakEntity {
    objc_setAssociatedObject(self, @"weakEntity", weakEntity, OBJC_ASSOCIATION_ASSIGN);
}

- (id)weakEntity {
    return objc_getAssociatedObject(self, @"weakEntity");
}

@end
