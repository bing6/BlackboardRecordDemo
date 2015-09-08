//
//  XScreenCapture.h
//  KDFuDao
//
//  Created by bing.hao on 14-6-10.
//  Copyright (c) 2014年 bing.hao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "BRPageView.h"
#import <mach/mach_time.h>

@protocol BRXScreenCaptureDelegate <NSObject>

- (void)xScreenCaptureDidProgress:(float)progress;
- (void)xScreenCaptureDidFinsished:(id)sender;

@end

@interface BRXScreenCapture : NSObject
{
    AVAssetWriter            * _assetWriter;
    AVAssetWriterInput       * _assetWriterVideoInput;
    AVAssetWriterInputPixelBufferAdaptor * _wVideoAdaptor;
    
    uint64_t _startAtNumber;
//    double   _durationCounter;
    
    
    BOOL _ready;
    BOOL _recording;
    
    NSDictionary  * _videoSettings;
    NSString      * _cacheVidoePath;

}

@property (nonatomic, weak) UIView * captureView;

@property (nonatomic, assign) CGFloat videoWidth;
@property (nonatomic, assign) CGFloat videoHeight;
@property (nonatomic, assign) CGFloat duration;
@property (nonatomic, assign) NSInteger frameRate;
@property (nonatomic, assign, readonly) double durationCounter;
@property (nonatomic, assign) BOOL isRecordFile;

@property (nonatomic, weak) id<BRXScreenCaptureDelegate> delegate;

//- (BOOL)prepareToRecord;
- (void)start;
- (void)pause;
- (void)finishedRecord;


@end
