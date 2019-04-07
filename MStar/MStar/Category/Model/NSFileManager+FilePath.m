
/*
 *   Copyright (c) 2014年 唐斌. All rights reserved.
 *
 * 项目名称: SmallPudding
 * 文件名称: NSFileManager+FilePath.m
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 14-5-15 下午4:10
 */


#import "NSFileManager+FilePath.h"

@implementation NSFileManager (FilePath)

/**
 * @brief 得到文件路径，
 * @param fileName 文件名，不包括扩展名
 * @param extType 扩展名类型
 * @param saveType 存储类型，0表示存储在Doc中；1表示存在cache中
 */
+ (NSString *)getPathByFileName:(NSString *)fileName ofType:(NSString *)extType saveType:(int)saveType
{
    NSString *path = nil;
    if (saveType == 0)
    {
        path = [self getFilePath];
    }
    else
    {
        path = [self getFileLibraryCachesPath];
    }
    NSString* fileDirectory = [[path stringByAppendingPathComponent:fileName]stringByAppendingPathExtension:extType];
    return fileDirectory;
}

/**
 生成文件路径
 @param _fileName 文件名
 @returns 文件路径
 */
+ (NSString *)getPathByFileName:(NSString *)fileName saveType:(int)saveType
{
    NSString *path = nil;
    if (saveType == 0)
    {
        path = [self getFilePath];
    }
    else
    {
        path = [self getFileLibraryCachesPath];
    }
    NSString* fileDirectory = [path stringByAppendingPathComponent:fileName];
    return fileDirectory;
}


// 得到Document的路径
+ (NSString *)getFilePath:(NSString *)filename
{
//    NSString *strPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [[self getFilePath] stringByAppendingPathComponent:filename];
    return filePath;
}

+ (NSString *)getFilePath
{
    NSString *strPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return strPath;
}

+ (NSString *)getfilebulderPath:(NSString *)filename
{
//    NSString *strPath = [[NSBundle mainBundle] bundlePath];
    NSString *strPath = [[self getfilebulderPath] stringByAppendingPathComponent:filename];
    return strPath;
}

+ (NSString *)getfilebulderPath
{
    NSString *strPath = [[NSBundle mainBundle] bundlePath];
    return strPath;
}

// 得到缓存文件夹的路径
+ (NSString *)getFileLibraryCachesPath:(NSString *)filename
{
//    NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[self getFileLibraryCachesPath] stringByAppendingPathComponent:filename];
    
//    NSString *strPath = [NSString stringWithFormat:@"%@/Caches", [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0]];
//    strPath = [strPath stringByAppendingPathComponent:filename];
    
    return filePath;
}

+ (NSString *)getFileLibraryCachesPath
{
    NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    
    return [paths objectAtIndex:0];
}

// 文件文件是否存在
+ (BOOL)isPathFileExit:(NSString *)filepathname
{
    BOOL bRet = NO;
    
    /*
     if ([[NSFileManager defaultManager] fileExistsAtPath:filepathname])
     {
     bRet = TRUE;
     }*/
    BOOL isDir;
    if ([[NSFileManager defaultManager] fileExistsAtPath:filepathname isDirectory:&isDir])
    {
        if (isDir)
        {
            //            表示目录存在，文件不存在
            bRet = NO;
        }
        else
        {
            //            表示文件存在
            bRet = YES;
        }
    }
    
    return bRet;
}

#pragma mark - 获取文件大小
+ (NSInteger)getFileSize:(NSString *)path
{
//    NSLog(@"path=%@", path);
    NSFileManager *filemanager = [[NSFileManager alloc]init];
    if([self isPathFileExit:path])
    {
//        NSLog(@"文件存在");
        NSDictionary * attributes = [filemanager attributesOfItemAtPath:path error:nil];
        NSNumber *theFileSize;
        if ((theFileSize = [attributes objectForKey:NSFileSize]))
        {
            return  [theFileSize intValue];
        }
        else
        {
            return -1;
        }
    }
    else
    {
        return -1;
    }
}

@end
