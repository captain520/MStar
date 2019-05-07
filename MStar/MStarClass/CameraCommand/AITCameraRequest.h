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

@property (nonatomic, copy) void (^actionBlock)(NSString *result);
@property (nonatomic, copy) void (^failBlock)(NSError *error);

- (id) initWithUrl: (NSURL *) url Delegate: (id <AITCameraRequestDelegate>) delegate ;
- (id) initWithUrl: (NSURL *) url block:(void (^)(NSString *resutl))block fail:(void (^)(NSError *error))failBlock;

@end
