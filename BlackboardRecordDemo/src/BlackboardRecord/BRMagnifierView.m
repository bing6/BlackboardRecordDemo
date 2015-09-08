//
//  BRMagnifierView.m
//  BlackboardRecordDemo
//
//  Created by bing.hao on 15/9/8.
//  Copyright (c) 2015年 bing.hao. All rights reserved.
//

#import "BRMagnifierView.h"

@interface BRMagnifierView ()

@property (nonatomic, strong) UIButton * button;

@end

@implementation BRMagnifierView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.frame = CGRectMake(0, 0, kMAGNIFIER_MIN_WIDTH, kMAGNIFIER_MIN_HEIGHT);
        
        self.backgroundColor     = [UIColor clearColor];
        self.layer.masksToBounds = YES;
        self.borderColor         = RGB(70, 208, 201);
        self.borderWidth         = 2;
        self.scal                = (kENLARGE_WIDTH + kENLARGE_HEIGHT) / (self.width + self.height);
        
        [self addSubview:self.button];
        
    }
    return self;
}

- (UIButton *)button
{
    if (!_button) {
        _button = [[UIButton alloc] init];
        
        [_button setFrame:CGRectMake(self.width - 20, self.height - 20, 20, 20)];
        [_button setImage:[UIImage imageNamed:@"btn_Drag"] forState:UIControlStateNormal];
        [_button setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin];
        
        UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandler:)];
        
        [self.button addGestureRecognizer:pan];
    }
    return _button;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    
    _startPoint = [touch locationInView:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    
    _currPoint = [touch locationInView:self.superview];
    
    CGPoint p = CGPointMake(_currPoint.x - _startPoint.x, _currPoint.y - _startPoint.y);
    
    self.x = MIN(KS_SCREEN_WIDTH - self.width, MAX(0, p.x));
    self.y = MIN(KS_SCREEN_WIDTH + 64 - self.height, MAX(64, p.y));
    
    [self.delgate magnifierView:self atMove:CGPointMake(self.x, self.y - 64)];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)panHandler:(UIPanGestureRecognizer *)recognizer
{
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged:
        {
            CGPoint p = [recognizer locationInView:self.superview];
            
            self.width  = MIN(MAX(p.x - self.x, kMAGNIFIER_MIN_WIDTH), kMAGNIFIER_MAX_WIDTH);
            self.height = MIN(MAX(p.y - self.y, kMAGNIFIER_MIN_HEIGHT), kMAGNIFIER_MAX_HEIGHT);
            self.scal   = (kENLARGE_WIDTH + kENLARGE_HEIGHT) / (self.width + self.height);
            
            [self.delgate magnifierView:self scal:self.scal];
            
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            break;
        }
        default:
            break;
    }
    
}

@end
