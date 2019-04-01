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

@interface MSPreviewVC ()

@property (nonatomic, strong) AVPlayer *player;
@property (strong, nonatomic)AVPlayerLayer *playerLayer;//播放界面（layer）

@property (nonatomic, strong) UIButton *recordBT, *shotBT, *previewBT;

@property (nonatomic, strong) UIButton *fullScreenBT;

@property (nonatomic,strong) UIButton *redRecrodLight;

@end

@implementation MSPreviewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initailizeBaseProperties];
    [self setupUI];
    [self flickRecodeLight];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Initialized properties
- (void)initailizeBaseProperties {
    
}
#pragma mark - setter && getter method
- (AVPlayer *)player {
    if (nil == _player) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"FILE171122-141954-0001F.MOV" withExtension:nil];
        _player = [AVPlayer playerWithURL:url];
    }
    return _player;
}
#pragma mark - Setup UI
- (void)setupUI {
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"SwitchCameral"] style:UIBarButtonItemStylePlain target:self action:@selector(switchCameralAction:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"setting"] style:UIBarButtonItemStylePlain target:self action:@selector(settingAction:)];
    
    
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.frame = CGRectMake(0, UIApplication.sharedApplication.statusBarFrame.size.height + 44 * 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.width * 3 / 4);
    [self.view.layer addSublayer:self.playerLayer];
    
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
        
        [self.view addSubview:self.fullScreenBT];
        [self.fullScreenBT addTarget:self action:@selector(fullScreenAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.fullScreenBT setImage:[UIImage imageNamed:@"全屏"] forState:UIControlStateNormal];
        [self.fullScreenBT mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(UIApplication.sharedApplication.statusBarFrame.size.height * 0 + UIScreen.mainScreen.bounds.size.width * 3 / 4 - 40 - 16);
            make.right.mas_equalTo(-16);
            make.size.mas_equalTo(CGSizeMake(40, 40));
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

    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"在使用之前请确保连接了设备WIFI" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    
    [alertView show];

}
#pragma mark - Delegate && dataSource method implement
#pragma mark - load data
- (void)loadData {
    
}

#pragma mark - Private method implement
- (void)switchCameralAction:(id)sender {
    
}

- (void)settingAction:(id)sender {
    
    MSSettingVC *vc = [[MSSettingVC alloc] initWithStyle:UITableViewStyleGrouped];
    vc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)previewAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    if (sender.isSelected) {
        [self.player play];
    } else {
        [self.player pause];
    }
}

- (void)shotAction:(id)sender {
    
}

- (void)recorderAction:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (void)fullScreenAction:(id)sender {
    [self.player pause];
    
    CPPlayerVC *playerVC = [[CPPlayerVC alloc] init];
    playerVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController presentViewController:playerVC animated:YES completion:^{
        
    }];
}

- (void)flickRecodeLight {
    
    self.redRecrodLight.hidden = !self.redRecrodLight.hidden;
    
    [self performSelector:@selector(flickRecodeLight) withObject:nil afterDelay:1];
}

@end
