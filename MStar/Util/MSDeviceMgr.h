//
//  MSDeviceMgr.h
//  MStar
//
//  Created by 王璋传 on 2019/9/19.
//  Copyright © 2019 王璋传. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AITFileNode.h"

NS_ASSUME_NONNULL_BEGIN

@interface MSDeviceMgr : NSObject

@property (nonatomic, strong) NSString *camId;

@property (nonatomic, assign) BOOL fullScreen;

@property (nonatomic, assign) BOOL isRecording;

+ (instancetype)manager;

//  获取录制状态
- (void)getRecordingState:(void (^)(BOOL recordState))block;

//  打开录制
- (void)startRecrod;

//  停止录制
- (void)stopRecrod;

- (void)stopRecrod:(void (^)(void))block;


///  切换录制状态
/// @param block 切换成功回调
- (void)toggleRecordState:(void (^)(void))block ;


/// 切换前后摄像头
/// @param block 回调
- (void)toggleCameId:(void (^)(BOOL done))block;


- (void)loadRemoteFile:(W1MFileType )fileType
                  page:(NSUInteger )page
                isRear:(BOOL)isRear
                 block:(void (^)(NSArray <AITFileNode *> *datas))success
                  fail:(void (^)(NSError *error))fail;


- (void)beginRecord:(void (^)(BOOL res))block;

- (void)endRecord:(void (^)(BOOL res))block;

- (void)toggleRecord:(void (^)(void))block;



/// 开始录制
/// @param block 开始成功回调
- (void)startRecordWithBlock:(void (^)(void))block;


@end

NS_ASSUME_NONNULL_END
