//
//  BRPageView.h
//  BlackboardRecordDemo
//
//  Created by bing.hao on 15/9/8.
//  Copyright (c) 2015年 bing.hao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRDrawView.h"

#define PV_NOTIFICATION_CHANGE_EDIT @"__PV_NOTIFICATION_CHANGE_EDIT"

@interface BRPageView : UIScrollView

@property (nonatomic, assign) BOOL zoomState;

@property (nonatomic, readonly) BRDrawView *drawView;
@property (nonatomic, readonly) UIView *pictureView;

@property (nonatomic, assign) BOOL editing;

/**
 * @brief 添加一张图片
 */
- (void)addImageAndEditing:(UIImage *)image;
/**
 * @brief 删除当前选中图片
 */
- (void)removeSelectedImageView;
/**
 * @brief 判断当前点是否包含图片，如果包含就选中
 */
- (BOOL)findImageAndSelected:(CGPoint)point;

@end
