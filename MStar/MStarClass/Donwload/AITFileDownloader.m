//
//  AITFileDownloader.m
//  WiFiCameraViewer
//
//  Created by Clyde on 2013/11/17.
//  Copyright (c) 2013年 a-i-t. All rights reserved.
//

#import "AITFileDownloader.h"
#import "AITUtil.h"

@implementation AITFileDownloader

+ (instancetype)manager {
    
    static AITFileDownloader *obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[AITFileDownloader alloc] init];
    });
    
    return obj;
}

-(id)initWithUrl:(NSURL *) url Path: (NSString *)path
{
    self = [super init] ;
    if (self) {
        srcURL   = url;
        filePath = path ;
        downloading = false;
        abort = false;
    }
    return self ;
}

/**
 *  初始化实例
 *  zhizai海思方案下载方法
 *  @param filePath 文件的sourceFilePath
 *  @param path     下载文件要存放的路径
 *
 *  @return 返回实例
 */
-(id)initZHWithFilePath:(NSString *)sourceFilePath savePath: (NSString *)path  {
    
//    NSURL *url = [NSURL URLWithString:
//                  [NSString stringWithFormat:@"%@/%@", ZZETCIp,
//                   [sourceFilePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
//    return [self initWithUrl:url Path:path];
    return nil;
}

/**
 *  初始化实例
 *
 *  @param filePath 文件的sourceFilePath
 *  @param path     下载文件要存放的路径
 *
 *  @return 返回实例
 */
-(id)initWithFilePath:(NSString *)sourceFilePath savePath: (NSString *)path  {
    
    NSURL *url = [NSURL URLWithString:
                  [NSString stringWithFormat:@"http://%@%@", [AITUtil getCameraAddress],
                   [sourceFilePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    return [self initWithUrl:url Path:path];
}

/**
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
                error:(void (^)(NSError *error))errorBlock {
    
    self.downloadingBlock      = downloadingBlock;
    self.downloadErrorBlock    = errorBlock;
    self.downloadAbortBlock    = downloadAbortBlock;
    self.downloadFinishedBlock = finishedBlock;
    
    [self startDownload];
}

-(void)startDownload
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
        [[NSFileManager defaultManager] removeItemAtPath: filePath error: nil] ;
    [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil] ;
    handle = [NSFileHandle fileHandleForUpdatingAtPath:filePath] ;
    if (handle) {
        NSURLRequest * request = [NSURLRequest requestWithURL:srcURL cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30.0] ;
            connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO] ;
    }
    if (connection) {
        [connection scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        [connection start] ;
        downloading = true;
    }
}

- (void)abortDownload
{
    NSLog(@"Abort remove %@", filePath);
    [connection cancel];
    [[NSFileManager defaultManager] removeItemAtPath: filePath error: nil] ;
    
   //   取消下载回调
    !self.downloadAbortBlock ? : self.downloadAbortBlock();
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    if (handle) {
        offsetInFile = -1;
        [handle closeFile];
        handle = nil;
        [[NSFileManager defaultManager] removeItemAtPath: filePath error: nil] ;
    }
    
    //  下载失败回调
    !self.downloadErrorBlock ? : self.downloadErrorBlock(error);
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [handle truncateFileAtOffset: 0];
    bodyLength = response.expectedContentLength ;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [handle writeData:data];
    offsetInFile = handle.offsetInFile;
    
    NSLog(@"--------------------:%.2f%%",(CGFloat)((CGFloat)offsetInFile / (CGFloat)bodyLength) * 100);
    
    //  下载进度回调
//    NSString *percentStr = [NSString stringWithFormat:@"--------------------:%.2f%%",(CGFloat)((CGFloat)offsetInFile / (CGFloat)bodyLength) * 100];
    CGFloat perF = (CGFloat)((CGFloat)offsetInFile / (CGFloat)bodyLength);
    !self.downloadingBlock ? : self.downloadingBlock(perF);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (handle.offsetInFile == bodyLength) {
        NSLog(@"File %lld bytes downloaded", handle.offsetInFile) ;
    } else {
        NSLog(@"File %lld bytes downloaded, expecte %lld", handle.offsetInFile, bodyLength) ;
    }
    [handle closeFile] ;
    handle = nil ;
    
//    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
//    localNotification.fireDate = [NSDate date] ;
//    localNotification.alertBody = NSLocalizedString(@"File Downloaded", nil) ;
//    
//    NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:filePath, @"filePath", nil];
//    
//    localNotification.userInfo = infoDict ;
//    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    //  下载完成回调
    !self.downloadFinishedBlock ? : self.downloadFinishedBlock();
}

- (void)startDownloadFrom:(NSString *)fileName
                       to:(NSString *)path
                 progress:(void (^)(CGFloat downloadPer))downloadingBlock
                 finished:(void (^)(void))finishedBlock
                    abort:(void (^)(void))downloadAbortBlock
                    error:(void (^)(NSError *error))errorBlock {
    
    NSString *srcStr =  [NSString stringWithFormat:@"http://%@", [AITUtil getCameraAddress]];
    srcStr = [srcStr stringByAppendingPathComponent:fileName];
    srcURL = [NSURL URLWithString:srcStr];
    filePath = path ;
    downloading = false;
    abort = false;
    
    [self startDownload:downloadingBlock finished:finishedBlock abort:downloadAbortBlock error:errorBlock];
    

//    [NSURL URLWithString:
//     [NSString stringWithFormat:@"http://%@%@", [AITUtil getCameraAddress],
//      [sourceFilePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
//    ifc_buf = [[AITFileDownloader alloc] initWithFilePath:fileName savePath:path];//[[AITFileDownloader alloc] initWithUrl:[NSURL URLWithString:fileName] Path:path];
//    AITFileDownloader *obj = [[AITFileDownloader alloc] initWithFilePath:fileName savePath:path];//[[AITFileDownloader alloc] initWithUrl:[NSURL URLWithString:fileName] Path:path];
//
//
//    return handle;
}


@end
