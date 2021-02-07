//
//  NSFont+pSize.m
//  PvtMac
//
//  Created by popor on 2021/2/2.
//  Copyright © 2021 popor. All rights reserved.
//

#import "NSFont+pSize.h"

@implementation NSFont (pSize)

- (CGFloat)lineHeight {
    return ceilf(self.ascender + ABS(self.descender) + self.leading);
}

@end
