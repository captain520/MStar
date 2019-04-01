//
//  AppDelegate.m
//  MStar
//
//  Created by 王璋传 on 2019/3/7.
//  Copyright © 2019 王璋传. All rights reserved.
//

#import "AppDelegate.h"

//#define XCODE_COLORS_ESCSPE @"\033["
//
//#define XCODE_COLORS_RESET_FG   XCODE_COLORS_ESCSPE @"fg;"
//#define XCODE_COLORS_RESET_BG   XCODE_COLORS_ESCSPE @"bg;"
//#define XCODE_COLORS_RESET      XCODE_COLORS_ESCSPE @";"

#define XCODE_COLORS_ESCAPE @"\033["
#define XCODE_COLORS_RESET_FG  XCODE_COLORS_ESCAPE @"fg;"
#define XCODE_COLORS_RESET_BG  XCODE_COLORS_ESCAPE @"bg;"
#define XCODE_COLORS_RESET     XCODE_COLORS_ESCAPE @";"

#define ms_consolecodes_none          "\e[0m"
#define ms_consolecodes_brightred     "\e[1;31m"
#define ms_consolecodes_green         "\e[0;32m"
#define ms_consolecodes_brightyellow  "\e[1;33m"
#define ms_consolecodes_brightblue    "\e[1;34m"
#define ms_consolecodes_brightcyan    "\e[1;36m"

static const char *ms_col[64]={
    ms_consolecodes_brightblue,        //assert
    ms_consolecodes_brightred,         //error
    ms_consolecodes_brightyellow,      //waring
    ms_consolecodes_brightcyan,        //info
    ms_consolecodes_none,              //debug
    ms_consolecodes_green};            //verbose

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//    NSLog(XCODE_COLORS_ESCSPE @"fg0,0,255;"
//          XCODE_COLORS_ESCSPE @"bg220,0,0;"
//          @"lsdfklsdf"
//          XCODE_COLORS_RESET
//          );
//    NSLog(XCODE_COLORS_ESCAPE @"fg0,0,255;" @"Blue text" XCODE_COLORS_RESET); NSLog(XCODE_COLORS_ESCAPE @"bg220,0,0;" @"Red background" XCODE_COLORS_RESET);
//    NSLog(XCODE_COLORS_ESCAPE @"fg0,0,255;"
//          XCODE_COLORS_ESCAPE @"bg220,0,0;"
//          @"Blue text on red background"
//          XCODE_COLORS_RESET);
//    NSLog(XCODE_COLORS_ESCAPE @"fg209,57,168;" @"You can supply your own RGB values!" XCODE_COLORS_RESET);
    
    printf("\033[0;35;46m 字体有色，且有背景色 \033[0m");
    

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
