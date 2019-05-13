//
//  MSPhotoBrowserVC.m
//  MStar
//
//  Created by 王璋传 on 2019/5/10.
//  Copyright © 2019 王璋传. All rights reserved.
//

#import "MSPhotoBrowserVC.h"

@interface MSPhotoBrowserVC ()<IDMPhotoBrowserDelegate>

@property (nonatomic, strong) UIButton * backAction;

@end

@implementation MSPhotoBrowserVC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.displayDoneButton = NO;
    self.displayArrowButton = NO;
    self.delegate = self;
    self.displayCounterLabel = YES;
    self.displayToolbar = YES;
    self.autoHideInterface = NO;
//    self.autoHideInterface = YES;
//    self.edgesForExtendedLayout = UIRectEdgeNone;
//    self.automaticallyAdjustsScrollViewInsets = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    [self setupUI];
}

#pragma mark - Initialized properties
- (void)initailizeBaseProperties {
    
}
#pragma mark - setter && getter method
#pragma mark - Setup UI
- (void)setupUI {
    if (nil == self.backAction) {
        self.backAction = [UIButton new];
//        self.backAction.backgroundColor = UIColor.redColor;
        self.backAction.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self.backAction setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [self.backAction addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.backAction setImageEdgeInsets:UIEdgeInsetsMake(0, 16, 0, 0)];
        [self.view addSubview:self.backAction];
        [self.backAction mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(StatusHeight);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(44);
        }];
    }
}
#pragma mark - Delegate && dataSource method implement
- (void)photoBrowser:(IDMPhotoBrowser *)photoBrowser didShowPhotoAtIndex:(NSUInteger)index {
    NSLog(@"----:%@",@(index));
}
#pragma mark - load data
- (void)loadData {
    
}
- (void)handleLoadDataBlock:(NSArray *)results {
}

#pragma mark - Private method implement

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
        return UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskPortrait;
}

- (void)orientChange:(NSNotification *)noti {
    //    NSDictionary* ntfDict = [noti userInfo];
    UIDeviceOrientation  orient = [UIDevice currentDevice].orientation;
    switch (orient) {
        case UIDeviceOrientationPortrait:
        {
            self.disableVerticalSwipe = YES;
        }
            break;
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationPortraitUpsideDown:
        case UIDeviceOrientationLandscapeRight:
        {
            self.disableVerticalSwipe = YES;
        }
            break;
        default:
            break;
    }
}

- (IBAction)backAction:(id)sender {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationPortrait) {
        //        [self.navigationController popViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        
        if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
            SEL selector = NSSelectorFromString(@"setOrientation:");
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
            [invocation setSelector:selector];
            [invocation setTarget:[UIDevice currentDevice]];
            int val = UIInterfaceOrientationPortrait;
            [invocation setArgument:&val atIndex:2];
            [invocation invoke];
        }
    }
}

@end
