//
//  AppDelegate+Category.m
//  MStar
//
//  Created by 王璋传 on 2019/4/5.
//  Copyright © 2019 王璋传. All rights reserved.
//

#import "AppDelegate+Category.h"

@implementation AppDelegate (Category)

/**
 *  初始化导航条
 */
- (void)setUINavigatinoBarProperities {
    
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : UIColor.blackColor} forState:UIControlStateSelected];
    [[UITabBar appearance] setTintColor:UIColor.blackColor];
//
//    [[UINavigationBar appearance] setBackIndicatorImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[[UIImage imageNamed:@"left"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//        [[UINavigationBar appearance] setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];

    return;

    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
//    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
//    [[UINavigationBar appearance] setBarTintColor:MAIN_COLOR];
    //
    [[UINavigationBar appearance] setBackIndicatorImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [[UINavigationBar appearance] setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//        [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    //    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-100, 0) forBarMetrics:UIBarMetricsDefault];
    
    //    [[UINavigationBar appearance] setClipsToBounds:YES];
    //        [[UINavigationBar appearance] setTranslucent:NO];
    
    //
    //    [[UINavigationBar appearance] setTranslucent:NO];//设置为不透明
    //
    NSDictionary *titleTextAttributes = @{NSForegroundColorAttributeName:C33,NSFontAttributeName:[UIFont boldSystemFontOfSize:18]};
    [[UINavigationBar appearance] setTitleTextAttributes:titleTextAttributes];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : UIColor.blackColor} forState:UIControlStateSelected];

//    [[UITabBar appearance] setBarTintColor:[UIColor blackColor]];
    [[UITabBar appearance] setTintColor:UIColor.blackColor];
}

@end
