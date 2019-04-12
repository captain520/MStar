//
//  ZZW1MFileMgrModel.h
//  chelian
//
//  Created by captain on 2017/7/7.
//  Copyright © 2017年 zhizai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZError.h"

/*
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

@interface ZZW1MFileMgrModel : NSObject

+(NSString *)getLocalNameWithTime:(NSString *)date;

/*!
 *  获取对应文件类型的所有文件
 *
 *  @param fileType 文件类型
 *  @param block    结果回调
 *  @param fail     错误回调
 */
+ (void)fetchW1MFileList:(W1MFileType )fileType block:(void (^)(NSDictionary *dataDict))block fail:(void (^)(ZZError *error))failBlock;


#warning mark 一下方法默认获取20条数据

/*!
 *  获取第一页录像文件列表(每页20文件)
 *
 *  @param block xml dict block
 *  @param fail     错误回调
 *  @return nil;
 */
+ (void)fetchW1MDcimFileList:(void (^)(NSDictionary *dataDict))block fail:(void (^)(ZZError *error))failBlock;


/*!
 *  获取录像文件列表
 *
 *  @param pageNum 请求的页码
 *  @param fail     错误回调
 *  @param block   xml dict block
 */
+ (void)fetchW1MFileList:(NSInteger )pageNum fileType:(W1MFileType )fileType block:(void (^)(NSDictionary *dataDict))block fail:(void (^)(ZZError *error))failBlock;


/*!
 *  删除SD卡文件
 *
 *  @param fileName 文件Path
 *  @param fail     错误回调
 *  @param block    block回掉
 */
+ (void)deleteFileWithPath:(NSString *)fileName block:(void (^)(NSDictionary *result))block fail:(void (^)(ZZError *error))failBlock;

@end
