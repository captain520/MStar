//
//  MSContentVC.m
//  MStar
//
//  Created by 王璋传 on 2019/4/12.
//  Copyright © 2019 王璋传. All rights reserved.
//

#import "MSContentVC.h"

#define SELECTED_COLOR  [UIColor colorWithRed:18./255 green:150./255 blue:219./255 alpha:1]

@interface MSContentVC ()

@end

@implementation MSContentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout = UIRectEdgeLeft | UIRectEdgeRight | UIRectEdgeBottom;
    self.navigationController.navigationBar.backgroundColor = UIColor.redColor;

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
    
//    [self initViewControllers];
}

- (void)initViewControllers {
    
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = UIColor.whiteColor;

    self.viewControllers = @[vc];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
