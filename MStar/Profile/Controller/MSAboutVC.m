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

@end

@implementation MSAboutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initailizeBaseProperties];
}

#pragma mark - Initialized properties
- (void)initailizeBaseProperties {
    self.tableView.backgroundColor = UIColor.whiteColor;
}
#pragma mark - setter && getter method
#pragma mark - Setup UI
- (void)setupUI {
    
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
//            cell.textLabel.text = @"去评分";
            cell.textLabel.text = @"Version";
            break;
        case 1:
            cell.textLabel.text = @"Version";
            break;
        default:
            break;
    }
    
    cell.detailTextLabel.text = @"V1.0.0";

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
