//
//  MSPreviewView.m
//  MStar
//
//  Created by 王璋传 on 2019/10/14.
//  Copyright © 2019 王璋传. All rights reserved.
//

#import "MSPreviewView.h"

@implementation MSPreviewView {
    BOOL isRecordStates;
}

- (void)dealloc {
    NSLog(@"%s",__FUNCTION__);
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.image = [UIImage imageNamed:@"NoWifi"];
        self.contentMode = UIViewContentModeCenter;
        self.userInteractionEnabled = YES;
        
        [self setupUI];
        [self flick];
    }
    
    return self;
}

- (void)setupUI {
    
    self.redRecrodLight = [UIButton new];
    
    [self.redRecrodLight setTitleColor:UIColor.redColor forState:UIControlStateNormal];
    [self.redRecrodLight setTitle:@" REC" forState:UIControlStateNormal];
    [self.redRecrodLight setImage:[UIImage imageNamed:@"record"] forState:UIControlStateNormal];
    [self addSubview:self.redRecrodLight];
    [self.redRecrodLight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(16);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
    }];
    
    //  全屏按钮
    self.fullScreenBT = [UIButton new];
    self.fullScreenBT.hidden = YES;
    
    [self addSubview:self.fullScreenBT];
    [self.fullScreenBT setImage:[UIImage imageNamed:@"全屏"] forState:UIControlStateNormal];
    [self.fullScreenBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16);
        make.bottom.mas_equalTo(-16);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
}

- (void)updateRecordStates:(BOOL)isRecording {
    isRecordStates = isRecording;
}

/// 开始闪烁
- (void)flick {
    
    isRecordStates = [MSDeviceMgr manager].isRecording;
    
    [self bringSubviewToFront:self.redRecrodLight];
    [self bringSubviewToFront:self.fullScreenBT];

    if (isRecordStates == NO) {
        self.redRecrodLight.hidden = YES;
    } else {
        self.redRecrodLight.hidden = !self.redRecrodLight.hidden;
    }
    
    [self performSelector:@selector(flick) withObject:nil afterDelay:1.0f];
}

/// 停止闪烁
- (void)stopFlick {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(flick) object:nil];
}

@end
