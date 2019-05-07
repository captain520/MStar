//
//  MSPlayerVC.m
//  MStar
//
//  Created by 王璋传 on 2019/3/7.
//  Copyright © 2019 王璋传. All rights reserved.
//

#import "MSPlayerVC.h"
#import <AVFoundation/AVFoundation.h>

@interface MSPlayerVC ()

@property (nonatomic, strong) AVPlayer *player;
@property (strong, nonatomic) AVPlayerLayer *playerLayer;//播放界面（layer）

@end

@implementation MSPlayerVC



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.liveUrl = @"http://122.144.137.20:81/2018/12/video/d63797a1912a4f529d8cffab862d8747.mp4";
    
    NSURL *url = [NSURL URLWithString:self.liveUrl];//[[NSBundle mainBundle] URLForResource:@"FILE171122-141954-0001F.MOV" withExtension:@""];
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:url];
    self.player = [AVPlayer playerWithPlayerItem:item];

    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.frame = CGRectMake(0, 100, UIScreen.mainScreen.bounds.size.width, 200);
    self.playerLayer.backgroundColor = UIColor.purpleColor.CGColor;
    
    [self.view.layer addSublayer:self.playerLayer];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"播放" style:UIBarButtonItemStyleDone target:self action:@selector(playAction:)];
}

- (void)playAction:(id)sender {
    [self.player play];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    [self.player play];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

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

//- (AVPlayer *)player {
//    if (nil == _player) {
//        NSURL *url = [NSURL URLWithString:self.liveUrl];//[[NSBundle mainBundle] URLForResource:@"FILE171122-141954-0001F.MOV" withExtension:@""];
//        _player = [AVPlayer playerWithURL:url];
//    }
//    return _player;
//}

@end
