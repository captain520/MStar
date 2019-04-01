//
//  MSDownloadView.m
//  MStar
//
//  Created by 王璋传 on 2019/3/7.
//  Copyright © 2019 王璋传. All rights reserved.
//

#import "MSDownloadView.h"
#import <Masonry.h>

@interface MSDownloadView()

@property (nonatomic, strong) UIView *downloadView;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UILabel *comepelteHintLB;
@property (nonatomic, strong) UIButton *cancelBt;

@end

@implementation MSDownloadView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    
    {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.5];
    }
    
    {
        self.downloadView = [UIView new];
        self.downloadView.backgroundColor = UIColor.whiteColor;
        self.downloadView.layer.cornerRadius = 5.0f;
        
        [self addSubview:self.downloadView];
        [self.downloadView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.right.mas_equalTo(-16);
            make.centerY.mas_equalTo(0);
            make.height.mas_equalTo(180);
        }];
    }
    
    {
        self.progressView = [UIProgressView new];
        self.progressView.progress = .5;
        
        [self.downloadView addSubview:self.progressView];
        [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(-32);
            make.left.mas_equalTo(16);
            make.right.mas_equalTo(-16);
            make.height.mas_equalTo(30);
        }];
    }
    
    {
        self.comepelteHintLB = [UILabel new];
        self.comepelteHintLB.font = [UIFont systemFontOfSize:13];
        self.comepelteHintLB.text = @"已下载50.01%";
        self.comepelteHintLB.textColor = UIColor.blueColor;
        self.comepelteHintLB.textAlignment = NSTextAlignmentCenter;
        
        [self.downloadView addSubview:self.comepelteHintLB];
        [self.comepelteHintLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self->_progressView.mas_bottom).offset(16);
            make.left.mas_equalTo(16);
            make.right.mas_equalTo(-16);
        }];
    }
    
    {
        UIView *sepLine = [UIView new];
        sepLine.backgroundColor = UIColor.grayColor;
        
        [self.downloadView addSubview:sepLine];
        [sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-40);
            make.height.mas_equalTo(.5);
        }];
    }
    
    {
        self.cancelBt = [UIButton new];
        self.cancelBt.titleLabel.font = [UIFont systemFontOfSize:13];
        self.cancelBt.layer.cornerRadius = 5.0f;

        [self.downloadView addSubview:self.cancelBt];
        [self.cancelBt setTitle:@"取 消" forState:UIControlStateNormal];
        [self.cancelBt setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [self.cancelBt addTarget:self action:@selector(dimiss) forControlEvents:UIControlEventTouchUpInside];
        [self.cancelBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(40);
        }];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dimiss];
}

- (void)show {
    
    [UIApplication.sharedApplication.keyWindow addSubview:self];
}

- (void)dimiss {
    [self removeFromSuperview];
}

@end
