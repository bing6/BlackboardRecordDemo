
//
//  AssetsEntity.m
//  BlackboardRecordDemo
//
//  Created by bing.hao on 15/9/9.
//  Copyright (c) 2015年 bing.hao. All rights reserved.
//

#import "AssetsEntity.h"

@implementation AssetsEntity

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.assetsId = FMDT_UUID();
    }
    return self;
}

@end
