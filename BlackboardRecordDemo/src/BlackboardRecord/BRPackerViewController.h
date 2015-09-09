//
//  BRPackerViewController.h
//  BlackboardRecordDemo
//
//  Created by bing.hao on 15/9/7.
//  Copyright (c) 2015年 bing.hao. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol BRPackerViewControllerDelegate;

@interface BRPackerViewController : UIViewController

@property (nonatomic, readonly) CGFloat videoDuration;

@property (nonatomic, weak) id<BRPackerViewControllerDelegate> delegate;

@end


@protocol BRPackerViewControllerDelegate <NSObject>

@optional
//取消
- (void)packerViewControllerDidCancel:(BRPackerViewController *)sender;
//完成
- (void)packerViewControllerDidComplete:(BRPackerViewController *)sender
                                  video:(NSString *)vpath
                                  image:(NSString *)ipath;

@end