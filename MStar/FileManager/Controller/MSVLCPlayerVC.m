//
//  MSVLCPlayerVC.m
//  CPSpace
//
//  Created by 王璋传 on 2019/5/9.
//  Copyright © 2019 王璋传. All rights reserved.
//

#import "MSVLCPlayerVC.h"
#import <MobileVLCKit/MobileVLCKit.h>
#import "UIImage+Category.h"
#import <AVFoundation/AVFoundation.h>

@interface MSVLCPlayerVC ()<VLCMediaPlayerDelegate>

@property (nonatomic, strong) VLCMediaPlayer *player;

@property (nonatomic,strong)AVPlayer *avPlayer;//播放器对象
@property (nonatomic,strong)AVPlayerItem *currentPlayerItem;
@property (nonatomic,strong)AVPlayerLayer *avLayer;

@property (nonatomic, strong) id timeTarget;

@end

@implementation MSVLCPlayerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initailizeBaseProperties];
    [self setupUI];
}

#pragma mark - Initialized properties
- (void)initailizeBaseProperties {
    self.view.backgroundColor = UIColor.blackColor;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
}
#pragma mark - setter && getter method

- (AVPlayer *)avPlayer {
    
    if (nil == _avPlayer) {
        NSURL *itemUrl = [NSURL fileURLWithPath:self.videoUrl];
        self.currentPlayerItem = [[AVPlayerItem alloc] initWithURL:itemUrl];
        
        _avPlayer = [[AVPlayer alloc] initWithPlayerItem:self.currentPlayerItem];
        
        self.avLayer = [AVPlayerLayer playerLayerWithPlayer:_avPlayer];
        self.avLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        
        [self.view.layer addSublayer:self.avLayer];
        
        [self.currentPlayerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
//        观察loadedTimeRanges，可以获取缓存进度，实现缓冲进度条
        [self.currentPlayerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    }
    
    return _avPlayer;
}


- (VLCMediaPlayer *)player {
    if (nil == _player) {
        
        if (self.videoUrl == nil) {
            NSString *urlStr = @"http://122.144.137.20:81/2018/12/video/d63797a1912a4f529d8cffab862d8747.mp4";
            self.videoUrl = urlStr;
        }
        
        NSURL *mediaUrl = nil;

        if ([self.videoUrl hasPrefix:@"http"]) {
            mediaUrl = [NSURL URLWithString:self.videoUrl];
        } else {
            mediaUrl = [NSURL fileURLWithPath:self.videoUrl];
        }
        
        VLCMedia *media = [VLCMedia mediaWithURL:mediaUrl];
//        VLCMedia *media = [VLCMedia mediaWithURL:[NSURL URLWithString:self.videoUrl]];

        _player = [[VLCMediaPlayer alloc] initWithOptions:nil];
        _player.delegate = self;
        _player.media = media;
        _player.drawable = self.view;
    }
    
    return _player;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.avLayer.frame = self.view.bounds;
}

#pragma mark - Setup UI
- (void)setupUI {
    [self.progressSlider setThumbImage:[UIImage imageNamed:@"滑块"] forState:UIControlStateNormal];
    [self.progressSlider setThumbImage:[UIImage imageNamed:@"滑块"] forState:UIControlStateHighlighted];
}

- (void)showTool {
    
    [self.view bringSubviewToFront:self.backButton];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showTool) object:nil];

    [self.view bringSubviewToFront:self.toolView];

    [UIView animateWithDuration:1.0f animations:^{
        self.toolView.alpha = 1;
        self.backButton.alpha = 1;
    }];
    
    if (self.player.isPlaying) {
        [self performSelector:@selector(hideTool) withObject:nil afterDelay:5];
    }
    
}

- (void)hideTool {
    
//    if (self.player.isPlaying) {
//        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideTool) object:nil];
//
//        [UIView animateWithDuration:1.0f animations:^{
//            self.toolView.alpha = 0;
//            self.backButton.alpha = 0;
//        }];
//    }
    
}
#pragma mark - Delegate && dataSource method implement

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        //获取playerItem的status属性最新的状态
        AVPlayerStatus status = [[change objectForKey:@"new"] intValue];
        switch (status) {
            case AVPlayerStatusReadyToPlay:{
                //获取视频长度
                CMTime duration = playerItem.duration;
                //更新显示:视频总时长(自定义方法显示时间的格式)
                self.remainTimeLabel.text = [self formatTimeWithTimeInterVal:CMTimeGetSeconds(duration)];
                //开启滑块的滑动功能
                break;
            }
            case AVPlayerStatusFailed:{//视频加载失败，点击重新加载
                
                break;
            }
            case AVPlayerStatusUnknown:{
                NSLog(@"加载遇到未知问题:AVPlayerStatusUnknown");
                break;
            }
            default:
                break;
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        //获取视频缓冲进度数组，这些缓冲的数组可能不是连续的
        NSArray *loadedTimeRanges = playerItem.loadedTimeRanges;
        //获取最新的缓冲区间
        CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];
        //缓冲区间的开始的时间
        NSTimeInterval loadStartSeconds = CMTimeGetSeconds(timeRange.start);
        //缓冲区间的时长
        NSTimeInterval loadDurationSeconds = CMTimeGetSeconds(timeRange.duration);
        //当前视频缓冲时间总长度
        NSTimeInterval currentLoadTotalTime = loadStartSeconds + loadDurationSeconds;
        //NSLog(@"开始缓冲:%f,缓冲时长:%f,总时间:%f", loadStartSeconds, loadDurationSeconds, currentLoadTotalTime);
        //更新显示：当前缓冲总时长
//        _currentLoadTimeLabel.text = [self formatTimeWithTimeInterVal:currentLoadTotalTime];
        //更新显示：视频的总时长
        self.remainTimeLabel.text = [self formatTimeWithTimeInterVal:CMTimeGetSeconds(self.avPlayer.currentItem.duration)];
//        self.currentTimeLB.text = [self formatTimeWithTimeInterVal:CMTimeGetSeconds(self.avPlayer.currentTime)];
        //更新显示：缓冲进度条的值
//        _progressView.progress = currentLoadTotalTime/CMTimeGetSeconds(self.player.currentItem.duration);
    }
}

//转换时间格式的方法
- (NSString *)formatTimeWithTimeInterVal:(NSTimeInterval)timeInterVal{
    int minute = 0, hour = 0, secend = timeInterVal;
    minute = (secend % 3600)/60;
    hour = secend / 3600;
    secend = secend % 60;
    return [NSString stringWithFormat:@"%02d:%02d:%02d", hour, minute, secend];
}

- (void)mediaPlayerStateChanged:(NSNotification *)aNotification
{
    switch (self.player.state) {
        case VLCMediaPlayerStatePaused:
        {
            NSLog(@"Paused");
            [self.playPauseButton setImage:[UIImage imageNamed:@"播放按钮"] forState:UIControlStateNormal];
            [self showTool];
            [[CPLoadStatusToast shareInstance] dimiss];
        }
            break;
        case VLCMediaPlayerStateStopped: {
            NSLog(@"Stoped");
            [self.playPauseButton setImage:[UIImage imageNamed:@"播放按钮"] forState:UIControlStateNormal];
            [self showTool];
            [[CPLoadStatusToast shareInstance] dimiss];
        }
            break;
        case VLCMediaPlayerStateEnded: {
            NSLog(@"playing");
            [self.playPauseButton setImage:[UIImage imageNamed:@"播放按钮"] forState:UIControlStateNormal];
            [self showTool];
            [[CPLoadStatusToast shareInstance] dimiss];
        }
            break;
        case VLCMediaPlayerStatePlaying: {
            NSLog(@"playing");
            [self.playPauseButton setImage:[UIImage imageNamed:@"暂停按钮"] forState:UIControlStateNormal];
//            [self performSelector:@selector(showTool) withObject:nil afterDelay:3];
            [self showTool];
            [[CPLoadStatusToast shareInstance] dimiss];
        }
            break;
        case VLCMediaPlayerStateError: {
            [self.playPauseButton setImage:[UIImage imageNamed:@"播放按钮"] forState:UIControlStateNormal];
            NSLog(@"error");
            [self showTool];
            [[CPLoadStatusToast shareInstance] dimiss];
        }
            break;
            
        case VLCMediaPlayerStateBuffering: {
            NSLog(@"6666666666");
//            [CPLoadStatusToast shareInstance].style = CPLoadStatusStyleLoading;
//            [[CPLoadStatusToast shareInstance] show];
        }
            break;
        default:
            break;
    }
}

- (void)mediaPlayerTimeChanged:(NSNotification *)aNotification {
    
    NSLog(@"%s",__FUNCTION__);
    
    self.currentTimeLB.text = self.player.time.stringValue;
    self.remainTimeLabel.text = self.player.media.length.stringValue;//self.player.remainingTime.stringValue;
    self.progressSlider.value = self.player.position;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (YES == isMovMediaType(self.videoUrl)) {
        [self.currentPlayerItem removeObserver:self forKeyPath:@"status" context:nil];
        [self.currentPlayerItem removeObserver:self forKeyPath:@"loadedTimeRanges" context:nil];
        [self.avPlayer  removeTimeObserver:self.timeTarget];
    }
    
    
    NSLog(@"------------------------------------------------ Delloc ----------------------------------------------------");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (isMovMediaType(self.videoUrl)) {
        NSLog(@"mov类型文件");
        [self.avPlayer play];
        
        __weak typeof(self) weakSelf = self;
        
        self.timeTarget = [self.avPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
            
            //当前播放的时间
            NSTimeInterval currentTime = CMTimeGetSeconds(time);
            //视频的总时间
            NSTimeInterval totalTime = CMTimeGetSeconds(weakSelf.currentPlayerItem.duration);
            //设置滑块的当前进度
            weakSelf.remainTimeLabel.text = [weakSelf formatTimeWithTimeInterVal:totalTime];
            weakSelf.progressSlider.value = currentTime / totalTime;
            //设置显示的时间：以00:00:00的格式
            weakSelf.currentTimeLB.text = [weakSelf formatTimeWithTimeInterVal:currentTime];
            
            NSLog(@"progress:%@",@(weakSelf.progressSlider.value));
            
            if (weakSelf.progressSlider.value >= 0.99) {
                [weakSelf backAction:nil];
            }

        }];
    } else {
        NSLog(@"%@类型文件",self.videoUrl.pathExtension);
        [self.player play];
    }

//    [self.player play];
    
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
//    [self.navigationController.navigationBar setBackgroundColor:UIColor.clearColor];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
//    [self.navigationController.navigationBar setBackgroundImage:UIImage.new forBarMetrics:UIBarMetricsDefault];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
//    [self.navigationController.navigationBar setBackgroundColor:UIColor.whiteColor];
//    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:UIColor.grayColor]];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:UIColor.whiteColor] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskPortrait;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self showTool];
}

#pragma mark - load data
- (void)loadData {
    
}
- (void)handleLoadDataBlock:(NSArray *)results {
}

#pragma mark - Private method implement
- (IBAction)fullAction:(UIButton *)sender {
    
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationLandscapeRight;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

- (IBAction)sliderAction:(UISlider *)sender {
    
    if (isMovMediaType(self.videoUrl)) {
        
        NSTimeInterval playTime = sender.value * CMTimeGetSeconds(self.currentPlayerItem.duration);
        CMTime seekTime = CMTimeMake(playTime, 1);
        
        [self.avPlayer seekToTime:seekTime];
       
    } else {
        self.player.position = sender.value;
    }
}

- (IBAction)playOrPauseAction:(id)sender {

    if (isMovMediaType(self.videoUrl)) {
        if (self.avPlayer.rate > 0.0001) {
            [self.avPlayer pause];
            [self.playPauseButton setImage:[UIImage imageNamed:@"播放按钮"] forState:UIControlStateNormal];
        } else {
            [self.avPlayer play];
            [self.playPauseButton setImage:[UIImage imageNamed:@"暂停按钮"] forState:UIControlStateNormal];
        }
    } else {
        if (self.player.isPlaying) {
            [self.player pause];
        } else {
            if (self.player.state == VLCMediaPlayerStateStopped) {
                [self.player stop];
            } else {
                [self.player play];
            }
            
            [self performSelector:@selector(hideTool) withObject:nil afterDelay:3];
        }
    }
    
}
- (IBAction)backAction:(id)sender {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationPortrait) {
//        [self.navigationController popViewControllerAnimated:YES];
        
//        [self.currentPlayerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
//        //        观察loadedTimeRanges，可以获取缓存进度，实现缓冲进度条
//        [self.currentPlayerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
        
//        [self.currentPlayerItem removeObserver:self forKeyPath:@"status" context:nil];
//        [self.currentPlayerItem removeObserver:self forKeyPath:@"loadedTimeRanges" context:nil];

//        [self dismissViewControllerAnimated:YES completion:nil];
        [self dismissViewControllerAnimated:YES completion:^{
            [self.player stop];
        }];
    } else {
        
        if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
            SEL selector = NSSelectorFromString(@"setOrientation:");
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
            [invocation setSelector:selector];
            [invocation setTarget:[UIDevice currentDevice]];
            int val = UIInterfaceOrientationPortrait;
            [invocation setArgument:&val atIndex:2];
            [invocation invoke];
        }
    }
}

- (void)orientChange:(NSNotification *)noti {
    //    NSDictionary* ntfDict = [noti userInfo];
    UIDeviceOrientation  orient = [UIDevice currentDevice].orientation;
    switch (orient) {
        case UIDeviceOrientationPortrait:
        {
            self.fullactoinButton.hidden = NO;
        }
            break;
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationPortraitUpsideDown:
        case UIDeviceOrientationLandscapeRight:
        {
            self.fullactoinButton.hidden = YES;
        }
            break;
        default:
            break;
    }
}

//  判断是不是Mov文件类型
static BOOL isMovMediaType(NSString *videoUrl) {
    
//    return YES;
//
//    return NO;
    
    return [videoUrl.pathExtension caseInsensitiveCompare:@"mov"] == NSOrderedSame;
//    if ([videoUrl hasPrefix:@"http"]) {
//        return NO;
//    } else {
//        return [videoUrl.pathExtension caseInsensitiveCompare:@"mov"] == NSOrderedSame;
//    }
}

@end
