//
//  EditImageView.m
//  KDFuDao
//
//  Created by bing.hao on 14-6-3.
//  Copyright (c) 2014年 bing.hao. All rights reserved.
//

#define kBUTTON_LEFT_TOP     451
#define kBUTTON_LEFT_CENTER  452
#define kBUTTON_LEFT_BOTTOM  453
#define kBUTTON_RIGHT_TOP    551
#define kBUTTON_RIGHT_CENTER 552
#define kBUTTON_RIGHT_BOTTOM 553

#define kMAX_WIDTH  160
#define kMAX_HEIGHT 284

#import "BREditImageView.h"

@interface BREditImageView ()
{
    CGPoint _prevPoint;
    CGPoint _currPoint;
    CGFloat _zoom;
    
    UIPanGestureRecognizer * _pan;
}
@end

@implementation BREditImageView

- (id)initWithImage:(UIImage *)image
{
    self = [super init];
    if (self) {
        
        _zoom = 1;
        
        self.userInteractionEnabled = YES;
        
        self.imageView = [[UIImageView alloc] initWithImage:image];
        self.imageView.width = image.size.width / 2;
        self.imageView.height = image.size.height / 2;
        

        self.width  = self.imageView.width  + 40.0f;
        self.height = self.imageView.height + 40.0f;
//
        self.imageView.center           = CGPointMake(self.width / 2, self.height / 2);
        self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
                                          UIViewAutoresizingFlexibleHeight |
                                          UIViewAutoresizingFlexibleRightMargin |
                                          UIViewAutoresizingFlexibleBottomMargin |
                                          UIViewAutoresizingFlexibleLeftMargin |
                                          UIViewAutoresizingFlexibleTopMargin ;
        
        [self addSubview:self.imageView];
    }
    
    return self;
}

- (void)setEdit:(BOOL)edit
{
    if (edit == _edit) { return; }
    
    if (edit) {

        [self addButtonWithCenter:CGPointMake(20, 20) withTag:kBUTTON_LEFT_TOP];
        [self addButtonWithCenter:CGPointMake(self.imageView.width + 20, 20) withTag:kBUTTON_RIGHT_TOP];
        [self addButtonWithCenter:CGPointMake(20, self.imageView.height / 2 + 20) withTag:kBUTTON_LEFT_CENTER];
        [self addButtonWithCenter:CGPointMake(self.imageView.width + 20, self.imageView.height / 2 + 20) withTag:kBUTTON_RIGHT_CENTER];
        [self addButtonWithCenter:CGPointMake(20, self.imageView.height + 20) withTag:kBUTTON_LEFT_BOTTOM];
        [self addButtonWithCenter:CGPointMake(self.imageView.width + 20, self.imageView.height + 20) withTag:kBUTTON_RIGHT_BOTTOM];

        _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveHandler:)];
        
        [self addGestureRecognizer:_pan];
        
        self.imageView.layer.shadowColor = [UIColor blackColor].CGColor;
        self.imageView.layer.shadowOffset = CGSizeMake(0, 0);
        self.imageView.layer.shadowOpacity = 0.8;
    } else {
        
        [self removeGestureRecognizer:_pan];
        
        [self removeButtonWithTag:kBUTTON_LEFT_TOP];
        [self removeButtonWithTag:kBUTTON_LEFT_CENTER];
        [self removeButtonWithTag:kBUTTON_LEFT_BOTTOM];
        [self removeButtonWithTag:kBUTTON_RIGHT_TOP];
        [self removeButtonWithTag:kBUTTON_RIGHT_CENTER];
        [self removeButtonWithTag:kBUTTON_RIGHT_BOTTOM];
        
        self.imageView.layer.shadowOpacity = 0;
    }
    
    _edit = edit;
}

- (void)moveHandler:(UIPanGestureRecognizer *)sender
{
    CGPoint translation = [sender translationInView:self.superview];
    
    self.center = CGPointMake(self.center.x + translation.x, self.center.y + translation.y);
    
    [sender setTranslation:CGPointZero inView:self.superview];
}

- (void)zoomButtonClickHandler:(UIPanGestureRecognizer *)sender
{
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
        {
            _prevPoint = [sender locationInView:self.superview];
    
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            _currPoint = [sender locationInView:self.superview];

            switch (sender.view.tag) {
                case kBUTTON_LEFT_TOP:
                {
                    if ((_currPoint.x - _prevPoint.x) < 0 && (_currPoint.y - _prevPoint.y) < 0) {
                        _zoom += [self distanceFromPointX:_currPoint distanceToPointY:_prevPoint] / ((self.width + self.height) / 2);
                    } else if ((_currPoint.x - _prevPoint.x) > 0 && (_currPoint.y - _prevPoint.y) > 0) {
                        _zoom -= [self distanceFromPointX:_prevPoint distanceToPointY:_currPoint] / ((self.width + self.height) / 2);
                    }
                    break;
                }
                case kBUTTON_LEFT_CENTER:
                {
                    if ((_currPoint.x - _prevPoint.x) < 0) {
                        _zoom += [self distanceFromPointX:_currPoint distanceToPointY:_prevPoint] / ((self.width + self.height) / 2);
                    } else if ((_currPoint.x - _prevPoint.x) > 0) {
                        _zoom -= [self distanceFromPointX:_prevPoint distanceToPointY:_currPoint] / ((self.width + self.height) / 2);
                    }
                    break;
                }
                case kBUTTON_LEFT_BOTTOM:
                {
                    if ((_currPoint.x - _prevPoint.x) < 0 && (_currPoint.y - _prevPoint.y) > 0) {
                        _zoom += [self distanceFromPointX:_currPoint distanceToPointY:_prevPoint] / ((self.width + self.height) / 2);
                    } else if((_currPoint.x - _prevPoint.x) > 0 && (_currPoint.y - _prevPoint.y) < 0) {
                        _zoom -= [self distanceFromPointX:_prevPoint distanceToPointY:_currPoint] / ((self.width + self.height) / 2);
                    }
                    break;
                }
                case kBUTTON_RIGHT_TOP:
                {
                    if ((_currPoint.x - _prevPoint.x) > 0 && (_currPoint.y - _prevPoint.y) < 0) {
                        _zoom += [self distanceFromPointX:_currPoint distanceToPointY:_prevPoint] / ((self.width + self.height) / 2);
                    } else if ((_currPoint.x - _prevPoint.x) < 0 && (_currPoint.y - _prevPoint.y) > 0) {
                        _zoom -= [self distanceFromPointX:_prevPoint distanceToPointY:_currPoint] / ((self.width + self.height) / 2);
                    }
                    break;
                }
                case kBUTTON_RIGHT_CENTER:
                {
                    if ((_currPoint.x - _prevPoint.x) > 0) {
                        _zoom += [self distanceFromPointX:_currPoint distanceToPointY:_prevPoint] / ((self.width + self.height) / 2);
                    } else if((_currPoint.x - _prevPoint.x) < 0) {
                        _zoom -= [self distanceFromPointX:_prevPoint distanceToPointY:_currPoint] / ((self.width + self.height) / 2);
                    }
                    break;
                }
                case kBUTTON_RIGHT_BOTTOM:
                {
                    if ((_currPoint.x - _prevPoint.x) > 0 && (_currPoint.y - _prevPoint.y) > 0) {
                        _zoom += [self distanceFromPointX:_currPoint distanceToPointY:_prevPoint] / ((self.width + self.height) / 2);
                    } else if ((_currPoint.x - _prevPoint.x) < 0 && (_currPoint.y - _prevPoint.y) < 0) {
                        _zoom -= [self distanceFromPointX:_prevPoint distanceToPointY:_currPoint] / ((self.width + self.height) / 2);
                    }
                }
                default:
                    break;
            }
            
            _zoom = MIN(MAX(_zoom, 0.4), 1.6f);
            
            self.transform = CGAffineTransformMakeScale(_zoom, _zoom);
            
            _prevPoint = _currPoint;
            
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            
            _currPoint = CGPointZero;
            _prevPoint = CGPointZero;
            
            break;
        }
        default:
            break;
    }
}

- (float)distanceFromPointX:(CGPoint)start distanceToPointY:(CGPoint)end
{
    float distance;
    //下面就是高中的数学，不详细解释了
    CGFloat xDist = (end.x - start.x);
    CGFloat yDist = (end.y - start.y);
    distance = sqrt((xDist * xDist) + (yDist * yDist));
    return distance;
}

- (void)addButtonWithCenter:(CGPoint)center withTag:(NSInteger)tag
{
    UIButton * button = [UIButton new];
    
//    [button setBackgroundColor:[UIColor orangeColor]];
    [button setFrame:CGRectMake(0, 0, 40, 40)];
    [button setImage:[UIImage imageNamed:@"Change-edge@2x.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"Change-edge@2x.png"] forState:UIControlStateHighlighted];
//    [button addTarget:self action:@selector(zoomButtonClickHandler:) forControlEvents:UIControlEventTouchUpInside];
    [button setTag:tag];
    [button setCenter:center];
    [button setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin |
                                UIViewAutoresizingFlexibleBottomMargin |
                                UIViewAutoresizingFlexibleLeftMargin |
                                UIViewAutoresizingFlexibleTopMargin ];
    
    UIPanGestureRecognizer * tgr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(zoomButtonClickHandler:)];
    
//    [tgr addTarget:self action:@selector(zoomButtonClickHandler:)];z
    
    [button addGestureRecognizer:tgr];
    
    [self addSubview:button];
}

- (void)removeButtonWithTag:(NSInteger)tag
{
    UIButton * button = (UIButton *)[self viewWithTag:tag];
    
    [button removeFromSuperview];
}

@end
