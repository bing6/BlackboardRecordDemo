//
//  AmplifierBoardView.m
//  BlackboardRecordDemo
//
//  Created by bing.hao on 15/9/8.
//  Copyright (c) 2015年 bing.hao. All rights reserved.
//

#import "BRAmplifierBoardView.h"

@interface BRAmplifierBoardView ()<BRDrawViewDelegate>
{
    BRPageView *_page;
}

@end

@implementation BRAmplifierBoardView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.radius          = 3;
        self.borderWidth     = 1;
        self.borderColor     = [UIColor clearColor];
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:[self redButton]];
        [self addSubview:[self blueButton]];
        [self addSubview:[self blackButton]];
        [self addSubview:[self eraserButton]];
        [self addSubview:[self moveButton]];
        
        KS_WS(ws);
        
        [self.redButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws);
            make.left.equalTo(ws).offset(5);
            make.size.mas_equalTo(CGSizeMake(30, 40));
        }];
        [self.blueButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws);
            make.left.equalTo(ws.redButton.mas_right).offset(5);
            make.size.mas_equalTo(CGSizeMake(30, 40));
        }];
        [self.blackButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws);
            make.left.equalTo(ws.blueButton.mas_right).offset(5);
            make.size.mas_equalTo(CGSizeMake(30, 40));
        }];
        [self.eraserButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws);
            make.left.equalTo(ws.blackButton.mas_right).offset(5);
            make.size.mas_equalTo(CGSizeMake(30, 40));
        }];
        [self.moveButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws);
            make.right.equalTo(ws).offset(-5);
            make.size.mas_equalTo(CGSizeMake(30, 40));
        }];
        
        [DMShared addListeningPropertyChange:self target:@selector(recvNotificationHandler:)];
        [KS_NOTIC_CENTER addObserver:self selector:@selector(recvNotificationHandler:) name:PV_NOTIFICATION_CHANGE_EDIT object:nil];
    }
    return self;
}

- (void)dealloc
{
    [KS_NOTIC_CENTER removeObserver:self name:PV_NOTIFICATION_CHANGE_EDIT object:nil];
    [DMShared removeListening:self];
}

#pragma mark -

- (void)refreshBlackboardImageViews
{
    [_page.pictureView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    [_inView.pictureView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSData      *data    = [NSKeyedArchiver archivedDataWithRootObject:obj];
        UIImageView *newView = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [_page.pictureView addSubview:newView];
    }];
}

#pragma mark -

- (void)recvNotificationHandler:(NSNotification *)sender
{
    if ([[sender name] isEqualToString:PV_NOTIFICATION_CHANGE_EDIT]) {
        if ([sender.object isEqual:self.inView]) {
            [self refreshBlackboardImageViews];
        }
    } else if ([[sender name] isEqualToString:DM_NOTIFICATION_LINE_WIDTH]) {
        self.eraserButton.selected = NO;
    } else if ([[sender name] isEqualToString:DM_NOTIFICATION_LINE_COCOR]) {
        self.eraserButton.selected = NO;
        if ([[DMShared lineColor] isEqual:kDM_COLOR_RED]) {
            self.redButton.selected    = YES;
            self.blueButton.selected   = NO;
            self.blackButton.selected  = NO;
        } else if ([[DMShared lineColor] isEqual:kDM_COLOR_BLUE]) {
            self.redButton.selected    = NO;
            self.blueButton.selected   = YES;
            self.blackButton.selected  = NO;
        } else if ([[DMShared lineColor] isEqual:kDM_COLOR_BLACK]) {
            self.redButton.selected    = NO;
            self.blueButton.selected   = NO;
            self.blackButton.selected  = YES;
        } else {
            self.redButton.selected    = NO;
            self.blueButton.selected   = NO;
            self.blackButton.selected  = NO;
        }
    } else if ([[sender name] isEqualToString:DM_NOTIFICATION_TYPE]) {
        if (DMShared.type == BRDrawToolsTypePen) {
            self.eraserButton.selected = NO;
            if ([[DMShared lineColor] isEqual:kDM_COLOR_RED]) {
                self.redButton.selected    = YES;
                self.blueButton.selected   = NO;
                self.blackButton.selected  = NO;
            } else if ([[DMShared lineColor] isEqual:kDM_COLOR_BLUE]) {
                self.redButton.selected    = NO;
                self.blueButton.selected   = YES;
                self.blackButton.selected  = NO;
            } else if ([[DMShared lineColor] isEqual:kDM_COLOR_BLACK]) {
                self.redButton.selected    = NO;
                self.blueButton.selected   = NO;
                self.blackButton.selected  = YES;
            } else {
                self.redButton.selected    = NO;
                self.blueButton.selected   = NO;
                self.blackButton.selected  = NO;
            }
        } else {
            self.eraserButton.selected = YES;
            self.redButton.selected    = NO;
            self.blueButton.selected   = NO;
            self.blackButton.selected  = NO;
        }
    }
}

#pragma mark -

- (void)didMoveToSuperview
{
    if (self.superview) {
        KS_WS(ws);
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(ws.superview);
            make.left.equalTo(ws.superview);
            make.right.equalTo(ws.superview);
            make.height.mas_equalTo(@188);
        }];
    }
}

- (void)setInView:(BRPageView *)inView
{
    if (_inView) {
        _inView.drawView.delegate = nil;
    }
    
    _inView = inView;
    _inView.drawView.delegate = self;
    
    if (_page) {
        [_page removeFromSuperview];
        _page = nil;
    }
    
    if (_inView == nil) {
        return;
    }
    
    _page = [BRPageView new];
    _page.borderColor = RGB(188, 186, 186);
    _page.borderWidth = 1;
    _page.layer.masksToBounds = YES;
    _page.x = 5;
    _page.y = 41;
    _page.width = KS_SCREEN_WIDTH - 10;
    _page.height = 142;
    _page.scrollEnabled         = NO;
    _page.zoomState             = YES;
    _page.zoomScale             = 4.0f;
    _page.contentOffset         = CGPointZero;
    _page.drawView.delegate  = self;
    _page.pinchGestureRecognizer.enabled = NO;
    _page.panGestureRecognizer.enabled = NO;
    
    [self addSubview:_page];
    
    id paths = [_inView.drawView valueForKey:@"pathArray"];
    
    [_page.drawView setValue:paths forKey:@"pathArray"];
    [_page.drawView updateCacheImage:YES];
    [self refreshBlackboardImageViews];
}

#pragma mark -

- (UIButton *)createColorButton:(UIColor *)color
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setImage:[UIImage imageNamed:@"btn_Pencil.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"st_btn_Pencil.png"] forState:UIControlStateHighlighted];
    [button setImage:[UIImage imageNamed:@"st_btn_Pencil.png"] forState:UIControlStateSelected];
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = color;
    
    [button addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(button).offset(-8);
        make.left.equalTo(button).offset(4);
        make.right.equalTo(button).offset(-4);
        make.height.mas_equalTo(@3);
    }];
    
    return button;
}

- (UIButton *)redButton
{
    if (!_redButton) {
        _redButton = [self createColorButton:kDM_COLOR_RED];
        _redButton.selected = YES;
    }
    return _redButton;
}

- (UIButton *)blueButton
{
    if (!_blueButton) {
        _blueButton = [self createColorButton:kDM_COLOR_BLUE];
    }
    return _blueButton;
}

- (UIButton *)blackButton
{
    if (!_blackButton) {
        _blackButton = [self createColorButton:kDM_COLOR_BLACK];
    }
    return _blackButton;
}

- (UIButton *)eraserButton
{
    if (!_eraserButton) {
        _eraserButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_eraserButton setImage:[UIImage imageNamed:@"btn_Rubber.png"] forState:UIControlStateNormal];
        [_eraserButton setImage:[UIImage imageNamed:@"st_btn_Rubber.png"] forState:UIControlStateHighlighted];
        [_eraserButton setImage:[UIImage imageNamed:@"st_btn_Rubber.png"] forState:UIControlStateSelected];
    }
    return _eraserButton;
}

- (UIButton *)moveButton
{
    if (!_moveButton) {
        _moveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moveButton setImage:[UIImage imageNamed:@"icon-right.png"] forState:UIControlStateNormal];
        [_moveButton setImage:[UIImage imageNamed:@"icon-right.png"] forState:UIControlStateHighlighted];
    }
    return _moveButton;
}

#pragma mark - BRDrawViewDelegate

- (void)drawView:(BRDrawView *)view beginDrawUsingTool:(id<BRDrawTools>)tools
{

}

- (void)drawView:(BRDrawView *)view endDrawUsingTool:(id<BRDrawTools>)tools
{
    NSArray *paths = [view valueForKey:@"pathArray"];
    BRDrawView *target = nil;
    if ([view isEqual:_page.drawView]) {
        target = self.inView.drawView;
    } else {
        target = _page.drawView;
    }
    [target setValue:paths forKey:@"pathArray"];
    [target updateLastPathCacheImage];
    [target setNeedsDisplay];
}

#pragma mark -

- (void)setScale:(CGFloat)scale offsetPoint:(CGPoint)point
{
    _page.zoomScale = scale;
    [self setOffset:point];
}

- (void)setOffset:(CGPoint)point
{
    CGPoint inViewPoint = self.inView.contentOffset;
    CGFloat scal = _page.zoomScale;
    CGPoint movePoint = CGPointMake((point.x + inViewPoint.x) * scal, (point.y + inViewPoint.y) * scal);
    
    _page.contentOffset = movePoint;
}

@end
