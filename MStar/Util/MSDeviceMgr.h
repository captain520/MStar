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
- (void)toggleCameId:(void (^)(void))block;


- (void)loadRemoteFile:(W1MFileType )fileType
                  page:(NSUInteger )page
                isRear:(BOOL)isRear
                 block:(void (^)(NSArray <AITFileNode *> *datas))success
                  fail:(void (^)(NSError *error))fail;

@end

NS_ASSUME_NONNULL_END
