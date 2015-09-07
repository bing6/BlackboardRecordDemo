//
//  UIView+KS.h
//  KSToolkit
//
//  Created by bing.hao on 14/11/30.
//  Copyright (c) 2014年 bing.hao. All rights reserved.
//

#import <UIKit/UIKit.h>

// View 圆角和加边框
#define KS_VIEW_BORDER_RADIUS(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

// View 圆角
#define KS_VIEW_RADIUS(View, Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]

typedef enum {
    KSVIEW_DRAK_DIRECTION_LEFT,
    KSVIEW_DRAK_DIRECTION_RIGHT,
    KSVIEW_DRAK_DIRECTION_TOP,
    KSVIEW_DRAK_DIRECTION_BOTTOM
} KSVIEW_DRAK_DIRECTION;

@interface UIView (KS)

/**
 * @brief 位置
 */
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

//@property (nonatomic, assign) BOOL    enabledPosition;
//@property (nonatomic, assign) CGFloat top;
//@property (nonatomic, assign) CGFloat bottom;
//@property (nonatomic, assign) CGFloat left;
//@property (nonatomic, assign) CGFloat right;

/**
 * @brief 边框颜色
 */
@property (nonatomic, strong) UIColor * borderColor;
/**
 * @brief 边框宽度
 */
@property (nonatomic, assign) CGFloat   borderWidth;
/**
 * @brief 园角
 */
@property (nonatomic, assign) CGFloat   radius;

/**
 * @brief 删除所有子试图
 */
- (void)removeAllSubviews;


@end
