//
//  CPPlayerVC.m
//  CPSpace
//
//  Created by 王璋传 on 2019/3/1.
//  Copyright © 2019 王璋传. All rights reserved.
//

#import "CPPlayerVC.h"
#import <AVFoundation/AVFoundation.h>
#import <Masonry.h>
#import <MobileVLCKit/MobileVLCKit.h>
#import "VLCConstants.h"

@interface CPPlayerVC () <VLCMediaDelegate,VLCMediaPlayerDelegate>{
    VLCMediaPlayer *mediaPlayer ;
}

//@property (nonatomic, strong) AVPlayer *player;
//@property (strong, nonatomic)AVPlayerLayer *playerLayer;//播放界面（layer）

@property (nonatomic, strong) UIImageView *playImageView;

@property (nonatomic, strong)  UIView *playerView;

@property (nonatomic, strong) UIButton *backBt;

@property (nonatomic, strong) UIView *actionView;

@property (nonatomic,strong) UIButton *redRecrodLight;

@end

@implementation CPPlayerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self setupUI];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self setupUI];

    [self autoDimiss];
    
    [self flickRecodeLight];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [mediaPlayer stop];
    
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

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)setupUI {
    
    self.view.backgroundColor = UIColor.grayColor;
    
    if ( nil == self.playImageView ) {
        self.playImageView = [UIImageView new];
        self.playImageView.backgroundColor = UIColor.redColor;
        self.playImageView.contentMode = UIViewContentModeScaleToFill;

        [self.view addSubview:self.playImageView];
        [self.playImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
    }
    

    self.playerView = [UIView new];
    self.playerView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.playerView];
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.top.mas_equalTo(0);
    }];
    
    VLCMedia *media = [VLCMedia mediaWithURL:[NSURL URLWithString:self.liveurl]];
    
    mediaPlayer = [[VLCMediaPlayer alloc] initWithOptions:@[
                                                            [NSString stringWithFormat:@"--%@=%@", kVLCSettingNetworkCaching,self.networkcache == nil ? kVLCSettingNetworkCachingDefaultValue : self.networkcache],
                                                            [NSString stringWithFormat:@"--%@=%@", kVLCSettingClockJitter, kVLCSettingClockJitterDefaultValue],
                                                            ]];
    mediaPlayer.videoAspectRatio = "16:9";
    [mediaPlayer setDelegate:self];
    [mediaPlayer setDrawable:self.playImageView];
    
    [mediaPlayer setMedia:media];
    [mediaPlayer play];
    
//    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
//    self.playerLayer.frame = self.playerView.bounds;
//    [self.playerView.layer addSublayer:self.playerLayer];
    
    {
        self.backBt = [UIButton new];
        self.backBt.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        self.backBt.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.5f];

        [self.playerView addSubview:self.backBt];
        [self.backBt setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [self.backBt setBackgroundImage:[UIImage imageNamed:@"shadowbg"] forState:UIControlStateNormal];
        [self.backBt setImageEdgeInsets:UIEdgeInsetsMake(0, 16, 0, 0)];
        [self.backBt addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.backBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(60);
        }];

        self.redRecrodLight = [UIButton new];
        
        [self.redRecrodLight setTitleColor:UIColor.redColor forState:UIControlStateNormal];
        [self.redRecrodLight setTitle:@" REC" forState:UIControlStateNormal];
        [self.redRecrodLight setImage:[UIImage imageNamed:@"record"] forState:UIControlStateNormal];
        [self.playerView addSubview:self.redRecrodLight];
        [self.redRecrodLight mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.top.mas_equalTo(self.backBt.mas_bottom).offset(8);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(30);
        }];
    }
    
    {
        self.actionView = [UIView new];
        self.actionView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0];
        
        [self.playerView addSubview:self.actionView];
        [self.actionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.width.mas_equalTo(80);
        }];
        
        
        UIButton *shotBt = [UIButton new];
        [shotBt setBackgroundImage:[UIImage imageNamed:@"yulanPaizhao"] forState:UIControlStateNormal];

        [self.actionView addSubview:shotBt];
        [shotBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.right.mas_equalTo(-8);
            make.height.mas_equalTo(shotBt.mas_width);
            make.bottom.mas_equalTo(-16 * 3);
        }];
        
        UIButton *recordBt = [UIButton new];
        [recordBt setBackgroundImage:[UIImage imageNamed:@"yulanShiping"] forState:UIControlStateNormal];
        
        [self.actionView addSubview:recordBt];
        [recordBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.right.mas_equalTo(-8);
            make.height.mas_equalTo(recordBt.mas_width);
            make.bottom.mas_equalTo(shotBt.mas_top).offset(-16 * 3);
        }];

    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self showTool];
}

#pragma mark - private method imeplement

- (void)playAction:(id)sender {
    if ([mediaPlayer isPlaying]) {
        [mediaPlayer pause];
    } else {
        [mediaPlayer play];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImage *)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode =AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)actualTime:NULL error:&thumbnailImageGenerationError];
    
    if(!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
    
    UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage:thumbnailImageRef] : nil;
    return thumbnailImage;
}

- (void)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)hideTool {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideTool) object:nil];
    
    [UIView animateWithDuration:.5 animations:^{
        
        [self.backBt mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(-60);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(60);
        }];
        
        [self.actionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.right.mas_equalTo(80);
            make.bottom.mas_equalTo(0);
            make.width.mas_equalTo(80);
        }];
        
        [self.view layoutIfNeeded];
    }];
}

- (void)showTool {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showTool) object:nil];

    [UIView animateWithDuration:.5 animations:^{
        
        [self.backBt mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(60);
        }];
        
        [self.actionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.width.mas_equalTo(80);
        }];

        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        [self autoDimiss];
    }];
}

- (void)autoDimiss {
    [self performSelector:@selector(hideTool) withObject:nil afterDelay:3.0];
}

- (void)flickRecodeLight {
    
    self.redRecrodLight.hidden = !self.redRecrodLight.hidden;
    
    [self performSelector:@selector(flickRecodeLight) withObject:nil afterDelay:1];
}

@end
