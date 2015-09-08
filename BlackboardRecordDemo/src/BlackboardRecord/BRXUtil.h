//
//  XUtil.h
//  KDFuDao
//
//  Created by bing.hao on 14-6-11.
//  Copyright (c) 2014年 bing.hao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface BRXUtil : NSObject

+ (void)createCacheDirectory;
+ (void)clearCacheDirectory;

//+ (void)mergerWithOutputPath:(NSString *)outpuntPath
//                   tbumbnail:(NSString *)tbumbnai
//               audioFileName:(NSString *)afn
//                      sucess:(void (^)(void))scallback
//                      failer:(void (^)(NSError *))fcallback;

+ (void)mergerWithOutputPath:(NSString *)outpuntPath
                   tbumbnail:(NSString *)tbumbnail
                      sucess:(void(^)(void))scallback
                      failer:(void(^)(NSError * error))fcallback;
@end
