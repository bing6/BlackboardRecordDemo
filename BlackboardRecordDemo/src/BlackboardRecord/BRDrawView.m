//
//  BRDrawView.m
//  BlackboardRecordDemo
//
//  Created by bing.hao on 15/9/7.
//  Copyright (c) 2015年 bing.hao. All rights reserved.
//

#import "BRDrawView.h"

@interface BRDrawView ()

@property (nonatomic, strong) NSMutableArray *pathArray;

@property (nonatomic, strong) id<BRDrawTools> currDT;

//@property (nonatomic, strong) NSMutableArray *bufferArray;

//初始化方法
- (void)myInit;

@end

@implementation BRDrawView


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self myInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self myInit];
    }
    return self;
}

- (void)myInit
{
    self.backgroundColor        = [UIColor clearColor];
    self.userInteractionEnabled = YES;
    
    self.pathArray = [NSMutableArray new];
}

#pragma mark - drawRect

- (void)drawRect:(CGRect)rect
{
    [self.image drawInRect:self.bounds];
}

- (void)updateLastPathCacheImage
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    
    id<BRDrawTools> last = [self.pathArray lastObject];
    
    [self.image drawAtPoint:CGPointZero];
    [last drawing];
    
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (void)updateCacheImage:(BOOL)redraw
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    if (redraw) {
        self.image = nil;
        for (id<BRDrawTools> tool in self.pathArray) {
            [tool drawing];
        }
    } else {
        [self.image drawAtPoint:CGPointZero];
        [self.currDT drawing];
    }
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

#pragma mark - Touches event

- (BOOL)isLongPress:(UITouch *)touch
{
    for (id entry in [touch gestureRecognizers]) {
        if ([entry isMemberOfClass:[UILongPressGestureRecognizer class]]) {
            return YES;
        }
    }
    return NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    if ([self isLongPress:touch] == NO) {
        self.currDT = [DMShared createDrawTools];
        
        [self.pathArray addObject:self.currDT];
        [self.currDT setInitPoint:[touch locationInView:self]];
        
        if ([self.delegate respondsToSelector:@selector(drawView:beginDrawUsingTool:)]) {
            [self.delegate drawView:self beginDrawUsingTool:self.currDT];
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    if ([self isLongPress:touch] == NO) {
        CGPoint curr = [touch locationInView:self];
        CGPoint prev = [touch previousLocationInView:self];
        
        [self.currDT setMovePoint:prev toPoint:curr];
        [self updateCacheImage:NO];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesMoved:touches withEvent:event];
    
    if ([self.delegate respondsToSelector:@selector(drawView:endDrawUsingTool:)]) {
        [self.delegate drawView:self endDrawUsingTool:self.currDT];
    }
    self.currDT = nil;
}

#pragma mark - clear

- (void)clear
{
    [self.pathArray removeAllObjects];
    [self updateCacheImage:YES];
    [self setNeedsDisplay];
}

@end
