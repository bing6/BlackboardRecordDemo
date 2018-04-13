//
//  DBSet.m
//  BlackboardRecordDemo
//
//  Created by bing.hao on 2018/4/13.
//  Copyright © 2018年 bing.hao. All rights reserved.
//

#import "DBSet.h"

@implementation DBSet

+ (instancetype)shared {
    static id _staticObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _staticObject = [DBSet new];
    });
    return _staticObject;
}

- (FMDTContext *)assets {
    return [self cacheWithClass:[AssetsEntity class]];
}

@end
