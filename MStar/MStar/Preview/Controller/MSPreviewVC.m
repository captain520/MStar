//
//  MSPreviewVC.m
//  MStar
//
//  Created by 王璋传 on 2019/3/7.
//  Copyright © 2019 王璋传. All rights reserved.
//

#import "MSPreviewVC.h"
#import <AVFoundation/AVFoundation.h>
#import <Masonry.h>
#import "CPPlayerVC.h"
#import "MSSettingVC.h"
#import <MobileVLCKit/MobileVLCKit.h>

#import "AITCameraCommand.h"
#import "VLCConstants.h"
#import "AITUtil.h"
#import "AITCameraListen.h"
#import "MSTabBarVC.h"

#import "MSSettingActionVC.h"

#import "MSPlayerVC.h"

static NSString *DEFAULT_RTSP_URL_AV1 = @"/liveRTSP/av1";
static NSString *DEFAULT_RTSP_URL_V1 = @"/liveRTSP/v1";
static NSString *DEFAULT_RTSP_URL_AV2 = @"/liveRTSP/av2";
static NSString *DEFAULT_RTSP_URL_AV4 = @"/liveRTSP/av4";
static NSString *DEFAULT_MJPEG_PUSH_URL = @"/cgi-bin/liveMJPEG";
static NSString *CAMEAR_PREVIEW_MJPEG_STATUS_RECORD = @"Camera.Preview.MJPEG.status.record";

static NSString *NETWORK_CACHE_H264 = @"400";
static NSString *NETWORK_CACHE_MJPG = @"400";

static NSString *CAMERAID_CMD_FRONT = @"front";
static NSString *CAMERAID_CMD_REAR = @"rear";
static bool cam_front = YES;

@interface MSPreviewVC ()<VLCMediaDelegate, VLCMediaPlayerDelegate>

@property (nonatomic, strong) UIButton *recordBT, *shotBT, *previewBT;

@property (nonatomic, strong) UIButton *fullScreenBT;

@property (nonatomic, strong) UIButton *redRecrodLight;
@property (nonatomic, strong) UIImageView *playImageView;

@end

@implementation MSPreviewVC
{
    VLCMediaPlayer *mediaPlayer;
    BOOL appRecording;
    BOOL cameraRecording;
    Camera_cmd_t camera_cmd;
    NSString *liveurl;
    NSString *camera_mode;
    NSString *networkcache;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initailizeBaseProperties];
    [self setupUI];
    [self flickRecodeLight];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //    [self syncDate];
    //    [self sendRecordCommand];
    

    [self reloadPlayer];
}

- (void)reloadPlayer {
    
    if (liveurl.length > 0) {
        if (NO == mediaPlayer.isPlaying) {
            [mediaPlayer play];
        }
    } else {
        //  同步时间后进行直播
        [self syncDate:^{
            [self queryPreStreamCommd];
        }];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSLog(@"viewWillDisappear");

    if (YES == cameraRecording) {
        [mediaPlayer stop];
    } else {
        
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

#pragma mark - Initialized properties
- (void)initailizeBaseProperties
{
    //    mediaPlayer = [VLCMediaPlayer alloc];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    self.view.backgroundColor = UIColor.blackColor;
    
    //    GCDAsyncUdpSocketReceiveFilterBlock filter = ^BOOL (NSData *data, NSData *address, id *context) {
    //        NSString *status = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //            /*
    //             * Many UIKit classes aren't thread safe.
    //             * As a general rule, you should try to make sure that
    //             * all of your UI interaction happens on the main thread.
    //             */
    //            [self CameraStatusArrived:status];
    //        });
    //        return NO;
    //    };
    //
    //    [AITCameraListen setFilterRecvDataBlock:filter];
    //
    NSString *cameraIp = [AITUtil getCameraAddress];
    NSLog(@"Camera IP = %@", cameraIp);
    
    
    [self addObservers];
}

- (void)addObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

//- (void)handleReachabilityBlock:(AFNetworkReachabilityStatus )status {
//
//    NSString *ssid = cp_getWifiName();
//    if ([ssid hasPrefix:@"TG"]) {
//        [self queryPreStreamCommd];
//    }
//}

#pragma mark - setter && getter method
#pragma mark - Setup UI
- (void)setupUI
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"SwitchCameral"] style:UIBarButtonItemStylePlain target:self action:@selector(switchCameralAction:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"setting"] style:UIBarButtonItemStylePlain target:self action:@selector(settingAction:)];
    
    if (nil == self.playImageView) {
        self.playImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, UIApplication.sharedApplication.statusBarFrame.size.height + 44 * 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.width * 3 / 4)];
        self.playImageView.backgroundColor = UIColor.blackColor;
        self.playImageView.image = [UIImage imageNamed:@"NoWifi"];
        self.playImageView.contentMode = UIViewContentModeCenter;
        [self.view addSubview:self.playImageView];
        [self.playImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(NAV_HEIGHT);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(SCREENWIDTH * 480. / 720);
        }];
    }
    
    {
        self.recordBT = [UIButton new];
        self.recordBT.backgroundColor = UIColor.groupTableViewBackgroundColor;
        self.recordBT.layer.cornerRadius = 30.0f;
        
        [self.view addSubview:self.recordBT];
        [self.recordBT setImage:[UIImage imageNamed:@"录像"] forState:UIControlStateSelected];
        [self.recordBT setImage:[UIImage imageNamed:@"已停止"] forState:UIControlStateNormal];
        [self.recordBT addTarget:self action:@selector(recorderAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.recordBT mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(400);
            make.left.mas_equalTo(32);
            make.size.mas_equalTo(CGSizeMake(60, 60));
        }];
        
        self.previewBT = [UIButton new];
        self.previewBT.backgroundColor = UIColor.groupTableViewBackgroundColor;
        self.previewBT.layer.cornerRadius = 50.0f;
        self.previewBT.hidden = YES;
        
        [self.view addSubview:self.previewBT];
        [self.previewBT setImage:[UIImage imageNamed:@"视频"] forState:UIControlStateNormal];
        [self.previewBT setImage:[UIImage imageNamed:@"停止"] forState:UIControlStateSelected];
        [self.previewBT addTarget:self action:@selector(previewAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.previewBT mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.top.mas_equalTo(300);
            make.size.mas_equalTo(CGSizeMake(100, 100));
            make.centerX.mas_equalTo(0);
            make.centerY.mas_equalTo(self.recordBT.mas_centerY);
        }];
        
        self.shotBT = [UIButton new];
        self.shotBT.backgroundColor = UIColor.groupTableViewBackgroundColor;
        self.shotBT.layer.cornerRadius = 30.0f;
        
        [self.view addSubview:self.shotBT];
        [self.shotBT setImage:[UIImage imageNamed:@"拍照"] forState:UIControlStateNormal];
        [self.shotBT addTarget:self action:@selector(shotAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.shotBT mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(400);
            make.right.mas_equalTo(-32);
            make.size.mas_equalTo(CGSizeMake(60, 60));
        }];
    }
    
    {
        self.fullScreenBT = [UIButton new];
        self.fullScreenBT.hidden = YES;
        
        [self.view addSubview:self.fullScreenBT];
        [self.fullScreenBT addTarget:self action:@selector(fullScreenAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.fullScreenBT setImage:[UIImage imageNamed:@"全屏"] forState:UIControlStateNormal];
        [self.fullScreenBT mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(UIApplication.sharedApplication.statusBarFrame.size.height * 1 + UIScreen.mainScreen.bounds.size.width * 3 / 4 - 20 - 16);
            make.right.mas_equalTo(-16);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
    }
    
    {
        self.redRecrodLight = [UIButton new];
        
        [self.redRecrodLight setTitleColor:UIColor.redColor forState:UIControlStateNormal];
        [self.redRecrodLight setTitle:@" REC" forState:UIControlStateNormal];
        [self.redRecrodLight setImage:[UIImage imageNamed:@"record"] forState:UIControlStateNormal];
        [self.view addSubview:self.redRecrodLight];
        [self.redRecrodLight mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(UIApplication.sharedApplication.statusBarFrame.size.height + 44 + 8);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(30);
        }];
    }
    
    //    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"在使用之前请确保连接了设备WIFI" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    //    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:NSLocalizedString(@"ConnectWiFiHint", @"ConnectWiFiHint") delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    //
    //    [alertView show];
}

#pragma mark - Delegate && dataSource method implement

- (void)mediaPlayerStateChanged:(NSNotification *)aNotification
{
    switch (mediaPlayer.state) {
        case VLCMediaPlayerStatePaused:
            break;
        case VLCMediaPlayerStateStopped: {
            self.previewBT.selected = NO;
        }
            break;
        case VLCMediaPlayerStateEnded:
            break;
        case VLCMediaPlayerStatePlaying: {
            NSLog(@"playing");
            self.previewBT.selected = YES;
        }
            break;
        case VLCMediaPlayerStateError: {
            NSLog(@"");
        }
            break;
        default:
            break;
    }
}

- (void)mediaDidFinishParsing:(VLCMedia *)aMedia
{
    NSLog(@"%s", __FUNCTION__);
}

- (void)mediaPlayerSnapshot:(NSNotification *)aNotification
{
    [CPLoadStatusToast shareInstance].style = CPLoadStatusStyleLoadingSuccess;
    [[CPLoadStatusToast shareInstance] show];
}

- (void)requestFinished:(NSString *)result
{
    int rtsp;
    NSString *recording;
    NSDictionary *dict;
    NSLog(@"Result = %@", result);
    
    switch (camera_cmd) {
        case CAMERA_CMD_CAMMENU: {
            if ([result isKindOfClass:[NSString class]] && result.length > 30) {
                [[MSCamMenuManager manager] LoadCamMenuXMLDoc:result];
                [self performSelector:@selector(queryPreStreamCommd) withObject:nil afterDelay:1];
            } else {
                //                [self.view makeToast:NSLocalizedString(@"ConnectTheDeviceWIFI", nil) duration:1.0f position:CSToastPositionCenter];
            }
        }
            break;
        case CAMERA_PRE_STREAMING: {
            dict = [AITCameraCommand buildResultDictionary:result];
            if (dict == nil) {
                //need call init for dummy
                //VLCMediaPlayer * mp =
                //                (void)
                //                [mediaPlayer initWithOptions:@[
                //                     [NSString stringWithFormat:@"--%@=%@", kVLCSettingNetworkCaching, kVLCSettingNetworkCachingDefaultValue],
                //                     [NSString stringWithFormat:@"--%@=%@", kVLCSettingClockJitter, @(1000)],
                //                ]];
                //mp = NULL;
                break;
            }
            rtsp = [[dict objectForKey:[AITCameraCommand PROPERTY_CAMERA_RTSP]] intValue];
            recording = [dict objectForKey:[AITCameraCommand PROPERTY_QUERY_RECORD]];
            camera_mode = [dict objectForKey:@"Camera.Preview.MJPEG.status.mode"];
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
            // Check is recording or idle
            if (![recording caseInsensitiveCompare:@"Recording"]) cameraRecording = YES;
            else cameraRecording = NO;
            //
            //            [self SetRecordButtonTitle:cameraRecording];
            
            //            liveurl = [NSString stringWithFormat:@"rtsp://%@%@", [AITUtil getCameraAddress], DEFAULT_RTSP_URL_V1];
            self.fullScreenBT.hidden = NO;
            
            NSLog(@"MRL = %@", liveurl);
            VLCMedia *media = [VLCMedia mediaWithURL:[NSURL URLWithString:liveurl]];
            media.delegate = self;
            //            [media parseWithOptions:VLCMediaParseNetwork timeout:3];
            
            NSLog(@"Network cache = %@", networkcache);
            //instancetype p;
            
            if (nil == mediaPlayer) {
                mediaPlayer = [[VLCMediaPlayer alloc] init];
            }
            
            //            (void)[mediaPlayer initWithOptions:@[
            //                       [NSString stringWithFormat:@"--%@=%@", kVLCSettingNetworkCaching, /*kVLCSettingNetworkCachingDefaultValue*/ networkcache],
            //                       [NSString stringWithFormat:@"--%@=%@", kVLCSettingClockJitter, @(1000)],
            //            ]];
            (void)[mediaPlayer initWithOptions:nil];
            [mediaPlayer setDelegate:self];
            [mediaPlayer setDrawable:self.playImageView];
            
            [mediaPlayer setMedia:media];
            [mediaPlayer play];
            
            //mediaPlayer.videoAspectRatio =  NULL;
            //mediaPlayer.videoCropGeometry = NULL;
            break;
        }
        case CAMERA_QUERY_CAMID:
            NSLog(@"CAMERA_QUERY_CAMID");
            if ([result rangeOfString:@"rear"].location != NSNotFound) {
                NSLog(@"CAMERA_QUERY_CAMID REAR");
                cam_front = NO;
                //                [self SetCamSwitchButtonTitle:NO];
            } else {//if([result rangeOfString:@"front"].location != NSNotFound) {
                if (YES == cam_front) {
                    [self.view makeToast:NSLocalizedString(@"No rear camera found", nil) duration:1.0f position:CSToastPositionCenter];
                }
                cam_front = YES;
            }
            
            break;
        case CAMERA_CMD_CAMID:
            NSLog(@"CAMERA_CMD_CAMID");
            camera_cmd = CAMERA_QUERY_CAMID;
            (void)[[AITCameraCommand alloc] initWithUrl:[AITCameraCommand commandGetCameraidUrl] Delegate:self];
            [mediaPlayer play];
            //            self.cameraSwitchButton.enabled   = YES;
            break;
        case CAMERA_CMD_RECORD:
            if (result == nil || result.length == 0) {
                [self.view makeToast:NSLocalizedString(@"SendCommandFail", nil) duration:2.0 position:CSToastPositionCenter];
                return;
            }
            
            if ([result containsString:@"OK"]) {
                cameraRecording = !cameraRecording;
            }
            break;
        case CAMERA_CMD_SNAPSHOT: {
            if (result == nil || result.length == 0) {
                [self.view makeToast:NSLocalizedString(@"SendCommandFail", nil) duration:2.0 position:CSToastPositionCenter];
                return;
            } else {
                [self.view makeToast:NSLocalizedString(@"SendCommandSuccess", nil) duration:2.0 position:CSToastPositionCenter];
                [self photosound];
            }
            NSLog(@"");
        }
            //            self.cameraSnapshotButton.enabled = YES;
            break;
        default:
            break;
    }
}

#pragma mark - load data
- (void)loadData
{
}

#pragma mark - Private method implement
- (void)switchCameralAction:(id)sender
{
    if ([mediaPlayer isPlaying]) {
        [mediaPlayer stop];
        usleep(800000);
        NSLog(@"cameraSwitchClick");
        
        camera_cmd = CAMERA_CMD_CAMID;
        
        if (cam_front) {
            //  前置转后置
            (void)[[AITCameraCommand alloc] initWithUrl:[AITCameraCommand commandSetCameraidUrl:CAMERAID_CMD_REAR] Delegate:self];
        } else {
            //  后置转前置
            (void)[[AITCameraCommand alloc] initWithUrl:[AITCameraCommand commandSetCameraidUrl:CAMERAID_CMD_FRONT] Delegate:self];
        }
    }
}

- (void)settingAction:(id)sender
{
    
    if (liveurl.length > 0) {
        
        MSSettingVC *vc = [[MSSettingVC alloc] initWithStyle:UITableViewStyleGrouped];
        vc.hidesBottomBarWhenPushed = YES;
        vc.isRecording = cameraRecording;
        
        [self.navigationController pushViewController:vc animated:YES];
        
    } else {
        [self.view makeToast:NSLocalizedString(@"ConnectTheDeviceWIFI", nil) duration:1. position:CSToastPositionCenter];
    }
    
}

- (void)previewAction:(UIButton *)sender
{
    if (NO == [mediaPlayer isPlaying]) {
        [mediaPlayer stop];
        [mediaPlayer play];
    } else {
        [mediaPlayer pause];
    }
}

//  拍照
- (void)shotAction:(id)sender
{
     __weak typeof(self) weakSelf = self;
    
    (void)[[AITCameraCommand alloc] initWithUrl:[AITCameraCommand commandCameraSnapshotUrl]
                                          block:^(NSString *result) {
                                              [weakSelf handleShotActionBlock];
                                          } fail:^(NSError *error) {
                                              
                                          }];

}

- (void)handleShotActionBlock {
    
    [self photosound];

    [UIView animateWithDuration:.1 animations:^{
        self.playImageView.alpha = 0;
    } completion:^(BOOL finished) {
        self.playImageView.alpha = 1;
    }];
    
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

//  录制视频
- (void)recorderAction:(UIButton *)sender
{
    sender.selected = !sender.selected;

     __weak typeof(self) weakSelf = self;
    
    (void)[[AITCameraCommand alloc] initWithUrl:[AITCameraCommand commandCameraRecordUrl]
                                          block:^(NSString *result) {
                                              [weakSelf handleRecordActionBlock:result];
                                          } fail:^(NSError *error) {
                                              
                                          }];
}

- (void)handleRecordActionBlock:(NSString *)result {
    if (NO == [result containsString:@"OK\n"]) {
        return;
    }
    
    cameraRecording = !cameraRecording;
}


- (void)fullScreenAction:(id)sender
{
    [mediaPlayer stop];
    
    if (liveurl.length > 0) {
        CPPlayerVC *playerVC = [[CPPlayerVC alloc] init];
        //        playerVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        playerVC.hidesBottomBarWhenPushed = YES;
        playerVC.liveurl = liveurl;
        playerVC.networkcache = networkcache;
        
        [self presentViewController:playerVC animated:YES  completion:^{
        }];
    }
    
    
    //    MSPlayerVC *vc = [[MSPlayerVC alloc] init];
    //    vc.liveUrl = liveurl;
    //
    //    [self.navigationController pushViewController:vc animated:YES];
    //    [self presentViewController:vc animated:YES completion:nil];
    
}

- (void)flickRecodeLight
{
    if (cameraRecording == NO) {
        self.redRecrodLight.hidden = YES;
        self.recordBT.selected = YES;
    } else {
        self.redRecrodLight.hidden = !self.redRecrodLight.hidden;
        self.recordBT.selected = NO;
    }
    
    [self performSelector:@selector(flickRecodeLight) withObject:nil afterDelay:1];
}

- (void)CameraStatusArrived:(NSString *)status
{
    NSDictionary *dict_status;
    
    // Check format of the status and is flesh one,
    // if return nil, it is not flesh or wrong format!
    dict_status = [AITCameraListen buildStatusDictionary:status];
    if (dict_status == nil) return;
    NSString *rec = [dict_status objectForKey:@"Recording"];
    if ([rec isEqualToString:@"YES"] != cameraRecording) {
        cameraRecording = !cameraRecording;
        //        [self SetRecordButtonTitle:cameraRecording];
    }
    //NSString *uim = [dict_status objectForKey:@"UIMode"];
}

- (void)queryPreStreamCommd
{
    cameraRecording = NO;

     __weak typeof(self) weakSelf = self;

    (void)[[AITCameraCommand alloc] initWithUrl:[AITCameraCommand commandQueryPreviewStatusUrl]
                                          block:^(NSString *result) {
                                              [weakSelf handleQueryStreamCommdBlock:result];
                                          } fail:^(NSError *error) {
                                              
                                          }];
}

- (void)handleQueryStreamCommdBlock:(NSString *)result {
    if ([result containsString:@"OK\n"] == NO) {
        return;
    }
    
    NSDictionary *dict = [AITCameraCommand buildResultDictionary:result];
    if (dict == nil) {
    }
    
    int rtsp = [[dict objectForKey:[AITCameraCommand PROPERTY_CAMERA_RTSP]] intValue];
    NSString *recording = [dict objectForKey:[AITCameraCommand PROPERTY_QUERY_RECORD]];
    camera_mode = [dict objectForKey:@"Camera.Preview.MJPEG.status.mode"];
    
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
    // Check is recording or idle
    if (![recording caseInsensitiveCompare:@"Recording"]) {
        cameraRecording = YES;
    } else {
        cameraRecording = NO;
    }
    
    self.fullScreenBT.hidden = NO;
    
    NSLog(@"MRL = %@", liveurl);
    VLCMedia *media = [VLCMedia mediaWithURL:[NSURL URLWithString:liveurl]];
    media.delegate = self;
    
    NSLog(@"Network cache = %@", networkcache);
    //instancetype p;
    
    if (nil == mediaPlayer) {
        mediaPlayer = [[VLCMediaPlayer alloc] initWithOptions:@[
                                                                [NSString stringWithFormat:@"--%@=%@",
                                                                 kVLCSettingNetworkCaching, networkcache],
                                                                [NSString stringWithFormat:@"--%@=%@",
                                                                 kVLCSettingClockJitter, @(1000)],
                                                                ]];
    }
    
    [mediaPlayer setDelegate:self];
    [mediaPlayer setDrawable:self.playImageView];
    
    [mediaPlayer setMedia:media];
    [mediaPlayer play];
}

- (void)queryCamMenu
{
    camera_cmd = CAMERA_CMD_CAMMENU;
    (void)[[AITCameraCommand alloc] initWithUrl:[AITCameraCommand commandGetCamMenu] Delegate:self];
}

- (void)queryCamIDUrl
{
    camera_cmd = CAMERA_QUERY_CAMID;
    (void)[[AITCameraCommand alloc] initWithUrl:[AITCameraCommand commandGetCameraidUrl] Delegate:self];
}

- (void)sendRecordCommand:(void (^)(void))block
{
    (void)[[AITCameraCommand alloc] initWithUrl:[AITCameraCommand commandCameraRecordUrl]
                                          block:^(NSString *result) {
                                              if (YES == [result containsString:@"OK\n"]) {
                                                  !block ? : block();
                                              }
                                          } fail:^(NSError *error) {
                                              
                                          }];
}



/**
 同步时间
 */
- (void)syncDate:(void (^)(void))block {
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy$MM$dd$HH$mm$ss"];
    NSString *dateStr = [formatter stringFromDate:date];
    
//    (void)[[AITCameraCommand alloc] initWithUrl:[AITCameraCommand commandSetDateTime:dateStr] Delegate:nil];
    (void)[[AITCameraCommand alloc] initWithUrl:[AITCameraCommand commandSetDateTime:dateStr]
                                          block:^(NSString *result) {
                                              !block ? : block();
                                          } fail:^(NSError *error) {
                                              !block ? : block();
                                          }];
}

- (void)applicationWillResignActive:(NSNotification *)application
{
}

- (void)applicationDidBecomeActive:(NSNotification *)application
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reloadPlayer];
    });
//    [self performSelector:@selector(reloadPlayer) withObject:nil afterDelay:1];
}

- (void)applicationDidEnterBackground:(NSNotification *)application
{
}

- (void)orientChange:(NSNotification *)noti {
    //    NSDictionary* ntfDict = [noti userInfo];
    UIDeviceOrientation  orient = [UIDevice currentDevice].orientation;
    switch (orient) {
        case UIDeviceOrientationPortrait:
            break;
        case UIDeviceOrientationLandscapeLeft:
        {
            [self fullScreenAction:nil];
        }
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            break;
        case UIDeviceOrientationLandscapeRight:
            break;
        default:
            break;
    }
}

@end
