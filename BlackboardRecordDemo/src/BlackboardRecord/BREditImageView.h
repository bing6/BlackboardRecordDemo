//
//  EditImageView.h
//  KDFuDao
//
//  Created by bing.hao on 14-6-3.
//  Copyright (c) 2014年 bing.hao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BREditImageView : UIView

@property (nonatomic, strong) UIImageView * imageView;

@property (nonatomic, assign) BOOL edit;

- (id)initWithImage:(UIImage *)image;

@end
