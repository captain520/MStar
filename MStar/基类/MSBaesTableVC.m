//
//  MSBaesTableVC.m
//  MStar
//
//  Created by 王璋传 on 2019/10/16.
//  Copyright © 2019 王璋传. All rights reserved.
//

#import "MSBaesTableVC.h"

@interface MSBaesTableVC ()

@end

@implementation MSBaesTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataArray = @[].mutableCopy;
    
}


- (UITableView *)dataTableView {
    
    if (nil == _dataTableView) {
        _dataTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:self.tableViewStyle];
        _dataTableView.delegate   = self;
        _dataTableView.dataSource = self;
        _dataTableView.emptyDataSetSource = self;
        _dataTableView.emptyDataSetDelegate = self;
        _dataTableView.backgroundColor = [UIColor colorWithRed:238.0/255 green:238.0f/255 blue:238./255 alpha:1];
//        if (@available(iOS 13, *)) {
//            _dataTableView.backgroundColor = UIColor.systemGroupedBackgroundColor;
//        } else {
//            _dataTableView.backgroundColor = UIColor.groupTableViewBackgroundColor;
//        }

        [self.view addSubview:_dataTableView];
    }
    
    return _dataTableView;
}


#pragma mark - Delegate method implement

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"noData"];
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    NSLog(@"------------------------------");
    
    [self loadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"UITableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSArray *items4Section = self.dataArray[indexPath.section];
    NSDictionary *itemDict4Row = items4Section[indexPath.row];

    cell.textLabel.text = itemDict4Row[@"Function"];
    cell.detailTextLabel.text = itemDict4Row[@"ClassName"];;
    
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {

    NSString *headerIdentifier = @"Header";

    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerIdentifier];
    if (!header) {
        header = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:headerIdentifier];
        header.contentView.backgroundColor = UIColor.redColor;
    }

    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

#pragma mark - Private method

- (void)loadData {
    [self.dataTableView reloadData];
}


@end
