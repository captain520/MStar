//
//  MSPreviewView.h
//  MStar
//
//  Created by 王璋传 on 2019/10/14.
//  Copyright © 2019 王璋传. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MSPreviewView : UIImageView

@property (nonatomic, strong) UIButton *redRecrodLight;
@property (nonatomic, strong) UIButton *fullScreenBT;

/// 更新录制状态·
/// @param isRecording  YES: 录制中  NO: 未录制
- (void)updateRecordStates:(BOOL)isRecording;

/// 停止闪烁
- (void)stopFlick;

@end

NS_ASSUME_NONNULL_END
