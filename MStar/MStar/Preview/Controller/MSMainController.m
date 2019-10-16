//
//  MSMainController.m
//  MStar
//
//  Created by 王璋传 on 2019/10/14.
//  Copyright © 2019 王璋传. All rights reserved.
//

#import "MSMainController.h"
#import "AITUtil.h"
#import <AVFoundation/AVFoundation.h>

static NSString *DEFAULT_RTSP_URL_AV1 = @"/liveRTSP/av1";
static NSString *DEFAULT_RTSP_URL_V1 = @"/liveRTSP/v1";
static NSString *DEFAULT_RTSP_URL_AV2 = @"/liveRTSP/av2";
static NSString *DEFAULT_RTSP_URL_AV4 = @"/liveRTSP/av4";
static NSString *DEFAULT_MJPEG_PUSH_URL = @"/cgi-bin/liveMJPEG";
static NSString *CAMEAR_PREVIEW_MJPEG_STATUS_RECORD = @"Camera.Preview.MJPEG.status.record";

static NSString *NETWORK_CACHE_H264 = @"400";
static NSString *NETWORK_CACHE_MJPG = @"400";

@interface MSMainController ()

@property (nonatomic, copy) NSString * dateStr;

@end

@implementation MSMainController {
    BOOL ret;
}

- (void)dealloc {
    NSLog(@"_____________%s_________________",__FUNCTION__);
}

- (void)getRecordingState4Loop {
    
    [[MSDeviceMgr manager] getRecordingState:^(BOOL recordState) {
        NSLog(@"%@",recordState ? @"录制中" : @"未录制");
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(updateRecordStates:)]) {
            if (self->ret != recordState) {
                self->ret = recordState;
                [self.delegate updateRecordStates:recordState];
            }
            
            if (self.updateRecordStatesBlock) {
                self.updateRecordStatesBlock(recordState);
            }
        }
        
        [self performSelector:@selector(getRecordingState4Loop) withObject:nil afterDelay:2.0f];
    }];
}

- (void)stopRecordingState4Loop {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(getRecordingState4Loop) object:nil];
}

#if 0

/// 设备是否为本公司设备///
/// @param block 回调
- (void)isDevice4Togevision:(void (^)(NSString *fwVersion))block {
    
    //  设备同步时间格式
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy$MM$dd$HH$mm$ss"];
    

    //  App显示时间格式
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc]init];
    [formatter1 setDateFormat:@"yy-MM-dd-HH-mm-ss"];
    self.dateStr = [formatter1 stringFromDate:date];

    //  时间同步命令
     __weak typeof(self) weakSelf = self;
    NSString *dateStr = [formatter stringFromDate:date];
    
    (void)[[AITCameraCommand alloc] initWithUrl:[AITCameraCommand commandSetDateTime:dateStr]
                                          block:^(NSString *result) {
                                              if ([result containsString:@"OK"]) {
                                                  [weakSelf getFwVersion:block];
                                              } else {
                                                  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                      [weakSelf isDevice4Togevision:block];
                                                  });
                                              }
                                          } fail:^(NSError *error) {
                                              dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                  [weakSelf isDevice4Togevision:block];
                                              });
                                          }];
}


/// 获取设备固件版本号
/// @param block 回调
- (void)getFwVersion:(void (^)(NSString *fwVersion))block {
    
    __weak typeof(self) weakSelf = self;
    
    (void)[[AITCameraCommand alloc] initWithUrl:[AITCameraCommand commandQuerySettings]
                                          block:^(NSString *result) {
                                              [weakSelf handleQuerySettings:result block:block];
                                          } fail:^(NSError *error) {
                                          }];
}

- (void)handleQuerySettings:(NSString *)result block:(void (^)(NSString *fwVersion))block {
    if (NO == [result containsString:@"OK\n"]) {
        return;
    }
    
    NSArray <NSString *> *cameraMenu = [result componentsSeparatedByString:@"\n"];
    [cameraMenu enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj containsString:@"Camera.Menu.FWversion="]) {
            NSString *fwversion = [obj componentsSeparatedByString:@"="].lastObject;
            NSLog(@"---- fwversion ------%@",fwversion);
            
            NSString *encrypByte = [fwversion componentsSeparatedByString:@"-"].lastObject;
            NSString *ver = [fwversion componentsSeparatedByString:@"-"].firstObject;
            
            NSArray *dateStrs = [self.dateStr componentsSeparatedByString:@"-"];
            
            int ret = TogevisionCRC([dateStrs[0] intValue], [dateStrs[1] intValue], [dateStrs[2] intValue], [dateStrs[3] intValue], [dateStrs[4] intValue], [dateStrs[5] intValue]);

            if (ret == encrypByte.intValue) {
                NSLog(@"是自己的设备%d",ret);
                !block ? : block(ver);
            } else {
                NSLog(@"不是自己的设备%d",ret);
            }
            
        }
    }];
}


/// 设备算法验证
/// @param year 年
/// @param month 月
/// @param day 日
/// @param hour 时
/// @param min 分
/// @param second 秒
static unsigned char TogevisionCRC(unsigned char year,unsigned char month,unsigned char day,unsigned char hour,unsigned char min,unsigned char second)
{
    return (((year^month) + day&hour)^min)+second;
}

#endif


/// 查询直播流路径
/// @param block 回调
- (void)queryPreStreamCommd:(void (^)(NSString *url))block
{
     __weak typeof(self) weakSelf = self;

    (void)[[AITCameraCommand alloc] initWithUrl:[AITCameraCommand commandQueryPreviewStatusUrl]
                                          block:^(NSString *result) {
                                              [weakSelf handleQueryStreamCommdBlock:result block:block];
                                          } fail:^(NSError *error) {
                                              
                                          }];
}

- (void)handleQueryStreamCommdBlock:(NSString *)result block:(void (^)(NSString *))block {
    if ([result containsString:@"OK\n"] == NO) {
        return;
    }
    
    NSDictionary *dict = [AITCameraCommand buildResultDictionary:result];
    if (dict == nil) {
    }
    
    int rtsp = [[dict objectForKey:[AITCameraCommand PROPERTY_CAMERA_RTSP]] intValue];
    NSString *networkcache = nil;
    NSString *liveurl = nil;

    //networkcache =[dict objectForKey:@"Camera.Preview.MJPEG.w"];
    // Check Support rtsp v1, av1 ? or MJPEG
    //NSLog(@"STREAMING = %@", rtsp) ;
    if (rtsp == 1) {
        networkcache = NETWORK_CACHE_MJPG;
        liveurl = [NSString stringWithFormat:@"rtsp://%@%@", [AITUtil getCameraAddress], DEFAULT_RTSP_URL_AV1];
    } else if (rtsp == 2) {
        networkcache = NETWORK_CACHE_H264;
        liveurl = [NSString stringWithFormat:@"rtsp://%@%@", [AITUtil getCameraAddress], DEFAULT_RTSP_URL_V1];
    } else if (rtsp == 3) {
        networkcache = NETWORK_CACHE_H264;
        liveurl = [NSString stringWithFormat:@"rtsp://%@%@", [AITUtil getCameraAddress], DEFAULT_RTSP_URL_AV2];
    } else if (rtsp == 4) {
        networkcache = NETWORK_CACHE_H264;
        liveurl = [NSString stringWithFormat:@"rtsp://%@%@", [AITUtil getCameraAddress], DEFAULT_RTSP_URL_AV4];
    } else {
        networkcache = NETWORK_CACHE_MJPG;
        liveurl = [NSString stringWithFormat:@"http://%@%@", [AITUtil getCameraAddress], DEFAULT_MJPEG_PUSH_URL];
    }
    
    !block ? : block(liveurl);
}


/// 拍照
/// @param block 回调
- (void)shotAction:(void (^)(void))block
{
    //  直接先调用效果
    [self handleShotActionBlock];
    
    !block ? : block();

    (void)[[AITCameraCommand alloc] initWithUrl:[AITCameraCommand commandCameraSnapshotUrl]
                                          block:^(NSString *result) {
        
                                          } fail:^(NSError *error) {
                                              
                                          }];

}

- (void)handleShotActionBlock {

    [self photosound];

//    [UIView animateWithDuration:.1 animations:^{
//        self.splashView.alpha = 1;
//    } completion:^(BOOL finished) {
//        self.splashView.alpha = 0;
//    }];
    
}

- (void)photosound
{
    NSString *soundName = @"photoShutter";
    NSString *soundType = @"caf";
    NSString *path = [NSString stringWithFormat:@"/System/Library/Audio/UISounds/%@.%@", soundName, soundType];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &soundID);
    AudioServicesPlaySystemSound(soundID);
}


@end
