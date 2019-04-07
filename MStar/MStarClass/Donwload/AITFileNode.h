//
//  AITFileNode.h
//  WiFiCameraViewer
//
//  Created by Clyde on 2013/11/17.
//  Copyright (c) 2013年 a-i-t. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AITFileDownloader.h"

@interface AITFileNode : NSObject

@property NSString* name ;
@property NSString* format ;
@property int size ;
@property NSString* attr ;
@property NSString* time ;
@property BOOL blValid;
@property BOOL selected;
@property float progress;

@end


@interface AITFileNode()
{
@public
    AITFileDownloader *downloader;
}
@end
