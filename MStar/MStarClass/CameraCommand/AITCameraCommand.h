//
//  AITCameraCommand.h
//  WiFiCameraViewer
//
//  Created by Clyde on 2013/11/8.
//  Copyright (c) 2013年 a-i-t. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AITCameraRequest.h"

/**
 W1M 文件类型
 */
typedef enum {
    W1MFileTypeDcim ,       // 视频录制文件
    W1MFileTypeNormal,      // 视频录制文件,暂时没有用到
    W1MFileTypePhoto ,      // 截图
    W1MFileTypeEvent ,      // 锁存视频
    W1MFileTypeParking ,    // 预留
    W1MFileTypeOther
} W1MFileType;

@interface AITCameraCommand : NSObject <AITCameraRequestDelegate>

// Set property
+ (NSURL*) setProperty:(NSString*)prop Value:(NSString*)val;
//
+ (NSURL*) commandUpdateUrl: (NSString *) ssid EncryptionKey: (NSString *) encryptionKey ;
+ (NSURL*) commandFindCameraUrl ;
+ (NSURL*) commandCameraSnapshotUrl;
+ (NSURL*) commandCameraRecordUrl;
+ (NSURL*) commandQueryPreviewStatusUrl;
+ (NSURL*) commandGetCameraidUrl;
+ (NSURL*) commandSetCameraidUrl:(NSString *) camid;
+ (NSURL*) commandQueryCameraRecordUrl;
+ (NSURL*) commandReactivateUrl ;
+ (NSURL*) commandWifiInfoUrl ;
+ (NSURL*) commandListFileUrl: (int) count  From: (int) from;

/**
 获取文件URL

 @param count 数量
 @param from 下标
 @param isRear 是否为后置摄像头
 @param fileType 文件类型
 @return URL
 */
+ (NSURL*) commandListFileUrl: (int) count From: (int) from isRear:(BOOL)isRear fileType:(W1MFileType)fileType;
+ (NSURL*) commandListFirstFileUrl: (int) count ;
+ (NSURL*) commandDelFileUrl: (NSString *) fileName;
+ (NSURL*) commandQuerySettings;
+ (NSURL*) commandSetVideoRes: (NSString*) nsRes;
+ (NSURL*) commandSetImageRes: (NSString*) nsRes;
+ (NSURL*) commandSetFlicker: (NSString*) nsHz;
+ (NSURL*) commandSetEV: (NSString*) nsEvlabel;
+ (NSURL*) commandSetMTD: (NSString*) nsmtd;
+ (NSURL*) commandSetAWB: (NSString*) nsawb;
//
+ (NSURL*) commandSetDateTime: (NSString *) datetime;
+ (NSURL*) commandFormat;
//
+ (NSURL*) commandGetCamMenu;

+ (NSDictionary*) buildResultDictionary:(NSString*)result;

+ (NSString *) PROPERTY_SSID ;
+ (NSString *) PROPERTY_ENCRYPTION_KEY ;
+ (NSString *) PROPERTY_CAMERA_RTSP;
+ (NSString *) PROPERTY_QUERY_RECORD;
+ (NSString *) PROPERTY_CAMERAID;

+ (NSString *) PROPERTY_awb;
+ (NSString *) PROPERTY_ev;
+ (NSString *) PROPERTY_mtd;
+ (NSString *) PROPERTY_ImageRes;
+ (NSString *) PROPERTY_Flicker;
+ (NSString *) PROPERTY_VideoRes;
+ (NSString *) PROPERTY_IsStreaming;
+ (NSString *) PROPERTY_FWversion;
+ (NSString *) PROPERTY_DATETIME;

- (id) initWithUrl: (NSURL*) url View: (UIView *)aView ;
- (id) initWithUrl: (NSURL*) url Delegate:(id<AITCameraRequestDelegate>)delegate ;


/**
 获取固件版本信息

 @return 获取固件版本信息 Url
 */
+(NSURL*) commandQueryFWversion;

- (id) initWithUrl: (NSURL*) url block:(void (^)(NSString *result))block fail:(void (^)(NSError *error ))failBlock;

@end
