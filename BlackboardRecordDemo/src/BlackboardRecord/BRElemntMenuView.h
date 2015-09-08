//
//  AlertElemntView.h
//  KDFuDao
//
//  Created by bing.hao on 14-6-4.
//  Copyright (c) 2014年 bing.hao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BRElemntMenuViewDelegate <NSObject>

- (void)elementMenuView:(id)view atIndex:(NSInteger)index;

@end

@interface BRElemntMenuView : UIView

@property (nonatomic, weak) UIButton * addImgButton;
@property (nonatomic, weak) UIButton * addPicButton;
@property (nonatomic, weak) UIButton * addCameraButton;
@property (nonatomic, weak) UIButton * addPrevButton;
@property (nonatomic, weak) UIButton * addNextButton;

@property (nonatomic, weak) id<BRElemntMenuViewDelegate> delegate;

@end
