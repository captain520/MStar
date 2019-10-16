//
//  MSMainController.h
//  MStar
//
//  Created by 王璋传 on 2019/10/14.
//  Copyright © 2019 王璋传. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSMainVC.h"

@protocol MSMainControllerDelegate <NSObject>

@optional

/// 更新录制状态·
/// @param isRecording  YES: 录制中  NO: 未录制
- (void)updateRecordStates:(BOOL)isRecording;

@end

NS_ASSUME_NONNULL_BEGIN

@interface MSMainController : NSObject

@property (nonatomic, weak) id <MSMainControllerDelegate> delegate;
@property (nonatomic, copy) void (^updateRecordStatesBlock)(BOOL isRecording);


/// 获取录制状态
- (void)getRecordingState4Loop;


/// 停止获取录制状态
- (void)stopRecordingState4Loop;


/// 设备是否为本公司设备
/// @param block 回调
- (void)isDevice4Togevision:(void (^)(NSString *fwVersion))block;


/// 查询直播流路径
/// @param block 回调
- (void)queryPreStreamCommd:(void (^)(NSString *url))block;


/// 拍照
/// @param block 回调
- (void)shotAction:(void (^)(void))block;

@end

NS_ASSUME_NONNULL_END
