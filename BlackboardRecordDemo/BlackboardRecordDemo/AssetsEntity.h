//
//  AssetsEntity.h
//  BlackboardRecordDemo
//
//  Created by bing.hao on 15/9/9.
//  Copyright (c) 2015年 bing.hao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDBDataTable/FMDTObject.h>

@interface AssetsEntity : FMDTObject

@property (nonatomic, strong) NSString *assetsId;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *videoPath;
@property (nonatomic, strong) NSString *imagePath;
@property (nonatomic, assign) double    duration;
@property (nonatomic, assign) double createdAt;

@end
