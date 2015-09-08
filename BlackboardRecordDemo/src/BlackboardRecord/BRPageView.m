//
//  BRPageView.m
//  BlackboardRecordDemo
//
//  Created by bing.hao on 15/9/8.
//  Copyright (c) 2015年 bing.hao. All rights reserved.
//

#import "BRPageView.h"
#import "BREditImageView.h"

#define kContentW (KS_SCREEN_WIDTH)
#define kContentH (KS_SCREEN_HEIGHT*2 - 64)
#define kContentSize CGSizeMake(kContentW, kContentH)

@interface BRPageView ()<UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UIImageView *bgView;

@property (nonatomic, strong) BREditImageView *selectedImageView;

@end

@implementation BRPageView

@synthesize drawView = _drawView;
@synthesize pictureView = _pictureView;

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.frame                          = CGRectMake(0, 0, KS_SCREEN_WIDTH, KS_SCREEN_HEIGHT - 64);
        self.multipleTouchEnabled           = NO;
        self.pagingEnabled                  = NO;
        self.maximumZoomScale               = 1.0f;
        self.minimumZoomScale               = 1.0f;
        self.zoomScale                      = 1.0f;
        self.delegate                       = self;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator   = NO;
        self.contentSize                    = kContentSize;
        self.clipsToBounds                  = YES;
        self.pinchGestureRecognizer.delegate  = self;
        
        [self addSubview:self.mainView];
        [self.mainView addSubview:[self bgView]];
        [self.mainView addSubview:[self pictureView]];
        [self.mainView addSubview:[self drawView]];
        
        [self setScrollViewPanFingersNumber:2];
    }
    return self;
}

- (void)setZoomState:(BOOL)zoomState
{
    if ((_zoomState = zoomState)) {
        
        self.multipleTouchEnabled = YES;
        self.maximumZoomScale     = 4.0f;
        self.minimumZoomScale     = 2.0f;
    } else {
        
        self.multipleTouchEnabled = NO;
        self.maximumZoomScale     = 1.0f;
        self.minimumZoomScale     = 1.0f;
    }
}

#pragma mark -

- (UIView *)mainView
{
    if (!_mainView) {
        _mainView = [UIView new];
        _mainView.frame = CGRectMake(0, 0, kContentW, kContentH);
    }
    return _mainView;
}

- (UIImageView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bpv_bg.png"]];
        _bgView.frame = CGRectMake(0, 0, kContentW, kContentH);
    }
    return _bgView;
}

- (UIView *)pictureView
{
    if (!_pictureView) {
        _pictureView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kContentW, kContentH)];
    }
    return _pictureView;
}

- (BRDrawView *)drawView
{
    if (!_drawView) {
        _drawView = [[BRDrawView alloc] initWithFrame:CGRectMake(0, 0, kContentW, kContentH)];
    }
    return _drawView;
}

#pragma mark -

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]]) {
        return NO;
    }
    return YES;
}

- (void)setScrollViewPanFingersNumber:(NSInteger)num
{
    for (UIGestureRecognizer * entry in self.gestureRecognizers) {
        
        if ([entry isKindOfClass:[UIPanGestureRecognizer class]]) {
            UIPanGestureRecognizer *panGR = (UIPanGestureRecognizer *)entry;
            panGR.minimumNumberOfTouches = num;
        }
    }
}

#pragma mark -UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.mainView;
}

#pragma mark - 

- (void)setEditing:(BOOL)editing
{
    if (self.selectedImageView) {
        if ((_editing = editing)) {
            self.drawView.userInteractionEnabled = NO;
            [self.selectedImageView setEdit:YES];
            [self addSubview:self.selectedImageView];
        } else {
            self.drawView.userInteractionEnabled = YES;
            [self.selectedImageView setEdit:NO];
            [self.pictureView addSubview:self.selectedImageView];
            [self setSelectedImageView:nil];
        }
        
        KS_NOTIC_CENTER_POST2(PV_NOTIFICATION_CHANGE_EDIT, self);
    }
}

- (void)addImageAndEditing:(UIImage *)image
{
    BREditImageView * imageView = [[BREditImageView alloc] initWithImage:image];
    imageView.x = -20;
    imageView.y = -20;
    [self.pictureView addSubview:imageView];
    [self setSelectedImageView:imageView];
    [self setEditing:YES];
}

- (void)removeSelectedImageView
{
    [self.selectedImageView removeFromSuperview];
    [self setSelectedImageView:nil];
}

- (BOOL)findImageAndSelected:(CGPoint)point
{
    NSMutableArray *tmp = [NSMutableArray new];
    
    for (UIView *entry in self.pictureView.subviews) {
        if (CGRectContainsPoint(entry.frame, point)) {
            [tmp addObject:entry];
        }
    }
    if ([tmp count] > 0) {
        self.selectedImageView = [tmp lastObject];
        return YES;
    }
    return NO;
}

#pragma mark -

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setEditing:NO];
}

@end
