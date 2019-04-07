//
//  AITUtil.h
//  WiFiCameraViewer
//
//  Created by Clyde on 2013/11/2.
//  Copyright (c) 2013年 a-i-t. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIButton ;

@interface AITUtil : NSObject

+ (NSString *)getCameraAddress ;
+ (BOOL) isWiFiEnabled ;
+ (void) setButtonBorder: (UIButton*) button ;

@end
