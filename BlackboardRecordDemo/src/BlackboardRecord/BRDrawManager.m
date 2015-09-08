//
//  BRDrawManager.m
//  BlackboardRecordDemo
//
//  Created by bing.hao on 15/9/8.
//  Copyright (c) 2015年 bing.hao. All rights reserved.
//

#import "BRDrawManager.h"

@implementation BRDrawManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.lineAlpha = 1.0f;
        self.lineColor = kDM_COLOR_RED;
        self.lineWidth = kDM_WIDTH_FINE;
        self.type      = BRDrawToolsTypePen;
    }
    return self;
}

+ (id)shared
{
    static id __object;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __object = [BRDrawManager new];
    });
    return __object;
}

- (void)setLineWidth:(CGFloat)lineWidth
{
    if (_lineWidth != lineWidth) {
        _lineWidth = lineWidth;
        _type = BRDrawToolsTypePen;
        KS_NOTIC_CENTER_POST1(DM_NOTIFICATION_LINE_WIDTH);
    }
}

- (void)setLineAlpha:(CGFloat)lineAlpha
{
    if (_lineAlpha != lineAlpha) {
        _lineAlpha = lineAlpha;
        _type = BRDrawToolsTypePen;
        KS_NOTIC_CENTER_POST1(DM_NOTIFICATION_LINE_ALPHA);
    }
}

- (void)setLineColor:(UIColor *)lineColor
{
    if ([_lineColor isEqual:lineColor] == NO) {
        _lineColor = lineColor;
        _type = BRDrawToolsTypePen;
        KS_NOTIC_CENTER_POST1(DM_NOTIFICATION_LINE_COCOR);
    }
}

- (void)setType:(BRDrawToolsType)type
{
    if (_type != type) {
        _type = type;
        KS_NOTIC_CENTER_POST1(DM_NOTIFICATION_TYPE);
    }
}

- (id<BRDrawTools>)createDrawTools
{
    id<BRDrawTools> dt = nil;
    switch (self.type) {
        case BRDrawToolsTypePen:
        {
            dt = [BRPenDrawTool new];
            [dt setLineWidth:self.lineWidth];
            [dt setLineColor:self.lineColor];
            [dt setLineAlpha:self.lineAlpha];
            break;
        }
        case BRDrawToolsTypeErase:
        {
            dt = [BREraseDrawTool new];
            [dt setLineWidth:20.0f];
            break;
        }
    }
    return dt;
}

- (void)addListeningPropertyChange:(id)obj target:(SEL)target
{
    [KS_NOTIC_CENTER addObserver:obj selector:target name:DM_NOTIFICATION_LINE_WIDTH object:nil];
    [KS_NOTIC_CENTER addObserver:obj selector:target name:DM_NOTIFICATION_LINE_ALPHA object:nil];
    [KS_NOTIC_CENTER addObserver:obj selector:target name:DM_NOTIFICATION_LINE_COCOR object:nil];
    [KS_NOTIC_CENTER addObserver:obj selector:target name:DM_NOTIFICATION_TYPE object:nil];
}

- (void)removeListening:(id)obj
{
    [KS_NOTIC_CENTER removeObserver:obj];
}

@end
