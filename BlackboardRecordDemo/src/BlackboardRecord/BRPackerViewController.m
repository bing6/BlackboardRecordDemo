//
//  BRPackerViewController.m
//  BlackboardRecordDemo
//
//  Created by bing.hao on 15/9/7.
//  Copyright (c) 2015年 bing.hao. All rights reserved.
//

#import "BRPackerViewController.h"
#import "BRNavigationBarView.h"
#import "BRPageView.h"
#import "BRAmplifierBoardView.h"
#import "BRMagnifierView.h"
#import "BRElemntMenuView.h"
#import "BREditMenuView.h"
#import "BRColorMenuView.h"
#import "BRXUtil.h"
#import "BRXScreenCapture.h"
#import "BRXRecordAudio.h"

@interface BRPackerViewController ()
<
    UIScrollViewDelegate,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate,
    UIAlertViewDelegate,
    BRMagnifierViewDelegate,
    BRElemntMenuViewDelegate,
    BRColorMenuViewDelegate,
    BREditMenuViewDelegate,
    BRXScreenCaptureDelegate
>
{
    BRXScreenCapture  * _videoRecord;
    BRXRecordAudio    * _audioRecord;
}

@property (nonatomic, strong) BRNavigationBarView *navigationBar;
@property (nonatomic, strong) BRPageView *page;
@property (nonatomic, strong) BRAmplifierBoardView *board;
@property (nonatomic, strong) BRMagnifierView *magnifier;
@property (nonatomic, strong) BRElemntMenuView *menu1;
@property (nonatomic, strong) BRColorMenuView *menu2;
@property (nonatomic, strong) BREditMenuView *menu3;

@property (nonatomic, assign) BOOL isRecordPermission;

@end

@implementation BRPackerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建存储目录
    [BRXUtil createCacheDirectory];
    //检测是否支持录音
    [self checkAudio];
    
    _audioRecord = [BRXRecordAudio new];
    _videoRecord = [BRXScreenCapture new];
    
    _videoRecord.delegate    = self;
    _videoRecord.captureView = self.page;
    
    //设置属性
    [self.navigationController setNavigationBarHidden:YES];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //添加view
    [self.view addSubview:self.navigationBar];
    [self.view addSubview:self.page];
    [self.view addSubview:self.board];
    [self.view addSubview:self.magnifier];
    
    //显示放大板
    [self setDisplayBoard:YES];
    //添加长按手势，用于区别是否选中了图片
    [self addLongPressGestureRecognizer];
}

#pragma mark -

- (void)checkAudio
{
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
//    UInt32 audioRoute = kAudioSessionOverrideAudioRoute_Speaker;
//    AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(audioRoute), &audioRoute);
    

    _isRecordPermission = YES;
    
    if ([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)]) {
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            if (!granted) {
                _isRecordPermission = NO;
            }
        }];
    }
}

- (void)addLongPressGestureRecognizer
{
    UILongPressGestureRecognizer * longPress = [UILongPressGestureRecognizer new];
    [longPress addTarget:self action:@selector(longPressHandler:)];
    [longPress setMinimumPressDuration:1.0f];
    [self.page addGestureRecognizer:longPress];
}

#pragma mark -

- (void)bindEvent:(id)obj action:(SEL)action
{
    [obj addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark -

- (BRNavigationBarView *)navigationBar
{
    if (!_navigationBar) {
        _navigationBar = [BRNavigationBarView new];
        [self bindEvent:_navigationBar.backButton action:@selector(backButtonHandler:)];
        [self bindEvent:_navigationBar.addButton action:@selector(addButtonHandler:)];
        [self bindEvent:_navigationBar.amplifierBoardButton action:@selector(amplifierBoardButtonHandler:)];
        [self bindEvent:_navigationBar.paletteButton action:@selector(paletteButtonHandler:)];
        [self bindEvent:_navigationBar.eraserButton action:@selector(eraserButtonHandler:)];
        [self bindEvent:_navigationBar.recordButton action:@selector(recordButtonHandler:)];
        [self bindEvent:_navigationBar.sendButton action:@selector(sendButtonHandler:)];
    }
    return _navigationBar;
}

- (BRPageView *)page
{
    if (!_page) {
        _page = [BRPageView new];
        _page.y = 64;
    }
    return _page;
}

- (BRAmplifierBoardView *)board
{
    if (!_board) {
        _board = [BRAmplifierBoardView new];
        _board.hidden = YES;
        [self bindEvent:_board.redButton action:@selector(redButtonHandler:)];
        [self bindEvent:_board.blueButton action:@selector(blueButtonHandler:)];
        [self bindEvent:_board.blackButton action:@selector(blackButtonHandler:)];
        [self bindEvent:_board.eraserButton action:@selector(eraserButtonHandler:)];
        [self bindEvent:_board.moveButton action:@selector(moveButtonHandler:)];
    }
    return _board;
}

- (BRMagnifierView *)magnifier
{
    if (!_magnifier) {
        _magnifier = [BRMagnifierView new];
        _magnifier.hidden = YES;
        _magnifier.y = 64;
        _magnifier.delgate = self;
    }
    return _magnifier;
}

- (BRElemntMenuView *)menu1
{
    if (!_menu1) {
        _menu1 = [BRElemntMenuView new];
        _menu1.x        = 15;
        _menu1.y        = 65;
        _menu1.hidden   = YES;
        _menu1.delegate = self;
    }
    return _menu1;
}

- (BRColorMenuView *)menu2
{
    if (!_menu2) {
        _menu2 = [BRColorMenuView new];
        _menu2.x        = 75;
        _menu2.y        = 65;
        _menu2.hidden   = YES;
        _menu2.delegate = self;
    }
    return _menu2;
}

- (BREditMenuView *)menu3
{
    if (!_menu3) {
        _menu3 = [BREditMenuView new];
        _menu3.hidden   = YES;
        _menu3.delegate = self;
    }
    return _menu3;
}

#pragma mark - 

- (void)backButtonHandler:(id)sender
{
    if (self.menu1.hidden == NO) {
        self.navigationBar.addButton.selected = NO;
    }
    self.menu1.hidden = YES;
    self.menu2.hidden = YES;
    self.menu3.hidden = YES;
    self.page.userInteractionEnabled = YES;
}

- (void)addButtonHandler:(UIButton *)sender
{
    if (self.menu1.superview == nil) {
        [self.view addSubview:self.menu1];
    }
    sender.selected = !sender.selected;
    self.menu1.hidden = !self.menu1.hidden;
    self.menu2.hidden = YES;
    self.menu3.hidden = YES;
    if (self.menu1.hidden) {
        self.page.userInteractionEnabled = YES;
    } else {
        self.page.userInteractionEnabled = NO;
    }
}

- (void)amplifierBoardButtonHandler:(UIButton *)sender
{
    [self setDisplayBoard:!sender.selected];
    
    if (self.menu1.hidden == NO) {
        self.navigationBar.addButton.selected = NO;
    }
    self.menu1.hidden = YES;
    self.menu2.hidden = YES;
    self.menu3.hidden = YES;
    self.page.userInteractionEnabled = YES;
}

- (void)paletteButtonHandler:(UIButton *)sender
{
    if (self.menu2.superview == nil) {
        [self.view addSubview:self.menu2];
    }
    if (self.menu1.hidden == NO) {
        self.navigationBar.addButton.selected = NO;
    }
    self.menu1.hidden = YES;
    self.menu2.hidden = !self.menu2.hidden;
    self.menu3.hidden = YES;
    if (self.menu2.hidden) {
        self.page.userInteractionEnabled = YES;
    } else {
        self.page.userInteractionEnabled = NO;
    }
}

- (void)eraserButtonHandler:(UIButton *)sender
{
//    sender.selected = !sender.selected;
    if (!sender.selected) {
        sender.selected = YES;
        DMShared.type = BRDrawToolsTypeErase;
    } else {
        sender.selected = NO;
        DMShared.type = BRDrawToolsTypePen;
    }
    
    if (self.menu1.hidden == NO) {
        self.navigationBar.addButton.selected = NO;
    }
    self.menu1.hidden = YES;
    self.menu2.hidden = YES;
    self.menu3.hidden = YES;
    self.page.userInteractionEnabled = YES;
}

- (void)recordButtonHandler:(UIButton *)sender
{
    if (self.menu1.hidden == NO) {
        self.navigationBar.addButton.selected = NO;
    }
    self.menu1.hidden = YES;
    self.menu2.hidden = YES;
    self.menu3.hidden = YES;
    self.page.userInteractionEnabled = YES;
    
    if (!_isRecordPermission) {
        KS_ALERT_1(@"录音要访问您的麦克风。\n请启用麦克风-设置/隐私/麦克风");
        return;
    }

    if((sender.selected = !sender.selected)){
        
        [_audioRecord start:_videoRecord.durationCounter];
        [_videoRecord start];
    } else {
        
        [_videoRecord pause];
        [_audioRecord pause];
    }
}

- (void)sendButtonHandler:(UIButton *)sneder
{
    if (self.menu1.hidden == NO) {
        self.navigationBar.addButton.selected = NO;
    }
    self.menu1.hidden = YES;
    self.menu2.hidden = YES;
    self.menu3.hidden = YES;
    self.page.userInteractionEnabled = YES;
    
    if (_videoRecord.isRecordFile) {
        [_videoRecord finishedRecord];
    }
}

- (void)redButtonHandler:(id)sender
{
    [self chageColorHandler:kDM_COLOR_RED];
}

- (void)blueButtonHandler:(id)sender
{
    [self chageColorHandler:kDM_COLOR_BLUE];
}

- (void)blackButtonHandler:(id)sender
{
    [self chageColorHandler:kDM_COLOR_BLACK];
}

- (void)chageColorHandler:(UIColor *)c
{
    [DMShared setLineColor:c];
}

- (void)moveButtonHandler:(id)sender
{
    CGFloat offset = MIN(KS_SCREEN_WIDTH - self.magnifier.width, self.magnifier.x + self.magnifier.width);
    
    [UIView animateWithDuration:0.3f animations:^{
        self.magnifier.x = offset;
    } completion:^(BOOL finished) {
        [self.board setOffset:CGPointMake(self.magnifier.x, self.magnifier.y - 64)];
    }];
}

#pragma mark -

- (void)setDisplayBoard:(BOOL)show
{
    self.navigationBar.amplifierBoardButton.selected = show;
    self.board.hidden = !show;
    self.magnifier.hidden = !show;
    
    if (show) {
        self.magnifier.x = 0;
        self.magnifier.y = 64;
        self.board.inView = self.page;
    } else {
        self.board.inView = nil;
    }
}

#pragma mark -

- (void)longPressHandler:(UILongPressGestureRecognizer *)recognizer
{
    CGPoint p1 = [recognizer locationInView:self.page];
    CGPoint p2 = [recognizer locationInView:self.view];
    
    if ([self.page findImageAndSelected:p1]) {
        if (self.menu3.superview == nil) {
            [self.view addSubview:self.menu3];
        }
        self.menu3.center = CGPointMake(p2.x, p2.y + self.menu3.height / 2);
        self.menu3.hidden = NO;
        self.page.userInteractionEnabled = NO;
    }
}

#pragma mark -

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.menu1.hidden == NO) {
        self.navigationBar.addButton.selected = NO;
    }
    self.menu1.hidden = YES;
    self.menu2.hidden = YES;
    self.menu3.hidden = YES;
    self.page.userInteractionEnabled = YES;
}

#pragma mark - BRXScreenCaptureDelegate

- (void)xScreenCaptureDidFinsished:(id)sender
{
    [_audioRecord finishedRecord];

    NSTimeInterval name = [NSDate date].timeIntervalSince1970;
    NSString *mp4Path = KS_PATH_CACHE_FORMAT(@"/%f.mp4", name);
    NSString *jpgPath = KS_PATH_CACHE_FORMAT(@"/%f.jpg", name);
    
    [BRXUtil mergerWithOutputPath:mp4Path tbumbnail:jpgPath sucess:^{
        
        NSLog(@"OK....");
//        NSDictionary * data = @{ @"video_path" : output, @"image_path" : output2 };
//        
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"BlackboardSuccess" object:data];
//        
//        runDispatchGetMainQueue(^{
//            [self dismissViewControllerAnimated:YES completion:nil];
//        });
        
    } failer:^(NSError *error) {
        
        NSLog(@"%@", error);
    }];
}

- (void)xScreenCaptureDidProgress:(float)progress
{
    [self.navigationBar setTimeValue:300 - (300 * progress)];
}

#pragma mark -- ImagePickerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage * image1 = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage * imgee2 = [self getAssetThumbImage:image1];
    
    [self.page addImageAndEditing:imgee2];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)getAssetThumbImage:(UIImage *)image
{
    @autoreleasepool {
        
        CGSize osize = image.size;
        
        CGFloat nw = 0.0f;
        CGFloat nh = 0.0f;
        
        if (osize.width > osize.height) {
            nw = 640 * 0.75;
            nh = osize.height * (nw / osize.width);
        } else {
            nh = 640 * 0.75;
            nw = osize.width * (nh / osize.height);
        }
        
        UIGraphicsBeginImageContext(CGSizeMake(nw, nh));
        
        [image drawInRect:CGRectMake(0, 0, nw, nh)];
        
        UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
        
        image = nil;
        
        return newImage;
    }
}

#pragma mark - BRMagnifierViewDelegate

- (void)magnifierView:(id)view scal:(float)scal
{
    [self.board setScale:scal offsetPoint:CGPointMake(self.magnifier.x, self.magnifier.y - 64)];
}

- (void)magnifierView:(id)view atMove:(CGPoint)point
{
    [self.board setOffset:point];
}

#pragma mark - BRElemntMenuViewDelegate

- (void)elementMenuView:(id)view atIndex:(NSInteger)index
{
    self.navigationBar.addButton.selected = NO;
    self.menu1.hidden = YES;
    
    if (index == 1 || index == 2) {
        UIImagePickerController * controller = [UIImagePickerController new];
        if (index == 1) {
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        } else {
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        //            controller.allowsEditing = YES;
        controller.delegate      = self;
        [self presentViewController:controller animated:YES completion:nil];
    }
}

#pragma mark - BRColorMenuViewDelegate

- (void)colorMenuView:(id)view selectColor:(UIColor *)color
{
    self.menu2.hidden = YES;
    self.page.userInteractionEnabled = YES;
    [self chageColorHandler:color];
}

- (void)colorMenuView:(id)view selectWidth:(CGFloat)width
{
    self.menu2.hidden = YES;
    self.page.userInteractionEnabled = YES;
    [DMShared setLineWidth:width];
}

#pragma mark - BREditMenuViewDelegate

- (void)editMenuView:(id)view atIndex:(NSInteger)index
{
    if (index == 1) {
        [self.page setEditing:YES];
    } else {
        [self.page removeSelectedImageView];
    }
    if (self.menu1.hidden == NO) {
        self.navigationBar.addButton.selected = NO;
    }
    self.menu1.hidden = YES;
    self.menu2.hidden = YES;
    self.menu3.hidden = YES;
    self.page.userInteractionEnabled = YES;
}

@end
