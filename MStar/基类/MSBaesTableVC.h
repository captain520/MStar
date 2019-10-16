//
//  MSBaesTableVC.h
//  MStar
//
//  Created by 王璋传 on 2019/10/16.
//  Copyright © 2019 王璋传. All rights reserved.
//

#import "MSBaseVC.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

NS_ASSUME_NONNULL_BEGIN

@interface MSBaesTableVC : MSBaseVC<UITableViewDelegate, UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView  *dataTableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) UITableViewStyle tableViewStyle;

@property (nonatomic, assign) NSUInteger currentIndex;
@property (nonatomic, assign) NSUInteger pageSize;

/// 加载数据
- (void)loadData;

@end

NS_ASSUME_NONNULL_END
