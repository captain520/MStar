//
//  ViewController.m
//  MStar
//
//  Created by 王璋传 on 2019/3/7.
//  Copyright © 2019 王璋传. All rights reserved.
//

#import "ViewController.h"
#import <UIColor+ColorWithHex.h>
#import "MSPreviewVC.h"
#import "MSSDFileLIstVC.h"
#import "MSFileListContentVC.h"
#import "MSProfileVC.h"

#import <UMSSDKUI/UMSProfileViewController.h>

@interface ViewController ()<BATabBarControllerDelegate>

@property (nonatomic, strong) BATabBarController* vc;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Initialized properties
- (void)initailizeBaseProperties {
    
}
#pragma mark - setter && getter method
#pragma mark - Setup UI
- (void)setupUI {
    
    BATabBarItem *tabBarItem, *tabBarItem2, *tabBarItem3, *tabBarItem4;
    
    MSPreviewVC *vc0 = [[MSPreviewVC alloc] init];
    vc0.view.backgroundColor = UIColor.whiteColor;
    UINavigationController *nav0 = [[UINavigationController alloc] initWithRootViewController:vc0];
    
    MSFileListContentVC *vc1 = [[MSFileListContentVC alloc] init];
    vc1.title = @"SD卡文件";
    vc1.view.backgroundColor = UIColor.whiteColor;
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:vc1];
    
    MSFileListContentVC *vc2 = [[MSFileListContentVC alloc] init];
    vc2.title = @"本地文件";
    vc2.isLocalFileList = YES;
    vc2.view.backgroundColor = UIColor.whiteColor;
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:vc2];
    
//    UMSProfileViewController *vc3 = [[UMSProfileViewController alloc] init];
    MSProfileVC *vc3 = [[MSProfileVC alloc] initWithStyle:UITableViewStyleGrouped];
//    vc3.view.backgroundColor = UIColor.whiteColor;
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:vc3];


    NSMutableAttributedString *option1 = [[NSMutableAttributedString alloc] initWithString:@"相机"];
    [option1 addAttribute:NSForegroundColorAttributeName value:Ccc range:NSMakeRange(0,option1.length)];
    
    tabBarItem = [[BATabBarItem alloc] initWithImage:[UIImage imageNamed:@"shexiangji"] selectedImage:[UIImage imageNamed:@"cameralSelected"] title:option1];

    NSMutableAttributedString *option2 = [[NSMutableAttributedString alloc] initWithString:@"SD卡"];
    [option2 addAttribute:NSForegroundColorAttributeName value:Ccc range:NSMakeRange(0,option2.length)];
    
    tabBarItem2 = [[BATabBarItem alloc] initWithImage:[UIImage imageNamed:@"SDCard"] selectedImage:[UIImage imageNamed:@"SDCardSelected"] title:option2];
    
    NSMutableAttributedString * option3 = [[NSMutableAttributedString alloc] initWithString:@"本地"];
    [option3 addAttribute:NSForegroundColorAttributeName value:Ccc range:NSMakeRange(0,option3.length)];
    
    tabBarItem3 = [[BATabBarItem alloc] initWithImage:[UIImage imageNamed:@"bendi"] selectedImage:[UIImage imageNamed:@"localSelected"] title:option3];
    
    NSMutableAttributedString * option4 = [[NSMutableAttributedString alloc] initWithString:@"个人"];
    [option4 addAttribute:NSForegroundColorAttributeName value:Ccc range:NSMakeRange(0,option4.length)];
    
    tabBarItem4 = [[BATabBarItem alloc] initWithImage:[UIImage imageNamed:@"My"] selectedImage:[UIImage imageNamed:@"profileSelected"] title:option4];
    
    
    self.vc = [[BATabBarController alloc] init];
//    self.vc.hidesBottomBarWhenPushed = YES;
//    self.vc.tabBarItemStrokeColor = MAIN_COLOR;
//    self.vc.tabBarBackgroundColor = MAIN_COLOR;
    
    self.vc.viewControllers = @[nav0,nav1,nav2,nav3];
    self.vc.tabBarItems = @[tabBarItem,tabBarItem2,tabBarItem3,tabBarItem4];
//    [self.vc setSelectedViewController:vc2 animated:NO];
    
    self.vc.delegate = self;
    [self.view addSubview:self.vc.view];
}
#pragma mark - Delegate && dataSource method implement
- (void)tabBarController:(BATabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    NSLog(@"Delegate success!");
}
#pragma mark - load data
- (void)loadData {
    
}
- (void)handleLoadDataBlock:(NSArray *)results {
}

#pragma mark - Private method implement


@end
