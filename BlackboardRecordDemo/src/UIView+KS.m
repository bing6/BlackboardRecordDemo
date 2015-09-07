//
//  UIView+KS.m
//  KSToolkit
//
//  Created by bing.hao on 14/11/30.
//  Copyright (c) 2014年 bing.hao. All rights reserved.
//

#import "UIView+KS.h"
#import <objc/runtime.h>

@implementation UIView (KS)

#pragma --mark
#pragma --mark x,y,w,h

- (CGFloat)width
{
    return CGRectGetWidth(self.frame);
}

- (void)setWidth:(CGFloat)width
{
    CGRect newfrmae = self.frame;
    
    newfrmae.size.width = width;
    
    self.frame = newfrmae;
}

- (CGFloat)height
{
    return CGRectGetHeight(self.frame);
}

- (void)setHeight:(CGFloat)height
{
    CGRect newframe = self.frame;
    
    newframe.size.height = height;
    
    self.frame = newframe;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)x
{
    CGRect newFrame = self.frame;
    
    newFrame.origin.x = x;
    
    self.frame = newFrame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)y
{
    CGRect newframe = self.frame;
    
    newframe.origin.y = y;
    
    self.frame = newframe;
}

#pragma --mark
#pragma --mark border

- (UIColor *)borderColor
{
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

- (void)setBorderColor:(UIColor *)borderColor
{
    self.layer.borderColor = borderColor.CGColor;
}

- (CGFloat)borderWidth
{
    return self.layer.borderWidth;
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    self.layer.borderWidth = borderWidth;
}

- (CGFloat)radius
{
    return self.layer.cornerRadius;
}

- (void)setRadius:(CGFloat)radius
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius  = radius;
}

#pragma --mark
#pragma --mark Remove all subviews

- (void)removeAllSubviews
{
    while ([self.subviews count]) {
        
        UIView * view = [self.subviews lastObject];
        
        [view removeFromSuperview];
        
        view = nil;
    }
}

@end



















