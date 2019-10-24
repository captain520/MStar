//
//  MSMainVC.m
//  MStar
//
//  Created by 王璋传 on 2019/10/14.
//  Copyright © 2019 王璋传. All rights reserved.
//

#import "MSMainVC.h"
#import "MSPreviewView.h"
#import "MSSettingVC.h"
#import "MSMainController.h"

#import <MobileVLCKit/MobileVLCKit.h>
#import "VLCConstants.h"
#import "CPPlayerVC.h"

static NSString *CAMERAID_CMD_FRONT = @"front";
static NSString *CAMERAID_CMD_REAR = @"rear";

@interface MSMainVC ()<MSMainControllerDelegate>

@property (nonatomic, strong) MSPreviewView *preview;
@property (nonatomic, strong) UIButton *toggleCamBt;
@property (nonatomic, strong) UIButton *shotCameBT;
@property (nonatomic, strong) UIButton *recordCameBT;
@property (nonatomic, strong) UIButton *fullScreenBT;
@property (nonatomic, strong) MSMainController *controller;
@property (nonatomic, strong) UIImageView * splashView;

@property (nonatomic, strong) NSString *liveUrl;

@property (nonatomic, assign) BOOL hasAppear;

@property (nonatomic, assign) BOOL isFullSceen;

@end

//  放到其它地方容易导致崩溃

static VLCMediaPlayer *player;

@implementation MSMainVC {
}

- (void)dealloc {
    NSLog(@"_____________%s_________________",__FUNCTION__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self initBaseProperties];
    [self setupUI];
    [self loadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.hasAppear = YES;
    
    [self startPlay];
    [[MSDeviceMgr manager] startRecrod];
    
//    [self.controller getRecordingState4Loop];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    //    [self.controller stopRecordingState4Loop];
    [self stopPlayer];
    //    [[MSDeviceMgr manager] stopRecrod];
}

- (void)viewDidDisappear:(BOOL)animated {
    self.hasAppear = NO;
}


- (void)initBaseProperties {
    
    self.controller = [[MSMainController alloc] init];
    self.controller.delegate = self;
    
    [self.controller getRecordingState4Loop];
    
    [self addNoticationObserver];
}

- (void)addNoticationObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)setupUI {
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"setting"] style:UIBarButtonItemStylePlain target:self action:@selector(settingAction:)];
    
    self.preview.backgroundColor = UIColor.blackColor;
    
    //  切换摄像头按钮
    self.toggleCamBt = [[UIButton alloc] init];
    self.toggleCamBt.backgroundColor = TestColor;
    
    [self.view addSubview:self.toggleCamBt];
    
    [self.toggleCamBt addTarget:self action:@selector(toggleCamAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.toggleCamBt setImage:[UIImage imageNamed:@"切换前后镜头"] forState:UIControlStateNormal];
    [self.toggleCamBt mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.top.mas_equalTo(self->_preview.mas_bottom).offset(30 RPX);
        make.top.mas_equalTo(NAV_HEIGHT + SCREENWIDTH * 480. / 720);
        make.left.mas_equalTo(30 RPX);
        make.size.mas_equalTo(CGSizeMake(100 RPX, 100 RPX));
    }];
    
    
    //  拍照按钮
    self.shotCameBT = [[UIButton alloc] init];
    self.shotCameBT.backgroundColor = TestColor;
    
    [self.view addSubview:self.shotCameBT];
    [self.shotCameBT setImage:[UIImage imageNamed:@"拍照"] forState:UIControlStateNormal];
    [self.shotCameBT addTarget:self action:@selector(shotCamAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.shotCameBT mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.top.mas_equalTo(self->_preview.mas_bottom).offset(30 RPX);
        make.centerY.mas_equalTo(self->_toggleCamBt.mas_centerY);
        make.right.mas_equalTo(-30 RPX);
        make.size.mas_equalTo(CGSizeMake(100 RPX, 100 RPX));
    }];
    
    
    //  录制按钮
    self.recordCameBT = [UIButton new];//[[UIButton alloc] init];
    self.recordCameBT.backgroundColor = TestColor;
    
    [self.view addSubview:self.recordCameBT];
    [self.recordCameBT setImage:[UIImage imageNamed:@"录像"] forState:UIControlStateNormal];
    [self.recordCameBT addTarget:self action:@selector(recordCamAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.recordCameBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self->_toggleCamBt.mas_bottom).offset(30 RPX);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(80 RPX, 80 RPX));
    }];
    
    
    // 全屏操作
    
    [self.preview.fullScreenBT addTarget:self action:@selector(fullAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark - Set && get method

- (UIImageView *)splashView {
    
    if (nil == _splashView) {
        _splashView = [UIImageView new];
        _splashView.backgroundColor = UIColor.blackColor;
        _splashView.alpha = 0;
        
        [self.preview addSubview:_splashView];
        
        [_splashView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
    }
    
    return _splashView;
}

- (MSPreviewView *)preview {
    
    if (nil == _preview) {
        _preview = [[MSPreviewView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREENWIDTH, SCREENWIDTH * 480. / 720)];
        
        [self.view addSubview:_preview];
        //        [_preview mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.top.mas_equalTo(NAV_HEIGHT);
        //            make.left.mas_equalTo(0);
        //            make.right.mas_equalTo(0);
        //            make.height.mas_equalTo(SCREENWIDTH * 480. / 720);
        //        }];
    }
    
    return _preview;
}


#pragma mark - Delegate method implement

- (void)updateRecordStates:(BOOL)isRecording {
    
    UIImage *image = [UIImage imageNamed:!isRecording ? @"录像":@"已停止"];
    
    [self.recordCameBT setImage:image forState:UIControlStateNormal];
    [self.preview updateRecordStates:isRecording];
}


#pragma mark - Private method

- (void)loadData {
    
    //    __weak typeof(self) weakSelf = self;
    //
    //    [self.controller queryPreStreamCommd:^(NSString * _Nonnull url) {
    //        [weakSelf handleLoadDataSuccessBlock:url];
    //    }];
    
    //    sleep(3);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self handleLoadDataSuccessBlock:@"rtsp://192.72.1.1/liveRTSP/v1"];
    });
}

- (void)handleLoadDataSuccessBlock:(NSString *)liveurl {
    
    __weak MSPreviewView *weakPreView = self.preview;
    
    self.liveUrl = liveurl;
    self.preview.fullScreenBT.hidden = NO;
    
    
    if (nil == player) {
        
        VLCMedia *media = [VLCMedia mediaWithURL:[NSURL URLWithString:liveurl]];
        
        player = [[VLCMediaPlayer alloc] initWithOptions:@[
            [NSString stringWithFormat:@"--%@=%@",
             kVLCSettingNetworkCaching, @"400"],
            [NSString stringWithFormat:@"--%@=%@",
             kVLCSettingClockJitter, @(1000)],
        ]];
        player.videoAspectRatio = "3:2";
        [player setMedia:media];
    }
    
    [player setDrawable:weakPreView];
    
    [self startPlay];
    
}


/// 切换前后摄像头
/// @param sender 控件
- (void)toggleCamAction:(id)sender {
    
    self.preview.image = nil;
    
    [self.view cp_showToast];
    
    [[MSDeviceMgr manager] toggleCameId:^(BOOL done) {
        
        if (done) {
            [self stopPlayer];
            [player play];
            [UIView transitionWithView:self.preview
                              duration:1.0f
                               options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
            } completion:^(BOOL finished) {
            }];
        }
        
        [self.view cp_hideToast];
        
    }];
}

/// 拍照
/// @param sender 控件
- (void)shotCamAction:(id)sender {
    
    [self.view cp_showToast];
    
    [self.controller shotAction:^(BOOL finished) {
        
        [self.view cp_hideToast];
        
        if (YES == finished) {
            [UIView animateWithDuration:.1 animations:^{
                self.splashView.alpha = 1;
            } completion:^(BOOL finished) {
                self.splashView.alpha = 0;
            }];
        }
        
    }];
}

///  切换录制状态
/// @param sender 控件
- (void)recordCamAction:(id)sender {
    
    [self.view cp_showToast];
    
    [self.controller stopRecordingState4Loop];
    
    [[MSDeviceMgr manager] toggleRecordState:^(void) {
        NSLog(@"切换成功");
        [self.view cp_hideToast];
        [self.controller getRecordingState4Loop];
    }];
    
}

/// 返回
/// @param sender 控件
- (void)backAction:(id)sender {
    
    [self.controller stopRecordingState4Loop];
    [self.preview stopFlick];
    [player stop];
    player.drawable = nil;
    
    //    sleep(1);
    [self.parentViewController.navigationController popToRootViewControllerAnimated:YES];
}


/// 进入设置页面
/// @param sender 控件
- (void)settingAction:(UIBarButtonItem *)sender
{
    
    sender.enabled = NO;
    
    [self.navigationController.view cp_showToast];
    
    [[MSDeviceMgr manager] stopRecrod:^{
        
        [self.navigationController.view cp_hideToast];
        
        MSSettingVC *vc = [[MSSettingVC alloc] initWithStyle:UITableViewStyleGrouped];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    [self performSelector:@selector(toggleSettingItemEnable) withObject:nil afterDelay:1.0];
}

- (void)toggleSettingItemEnable {
    self.navigationItem.rightBarButtonItem.enabled = YES;
}


- (void)applicationDidBecomeActive:(NSNotification *)application
{
    [self backAction:nil];
}

- (void)orientChange:(NSNotification *)noti {
    
    NSLog(@"-------------- 横竖屏切换 ----------------");
    //    NSDictionary* ntfDict = [noti userInfo];
    UIDeviceOrientation  orient = [UIDevice currentDevice].orientation;
    switch (orient) {
        case UIDeviceOrientationPortrait:
            [self minScreen];
            break;
        case UIDeviceOrientationLandscapeLeft:
        {
            NSLog(@"%s",__FUNCTION__);
            //            !self.hasAppear ? : [self fullAction:nil];
            //            [self fullAction:nil];
            [self maxScreen];
        }
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            break;
        case UIDeviceOrientationLandscapeRight:
            [self maxScreen];
            break;
        default:
            break;
    }
}

- (void)stopPlayer {
    self.preview.image = nil;
    [player stop];
}

- (void)startPlay {
    [self.view bringSubviewToFront:self.fullScreenBT];
    [player play];
}


- (void)fullAction:(id)sender {
    
    if (self.hasAppear == NO) {
        return;
    }
    
    if (self.liveUrl.length > 0){
        
        if (self.isFullSceen == NO) {
            [self maxScreen];
        } else {
            [self minScreen];
        }
    }
    
    
    //    [self stopPlayer];
    //
    //    if (self.liveUrl.length > 0) {
    //
    //
    //        if ([MSDeviceMgr manager].fullScreen == NO && self.hasAppear == YES) {
    //            [MSDeviceMgr manager].fullScreen = YES;
    //            CPPlayerVC *playerVC = [[CPPlayerVC alloc] init];
    //            //        playerVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    //            playerVC.hidesBottomBarWhenPushed = YES;
    //            playerVC.liveurl = self.liveUrl;
    //            playerVC.networkcache = @"400";
    //            playerVC.controller = self.controller;
    //
    //            [self presentViewController:playerVC animated:YES  completion:^{
    //            }];
    //        } else {
    //
    //        }
    //
    //
    //    }
}

- (void)maxScreen {
    
    if (self.hasAppear == NO) {
        return;
    }
    
    if (self.isFullSceen == NO) {
        
        
        UIApplication.sharedApplication.statusBarHidden = YES;
        self.isFullSceen = YES;
        
        [self.preview removeFromSuperview];
        [UIApplication.sharedApplication.keyWindow addSubview:self.preview];
        
        [UIView animateWithDuration:.25f animations:^{
            self.preview.frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.height, UIScreen.mainScreen.bounds.size.width);
            self.preview.center = CGPointMake(CGRectGetMidX(UIApplication.sharedApplication.keyWindow.bounds), CGRectGetMidY(UIApplication.sharedApplication.keyWindow.bounds));
            
            self.preview.transform = CGAffineTransformMakeRotation(M_PI_2);
        }];
    }
}

- (void)minScreen {
    
    if (self.hasAppear == NO) {
        return;
    }
    
    if (self.isFullSceen == YES) {
        
        UIApplication.sharedApplication.statusBarHidden = NO;
        self.isFullSceen = NO;
        
        [self.preview removeFromSuperview];
        [self.view addSubview:self.preview];
        
        [UIView animateWithDuration:.25f animations:^{
            self.preview.transform = CGAffineTransformIdentity;
            self.preview.frame = CGRectMake(0, NAV_HEIGHT, SCREENWIDTH, SCREENWIDTH * 480. / 720);
            [self.preview setNeedsDisplay];
        }];
        
    }
}

- (void)viewWillLayoutSubviews {
    NSLog(@"------------------------------");
}



@end
