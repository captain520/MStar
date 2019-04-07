//
//  AITCameraListen.h
//  WiFiCameraViewer
//
//  Created by Apple on 2014/8/30.
//  Copyright (c) 2014年 a-i-t. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#include <CoreFoundation/CoreFoundation.h>
#include <sys/socket.h>
#include <netinet/in.h>
#import "GCDAsyncUdpSocket.h"

@interface AITCameraListen : NSObject

{
    //id <AITCameraListenDelegate> _delegate;
}
@property (strong, nonatomic) id delegate;
@property (strong, nonatomic) NSMutableData* recvBuf;


+(NSString*) getValueOf:(NSString*)status ByItem:(NSString*)theItem;
+(BOOL) checkDataFormat:(NSString*)data fromAddress:(NSData*)address withFilterContext:(id)context;
+(NSDictionary*) buildStatusDictionary:(NSString*)status;
+(void) setFilterRecvDataBlock:(GCDAsyncUdpSocketReceiveFilterBlock) filter;

-(void) startListen;

@end
