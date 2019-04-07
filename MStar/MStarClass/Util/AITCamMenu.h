//
//  AITCamMenu.h
//  WiFiCameraViewer
//
//  Created by Apple on 2014/8/16.
//  Copyright (c) 2014年 a-i-t. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AITCamMenu : NSObject

@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString* menuid;
@property (strong, nonatomic) NSString* focus;
@property (strong, nonatomic) NSString* dup;
@property (strong, nonatomic) NSMutableArray* keyArray;
@property (weak, nonatomic)   AITCamMenu* parent;
@property (strong, nonatomic) NSMutableDictionary* items;

+ (AITCamMenu*)initWithTitle: (NSString *)title
                     MenuId: (NSString *)menuid;

- (void)addItems: (AITCamMenu*)menuitem;
- (AITCamMenu*)findItemByMenuId: (NSString*)theid;

@end
