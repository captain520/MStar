//
//  AITCamMenu.m
//  WiFiCameraViewer
//
//  Created by Apple on 2014/8/16.
//  Copyright (c) 2014年 a-i-t. All rights reserved.
//

#import "AITCamMenu.h"

@implementation AITCamMenu

@synthesize focus = _focus;

+ (AITCamMenu*) initWithTitle:(NSString *)title MenuId:(NSString *)menuid {
    AITCamMenu *theMenu;
    theMenu = [AITCamMenu alloc];
    theMenu.title  = title;
    theMenu.menuid = menuid;
    theMenu.focus  = nil;
    theMenu.parent = nil;
    theMenu.dup    = nil;
    theMenu.items  = [NSMutableDictionary dictionary];
    theMenu.keyArray = [[NSMutableArray alloc] init];
    return theMenu;
}

- (void)addItems:(AITCamMenu *)menuitem {
    [self.items setObject:menuitem forKey:menuitem.menuid];
    [self.keyArray addObject:menuitem.menuid];
}


- (AITCamMenu*) findItemByMenuId:(NSString *)theid {
    AITCamMenu *target;
    //
    target = [self.items objectForKey:theid];
    if (target != nil)
        return target;
    //
    NSEnumerator *enumerator = [self.items keyEnumerator];
    NSString *key;
    while ((key = [enumerator nextObject])) {
        /* code that uses the returned key */
        AITCamMenu *child;
        child = [self.items objectForKey:key];
        target = [child findItemByMenuId:theid];
        if (target)
            return target;
    }
    // not found!
    return nil;
}
@end
