//
//  BRDrawView.h
//  BlackboardRecordDemo
//
//  Created by bing.hao on 15/9/7.
//  Copyright (c) 2015年 bing.hao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRDrawManager.h"

@protocol BRDrawViewDelegate;

@interface BRDrawView : UIImageView

@property (nonatomic, weak) id<BRDrawViewDelegate> delegate;

- (void)updateLastPathCacheImage;
- (void)updateCacheImage:(BOOL)redraw;
- (void)clear;

@end

@protocol BRDrawViewDelegate <NSObject>

@optional
- (void)drawView:(BRDrawView *)view beginDrawUsingTool:(id<BRDrawTools>)tools;
- (void)drawView:(BRDrawView *)view endDrawUsingTool:(id<BRDrawTools>)tools;

@end
