//
//  BRDrawManager.h
//  BlackboardRecordDemo
//
//  Created by bing.hao on 15/9/8.
//  Copyright (c) 2015年 bing.hao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BRDrawTools.h"

#define DMShared [BRDrawManager shared]

#define DM_NOTIFICATION_LINE_COCOR @"__DM_NOTIFICATION_LINE_COCOR"
#define DM_NOTIFICATION_LINE_ALPHA @"__DM_NOTIFICATION_LINE_ALPHA"
#define DM_NOTIFICATION_LINE_WIDTH @"__DM_NOTIFICATION_LINE_WIDTH"
#define DM_NOTIFICATION_TYPE       @"__DM_NOTIFICATION_TYPE"

typedef enum {
    BRDrawToolsTypePen,
    BRDrawToolsTypeErase
} BRDrawToolsType;

#define kDM_COLOR_RED        RGBA(252, 68, 30, 1)
#define kDM_COLOR_BLUE       RGBA(22, 127, 251, 1)
#define kDM_COLOR_BLACK      RGBA(49, 49, 49, 1)
#define kDM_COLOR_GREEN      RGBA(34, 146, 23, 1)
#define kDM_COLOR_LIGHTBLUE  RGBA(42, 239, 253, 1)
#define kDM_COLOR_LIGHTGREEN RGBA(120, 253, 75, 1)
#define kDM_COLOR_PINK       RGBA(252, 40, 252, 1)
#define kDM_COLOR_YELLOW     RGBA(255, 253, 57, 1)

#define kDM_WIDTH_FINE  1
#define kDM_WIDTH_THICK 3

@interface BRDrawManager : NSObject

@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) CGFloat lineAlpha;
@property (nonatomic, assign) CGFloat lineWidth;

@property (nonatomic, assign) BRDrawToolsType type;

+ (BRDrawManager *)shared;

- (id<BRDrawTools>)createDrawTools;

- (void)addListeningPropertyChange:(id)obj target:(SEL)target;
- (void)removeListening:(id)obj;

@end
