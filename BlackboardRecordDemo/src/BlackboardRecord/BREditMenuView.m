//
//  KDAlertEditView.m
//  KDFuDao
//
//  Created by bing.hao on 14-8-6.
//  Copyright (c) 2014年 bing.hao. All rights reserved.
//

#import "BREditMenuView.h"

@implementation BREditMenuView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.frame = CGRectMake(0, 0, 191, 55);
        
//        [UIView fillBackgroundWithTarget:self withName:@"bg_editor"];
        
        UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_editor"]];
        
        [self addSubview:imageView];
        
        UIButton * button1 = [[UIButton alloc] init];
        
        [button1 setTag:1];
        [button1 setFrame:CGRectMake(((191 / 2) - 100) / 2, 12, 100, 40)];
        [button1 setImage:[UIImage imageNamed:@"btn_-editor"] forState:UIControlStateNormal];
        [button1 setImage:[UIImage imageNamed:@"st_btn_-editor"] forState:UIControlStateHighlighted];
        [button1 setTitle:@"编辑" forState:UIControlStateNormal];
        [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button1 setTitleColor:RGBA(44, 209, 202, 1) forState:UIControlStateHighlighted];
        [button1.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
        [button1 setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        [button1 addTarget:self action:@selector(buttonHandler:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button1];
        
        UIButton * button2 = [[UIButton alloc] init];
        
        [button2 setTag:2];
        [button2 setFrame:CGRectMake((((191 / 2) - 100) / 2) + (191 / 2), 12, 100, 40)];
        [button2 setImage:[UIImage imageNamed:@"btn_-Delete"] forState:UIControlStateNormal];
        [button2 setImage:[UIImage imageNamed:@"st_btn_-Delete"] forState:UIControlStateHighlighted];
        [button2 setTitle:@"删除" forState:UIControlStateNormal];
        [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button2 setTitleColor:RGBA(44, 209, 202, 1) forState:UIControlStateHighlighted];
        [button2.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
        [button2 setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        [button2 addTarget:self action:@selector(buttonHandler:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button2];
        
        //- (void)alertColorView:(id)view atIndex:(NSInteger)index;
    }
    return self;
}

- (void)buttonHandler:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(editMenuView:atIndex:)]) {
        [self.delegate editMenuView:sender atIndex:[sender tag]];
    }
}

@end
