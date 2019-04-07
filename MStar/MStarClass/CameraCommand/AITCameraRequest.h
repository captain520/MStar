//
//  AITCameraRequest.h
//  WiFiCameraViewer
//
//  Created by Clyde on 2013/11/8.
//  Copyright (c) 2013年 a-i-t. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/NSLock.h>

@protocol AITCameraRequestDelegate <NSObject>

-(void) requestFinished:(NSString*) result ;

@end

@interface AITCameraRequest : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

- (id) initWithUrl: (NSURL *) url Delegate: (id <AITCameraRequestDelegate>) delegate ;

@end
