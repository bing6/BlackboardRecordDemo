//
//  AlertColorView.m
//  KDFuDao
//
//  Created by bing.hao on 14-6-5.
//  Copyright (c) 2014年 bing.hao. All rights reserved.
//

#import "BRColorMenuView.h"

@implementation BRColorMenuView

- (id)init
{
    self = [super init];
    if (self) {
        
        self.frame = CGRectMake(0, 0, 134, 146);
        
        UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_Paint-brush"]];
        
        [self addSubview:imageView];

        
        [self addColorButtonWithTag:700 point:CGPointMake(7.5, 24) bgColor:kDM_COLOR_RED];
        [self addColorButtonWithTag:701 point:CGPointMake(39.5, 24) bgColor:kDM_COLOR_BLUE];
        [self addColorButtonWithTag:702 point:CGPointMake(71.5, 24) bgColor:kDM_COLOR_BLACK];
        [self addColorButtonWithTag:703 point:CGPointMake(103.5, 24) bgColor:kDM_COLOR_GREEN];
        [self addColorButtonWithTag:704 point:CGPointMake(7.5, 68) bgColor:kDM_COLOR_LIGHTBLUE];
        [self addColorButtonWithTag:705 point:CGPointMake(39.5, 68) bgColor:kDM_COLOR_LIGHTGREEN];
        [self addColorButtonWithTag:706 point:CGPointMake(71.5, 68) bgColor:kDM_COLOR_PINK];
        [self addColorButtonWithTag:707 point:CGPointMake(103.5, 68) bgColor:kDM_COLOR_YELLOW];
        
        [self selectColorButtonWithColor:[DMShared lineColor]];
        
        UIButton * button1 = [UIButton new];
        
        [button1 setSelected:YES];
        [button1 setTag:801];
        [button1 setFrame:CGRectMake(7.5, 112, 54, 22)];
        [button1 setImage:[UIImage imageNamed:@"Fine-pen"] forState:UIControlStateNormal];
        [button1 setImage:[UIImage imageNamed:@"st_Fine-pen"] forState:UIControlStateHighlighted];
        [button1 setImage:[UIImage imageNamed:@"st_Fine-pen"] forState:UIControlStateSelected];
        [button1 addTarget:self action:@selector(widthButtonClickHandler:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button1];
        
        UIButton * button2 = [UIButton new];
        
        [button2 setTag:802];
        [button2 setFrame:CGRectMake(72.5, 112, 54, 22)];
        [button2 setImage:[UIImage imageNamed:@"Thick-pen"] forState:UIControlStateNormal];
        [button2 setImage:[UIImage imageNamed:@"st_Thick-pen"] forState:UIControlStateHighlighted];
        [button2 setImage:[UIImage imageNamed:@"st_Thick-pen"] forState:UIControlStateSelected];
        [button2 addTarget:self action:@selector(widthButtonClickHandler:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button2];
        
        if (kDM_WIDTH_THICK == [DMShared lineWidth]) {
            button1.selected = NO;
            button2.selected = YES;
        } else {
            button1.selected = YES;
            button2.selected = NO;
        }
    }
    return self;
}

- (void)addColorButtonWithTag:(NSInteger)tag point:(CGPoint)p bgColor:(UIColor *)color
{
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(p.x, p.y, 22, 22)];
    
    button.tag = tag;
    button.backgroundColor = color;
    
    [button addTarget:self action:@selector(colorButtonClickHandler:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:button];
}

- (void)colorButtonClickHandler:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(colorMenuView:selectColor:)]) {
        [self.delegate colorMenuView:self selectColor:[sender backgroundColor]];
    }
}

- (void)widthButtonClickHandler:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(colorMenuView:selectWidth:)]) {
        [self.delegate colorMenuView:self selectWidth:sender.tag == 801 ? kDM_WIDTH_FINE : kDM_WIDTH_THICK];
    }
}

- (void)selectColorButtonWithColor:(UIColor *)color
{
    for (int i = 700; i < 708; i++) {
        
        UIButton * button = (UIButton *)[self viewWithTag:i];
        button.layer.borderWidth = 0;
        
        if ([button.backgroundColor isEqual:color]) {
            
            button.layer.borderWidth   = 2;
            button.layer.borderColor   = [UIColor whiteColor].CGColor;
            button.layer.masksToBounds = YES;
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
