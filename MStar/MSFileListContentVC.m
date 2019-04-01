//
//  MSFileListContentVC.m
//  MStar
//
//  Created by 王璋传 on 2019/3/7.
//  Copyright © 2019 王璋传. All rights reserved.
//

#import "MSFileListContentVC.h"
#import "MSSDFileLIstVC.h"


#define SELECTED_COLOR  [UIColor colorWithRed:18./255 green:150./255 blue:219./255 alpha:1]

@interface MSFileListContentVC ()

@end

@implementation MSFileListContentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.edgesForExtendedLayout = UIRectEdgeLeft | UIRectEdgeRight | UIRectEdgeBottom;
    
    [self setTabBarFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 44) contentViewFrame:CGRectMake(0, 44, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height - 44 - UIApplication.sharedApplication.statusBarFrame.size.height - 44)];
    
    self.tabBar.itemTitleColor = UIColor.blackColor;
    self.tabBar.itemTitleSelectedColor = SELECTED_COLOR;
    self.tabBar.itemTitleFont = [UIFont systemFontOfSize:14];
    self.tabBar.itemTitleSelectedFont = [UIFont systemFontOfSize:16];
    self.tabBar.leadingSpace = 20;
    self.tabBar.trailingSpace = 20;
    
    self.tabBar.itemFontChangeFollowContentScroll = YES;
    self.tabBar.indicatorScrollFollowContent = YES;
    self.tabBar.indicatorColor = SELECTED_COLOR;
    
    [self.tabBar setIndicatorWidth:80 marginTop:42 marginBottom:0 tapSwitchAnimated:YES];
    
    
    [self.tabContentView setContentScrollEnabled:YES tapSwitchAnimated:YES];
    self.tabContentView.loadViewOfChildContollerWhileAppear = YES;
    
    [self initViewControllers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initViewControllers {
    
    if (self.isLocalFileList == NO) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"SwitchCameral"] style:UIBarButtonItemStylePlain target:self action:@selector(switchCameralAction:)];
    }
    
    MSSDFileLIstVC *videoVC = [MSSDFileLIstVC new];
    videoVC.yp_tabItemTitle = @"视频";
    videoVC.isLocalFileList = self.isLocalFileList;

    MSSDFileLIstVC *imageVc = [MSSDFileLIstVC new];
    imageVc.yp_tabItemTitle = @"图片";
    imageVc.isLocalFileList = self.isLocalFileList;
    

    self.viewControllers = @[videoVC, imageVc];
}

- (void)switchCameralAction:(id)sender {
    
}

@end
