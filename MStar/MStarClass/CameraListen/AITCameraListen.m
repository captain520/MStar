//
//  AITCameraListen.m
//  WiFiCameraViewer
//
//  Created by Apple on 2014/8/30.
//  Copyright (c) 2014年 a-i-t. All rights reserved.
//

#import "AITCameraListen.h"

@interface AITCameraListen ()
{
    BOOL isRunning;
}

@end

static GCDAsyncUdpSocket* gcdUdpSock;
static unsigned int       last_statustime   = 0;
static unsigned int       last_statusticket = 0;
static NSDictionary       *theStatusDictionary;


@implementation AITCameraListen

-(void) startListen {
    NSLog(@"connectViaUpdClientSocket");
/*
 [NSThread detachNewThreadSelector:@selector(startUdpClientConnection)
                             toTarget:self
                           withObject:nil];
 */
    [self startUdpClientConnection];
}


- (void)startUdpClientConnection
{
    gcdUdpSock = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    [gcdUdpSock setIPv4Enabled:YES];
    [gcdUdpSock setPreferIPv4];
    [gcdUdpSock setIPv6Enabled:NO];
    
    int port = 49142;//[portField.text intValue];
    
    NSError *error = nil;
    struct sockaddr_in ip;
    ip.sin_family = AF_INET;
    ip.sin_addr.s_addr = inet_addr("0.0.0.0");
    ip.sin_port = htons(port);
    ip.sin_len = sizeof(struct sockaddr_in);
    NSData * discoveryHost = [NSData dataWithBytes:&ip length:ip.sin_len];
    
    if (![gcdUdpSock bindToAddress:discoveryHost error: &error])
    {
        NSLog(@"Error starting server bind address");
        return;
    }
    if (![gcdUdpSock beginReceiving:&error])
    {
        [gcdUdpSock close];
        NSLog(@"Error starting server recv");
        return;
    }
    isRunning = YES;
    GCDAsyncUdpSocketReceiveFilterBlock filter = ^BOOL (NSData *data, NSData *address, id *context) {

        //MyProtocolMessage *msg = [MyProtocol parseMessage:data];
        NSLog(@"FILTER %@: %@", address, data);
        //context = response;
        return true;
    };
    [AITCameraListen setFilterRecvDataBlock:filter];
    
}

- (void)StopUdpClientConnect
{
    if (isRunning) {
        isRunning = NO;
        [gcdUdpSock close];
    }
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
      fromAddress:(NSData *)address
withFilterContext:(id)filterContext
{
	if (!isRunning) return;
	
	NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	if (msg)
	{
		/* If you want to get a display friendly version of the IPv4 or IPv6 address, you could do this:
		 
         NSString *host = nil;
         uint16_t port = 0;
         [GCDAsyncUdpSocket getHost:&host port:&port fromAddress:address];
         
         */
		
		//[self logMessage:msg];
        // NSLog(msg);
	}
	else
	{
		//[self logError:@"Error converting received data into UTF-8 String"];
	}
	
	//[udpSocket sendData:data toAddress:address withTimeout:-1 tag:0];
}

+(void) setFilterRecvDataBlock:(GCDAsyncUdpSocketReceiveFilterBlock) filter
{
    dispatch_queue_t    dispatch_q = NULL;
    if (filter != nil)
        dispatch_q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    [gcdUdpSock setReceiveFilter:filter
                withQueue:dispatch_q];

}

+(NSDictionary*) buildStatusDictionary:(NSString*)status {
    NSMutableArray *keyArray;
    NSMutableArray *valArray;
    NSDictionary   *dict;
    NSArray *lines;
    
    keyArray = [[NSMutableArray alloc] init];
    valArray = [[NSMutableArray alloc] init];
    lines = [status componentsSeparatedByString:@"\n"];
    for (NSString *line in lines) {
        NSArray *state = [line componentsSeparatedByString:@"="];
        if ([state count] != 2)
            continue;
        [keyArray addObject:[[state objectAtIndex:0] copy]];
        [valArray addObject:[[state objectAtIndex:1] copy]];
    }
    dict = [NSDictionary dictionaryWithObjects:valArray forKeys:keyArray];
    //
    NSString *time;
    NSString *ticket;
    
    time   = [dict objectForKey:@"time"];
    ticket = [dict objectForKey:@"ticket"];
    if (time == nil || ticket == nil)
        return nil;
    NSLog(@"time-  %@ %d",   time, last_statustime);
    NSLog(@"ticket-%@ %d", ticket, last_statusticket);
    if ([time intValue]   != last_statustime ||
        [ticket intValue] != last_statusticket) {
        last_statustime   = [time intValue];
        last_statusticket = [ticket intValue];
        return dict;
    }
    return nil;
}

+(NSString*) getValueOf:(NSString*)status ByItem:(NSString*) theItem {
    NSArray *lines;
    
    lines = [status componentsSeparatedByString:@"\n"];
    for (NSString *line in lines) {
        NSArray *state = [line componentsSeparatedByString:@"="];
        if ([state count] != 2)
            continue;
        if ([theItem isEqualToString:[state objectAtIndex:0]])
            return[state objectAtIndex:1];
    }
    return nil;
}

+(BOOL) checkDataFormat:(NSString*)status
        fromAddress:(NSData*)address
      withFilterContext:(id)context
{
    NSString *time;
    NSString *ticket;
    
    time   = [AITCameraListen getValueOf:status ByItem:@"time"];
    ticket = [AITCameraListen getValueOf:status ByItem:@"ticket"];
    if (time == nil || ticket == nil)
        return NO;
    if ([time intValue]   != last_statustime &&
        [ticket intValue] != last_statusticket) {
        last_statustime   = [time intValue];
        last_statusticket = [ticket intValue];
        return YES;
    }
    return NO;
}

@end
