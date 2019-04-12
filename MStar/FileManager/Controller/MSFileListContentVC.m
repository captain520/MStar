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

@property (nonatomic, assign) BOOL isRear;

@property (nonatomic, strong) MSSDFileLIstVC *normalVideoVC, * imageVc, *eventVideoVC;

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
    
    self.normalVideoVC = [[MSSDFileLIstVC alloc] initWithStyle:UITableViewStyleGrouped];;
    self.normalVideoVC.yp_tabItemTitle = @"视频";
    self.normalVideoVC.isLocalFileList = self.isLocalFileList;
    self.normalVideoVC.fileType = W1MFileTypeNormal;

    self.imageVc = [[MSSDFileLIstVC alloc] initWithStyle:UITableViewStyleGrouped];
    self.imageVc.yp_tabItemTitle = @"图片";
    self.imageVc.isLocalFileList = self.isLocalFileList;
    self.imageVc.fileType = W1MFileTypePhoto;
    
    self.eventVideoVC = [[MSSDFileLIstVC alloc] initWithStyle:UITableViewStyleGrouped];
    self.eventVideoVC.yp_tabItemTitle = @"锁存视频";
    self.eventVideoVC.isLocalFileList = self.isLocalFileList;
    self.eventVideoVC.fileType = W1MFileTypeEvent;

    self.viewControllers = @[self.normalVideoVC, self.imageVc, self.eventVideoVC];
}

- (void)switchCameralAction:(id)sender {
    
    self.isRear = !self.isRear;
    self.normalVideoVC.isRear = self.isRear;
    [self.normalVideoVC refreshAllData];
    
    self.imageVc.isRear = self.isRear;
    [self.imageVc refreshAllData];
    
    self.eventVideoVC.isRear = self.isRear;
    [self.eventVideoVC refreshAllData];
}

@end
