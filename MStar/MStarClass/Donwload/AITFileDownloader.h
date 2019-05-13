//
//  AITFileDownloader.h
//  WiFiCameraViewer
//
//  Created by Clyde on 2013/11/17.
//  Copyright (c) 2013年 a-i-t. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AITFileDownloader : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (nonatomic, copy) void (^downloadingBlock)(CGFloat downloadPer);
@property (nonatomic, copy) void (^downloadFinishedBlock)(void);
@property (nonatomic, copy) void (^downloadErrorBlock)(NSError *error);
@property (nonatomic, copy) void (^downloadAbortBlock)(void);


/**
 实例化

 @return 初始化实例
 */
+ (instancetype)manager;

-(id)initWithUrl:(NSURL *) url Path: (NSString *)path ;
/*!
 *  初始化实例
 *  zhizai海思方案下载
 *  @param sourceFilePath 文件的sourceFilePath
 *  @param path     下载文件要存放的路径
 *
 *  @return 返回实例
 */
-(id)initZHWithFilePath:(NSString *)sourceFilePath savePath: (NSString *)path;
/*!
 *  初始化实例
 *
 *  @param sourceFilePath 文件的sourceFilePath
 *  @param path     下载文件要存放的路径
 *
 *  @return 返回实例
 */
-(id)initWithFilePath:(NSString *)sourceFilePath savePath: (NSString *)path ;

-(void)startDownload;
-(void)abortDownload;


/*!
 *  开始下载
 *
 *  @param downloadingBlock     下载进度回调
 *  @param finishedBlock        下载完成回调
 *  @param downloadAbortBlock   下载取消回调
 *  @param errorBlock           下载失败回调
 */
- (void)startDownload:(void (^)(CGFloat downloadPer))downloadingBlock
             finished:(void (^)(void))finishedBlock
                abort:(void (^)(void))downloadAbortBlock
                error:(void (^)(NSError *error))errorBlock;


- (void)startDownloadFrom:(NSString *)fileName
                       to:(NSString *)path
                 progress:(void (^)(CGFloat downloadPer))downloadingBlock
                 finished:(void (^)(void))finishedBlock
                    abort:(void (^)(void))downloadAbortBlock
                    error:(void (^)(NSError *error))errorBlock;



@end

@interface AITFileDownloader()
{
    NSString *filePath;
    NSURL    *srcURL;
    NSFileHandle *handle;
    
@public
    NSURLConnection *connection;
    bool downloading;
    bool abort;
    long long bodyLength ;
    long long offsetInFile;
}
@end
