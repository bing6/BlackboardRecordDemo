//
//  KDAlertEditView.h
//  KDFuDao
//
//  Created by bing.hao on 14-8-6.
//  Copyright (c) 2014年 bing.hao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BREditMenuViewDelegate <NSObject>

- (void)editMenuView:(id)view atIndex:(NSInteger)index;

@end

@interface BREditMenuView : UIView

@property (nonatomic, weak) id<BREditMenuViewDelegate> delegate;

@end
