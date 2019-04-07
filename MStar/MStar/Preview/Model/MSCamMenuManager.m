//
//  MSCamMenuManager.m
//  MStar
//
//  Created by 王璋传 on 2019/4/7.
//  Copyright © 2019 王璋传. All rights reserved.
//

#import "MSCamMenuManager.h"
#import "GDataXMLNode.h"

@implementation MSCamMenuManager

@synthesize cammenu = cammenu;
@synthesize curmenu = curmenu;

+ (instancetype)manager {
    
    static MSCamMenuManager *mgr = nil;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        mgr = [[MSCamMenuManager alloc] init];
    });
    
    return mgr;
}

- (void) LoadCamMenuXMLDoc:(NSString*)xmldoc
{
    /* get xml from res
     NSString* path = [[NSBundle mainBundle] pathForResource:@"test2" ofType:@"xml"];
     NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:path];
     NSError *error;
     GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
     */
    
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithXMLString:[xmldoc substringToIndex:[xmldoc rangeOfString:@">" options:NSBackwardsSearch].location + 1] options:0 error:nil];
    NSArray *theEles = [doc.rootElement elementsForName:@"menu"];
    cammenu = [AITCamMenu initWithTitle:nil MenuId: nil];
    for (GDataXMLElement *theEle in theEles) {
        if ([[theEle name] isEqualToString:@"menu"]) {
            NSString *title;
            NSString *menuid;
            NSString *focus;
            title  = [[theEle attributeForName:@"title"] stringValue];
            menuid = [[theEle attributeForName:@"id"] stringValue];;
            AITCamMenu *theMenu = [AITCamMenu initWithTitle:title MenuId: menuid];
            // Item
            NSArray *theItems = [theEle children];
            for (GDataXMLElement *theItem in theItems) {
                if ([[theItem name] isEqualToString:@"item"]) {
                    NSString *title;
                    NSString *menuid;
                    title  = theItem.stringValue;
                    menuid = [[theItem attributeForName:@"id"] stringValue];
                    AITCamMenu *item = [AITCamMenu initWithTitle:title MenuId: menuid];
                    [theMenu addItems:item];
                } else if ([[theItem name] isEqualToString:@"sel"]) {
                    focus = theItem.stringValue;
                }
            }
            //
            theMenu.dup = theMenu.focus = focus;
            [cammenu addItems:theMenu];
        }
    }
    cammenu.title = @"Camera Menu";
    cammenu.focus = @"VIDEORES";
    curmenu = cammenu;
}

@end
