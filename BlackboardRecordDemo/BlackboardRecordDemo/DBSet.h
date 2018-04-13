//
//  DBSet.h
//  BlackboardRecordDemo
//
//  Created by bing.hao on 2018/4/13.
//  Copyright © 2018年 bing.hao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDBDataTable/FMDTManager.h>
#import "AssetsEntity.h"

@interface DBSet : FMDTManager

@property (nonatomic, strong, readonly) FMDTContext *assets;

@end
