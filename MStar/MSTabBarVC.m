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

@interface MSTabBarVC ()

@end

@implementation MSTabBarVC

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
    
    MSPreviewVC *vc0 = [[MSPreviewVC alloc] init];
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
    NSLog(@"%s", __FUNCTION__);
    NSInteger itemIndex = [tabBar.items indexOfObject:item];
    
    if (itemIndex > 0) {
        
    } else {
        
    }
}

@end
