//
//  CPBaseTableVC.h
//  CPDemoSpace
//
//  Created by 王璋传 on 2019/10/9.
//  Copyright © 2019 王璋传. All rights reserved.
//

#import "MSBaseVC.h"

NS_ASSUME_NONNULL_BEGIMSBaseTableVCN

@interface MSBaseTableVC : MSBaseVC<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView  *dataTableView;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, assign) UITableViewStyle tableViewStyle;

/// 加载数据
- (void)loadData;

@end

NS_ASSUME_NONNULL_END
