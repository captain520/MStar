//
//  MSTabBarVC.m
//  MStar
//
//  Created by 王璋传 on 2019/3/7.
//  Copyright © 2019 王璋传. All rights reserved.
//

#import "MSTabBarVC.h"
#import "MSPreviewVC.h"

//#import <UMSSDKUI/UMSProfileViewController.h>
#import "MSPreviewVC.h"
#import "MSSDFileLIstVC.h"
#import "MSFileListContentVC.h"
#import "MSProfileVC.h"
#import "MSLocalFileContentVC.h"

#import "MSMainVC.h"

@interface MSTabBarVC ()

@end

@implementation MSTabBarVC

//- (void)dealloc {
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initControllers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initControllers {
    
//    MSPreviewVC *vc0 = [[MSPreviewVC alloc] init];
//    vc0.view.backgroundColor = UIColor.whiteColor;
//    vc0.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"LivePreview",nil) image:[UIImage imageNamed:@"直播"] tag:0];
//    UINavigationController *nav0 = [[UINavigationController alloc] initWithRootViewController:vc0];
    
    MSMainVC *vc0 = [[MSMainVC alloc] init];
    vc0.view.backgroundColor = UIColor.whiteColor;
    vc0.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"LivePreview",nil) image:[UIImage imageNamed:@"直播"] tag:0];
    UINavigationController *nav0 = [[UINavigationController alloc] initWithRootViewController:vc0];
    
    MSFileListContentVC *vc1 = [[MSFileListContentVC alloc] init];
    vc1.title = NSLocalizedString(@"SDFile", @"SD卡文件");
    vc1.view.backgroundColor = UIColor.whiteColor;
    vc1.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"SD", nil) image:[UIImage imageNamed:@"SD卡"] tag:0];
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:vc1];
    nav1.navigationBar.backgroundColor = UIColor.whiteColor;
    
    MSLocalFileContentVC *vc2 = [[MSLocalFileContentVC alloc] init];
    vc2.title = NSLocalizedString(@"LocalFile", @"本地文件");
    vc2.view.backgroundColor  = UIColor.whiteColor;
    vc2.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Local", nil) image:[UIImage imageNamed:@"本地"] tag:0];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:vc2];
    nav2.navigationBar.backgroundColor = UIColor.whiteColor;

    MSProfileVC *vc3 = [[MSProfileVC alloc] initWithStyle:UITableViewStyleGrouped];
    vc3.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Profile", nil) image:[UIImage imageNamed:@"个人中心"] tag:0];
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:vc3];
    
    self.viewControllers = @[nav0, nav1, nav2, nav3];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {

    NSInteger itemIndex = [tabBar.items indexOfObject:item];
    NSLog(@"%s -- index:%@", __FUNCTION__, @(itemIndex));
    
    if (1 == itemIndex) {
        [[MSDeviceMgr manager] stopRecrod:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ItemSelectedNotification" object:@(itemIndex)];
        }];
    } else if (0 != itemIndex) {
        [[MSDeviceMgr manager] stopRecrod:^{
            
        }];
    }
//    if (0 == itemIndex) {
//       //   预览页面在出现时会自动打开录像
//    } else if (1 == itemIndex) {
//        //  要停止录像后刷新视频列表
//        [[MSDeviceMgr manager] stopRecrod:^{
////            NSLog(@"stop record");
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"ItemSelectedNotification" object:@(itemIndex)];
//        }];
//    } else {
//        [[MSDeviceMgr manager] stopRecrod:^{
//            NSLog(@"stop record");
//        }];
//    }
}

@end
