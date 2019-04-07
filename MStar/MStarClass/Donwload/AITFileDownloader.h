//
//  AITFileDownloader.h
//  WiFiCameraViewer
//
//  Created by Clyde on 2013/11/17.
//  Copyright (c) 2013年 a-i-t. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AITFileDownloader : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

-(id)initWithUrl:(NSURL *) url Path: (NSString *)path ;
-(void)startDownload;
-(void)abortDownload;

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
