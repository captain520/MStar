
/*
 *   Copyright (c) 2014年 唐斌. All rights reserved.
 * 
 * 项目名称: SmallPudding
 * 文件名称: NSFileManager+FilePath.h
 * 文件标识: 
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 14-5-15 下午4:10
 */



#import <Foundation/Foundation.h>

@interface NSFileManager (FilePath)

/**
 * @brief 得到文件路径，
 * @param fileName 文件名，不包括扩展名
 * @param extType 扩展名类型
 * @param saveType 存储类型，0表示存储在Doc中；1表示存在cache中
 */
+ (NSString *)getPathByFileName:(NSString *)fileName ofType:(NSString *)extType saveType:(int)saveType;

/**
 * @brief 得到文件路径，
 * @param fileName 文件名，包括扩展名
 * @param saveType 存储类型，0表示存储在Doc中；1表示存在cache中
 */
+ (NSString *)getPathByFileName:(NSString *)fileName saveType:(int)saveType;

/** 得到Document的路径 */
+ (NSString *)getFilePath:(NSString *)filename;
+ (NSString *)getFilePath;

+ (NSString *)getfilebulderPath:(NSString *)filename;
+ (NSString *)getfilebulderPath;

/** 
 * @brief 得到缓存文件夹的路径
 * @param filename 文件名。例如:readme.txt
 */
+ (NSString *)getFileLibraryCachesPath:(NSString *)filename;
+ (NSString *)getFileLibraryCachesPath;

/** 
 * @brief 文件文件是否存在
 * @param filepathname 具体的文件路径
 */
+ (BOOL)isPathFileExit:(NSString *)filepathname;

/** 获取文件大小 */
+ (NSInteger) getFileSize:(NSString *)path;
@end
