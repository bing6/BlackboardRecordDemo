//
//  AssetsEntity.h
//  BlackboardRecordDemo
//
//  Created by bing.hao on 15/9/9.
//  Copyright (c) 2015年 bing.hao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDBDataTable/FMDataTable+Query.h>

@interface AssetsEntity : FMDataTable

@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *videoPath;
@property (nonatomic, strong) NSString *imagePath;
@property (nonatomic, assign) double    duration;

@end
