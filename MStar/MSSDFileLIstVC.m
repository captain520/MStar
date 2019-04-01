//
//  MSSDFileLIstVC.m
//  MStar
//
//  Created by 王璋传 on 2019/3/7.
//  Copyright © 2019 王璋传. All rights reserved.
//

#import "MSSDFileLIstVC.h"
#import "MSFIleListCell.h"
#import "MSDownloadView.h"
#import "MSPlayerVC.h"
#import "CPPlayerVC.h"

@interface MSSDFileLIstVC ()

@end

@implementation MSSDFileLIstVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Initialized properties
- (void)initailizeBaseProperties {
    
}
#pragma mark - setter && getter method
#pragma mark - Setup UI
- (void)setupUI {
    

    
    [self.tableView registerNib:[UINib nibWithNibName:@"MSFIleListCell" bundle:nil] forCellReuseIdentifier:@"MSFIleListCell"];
}
#pragma mark - Delegate && dataSource method implement
#pragma mark - load data
- (void)loadData {
    
}

#pragma mark - Private method implement


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdenitifier = @"MSFIleListCell";
    
    MSFIleListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdenitifier];
    if (self.isLocalFileList == NO) {
        [cell.downloadBT setImage:[UIImage imageNamed:@"download"] forState:UIControlStateNormal];
        [cell.downloadBT addTarget:self action:@selector(downloadAction:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [cell.downloadBT setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [cell.downloadBT addTarget:self action:@selector(playLocalVideoAction:) forControlEvents:UIControlEventTouchUpInside];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.isLocalFileList == NO) {
        return;
    } else {
        [self playLocalVideoAction:nil];
    }
}

- (void)downloadAction:(id)sender {
    
    MSDownloadView *downloadView = [[MSDownloadView alloc] initWithFrame:UIScreen.mainScreen.bounds];
    
    [downloadView show];
}

- (void)playLocalVideoAction:(id)sender {
    
    CPPlayerVC *playerVC = [[CPPlayerVC alloc] init];
    playerVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController presentViewController:playerVC animated:YES completion:^{
        
    }];
}



@end
