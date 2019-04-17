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

@interface MSProfileVC () {
}

@property (nonatomic, strong) NSArray *titles;

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
        @[@"Wi-Fi设置", @"格式化SD卡"],
//        @[@"最近浏览的视频", @"最近浏览的图片"],
        @[@"清理缓存", ],
        @[@"关于我们", ],
    ];

    [self setTitle:@"个人设置"];
}

- (void)dealloc {
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
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
    if (0 == section) {
        return SCREENWIDTH * 3 / 5;
    }

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

    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
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
        case 1:
        {
//            break;
//        case 2: {
            [self cleanCach];
        }
        break;
        case 2: {
//            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//
//            MSLocalFileVC *vc = [[MSLocalFileVC alloc] initWithCollectionViewLayout:layout];
//            vc.hidesBottomBarWhenPushed = YES;
//            vc.view.backgroundColor = UIColor.whiteColor;
//
//            [self.navigationController pushViewController:vc animated:YES];
            CPWebVC *webVC = [[CPWebVC alloc] init];
            webVC.urlStr = @"https://www.baidu.com";
            
            [self.navigationController pushViewController:webVC animated:YES];
        }
        break;

        default:
            break;
    }
}

#pragma mark - private mthod

- (IBAction)showValidation:(id)sender
{
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    [alert setHorizontalButtons:YES];

    SCLTextView *evenField = [alert addTextField:@"SSID"];
//    evenField.keyboardType = UIKeyboardTypeNumberPad;

    SCLTextView *oddField = [alert addTextField:@"passwd"];
    oddField.keyboardType = UIKeyboardTypeNumberPad;

    SCLButton *button = [alert addButton:@"确认修改" validationBlock:^BOOL {
        if (evenField.text.length == 0) {
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            alert.showAnimationType = SCLAlertViewShowAnimationFadeIn;
            [alert showError:@"请输入wifi名称" subTitle:nil closeButtonTitle:nil duration:2];

            [evenField becomeFirstResponder];
            return NO;
        }

        if (oddField.text.length < 8) {
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            alert.showAnimationType = SCLAlertViewShowAnimationFadeIn;
            [alert showError:@"请输入>=8位数的WIFI密码" subTitle:nil closeButtonTitle:nil duration:2];
            return NO;
        }

        //TODO: 发送修改命令

        return YES;
    } actionBlock:^{
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        alert.showAnimationType = SCLAlertViewShowAnimationFadeIn;

        dispatch_async(dispatch_get_main_queue(), ^{
                       [alert showSuccess:@"修改成功" subTitle:nil closeButtonTitle:nil duration:2];
                   });
    }];

    button.buttonFormatBlock = ^NSDictionary * (void)
    {
        NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];

        buttonConfig[@"backgroundColor"] = [UIColor redColor];
        buttonConfig[@"textColor"] = [UIColor whiteColor];
//        buttonConfig[@"borderWidth"] = @1.0f;
//        buttonConfig[@"borderColor"] = MAIN_COLOR;

        return buttonConfig;
    };

    [alert showEdit:self title:@"WIFI设置" subTitle:@"请输入您要修改成的WIFI名称m和密码!" closeButtonTitle:@"取消" duration:0];
}

//  格式化内存卡
- (void)formatSDCard
{
    SCLAlertView *alert = [[SCLAlertView alloc] init];

    alert.showAnimationType = SCLAlertViewHideAnimationSlideOutToCenter;
    alert.hideAnimationType = SCLAlertViewHideAnimationSlideOutFromCenter;

    alert.backgroundType = SCLAlertViewBackgroundTransparent;

    [alert   showWaiting:self title:@"Waiting..."
                subTitle:@"格式化内存卡中..."
        closeButtonTitle:nil duration:5.0f];
}

- (void)cleanCach
{
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];

    alert.showAnimationType = SCLAlertViewHideAnimationSlideOutToCenter;
    alert.hideAnimationType = SCLAlertViewHideAnimationSlideOutFromCenter;

    alert.backgroundType = SCLAlertViewBackgroundTransparent;

    [alert showTitle:@"Waiting..." subTitle:@"缓存清理中" style:SCLAlertViewStyleWaiting closeButtonTitle:nil duration:3];
//    [alert showWaiting:self title:@"Waiting..."
//              subTitle:@"格式化内存卡中..."
//      closeButtonTitle:nil duration:5.0f];
}

@end
