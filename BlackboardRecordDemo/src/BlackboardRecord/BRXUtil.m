//
//  XUtil.m
//  KDFuDao
//
//  Created by bing.hao on 14-6-11.
//  Copyright (c) 2014年 bing.hao. All rights reserved.
//

#import "BRXUtil.h"

@implementation BRXUtil

+ (void)createCacheDirectory
{
    NSString * path = KS_PATH_CACHE_FORMAT(@"/player");
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:nil] == NO) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    DLog(@"Storage path:%@", path);
}

+ (void)clearCacheDirectory
{
    NSString * path = KS_PATH_CACHE_FORMAT(@"/player");
    NSArray  * files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    
    for (NSString * entry in files) {
        [[NSFileManager defaultManager] removeItemAtPath:entry error:nil];
    }
}

//+ (void)mergerWithOutputPath:(NSString *)outpuntPath
//                   tbumbnail:(NSString *)tbumbnai
//               audioFileName:(NSString *)afn
//                      sucess:(void (^)(void))scallback
//                      failer:(void (^)(NSError *))fcallback
//{
//    NSString * vpath = pathcwf(@"player/video.mov");
//    NSString * apath = pathcwf(@"player/%@", afn);
//    
//    
//    AVURLAsset * asset1 = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:vpath] options:nil];
//    AVURLAsset * asset2 = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:apath] options:nil];
//    
//    AVAssetTrack * videoAssetTrack = [asset1 tracksWithMediaType:AVMediaTypeVideo][0];
//    AVAssetTrack * audioAssetTrack = [asset2 tracksWithMediaType:AVMediaTypeAudio][0];
//    
//    AVAssetImageGenerator * generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset1];
//    
//    generator.appliesPreferredTrackTransform = YES;
//    generator.maximumSize = CGSizeMake(640, 640);
//    
//    NSError * error = nil;
//    
//    CGImageRef img = [generator copyCGImageAtTime:videoAssetTrack.timeRange.duration actualTime:nil error:nil];
//    
//    if (error) {
//        NSLog(@"%@", error);
//    } else {
//        
//        UIImage * image = [UIImage imageWithCGImage:img];
//        
//        NSData * data = UIImageJPEGRepresentation(image, 0.6);
//        
//        [data writeToFile:tbumbnai atomically:YES];
//    }
//    
//    CGImageRelease(img);
//    
//    
//    AVMutableComposition      * composition;
//    AVMutableCompositionTrack * videoCompositionTrack;
//    AVMutableCompositionTrack * audioCompositionTrack;
//    
//    composition = [AVMutableComposition composition];
//    
//    videoCompositionTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
//    audioCompositionTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
//    
//    [videoCompositionTrack insertTimeRange:videoAssetTrack.timeRange ofTrack:videoAssetTrack atTime:kCMTimeZero error:nil];
//    [audioCompositionTrack insertTimeRange:audioAssetTrack.timeRange ofTrack:audioAssetTrack atTime:kCMTimeZero error:nil];
//    
//    AVAssetExportSession * exportSession = [AVAssetExportSession exportSessionWithAsset:composition presetName:AVAssetExportPresetPassthrough];
//    
//    [exportSession setOutputFileType:AVFileTypeQuickTimeMovie];
//    [exportSession setOutputURL:[NSURL fileURLWithPath:outpuntPath]];
//    [exportSession setShouldOptimizeForNetworkUse:YES];
//    [exportSession exportAsynchronouslyWithCompletionHandler:^{
//        
//        if (exportSession.status == AVAssetExportSessionStatusCompleted) {
//            scallback();
//        } else {
//            fcallback(exportSession.error);
//        }
//    }];
//}
+ (void)mergerWithOutputPath:(NSString *)outpuntPath
                   tbumbnail:(NSString *)tbumbnai
                      sucess:(void (^)(void))scallback
                      failer:(void (^)(NSError *))fcallback
{
    
    NSString * vpath = KS_PATH_CACHE_FORMAT(@"/player/video.mov");
    NSString * apath = KS_PATH_CACHE_FORMAT(@"/player/audio.caf");

    
    AVURLAsset * asset1 = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:vpath] options:nil];
    AVURLAsset * asset2 = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:apath] options:nil];

    AVAssetTrack * videoAssetTrack = nil;
    AVAssetTrack * audioAssetTrack = nil;
    
    if ([[asset1 tracksWithMediaType:AVMediaTypeVideo] count] > 0) {
        videoAssetTrack = [asset1 tracksWithMediaType:AVMediaTypeVideo][0];
    }
    
    if ([[asset2 tracksWithMediaType:AVMediaTypeAudio] count] > 0) {
        audioAssetTrack = [asset2 tracksWithMediaType:AVMediaTypeAudio][0];
    }
    
    AVAssetImageGenerator * generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset1];
    
    generator.appliesPreferredTrackTransform = YES;
    generator.maximumSize = CGSizeMake(640, 640);

    NSError * error = nil;
    
    CGImageRef img = [generator copyCGImageAtTime:videoAssetTrack.timeRange.duration actualTime:nil error:nil];
    
    if (error) {
        NSLog(@"%@", error);
    } else {
        
        UIImage * image = [UIImage imageWithCGImage:img];
        
        NSData * data = UIImageJPEGRepresentation(image, 0.6);
        
        [data writeToFile:tbumbnai atomically:YES];
    }
    
    CGImageRelease(img);
    
    
    AVMutableComposition      * composition;
    AVMutableCompositionTrack * videoCompositionTrack;
    AVMutableCompositionTrack * audioCompositionTrack;

    composition = [AVMutableComposition composition];
    
    videoCompositionTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    audioCompositionTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    [videoCompositionTrack insertTimeRange:videoAssetTrack.timeRange ofTrack:videoAssetTrack atTime:kCMTimeZero error:nil];
    [audioCompositionTrack insertTimeRange:audioAssetTrack.timeRange ofTrack:audioAssetTrack atTime:kCMTimeZero error:nil];
    
    
    
    AVAssetExportSession * exportSession = [AVAssetExportSession exportSessionWithAsset:composition presetName:AVAssetExportPresetPassthrough];
    
//    AVMutableVideoComposition * videoComposition = [AVMutableVideoComposition videoComposition];
//    
//    videoComposition.frameDuration = CMTimeMake(1, 25);
//    videoComposition.renderSize    = CGSizeMake(640, 640);
//    
//    AVMutableVideoCompositionInstruction      * instruction;
//    AVMutableVideoCompositionLayerInstruction * layerInstruction;
//    
//    
//    layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoCompositionTrack];
//    
//    instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
//    
//    instruction.layerInstructions = @[ layerInstruction ];
//    instruction.timeRange = videoAssetTrack.timeRange; //CMTimeRangeMake(kCMTimeZero, CMTimeMake(3, 1));
//    
//    videoComposition.instructions = @[instruction];
    
//    [exportSession setVideoComposition:videoComposition];
//    [exportSession setTimeRange:videoAssetTrack.timeRange];
    [exportSession setOutputFileType:AVFileTypeMPEG4];
    [exportSession setOutputURL:[NSURL fileURLWithPath:outpuntPath]];
    [exportSession setShouldOptimizeForNetworkUse:YES];
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
       
        if (exportSession.status == AVAssetExportSessionStatusCompleted) {
            scallback();
        } else {
            fcallback(exportSession.error);
        }
    }];
}

@end
