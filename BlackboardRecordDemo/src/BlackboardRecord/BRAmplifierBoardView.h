//
//  AmplifierBoardView.h
//  BlackboardRecordDemo
//
//  Created by bing.hao on 15/9/8.
//  Copyright (c) 2015年 bing.hao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRPageView.h"

@interface BRAmplifierBoardView : UIView

@property (nonatomic, weak) BRPageView *inView;

@property (nonatomic, strong) UIButton *redButton;
@property (nonatomic, strong) UIButton *blueButton;
@property (nonatomic, strong) UIButton *blackButton;
@property (nonatomic, strong) UIButton *eraserButton;
@property (nonatomic, strong) UIButton *moveButton;

- (void)setScale:(CGFloat)scale offsetPoint:(CGPoint)point;

- (void)setOffset:(CGPoint)point;

@end
