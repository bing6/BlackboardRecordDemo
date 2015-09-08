//
//  AlertElemntView.m
//  KDFuDao
//
//  Created by bing.hao on 14-6-4.
//  Copyright (c) 2014年 bing.hao. All rights reserved.
//

#import "BRElemntMenuView.h"

@implementation BRElemntMenuView

- (id)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, 134, 236 - 90);
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 6.f;
        
        UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_Add"]];
        
        [self addSubview:imageView];
        
        UIButton * button0 = [[UIButton alloc] initWithFrame:CGRectMake(12, 15, 100, 40)];
        
        [button0 setImage:[UIImage imageNamed:@"btn_fpho.png"] forState:UIControlStateNormal];
        [button0 setImage:[UIImage imageNamed:@"st_btn_fpho.png"] forState:UIControlStateHighlighted];
        [button0 setTitle:@"辅导图片" forState:UIControlStateNormal];
        [button0 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button0 setTitleColor:RGBA(44, 209, 202, 1) forState:UIControlStateHighlighted];
        [button0.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
        [button0 setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        [button0 addTarget:self action:@selector(buttonClickHandler:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button0];
        
        
        UIButton * button1 = [[UIButton alloc] initWithFrame:CGRectMake(12, 56, 100, 40)];
        
        [button1 setImage:[UIImage imageNamed:@"btn_-Add-photos"] forState:UIControlStateNormal];
        [button1 setImage:[UIImage imageNamed:@"st_btn_-Add-photos"] forState:UIControlStateHighlighted];
        [button1 setTitle:@"添加照片" forState:UIControlStateNormal];
        [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button1 setTitleColor:RGBA(44, 209, 202, 1) forState:UIControlStateHighlighted];
        [button1.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
        [button1 setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        [button1 addTarget:self action:@selector(buttonClickHandler:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button1];
        
        UIButton * button2 = [[UIButton alloc] initWithFrame:CGRectMake(12, 100, 100, 40)];
        
        [button2 setImage:[UIImage imageNamed:@"btn_camera"] forState:UIControlStateNormal];
        [button2 setImage:[UIImage imageNamed:@"st_btn_camera"] forState:UIControlStateHighlighted];
        [button2 setTitle:@"相机拍摄" forState:UIControlStateNormal];
        [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button2 setTitleColor:RGBA(44, 209, 202, 1) forState:UIControlStateHighlighted];
        [button2.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
        [button2 setTitleEdgeInsets:UIEdgeInsetsMake(5, 5, 0, 0)];
        [button2 addTarget:self action:@selector(buttonClickHandler:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button2];
        
//        UIButton * button3 = [[UIButton alloc] initWithFrame:CGRectMake(10, 148, 100, 40)];
//        
//        [button3 setImage:[UIImage imageNamed:@"btn_ext-page"] forState:UIControlStateNormal];
//        [button3 setImage:[UIImage imageNamed:@"st_btn_ext-page"] forState:UIControlStateHighlighted];
//        [button3 setTitle:@"前翻一页" forState:UIControlStateNormal];
//        [button3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [button3 setTitleColor:rgba(44, 209, 202, 1) forState:UIControlStateHighlighted];
//        [button3.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
//        [button3 setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
////        [button3 setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
//        [button3 addTarget:self action:@selector(buttonClickHandler:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:button3];
//        
//        UIButton * button4 = [[UIButton alloc] initWithFrame:CGRectMake(10, 193, 100, 40)];
//        
//        [button4 setImage:[UIImage imageNamed:@"btn_On-one-page"] forState:UIControlStateNormal];
//        [button4 setImage:[UIImage imageNamed:@"st_btn_On-one-page"] forState:UIControlStateHighlighted];
//        [button4 setTitle:@"后翻一页" forState:UIControlStateNormal];
//        [button4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [button4 setTitleColor:rgba(44, 209, 202, 1) forState:UIControlStateHighlighted];
//        [button4.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
//        [button4 setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
////        [button4 setImageEdgeInsets:UIEdgeInsetsMake(0, 0.5, 0, 0)];
//        [button4 addTarget:self action:@selector(buttonClickHandler:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:button4];
        
        self.addImgButton    = button0;
        self.addPicButton    = button1;
        self.addCameraButton = button2;
//        self.addPrevButton   = button3;
//        self.addNextButton   = button4;
        
    }
    return self;
}

- (void)buttonClickHandler:(id)sender
{
    NSInteger index = -1;
    
    if ([sender isEqual:self.addImgButton]) {
        index = 0;
    }
    if ([sender isEqual:self.addPicButton]) {
        index = 1;
    }
    if ([sender isEqual:self.addCameraButton]) {
        index = 2;
    }
    if ([sender isEqual:self.addPrevButton]) {
        index = 3;
    }
    if ([sender isEqual:self.addNextButton]) {
        index = 4;
    }
    
    [self.delegate elementMenuView:self atIndex:index];
}




@end
