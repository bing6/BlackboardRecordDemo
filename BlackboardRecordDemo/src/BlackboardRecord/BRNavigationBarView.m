//
//  BRNavigationBarView.m
//  BlackboardRecordDemo
//
//  Created by bing.hao on 15/9/7.
//  Copyright (c) 2015年 bing.hao. All rights reserved.
//

#import "BRNavigationBarView.h"
#import "BRDrawManager.h"

#define i1   @"btn_back.png"
#define i2_1 @"btn_photo.png"
#define i2_2 @"st_btn_photo.png"
#define i3_1 @"btn_Whiteboard.png"
#define i3_2 @"st_btn_Whiteboard.png"
#define i4_1 @"btn_Pencil.png"
#define i4_2 @"st_btn_Pencil.png"
#define i5_1 @"btn_Rubber.png"
#define i5_2 @"st_btn_Rubber.png"
#define i6_1 @"btn_time2.png"
#define i6_2 @"btn_time3.png"

#define BH 44
#define BW 38

@interface BRNavigationBarView ()

@property (nonatomic, strong) UIView  *colorView;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation BRNavigationBarView

//@synthesize backButton           = _backButton;
//@synthesize addButton            = _addButton;
//@synthesize amplifierBoardButton = _amplifierBoardButton;
//@synthesize paletteButton        = _paletteButton;
//@synthesize eraserButton         = _eraserButton;
//@synthesize recordButton         = _recordButton;
//@synthesize sendButton           = _sendButton;

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
    self.backgroundColor = RGB(249, 249, 249);
    
    [self addSubview:[self backButton]];
    [self addSubview:[self addButton]];
    [self addSubview:[self amplifierBoardButton]];
    [self addSubview:[self paletteButton]];
    [self addSubview:[self eraserButton]];
    [self addSubview:[self recordButton]];
    [self addSubview:[self sendButton]];
    [self addSubview:[self timeLabel]];
    [self addSubview:[self colorView]];
    
    KS_WS(ws);
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(ws);
        make.left.equalTo(ws).offset(5);
        make.size.mas_equalTo(CGSizeMake(30, BH));
    }];
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(ws);
        make.left.equalTo(ws.backButton.mas_right).offset(5);
        make.size.mas_equalTo(CGSizeMake(BW, BH));
    }];
    [self.amplifierBoardButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(ws);
        make.left.equalTo(ws.addButton.mas_right).offset(5);;
        make.size.mas_equalTo(CGSizeMake(BW, BH));
    }];
    [self.paletteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(ws);
        make.left.equalTo(ws.amplifierBoardButton.mas_right).offset(5);;
        make.size.mas_equalTo(CGSizeMake(BW, BH));
    }];
    [self.eraserButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(ws);
        make.left.equalTo(ws.paletteButton.mas_right).offset(5);;
        make.size.mas_equalTo(CGSizeMake(BW, BH));
    }];
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(ws);
        make.right.equalTo(ws).offset(-5);;
        make.size.mas_equalTo(CGSizeMake(44, BH));
    }];
    [self.recordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(ws);
        make.right.equalTo(ws.sendButton.mas_left).offset(-5);;
        make.size.mas_equalTo(CGSizeMake(58, BH));
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ws.recordButton);
        make.left.equalTo(ws.recordButton).offset(5);
        make.size.mas_equalTo(CGSizeMake(50, 44));
    }];
    [self.colorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.paletteButton);
        make.centerY.equalTo(ws.paletteButton).offset(10);
        make.size.mas_equalTo(CGSizeMake(BW - 13, 3));
    }];
    
    
    [DMShared addListeningPropertyChange:self target:@selector(recvNotificationHandler:)];
}

- (void)dealloc
{
    [DMShared removeListening:self];
}

#pragma mark - 

- (void)recvNotificationHandler:(id)sender
{
    if ([[sender name] isEqualToString:DM_NOTIFICATION_LINE_WIDTH]) {
        self.eraserButton.selected = NO;
        self.paletteButton.selected = YES;
    }
    if ([[sender name] isEqualToString:DM_NOTIFICATION_LINE_COCOR]) {
        self.eraserButton.selected = NO;
        self.paletteButton.selected = YES;
        
        self.colorView.backgroundColor = [DMShared lineColor];
    }
    if ([[sender name] isEqualToString:DM_NOTIFICATION_TYPE]) {
        if (DMShared.type == BRDrawToolsTypePen) {
            self.eraserButton.selected = NO;
            self.paletteButton.selected = YES;
        } else {
            self.eraserButton.selected = YES;
            self.paletteButton.selected = NO;
        }
        
    }
}

#pragma mark -

- (void)drawRect:(CGRect)rect
{
    CGRect frame = CGRectMake(0, rect.size.height - SINGLE_LINE_WIDTH, rect.size.width, SINGLE_LINE_WIDTH);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:frame];
    
    [RGB(188, 186, 186) setStroke];
    [path stroke];
}

#pragma mark -

- (UIButton *)createButton:(NSString *)icon1 :(NSString *)icon2 :(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if (icon1) {
        [button setImage:[UIImage imageNamed:icon1] forState:UIControlStateNormal];
    }
    if (icon2) {
        [button setImage:[UIImage imageNamed:icon2] forState:UIControlStateHighlighted];
        [button setImage:[UIImage imageNamed:icon2] forState:UIControlStateSelected];
    }
    if (title)
    {
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:KS_FONT(15)];
    }
    return button;
}

- (UIButton *)backButton
{
    if (!_backButton) {
        _backButton = [self createButton:i1 :nil :nil];
    }
    return _backButton;
}

- (UIButton *)addButton
{
    if (!_addButton) {
        _addButton = [self createButton:i2_1 :i2_2 :nil];
    }
    return _addButton;
}

- (UIButton *)amplifierBoardButton
{
    if (!_amplifierBoardButton) {
        _amplifierBoardButton = [self createButton:i3_1 :i3_2 :nil];
    }
    return _amplifierBoardButton;
}

- (UIButton *)paletteButton
{
    if (!_paletteButton) {
        _paletteButton = [self createButton:i4_1 :i4_2 :nil];
        _paletteButton.selected = YES;
    }
    return _paletteButton;
}

- (UIButton *)eraserButton
{
    if (!_eraserButton) {
        _eraserButton = [self createButton:i5_1 :i5_2 :nil];
    }
    return _eraserButton;
}

- (UIButton *)recordButton
{
    if (!_recordButton) {
        _recordButton = [self createButton:i6_1 :i6_2 :nil];
    }
    return _recordButton;
}

- (UIButton *)sendButton
{
    if (!_sendButton) {
        _sendButton = [self createButton:nil :nil :@"发送"];
    }
    return _sendButton;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.font = KS_FONT(12);
        _timeLabel.text = @"5:00";
    }
    return _timeLabel;
}

- (UIView *)colorView
{
    if (!_colorView) {
        _colorView = [UIView new];
        _colorView.backgroundColor = [DMShared lineColor];
    }
    return _colorView;
}

- (void)didMoveToSuperview
{
    KS_WS(ws);

    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.superview);
        make.left.equalTo(ws.superview);
        make.right.equalTo(ws.superview);
        make.height.mas_equalTo(@64);
    }];
}

#pragma mark -

- (void)setTimeValue:(CGFloat)time
{
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:time];
    NSString *text = [[date description] substringWithRange:NSMakeRange(15, 4)];
    KS_DISPATCH_MAIN_QUEUE(^{
        self.timeLabel.text = text;
    });
}

@end
