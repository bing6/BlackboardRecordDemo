//
//  BRDrawTools.m
//  BlackboardRecordDemo
//
//  Created by bing.hao on 15/9/8.
//  Copyright (c) 2015年 bing.hao. All rights reserved.
//

#import "BRDrawTools.h"

CGPoint __midPoint(CGPoint p1, CGPoint p2)
{
    return CGPointMake((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5);
}

@implementation BRPenDrawTool

@synthesize lineColor = _lineColor;
@synthesize lineAlpha = _lineAlpha;

- (id)init
{
    self = [super init];
    if (self != nil) {
        self.lineCapStyle = kCGLineCapRound;
    }
    return self;
}

- (void)setInitPoint:(CGPoint)begin
{
    [self moveToPoint:begin];
}

- (void)setMovePoint:(CGPoint)start toPoint:(CGPoint)to
{
    [self addQuadCurveToPoint:__midPoint(to, start) controlPoint:start];
}

- (void)drawing
{
    [self.lineColor setStroke];
    [self strokeWithBlendMode:kCGBlendModeNormal alpha:self.lineAlpha];
}

@end


@implementation BREraseDrawTool

@synthesize lineColor = _lineColor;
@synthesize lineAlpha = _lineAlpha;

- (id)init
{
    self = [super init];
    if (self != nil) {
        self.lineCapStyle = kCGLineCapRound;
    }
    return self;
}

- (void)setInitPoint:(CGPoint)begin
{
    [self moveToPoint:begin];
}

- (void)setMovePoint:(CGPoint)start toPoint:(CGPoint)to
{
    [self addQuadCurveToPoint:__midPoint(to, start) controlPoint:start];
}

- (void)drawing
{
    [self.lineColor setStroke];
    [self strokeWithBlendMode:kCGBlendModeClear alpha:self.lineAlpha];
}

@end