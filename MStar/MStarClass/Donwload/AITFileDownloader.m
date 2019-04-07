//
//  AITFileDownloader.m
//  WiFiCameraViewer
//
//  Created by Clyde on 2013/11/17.
//  Copyright (c) 2013年 a-i-t. All rights reserved.
//

#import "AITFileDownloader.h"


@implementation AITFileDownloader

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
    
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [NSDate date] ;
    localNotification.alertBody = NSLocalizedString(@"File Downloaded", nil) ;
    
    NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:filePath, @"filePath", nil];
    
    localNotification.userInfo = infoDict ;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}


@end
