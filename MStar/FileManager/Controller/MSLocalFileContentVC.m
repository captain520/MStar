//
//  MSLocalFileContentVC.m
//  MStar
//
//  Created by 王璋传 on 2019/4/12.
//  Copyright © 2019 王璋传. All rights reserved.
//

#import "MSLocalFileContentVC.h"
#import "MSLocalFileVC.h"
//#import "MSSDFileLIstVC.h"
#import "MSMediaListVC.h"

@interface MSLocalFileContentVC ()<YPTabBarDelegate>

@property (nonatomic, strong) MSLocalFileVC *normalVideoVC, *imageVc, *eventVideoVC;

@end

@implementation MSLocalFileContentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Edit", nil) style:UIBarButtonItemStyleDone target:self action:@selector(editAction:)];
    
    self.edgesForExtendedLayout = UIRectEdgeLeft | UIRectEdgeRight | UIRectEdgeBottom;
    self.navigationController.navigationBar.backgroundColor = UIColor.redColor;
    
    [self setTabBarFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 44) contentViewFrame:CGRectMake(0, 44, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height - 44 - UIApplication.sharedApplication.statusBarFrame.size.height - 44)];

    self.tabBar.itemTitleColor = UIColor.blackColor;
    self.tabBar.itemTitleSelectedColor = MAIN_COLOR;
    self.tabBar.itemTitleFont = [UIFont systemFontOfSize:14];
    self.tabBar.itemTitleSelectedFont = [UIFont systemFontOfSize:16];
    self.tabBar.leadingSpace = 20;
    self.tabBar.trailingSpace = 20;
    
    self.tabBar.itemFontChangeFollowContentScroll = YES;
    self.tabBar.indicatorScrollFollowContent = YES;
    self.tabBar.indicatorColor = MAIN_COLOR;
    
    [self.tabBar setIndicatorWidth:80 marginTop:42 marginBottom:0 tapSwitchAnimated:YES];
    
    
    [self.tabContentView setContentScrollEnabled:YES tapSwitchAnimated:YES];
    self.tabContentView.loadViewOfChildContollerWhileAppear = YES;
    

    [self initViewControllers];
}

- (void)initViewControllers {
    
    MSMediaListVC *videoVC = [[MSMediaListVC alloc] initWithStyle:UITableViewStyleGrouped];
    videoVC.yp_tabItemTitle = NSLocalizedString(@"NormalVideo", nil);
    videoVC.fileType = W1MFileTypeNormal;

    MSMediaListVC *photoVC = [[MSMediaListVC alloc] initWithStyle:UITableViewStyleGrouped];
    photoVC.yp_tabItemTitle = NSLocalizedString(@"Photo", nil);
    photoVC.fileType = W1MFileTypePhoto;
    
    self.viewControllers = @[videoVC, photoVC];
    
//    UICollectionViewFlowLayout *normalLayout = [[UICollectionViewFlowLayout alloc] init];
//    self.normalVideoVC = [[MSLocalFileVC alloc] initWithCollectionViewLayout:normalLayout];;
//    self.normalVideoVC.yp_tabItemTitle = NSLocalizedString(@"NormalVideo", nil);
//    self.normalVideoVC.fileType = W1MFileTypeNormal;
//
//    UICollectionViewFlowLayout *imageLayout = [[UICollectionViewFlowLayout alloc] init];
//    self.imageVc = [[MSLocalFileVC alloc] initWithCollectionViewLayout:imageLayout];
//    self.imageVc.yp_tabItemTitle = NSLocalizedString(@"Photo", nil);
//    self.imageVc.fileType = W1MFileTypePhoto;
//
////    UICollectionViewFlowLayout *eventLayout = [[UICollectionViewFlowLayout alloc] init];
////    self.eventVideoVC = [[MSLocalFileVC alloc] initWithCollectionViewLayout:eventLayout];
////    self.eventVideoVC.yp_tabItemTitle = NSLocalizedString(@"EventVideo", nil);
////    self.eventVideoVC.fileType = W1MFileTypeEvent;
//
//    self.viewControllers = @[self.normalVideoVC, self.imageVc,/* self.eventVideoVC*/];
}

- (void)dealloc {
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)editAction:(UIBarButtonItem *)sender {
    
    NSUInteger currentPageIndex = self.tabBar.selectedItemIndex;
    
    switch (currentPageIndex) {
        case 0:
        {
            self.normalVideoVC.isInEdit = !self.normalVideoVC.isInEdit;
            self.navigationItem.rightBarButtonItem.title = self.normalVideoVC.isInEdit ? NSLocalizedString(@"Done", nil) : NSLocalizedString(@"Edit", nil);
        }
            break;
        case 1:
        {
            self.imageVc.isInEdit = !self.imageVc.isInEdit;
            self.navigationItem.rightBarButtonItem.title = self.imageVc.isInEdit ? NSLocalizedString(@"Done", nil) : NSLocalizedString(@"Edit", nil);
        }
            break;
        case 2:
        {
            self.eventVideoVC.isInEdit = !self.eventVideoVC.isInEdit;
            self.navigationItem.rightBarButtonItem.title = self.eventVideoVC.isInEdit ? NSLocalizedString(@"Done", nil) : NSLocalizedString(@"Edit", nil);
        }
            break;
            
        default:
            break;
    }
}

- (void)yp_tabBar:(YPTabBar *)tabBar didSelectedItemAtIndex:(NSUInteger)index {
    NSLog(@"%@",@(index));
    switch (index) {
        case 0:
        {
            self.navigationItem.rightBarButtonItem.title = self.normalVideoVC.isInEdit ? NSLocalizedString(@"Done", nil) : NSLocalizedString(@"Edit", nil);
        }
            break;
        case 1:
        {
            self.navigationItem.rightBarButtonItem.title = self.imageVc.isInEdit ? NSLocalizedString(@"Done", nil) : NSLocalizedString(@"Edit", nil);
        }
            break;
        case 2:
        {
            self.navigationItem.rightBarButtonItem.title = self.eventVideoVC.isInEdit ? NSLocalizedString(@"Done", nil) : NSLocalizedString(@"Edit", nil);
        }
            break;

        default:
            break;
    }
}

@end
