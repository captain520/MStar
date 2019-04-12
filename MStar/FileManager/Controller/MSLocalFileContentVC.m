//
//  MSLocalFileContentVC.m
//  MStar
//
//  Created by 王璋传 on 2019/4/12.
//  Copyright © 2019 王璋传. All rights reserved.
//

#import "MSLocalFileContentVC.h"
#import "MSLocalFileVC.h"

@interface MSLocalFileContentVC ()<YPTabBarDelegate>

@property (nonatomic, strong) MSLocalFileVC *normalVideoVC, *imageVc, *eventVideoVC;

@end

@implementation MSLocalFileContentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(editAction:)];
    
    [self initViewControllers];
}

- (void)initViewControllers {
    
    UICollectionViewFlowLayout *normalLayout = [[UICollectionViewFlowLayout alloc] init];
    self.normalVideoVC = [[MSLocalFileVC alloc] initWithCollectionViewLayout:normalLayout];;
    self.normalVideoVC.yp_tabItemTitle = @"视频";
    self.normalVideoVC.fileType = W1MFileTypeNormal;
    
    UICollectionViewFlowLayout *imageLayout = [[UICollectionViewFlowLayout alloc] init];
    self.imageVc = [[MSLocalFileVC alloc] initWithCollectionViewLayout:imageLayout];
    self.imageVc.yp_tabItemTitle = @"图片";
    self.imageVc.fileType = W1MFileTypePhoto;
    
    UICollectionViewFlowLayout *eventLayout = [[UICollectionViewFlowLayout alloc] init];
    self.eventVideoVC = [[MSLocalFileVC alloc] initWithCollectionViewLayout:eventLayout];
    self.eventVideoVC.yp_tabItemTitle = @"锁存视频";
    self.eventVideoVC.fileType = W1MFileTypeEvent;
    
    self.viewControllers = @[self.normalVideoVC, self.imageVc, self.eventVideoVC];
    self.tabBar.delegate = self;
}

- (void)editAction:(UIBarButtonItem *)sender {
    
    NSUInteger currentPageIndex = self.tabBar.selectedItemIndex;
    
    switch (currentPageIndex) {
        case 0:
        {
            self.normalVideoVC.isInEdit = !self.normalVideoVC.isInEdit;
            self.navigationItem.rightBarButtonItem.title = self.normalVideoVC.isInEdit ? @"完成" : @"编辑";
        }
            break;
        case 1:
        {
            self.imageVc.isInEdit = !self.imageVc.isInEdit;
            self.navigationItem.rightBarButtonItem.title = self.imageVc.isInEdit ? @"完成" : @"编辑";
        }
            break;
        case 2:
        {
            self.eventVideoVC.isInEdit = !self.eventVideoVC.isInEdit;
            self.navigationItem.rightBarButtonItem.title = self.eventVideoVC.isInEdit ? @"完成" : @"编辑";
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
            self.navigationItem.rightBarButtonItem.title = self.normalVideoVC.isInEdit ? @"完成" : @"编辑";
        }
            break;
        case 1:
        {
            self.navigationItem.rightBarButtonItem.title = self.imageVc.isInEdit ? @"完成" : @"编辑";
        }
            break;
        case 2:
        {
            self.navigationItem.rightBarButtonItem.title = self.eventVideoVC.isInEdit ? @"完成" : @"编辑";
        }
            break;

        default:
            break;
    }
}

@end
