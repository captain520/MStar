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
#import "MSAboutVC.h"

@interface MSProfileVC ()<AITCameraRequestDelegate> {
}

@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, copy) NSString * ssid;
@property (nonatomic, copy) NSString * ssidPasswd;
@property (nonatomic, copy) NSString * FWversion;

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
//        @[NSLocalizedString(@"WiFiSetting", nil),NSLocalizedString(@"FormatSDCard", nil)],
//        @[@"最近浏览的视频", @"最近浏览的图片"],
        @[NSLocalizedString(@"CleanCach", nil), NSLocalizedString(@"AboutUs", nil)],
//        @[NSLocalizedString(@"Version", nil), ],
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
    
//    if (nil != self.FWversion) {
//        return;
//    }
//
//     __weak typeof(self) weakSelf = self;
//
//    (void)[[AITCameraCommand alloc] initWithUrl:[AITCameraCommand commandQuerySettings]
//                                    block:^(NSString *result) {
//                                        [weakSelf handleQuerySettings:result];
//                                    } fail:^(NSError *error) {
//                                    }];
}

- (void)handleQuerySettings:(NSString *)result {
    if (NO == [result containsString:@"OK\n"]) {
        return;
    }
    
    NSArray <NSString *> *cameraMenu = [result componentsSeparatedByString:@"\n"];
    [cameraMenu enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj containsString:@"Camera.Menu.FWversion="]) {
            self.FWversion = [obj componentsSeparatedByString:@"="].lastObject;
            
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:2]] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            *stop = YES;
        }
    }];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [self.titles[section] count];
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
        cell.detailTextLabel.text = self.FWversion;
    }
    
    NSString *imageName = nil;

    switch (indexPath.section) {
        case 0:
        {
            if (0 == indexPath.row) {
                imageName = @"icon_clean";
            } else if (1 == indexPath.row) {
                imageName = @"icon_version";
            }
        }
            break;
        case 1:
            imageName = @"icon_clean";
            break;
        case 2:
        {
            imageName = @"icon_version";
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
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

    switch (indexPath.row) {
        case 0:
            [self cleanCach];
            break;
        case 1:
        {
            MSAboutVC *vc = [[MSAboutVC alloc] initWithStyle:UITableViewStyleGrouped];
            vc.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
//    switch (indexPath.section) {
//        case 0: {
//            if (0 == indexPath.row) {
//                [self showValidation:nil];
//            } else if (1 == indexPath.row) {
//                [self formatSDCard];
//            }
//        }
//            break;
//        case 1:
//        {
//            [self cleanCach];
//        }
//            break;
//        case 2: {
//
//        }
//        break;
//
//        default:
//            break;
//    }
}

-(void) requestFinished:(NSString*) result
{
    if (result != nil) {
        NSLog(@"Result = %@", result) ;
        NSArray <NSString *> *cameraMenu = [result componentsSeparatedByString:@"\n"];
        [cameraMenu enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj containsString:@"Camera.Menu.FWversion="]) {
                self.FWversion = [obj componentsSeparatedByString:@"="].lastObject;
                
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:2]] withRowAnimation:UITableViewRowAnimationAutomatic];

                *stop = YES;
            }
        }];

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
    
    __weak typeof(self) weakSelf = self;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"FormatSDCard", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf handleFormatSDCardAction];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
    
    [self presentViewController:alertController animated:YES completion:^{
    }];
}

- (void)handleFormatSDCardAction {
    
    [CPLoadStatusToast shareInstance].style = CPLoadStatusStyleLoading;
    [[CPLoadStatusToast shareInstance] show];
    
    (void)[[AITCameraCommand alloc] initWithUrl:[AITCameraCommand setProperty:@"SDFormat" Value:@"capture"]
                                          block:^(NSString *result) {
                                              [CPLoadStatusToast shareInstance].style = CPLoadStatusStyleLoadingSuccess;
                                              [[CPLoadStatusToast shareInstance] show];
                                          } fail:^(NSError *error) {
                                              [CPLoadStatusToast shareInstance].style = CPLoadStatusStyleFail;
                                              [[CPLoadStatusToast shareInstance] show];
                                          }];
}

- (void)cleanCach
{
    [CPLoadStatusToast shareInstance].style = CPLoadStatusStyleLoading;
    [[CPLoadStatusToast shareInstance] show];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [CPLoadStatusToast shareInstance].style = CPLoadStatusStyleLoadingSuccess;
        [[CPLoadStatusToast shareInstance] show];
    });
}

@end
