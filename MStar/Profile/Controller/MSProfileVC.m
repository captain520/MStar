//
//  MSProfileVC.m
//  MStar
//
//  Created by 王璋传 on 2019/4/8.
//  Copyright © 2019 王璋传. All rights reserved.
//

#import "MSProfileVC.h"
#import "MSLocalFileVC.h"
#import "JYEqualCellSpaceFlowLayout.h"
#import "NYWaterWaveView.h"
#import "CPWebVC.h"
#import "AITCameraRequest.h"
#import "CPLoadStatusToast.h"
#import "MSModifyPwdVC.h"

@interface MSProfileVC ()<AITCameraRequestDelegate> {
}

@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, copy) NSString * ssid;
@property (nonatomic, copy) NSString * ssidPasswd;

@end

@implementation MSProfileVC

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.extendedLayoutIncludesOpaqueBars = YES;
    _titles = @[
        @[NSLocalizedString(@"WiFiSetting", nil),NSLocalizedString(@"FormatSDCard", nil)],
//        @[@"最近浏览的视频", @"最近浏览的图片"],
        @[NSLocalizedString(@"CleanCach", nil), ],
        @[NSLocalizedString(@"Version", nil), ],
    ];

//    [self setTitle:NSLocalizedString(@"ProfileSetting", nil)];
    
    [self initializedBaseProperties];
}

//  初始化相关数据
- (void)initializedBaseProperties {
//    (void)[[AITCameraCommand alloc] initWithUrl:[AITCameraCommand commandWifiInfoUrl] Delegate:self] ;
}

- (void)dealloc {
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    if (0 == section) {
//        return SCREENWIDTH * 3 / 5;
//    }
//
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 1;
            break;
        default:
            break;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    cell.textLabel.text = self.titles[indexPath.section][indexPath.row];
    cell.textLabel.textColor = C33;
    if (2 == indexPath.section) {
        cell.detailTextLabel.text = @"V1.2.0";
    }
    
    NSString *imageName = nil;

    switch (indexPath.section) {
        case 0:
        {
            if (0 == indexPath.row) {
                imageName = @"icon_wifi";
            } else if (1 == indexPath.row) {
                imageName = @"icon_restore";
            }
        }
            break;
        case 1:
            imageName = @"icon_clean";
            break;
        case 2:
            imageName = @"icon_version";
            break;
            
        default:
            break;
    }
    
    cell.imageView.image = [UIImage imageNamed:imageName];

    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
    
    if (0 != section) {
        return nil;
    }

    NSString *headerIdentifier = @"Header";

    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerIdentifier];
    UIImageView *logoImageView = [header.contentView viewWithTag:1000];
    if (nil == header) {
        header = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:headerIdentifier];
//        header.clipsToBounds = YES;
//        header.contentView.backgroundColor = UIColor.redColor;

        if (nil == logoImageView) {

            NYWaterWaveView* waterView = [[NYWaterWaveView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 200)];
            waterView.backgroundColor = MAIN_COLOR;
            waterView.center = header.center;
            [header.contentView addSubview:waterView];
            [waterView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(-StatusHeight);
                make.left.mas_equalTo(0);
                make.right.mas_equalTo(0);
                make.bottom.mas_equalTo(0);
            }];
            
            logoImageView = [UIImageView new];
            logoImageView.backgroundColor = UIColor.whiteColor;
            logoImageView.layer.cornerRadius = 40;
            logoImageView.tag = 1000;
            logoImageView.clipsToBounds = YES;
            logoImageView.image = [UIImage imageNamed:@"logo"];
            
            [header.contentView addSubview:logoImageView];
            [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(0);
                make.centerY.mas_equalTo(0);
                make.width.mas_equalTo(80);
                make.height.mas_equalTo(80);
            }];
        }
    }

    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    switch (indexPath.section) {
        case 0: {
            if (0 == indexPath.row) {
                [self showValidation:nil];
            } else if (1 == indexPath.row) {
                [self formatSDCard];
            }
        }
            break;
        case 1:
        {
            [self cleanCach];
        }
            break;
        case 2: {
//            CPWebVC *webVC = [[CPWebVC alloc] init];
//            webVC.urlStr = @"https://www.baidu.com";
//            webVC.hidesBottomBarWhenPushed = YES;
//
//            [self.navigationController pushViewController:webVC animated:YES];
        }
        break;

        default:
            break;
    }
}

-(void) requestFinished:(NSString*) result
{
    if (result != nil) {
        NSLog(@"Result = %@", result) ;
        
        NSArray *lines = [result componentsSeparatedByString:@"\n"];
        
        for (NSString *line in lines) {
            
            if ([line hasPrefix:[AITCameraCommand PROPERTY_SSID]]) {
                NSArray *properties = [line componentsSeparatedByString:@"="] ;
                
                if ([properties count] == 2) {
//                    self.ssidText.text = [properties objectAtIndex:1] ;
                    //  获取WIFI名称
                    self.ssid = [properties objectAtIndex:1];
                }
            } else if ([line hasPrefix:[AITCameraCommand PROPERTY_ENCRYPTION_KEY]]) {
                NSArray *properties = [line componentsSeparatedByString:@"="] ;
                
                if ([properties count] == 2) {
//                    self.encryptionKeyText.text = [properties objectAtIndex:1] ;
                    //  获取WIIF密码
                    self.ssidPasswd = [properties objectAtIndex:1];
                }
            }
        }
        
    } else {
    }
}

#pragma mark - private mthod

- (IBAction)showValidation:(id)sender
{
    
    MSModifyPwdVC *vc = [MSModifyPwdVC new];
    vc.hidesBottomBarWhenPushed = YES;

    [self.navigationController pushViewController:vc animated:YES];
}

//  格式化内存卡
- (void)formatSDCard
{
//    SCLAlertView *alert = [[SCLAlertView alloc] init];
//
//    alert.showAnimationType = SCLAlertViewHideAnimationSlideOutToCenter;
//    alert.hideAnimationType = SCLAlertViewHideAnimationSlideOutFromCenter;
//
//    alert.backgroundType = SCLAlertViewBackgroundTransparent;
//
//    [alert   showWaiting:self title:NSLocalizedString(@"Progressing", nil)
//                subTitle:NSLocalizedString(@"Formating", nil)
//        closeButtonTitle:nil duration:5.0f];
    
    [CPLoadStatusToast shareInstance].style = CPLoadStatusStyleLoadingSuccess;
    [[CPLoadStatusToast shareInstance] show];
}

- (void)cleanCach
{
    [CPLoadStatusToast shareInstance].style = CPLoadStatusStyleLoading;
    [[CPLoadStatusToast shareInstance] show];
}

@end
