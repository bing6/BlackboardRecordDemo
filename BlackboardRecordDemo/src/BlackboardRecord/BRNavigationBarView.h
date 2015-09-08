//
//  BRNavigationBarView.h
//  BlackboardRecordDemo
//
//  Created by bing.hao on 15/9/7.
//  Copyright (c) 2015年 bing.hao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BRNavigationBarView : UIView

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UIButton *amplifierBoardButton;
@property (nonatomic, strong) UIButton *paletteButton;
@property (nonatomic, strong) UIButton *eraserButton;
@property (nonatomic, strong) UIButton *recordButton;
@property (nonatomic, strong) UIButton *sendButton;

- (void)setTimeValue:(CGFloat)time;

@end
