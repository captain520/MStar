//
//  CPRefreshVC.m
//  CPLibs
//
//  Created by 王璋传 on 2019/2/16.
//  Copyright © 2019 王璋传. All rights reserved.
//

#import "CPRefreshVC.h"

@interface CPRefreshVC ()

@end

@implementation CPRefreshVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addRefreshController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mar - datasource && delegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"noData"];
}

//- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
//    return [[NSAttributedString alloc] initWithString:NSLocalizedString(@"DataIsEmpty", nil) attributes:nil];
//}
//
//- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
//    return [[NSAttributedString alloc] initWithString:NSLocalizedString(@"ClickToRefreshData", nil) attributes:@{NSForegroundColorAttributeName : C99}];
//}

#pragma mark - Private method implement

- (void)addRefreshController {
    
    self.currentPage = 1;

    if (self.pageSize == 0) {
        self.pageSize = 10;
    }
    
    __weak typeof(self) weakSelf = self;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakSelf.currentPage = 0;
        
        [self.tableView.mj_footer setHidden:NO];
        [weakSelf.dataArray removeAllObjects];
        [weakSelf loadData];
    }];
    
    
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        weakSelf.currentPage++;
        
        [weakSelf loadData];
    }];
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;

}

- (void)loadData {

    //  ....
}

@end
