//
//  MSAboutVC.m
//  MStar
//
//  Created by 王璋传 on 2019/5/22.
//  Copyright © 2019 王璋传. All rights reserved.
//

#import "MSAboutVC.h"
#import "MSAboutUsHeader.h"

@interface MSAboutVC ()

@property (nonatomic, strong) UILabel *rightLB;

@end

@implementation MSAboutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initailizeBaseProperties];
    [self setupUI];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self setupUI];
}

#pragma mark - Initialized properties
- (void)initailizeBaseProperties {
    self.tableView.backgroundColor = UIColor.whiteColor;
    self.title = NSLocalizedString(@"AboutUs", nil);
}
#pragma mark - setter && getter method
#pragma mark - Setup UI
- (void)setupUI {
    
    if (nil == self.rightLB) {
        self.rightLB = [UILabel new];
        self.rightLB.textColor = C66;
        self.rightLB.font = [UIFont systemFontOfSize:15.0f];
        self.rightLB.frame = CGRectMake(0, SCREENHEIGHT - 100 - NAV_HEIGHT, SCREENWIDTH, 100);
        self.rightLB.numberOfLines = 0;

        [self.tableView addSubview:self.rightLB];

        self.rightLB.attributedText = [self rightAttr];
//        self.rightLB.backgroundColor = UIColor.redColor;
    }
}

- (NSAttributedString *)rightAttr {
    
    NSMutableParagraphStyle *p = [[NSMutableParagraphStyle alloc] init];
    p.alignment = NSTextAlignmentCenter;
    p.lineSpacing = 5.0f;
    
    NSString *topStr = @"深圳市泰合唯信科技有限公司 版权所有\n";
    NSString *tailStr = @"CopyRight 2015-2019 Togevision.All Rights Reserved";
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:topStr attributes:nil];
    NSAttributedString *attr0 = [[NSAttributedString alloc] initWithString:tailStr attributes:nil];
    
    [attr appendAttributedString:attr0];
    [attr addAttribute:NSParagraphStyleAttributeName value:p range:NSMakeRange(0, attr.length)];

    return attr;

}

#pragma mark - Delegate && dataSource method implement
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return SCREENWIDTH * 3 / 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"UITatbleViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.clipsToBounds = YES;
//        cell.backgroundColor = tableView.backgroundColor;
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = NSLocalizedString(@"SoftVersion", nil);
            break;
        case 1:
            cell.textLabel.text = NSLocalizedString(@"SoftVersion", nil);
            break;
        default:
            break;
    }
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    cell.detailTextLabel.text = app_Version;

    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSString *headerIdentifier = @"Header";
    
    MSAboutUsHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerIdentifier];
    if (nil == header) {
        header = [[MSAboutUsHeader alloc] initWithReuseIdentifier:headerIdentifier];
        header.contentView.backgroundColor = UIColor.whiteColor;
    }
    
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    NSString *footerIdentifier = @"footer";
    
    UITableViewHeaderFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:footerIdentifier];
    if (nil == footer) {
        footer = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:footerIdentifier];
    }
    
    return footer;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s", __FUNCTION__);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - load data
- (void)loadData {
    
}
- (void)handleLoadDataBlock:(NSArray *)results {
}

#pragma mark - Private method implement


@end
