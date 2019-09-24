//
//  MSDeviceMgr.h
//  MStar
//
//  Created by 王璋传 on 2019/9/19.
//  Copyright © 2019 王璋传. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MSDeviceMgr : NSObject

+ (instancetype)manager;

//  获取录制状态
- (void)getRecordingState:(void (^)(BOOL recordState))block;

//  打开录制
- (void)startRecrod;

//  停止录制
- (void)stopRecrod;

- (void)stopRecrod:(void (^)(void))block;

@end

NS_ASSUME_NONNULL_END
