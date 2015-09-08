//
//  AlertColorView.h
//  KDFuDao
//
//  Created by bing.hao on 14-6-5.
//  Copyright (c) 2014年 bing.hao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRDrawManager.h"

@protocol BRColorMenuViewDelegate <NSObject>

- (void)colorMenuView:(id)view selectColor:(UIColor *)color;
- (void)colorMenuView:(id)view selectWidth:(CGFloat)width;

@end


@interface BRColorMenuView : UIView

@property (nonatomic, weak) id<BRColorMenuViewDelegate> delegate;

@end
