//
//  MSSettingActionVC.m
//  MStar
//
//  Created by 王璋传 on 2019/5/4.
//  Copyright © 2019 王璋传. All rights reserved.
//

#import "MSSettingActionVC.h"

@interface MSSettingActionVC ()

@property (nonatomic, strong) NSIndexPath * selectedIndexPath;

@end

@implementation MSSettingActionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveAction:)];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"save"] style:UIBarButtonItemStyleDone target:self action:@selector(saveAction:)];
    self.selectedIndexPath = [NSIndexPath indexPathForRow:self.selectedIndex inSection:0];
    
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"UITableViewCell"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.tintColor = UIColor.redColor;
    // Configure the cell...

    AITCamMenu *menuItem = self.dataArray[indexPath.row];
    cell.textLabel.text = menuItem.title;
//    cell.textLabel.font = [UIFont systemFontOfSize:15];
    
    if (self.selectedIndexPath == indexPath) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath == self.selectedIndexPath) {
        return;
    } else {
        self.selectedIndexPath = indexPath;
        [self.tableView reloadData];
    }
}

- (void)saveAction:(id)sender {
    
    if (self.selectedIndexPath && self.selectedIndexPath.row != self.selectedIndex) {
        !self.selectedActionBlock ? : self.selectedActionBlock(self.dataArray[self.selectedIndexPath.row]);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
