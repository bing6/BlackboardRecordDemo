//
//  BRDrawTools.h
//  BlackboardRecordDemo
//
//  Created by bing.hao on 15/9/8.
//  Copyright (c) 2015年 bing.hao. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol BRDrawTools <NSObject>

@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) CGFloat lineAlpha;
@property (nonatomic, assign) CGFloat lineWidth;

- (void)setInitPoint:(CGPoint)begin;
- (void)setMovePoint:(CGPoint)start toPoint:(CGPoint)to;

- (void)drawing;

@end

#pragma mark -

@interface BRPenDrawTool : UIBezierPath<BRDrawTools>

@end


#pragma mark -

@interface BREraseDrawTool : UIBezierPath<BRDrawTools>

@end