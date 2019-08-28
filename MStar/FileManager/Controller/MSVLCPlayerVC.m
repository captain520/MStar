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

@interface MSVLCPlayerVC ()<VLCMediaPlayerDelegate>

@property (nonatomic, strong) VLCMediaPlayer *player;

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
    
    if (self.player.isPlaying) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideTool) object:nil];
        
        [UIView animateWithDuration:1.0f animations:^{
            self.toolView.alpha = 0;
            self.backButton.alpha = 0;
        }];
    }
    
}
#pragma mark - Delegate && dataSource method implement
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
    self.currentTimeLB.text = self.player.time.stringValue;
    self.remainTimeLabel.text = self.player.media.length.stringValue;//self.player.remainingTime.stringValue;
    self.progressSlider.value = self.player.position;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.player play];
    
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
    self.player.position = sender.value;
}

- (IBAction)playOrPauseAction:(id)sender {
    if (self.player.isPlaying) {
        [self.player pause];
    } else {
        if (self.player.state == VLCMediaPlayerStateStopped) {
            [self.player stop];
        }
        
        [self.player play];
        
        [self performSelector:@selector(hideTool) withObject:nil afterDelay:3];
    }
}
- (IBAction)backAction:(id)sender {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationPortrait) {
//        [self.navigationController popViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
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

@end
