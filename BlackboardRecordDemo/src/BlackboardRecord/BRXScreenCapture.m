//
//  XScreenCapture.m
//  KDFuDao
//
//  Created by bing.hao on 14-6-10.
//  Copyright (c) 2014年 bing.hao. All rights reserved.
//

#import "BRXScreenCapture.h"

@implementation BRXScreenCapture

- (id)init
{
    self = [super init];
    if (self) {
        
        self.videoWidth  = 640;
        self.videoHeight = 640;
        self.frameRate   = 10;
        self.duration    = 60 * 5;

        _cacheVidoePath = KS_PATH_CACHE_FORMAT(@"/player/video.mov");
        
        unlink([_cacheVidoePath UTF8String]);
        
        [self prepareToRecord];
    }
    return self;
}

- (BOOL)prepareToRecord
{
    if (!_ready) {
        
        NSError            * error  = nil;
        AVAssetWriter      * writer = nil;
        AVAssetWriterInput * input  = nil;
        
        
        NSURL * url = [NSURL fileURLWithPath:_cacheVidoePath];
        
        writer = [[AVAssetWriter alloc] initWithURL:url fileType:AVFileTypeQuickTimeMovie error:&error];
        
        if (error) {
            NSLog(@"%@", error);
            return NO;
        }
        
        NSDictionary * compression  = @{ AVVideoAverageBitRateKey : @(128.0 * 1024) };
        NSDictionary * videoSettins = @{ AVVideoCodecKey  : AVVideoCodecH264,
                                         AVVideoWidthKey  : @(self.videoWidth),
                                         AVVideoHeightKey : @(self.videoHeight),
                                         AVVideoCompressionPropertiesKey :  compression };
        
        input = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:videoSettins];
        input.expectsMediaDataInRealTime = YES;
        
        NSDictionary * attributes = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kCVPixelFormatType_32ARGB], kCVPixelBufferPixelFormatTypeKey, nil];
        
        AVAssetWriterInputPixelBufferAdaptor * adaptor = [AVAssetWriterInputPixelBufferAdaptor assetWriterInputPixelBufferAdaptorWithAssetWriterInput:input sourcePixelBufferAttributes:attributes];
        
        if ([writer canAddInput:input]) {
            [writer addInput:input];
        }
        
        _assetWriter           = writer;
        _assetWriterVideoInput = input;
        _wVideoAdaptor         = adaptor;
        _ready                 = YES;
        _videoSettings         = videoSettins;
        
        [_assetWriter startWriting];
        [_assetWriter startSessionAtSourceTime:kCMTimeZero];
    
    }
    
    return YES;
}


- (void)start
{
    self.isRecordFile = YES;
    
    if (_ready && !_recording) {
        
        _recording = YES;
        _startAtNumber = mach_absolute_time();
        
        NSThread * thread = [[NSThread alloc] initWithTarget:self selector:@selector(threadHandler) object:nil];
        
        [thread start];
    }
}

- (void)pause
{
    if (_recording) {
        
        _recording = NO;
        _durationCounter += [self getElapsed];
    }
}

- (void)finishedRecord
{
//    NSLog(@"Call finishedRecord.1");
    [self pause];
//    NSLog(@"Call finishedRecord.2");
    [_assetWriterVideoInput markAsFinished];
//    NSLog(@"Call finishedRecord.3");
    [_assetWriter finishWritingWithCompletionHandler:^{
        
//        NSLog(@"OVER");
        
        if ([self.delegate respondsToSelector:@selector(xScreenCaptureDidFinsished:)]) {
            [self.delegate xScreenCaptureDidFinsished:self];
        }
    }];
//    NSLog(@"Call finishedRecord.4");
}

- (void)threadHandler
{
    while (_recording) {
        
        [self videoWriterTimerHandler:nil];
        
        usleep(1000 * 1000 * (1.0f / self.frameRate));
        
    };
}

- (double)getElapsed
{
    mach_timebase_info_data_t info;
    mach_timebase_info(&info);
    
    uint64_t timeInterval = mach_absolute_time() - _startAtNumber;
    
    timeInterval *= info.numer;
    timeInterval /= info.denom;
    
    //纳秒转换为秒
    float duration = (timeInterval * 1.0f) / 1000000000;
    
    return duration;
}

- (void)videoWriterTimerHandler:(NSTimer *)timer
{
    if (_recording) {
        
        @autoreleasepool {
    
        
            CMTime elapsed = CMTimeMake((int)(([self getElapsed] + _durationCounter) * 1000), 1000);
            
            UIImage * image = [self viewToImage:self.captureView];
            
            CVPixelBufferRef buffer = [self newPixelBufferFromCGImage:image.CGImage];
            
            if ([_assetWriterVideoInput isReadyForMoreMediaData] && _recording) {
                [_wVideoAdaptor appendPixelBuffer:buffer withPresentationTime:elapsed];
                
//                NSLog(@"%f", CMTimeGetSeconds(elapsed));
                
                if (_recording == NO) {
                    _durationCounter += [self getElapsed];
                }
                
                CFRelease(buffer);
                
                CGFloat progress = (CMTimeGetSeconds(elapsed) / self.duration);
                
                if (progress >= 1.0f) {
                    
                    [self finishedRecord];
                    return;
                } else {
                    if ([self.delegate respondsToSelector:@selector(xScreenCaptureDidProgress:)]) {
                        [self.delegate xScreenCaptureDidProgress:(CMTimeGetSeconds(elapsed) / self.duration)];
                    }
                }
            }
        }
    }
}

- (CVPixelBufferRef) newPixelBufferFromCGImage: (CGImageRef) image
{
    CVPixelBufferRef pxbuffer = NULL;
    
    CFDictionaryRef option = (__bridge_retained CFDictionaryRef)_videoSettings;

    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault,
                                          self.videoWidth,
                                          self.videoHeight,
                                          kCVPixelFormatType_32ARGB,
                                          option,
                                          &pxbuffer
                                          );
    
    CFRelease(option);
    
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    
    NSParameterAssert(pxdata != NULL);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    int bitmapInfo = (CGBitmapInfo)kCGImageAlphaNoneSkipFirst;
#else
    int bitmapInfo = kCGImageAlphaNoneSkipFirst;
#endif
    
    CGContextRef context = CGBitmapContextCreate(pxdata,
                                                 self.videoWidth,
                                                 self.videoHeight,
                                                 8,
                                                 4*self.videoWidth,
                                                 rgbColorSpace,
                                                 bitmapInfo
                                                 );
    
    //    CGContextRef context = CGBitmapContextCreate(pxdata, self.size.width, self.size.height, 8, 4*self.size.width, rgbColorSpace,kCGImageAlphaNoneSkipFirst);
    
    NSParameterAssert(context);
    
    //    CGFloat iw = CGImageGetWidth(image);
    
    CGContextDrawImage(context, CGRectMake(0, 0, self.videoWidth, self.videoHeight), image);
    //    CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(image),
    //                                           CGImageGetHeight(image)), image);
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    
    return pxbuffer;
}


- (UIImage *)viewToImage:(UIView *)view
{
//    if(UIGraphicsBeginImageContextWithOptions != NULL) {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(KS_SCREEN_WIDTH, KS_SCREEN_WIDTH), NO, 0.0);
//    } else {
//        UIGraphicsBeginImageContext(CGSizeMake(320, 320));
//    }
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    return [UIImage imageWithData:data];
}

@end
