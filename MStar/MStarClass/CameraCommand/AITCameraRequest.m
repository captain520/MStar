//
//  AITCameraRequest.m
//  WiFiCameraViewer
//
//  Created by Clyde on 2013/11/8.
//  Copyright (c) 2013年 a-i-t. All rights reserved.
//

#import "AITCameraRequest.h"

@interface AITCameraRequest()
{
    id <AITCameraRequestDelegate> requestDelegate ;
    NSMutableData *receivedData ;
}
@end

@implementation AITCameraRequest

- (id) initWithUrl: (NSURL *) url Delegate: (id <AITCameraRequestDelegate>) delegate
{
    self = [super init] ;
    if (self) {
        
        NSLog(@"Requesting URL = %@",url);
        
        requestDelegate = delegate ;
        receivedData = [[NSMutableData alloc] init] ;
            
        NSURLRequest * request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:15.0] ;
        
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO] ;
        
        [connection scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        
        [connection start];
    }
    return self ;
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    [requestDelegate requestFinished: nil] ;
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *result = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding] ;
    
    NSLog(@"Requesting Result = %@", result) ;
    [requestDelegate requestFinished: result] ;
}


@end
