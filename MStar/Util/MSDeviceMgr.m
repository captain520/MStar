//
//  MSDeviceMgr.m
//  MStar
//
//  Created by 王璋传 on 2019/9/19.
//  Copyright © 2019 王璋传. All rights reserved.
//

#import "MSDeviceMgr.h"

@implementation MSDeviceMgr

+ (instancetype)manager {
    
    static MSDeviceMgr *mgr = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        mgr = [[MSDeviceMgr alloc] init];
    });
    
    return mgr;
}

- (id)init {
    
    if (self = [super init]) {
        
    }
    
    return self;
}


//  获取录制状态
- (void)getRecordingState:(void (^)(BOOL recordState))block {
    
    (void)[[AITCameraCommand alloc] initWithUrl:[AITCameraCommand commandQueryPreviewStatusUrl]
                                          block:^(NSString *result) {
                                              [self getRecordStateWith:result block:block];
                                          } fail:^(NSError *error) {
                                              !block ? : block(NO);
                                          }];
}

- (void)getRecordStateWith:(NSString *)result block:(void (^)(BOOL isRecording))block {
    
    BOOL cameraRecording = NO;
    
    if ([result containsString:@"OK\n"] == NO) {
        
        !block ? : block(cameraRecording);
        
        return;
    }
    

    NSDictionary *dict = [AITCameraCommand buildResultDictionary:result];
    NSString *recording = [dict objectForKey:[AITCameraCommand PROPERTY_QUERY_RECORD]];
    
    if (![recording caseInsensitiveCompare:@"Recording"]) {
        cameraRecording = YES;
    } else {
        cameraRecording = NO;
    }
    
    !block ? : block(cameraRecording);
}


//  打开录制
- (void)startRecrod {
    
    [self getRecordingState:^(BOOL recordState) {
        
        if (NO == recordState) {
            //  如果状态是未录制
            [self toggleRecordState];
        } else {
            //  如果状态正在录制，什么都不做
            
        }
        
    }];
}

//  停止录制
- (void)stopRecrod {
    
    [self getRecordingState:^(BOOL recordState) {
        
        if (NO == recordState) {
            //  如果状态是未录制
            
        } else {
            //  如果状态正在录制，切换录制状态
            [self toggleRecordState];
        }
    }];
}

//  切换录制状态
- (void)toggleRecordState {
    
    NSLog(@"开始切换录制状态");
    
    (void)[[AITCameraCommand alloc] initWithUrl:[AITCameraCommand commandCameraRecordUrl]
                                          block:^(NSString *result) {
                                              if ([result containsString:@"404 Not Found"]) {
                                                  [self toggleRecordState];
                                              }
                                              NSLog(@"切换录制状态：%@", result);
                                          } fail:^(NSError *error) {
                                              NSLog(@"切换录制状态：%@", error);
                                          }];
}

- (void)stopRecrod:(void (^)(void))block {
    
    [self getRecordingState:^(BOOL recordState) {
        
        if (NO == recordState) {
            //  如果状态是未录制
            
            !block ? : block();
        } else {
            //  如果状态正在录制，切换录制状态
            [self toggleRecordState:block];
        }
    }];
}

- (void)toggleRecordState:(void (^)(void))block {
    
    NSLog(@"开始切换录制状态");
    
    (void)[[AITCameraCommand alloc] initWithUrl:[AITCameraCommand commandCameraRecordUrl]
                                          block:^(NSString *result) {
                                              if ([result containsString:@"404 Not Found"]) {
                                                  [self toggleRecordState:block];
                                              } else {
                                                  !block ? : block();
                                              }
                                              NSLog(@"切换录制状态：%@", result);
                                          } fail:^(NSError *error) {
                                              NSLog(@"切换录制状态：%@", error);
                                          }];
}

@end
