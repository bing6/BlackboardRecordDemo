//
//  BRMagnifierView.h
//  BlackboardRecordDemo
//
//  Created by bing.hao on 15/9/8.
//  Copyright (c) 2015年 bing.hao. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kENLARGE_HEIGHT (142.0f)
#define kENLARGE_WIDTH  (KS_SCREEN_WIDTH - 10)
#define kMAGNIFIER_MULTIPLE1 4
#define kMAGNIFIER_MULTIPLE2 2
#define kMAGNIFIER_MIN_HEIGHT kENLARGE_HEIGHT / kMAGNIFIER_MULTIPLE1
#define kMAGNIFIER_MIN_WIDTH  kENLARGE_WIDTH / kMAGNIFIER_MULTIPLE1
#define kMAGNIFIER_MAX_HEIGHT kENLARGE_HEIGHT / kMAGNIFIER_MULTIPLE2
#define kMAGNIFIER_MAX_WIDTH  kENLARGE_WIDTH / kMAGNIFIER_MULTIPLE2

@protocol BRMagnifierViewDelegate <NSObject>

- (void)magnifierView:(id)view scal:(float)scal;
- (void)magnifierView:(id)view atMove:(CGPoint)point;

@end

@interface BRMagnifierView : UIView
{
    CGPoint _startPoint;
    CGPoint _currPoint;
}

@property (nonatomic, assign) float scal;
@property (nonatomic, weak) id<BRMagnifierViewDelegate> delgate;

@end
