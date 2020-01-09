//
//  MSRemoteFileVC.m
//  MStar
//
//  Created by 王璋传 on 2019/10/16.
//  Copyright © 2019 王璋传. All rights reserved.
//

#import "MSRemoteFileVC.h"
#import "MSRemoteFileCell.h"
#import <MJRefresh.h>
#import "MSRemoteFileController.h"
#import "CPDownloadActionSheet.h"
#import <IDMPhoto.h>
#import "AITUtil.h"
#import "MSPhotoBrowserVC.h"
#import "MSVLCPlayerVC.h"
#import "CPPlayerVC.h"
#import "GDataXMLNode.h"

typedef enum
{
    CAMERA_FILE_LIST,
    CAMERA_FILE_DELETE,
    CAMERA_FILE_STREAM
} CAMERA_cmd_t;

@interface MSRemoteFileVC ()<AITCameraRequestDelegate> {
    CAMERA_cmd_t   cmd_tag;
    AITCameraCommand *cameraCommand ;
}

@property (nonatomic, strong) MSRemoteFileController *controller;
@property (nonatomic, assign) BOOL isLoading;

@property (nonatomic, strong) dispatch_semaphore_t  semSignal;

@end

@implementation MSRemoteFileVC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableViewStyle = UITableViewStyleGrouped;
    
    [self initBaseProperties];
    [self setupUI];
    [self loadData];
}

- (void)initBaseProperties {
    self.dataArray = @[
    ].mutableCopy;
    
    self.pageSize = PageSize;
    self.semSignal = dispatch_semaphore_create(0);
    
    self.controller = [[MSRemoteFileController alloc] init];

    [self.dataTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAllData) name:@"ItemSelectedNotification" object:nil];
}

- (void)setupUI {
    
    __weak typeof(self) weakSelf = self;
    
    self.dataTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        NSLog(@"下拉刷新");
        [weakSelf handleHeaderFresh];
    }];
    
    self.dataTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        NSLog(@"上拉刷新");
        [weakSelf handleFooterFresh];
    }];
}

- (void)handleHeaderFresh {
    
    if (self.semSignal) {
        dispatch_semaphore_wait(self.semSignal, DISPATCH_TIME_FOREVER);
    }
    
    [self.dataTableView.mj_footer setHidden:NO];
    self.currentIndex = 0;
    [self.dataArray removeAllObjects];
    
    [self loadData];
}

- (void)handleFooterFresh {
    
    if (self.semSignal) {
        dispatch_semaphore_wait(self.semSignal, DISPATCH_TIME_FOREVER);
    }
    
    self.currentIndex++;
    [self.dataTableView.mj_footer setHidden:NO];

    [self loadData];
}

#pragma mark - Set && get method


#pragma mark - Delegate method implement

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"MSRemoteFileCell";
    
    MSRemoteFileCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[MSRemoteFileCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.backgroundColor = UIColor.whiteColor;
    }
    
    if (indexPath.row < self.dataArray.count) {
        AITFileNode *fileNode = [self.dataArray objectAtIndex:indexPath.row];
        cell.fileNode = fileNode;
    }
    

    return cell;
}



#pragma mark - Private method

- (void)loadData {
    
//    [self.parentViewController.view cp_showToast];

    [MBProgressHUD showHUDAddedTo:UIApplication.sharedApplication.keyWindow animated:YES];

    NSLog(@"------------显示------------------");

    __weak typeof(self) weakSelf = self;
    
    [[MSDeviceMgr manager] loadRemoteFile:self.fileType
                                     page:self.currentIndex
                                   isRear:self.isRear
                                    block:^(NSArray<AITFileNode *> * datas) {
        [weakSelf handleLoadDataSuccessBlock:datas];
        dispatch_semaphore_signal(self->_semSignal);
    } fail:^(NSError * error) {
        dispatch_semaphore_signal(self->_semSignal);
        [weakSelf hideToast];
        [weakSelf.dataTableView.mj_header endRefreshing];
        [weakSelf.dataTableView.mj_footer endRefreshing];
    }];
}

- (void)handleLoadDataSuccessBlock:(NSArray <AITFileNode *> *)result {
    
//    [self.parentViewController.view cp_hideToast];
    [self hideToast];
    
    NSLog(@"----------%@",@(result.count));
    
    [self.dataArray addObjectsFromArray:result];
    
    [self.dataTableView reloadData];
    [self.dataTableView.mj_header endRefreshing];
    [self.dataTableView.mj_footer endRefreshing];
    
    if (result.count < self.pageSize) {
        [self.dataTableView.mj_footer setHidden:YES];
    }
}

- (void)hideToast {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"------------移除------------------");
//        [self.parentViewController.view cp_hideToast];
        [MBProgressHUD hideHUDForView:UIApplication.sharedApplication.keyWindow animated:YES];
    });
}

//  点击操作相关
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak typeof(self) weakSelf = self;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *previewlAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Preview", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf handlePlayAction:indexPath];
    }];
    
    UIAlertAction *downloadAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Downlaod", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf handleDownloadAction:indexPath];
    }];
    
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Delete", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf handleDeleteActionBlock:indexPath];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:deleteAction];
    [alertController addAction:downloadAction];
    [alertController addAction:previewlAction];
    
    [self presentViewController:alertController animated:YES completion:^{
    }];
}

- (void)handleDeleteActionBlock:(NSIndexPath *)indexPath {
    
    
    __weak typeof(self) weakSelf = self;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Hint", nil) message:NSLocalizedString(@"DeleteCorfirm", nil) preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Delete", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf deleteFileAt:indexPath];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
    
    [self presentViewController:alertController animated:YES completion:^{
    }];
    
}

//  删除文件
- (void)deleteFileAt:(NSIndexPath *)indexPath {
    
    AITFileNode *file = [self.dataArray objectAtIndex:indexPath.row];
    cmd_tag = CAMERA_FILE_DELETE;
//    cameraCommand = [[AITCameraCommand alloc] initWithUrl:[AITCameraCommand commandDelFileUrl:[file.name stringByReplacingOccurrencesOfString: @"/" withString:@"$"]] Delegate:self] ;
    
    [[AITCameraCommand alloc] initWithUrl:[AITCameraCommand commandDelFileUrl:[file.name stringByReplacingOccurrencesOfString: @"/" withString:@"$"]] block:^(NSString *result) {
        NSLog(@"");
    } fail:^(NSError *error) {
        
    }];

    [self.dataArray removeObject:file];
    
    [self.dataTableView reloadData];
}

- (void)handlePlayAction:(NSIndexPath *)indexPath {
    
    AITFileNode *node = [self.dataArray objectAtIndex:indexPath.row];
    
    NSString *url = [NSString stringWithFormat:@"http://%@%@", [AITUtil getCameraAddress], [node.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    if (self.fileType == W1MFileTypePhoto) {
        
        NSMutableArray *photos = @[].mutableCopy;
        [photos addObject:[IDMPhoto photoWithURL:[NSURL URLWithString:url]]];
        
        MSPhotoBrowserVC *browser = [[MSPhotoBrowserVC alloc] initWithPhotos:photos];
        
        [self presentViewController:browser animated:YES completion:nil];
    } else {
        
        
        MSVLCPlayerVC *vc = [[MSVLCPlayerVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.videoUrl = url;
        
        [self presentViewController:vc animated:YES completion:nil];
    }
    
}

- (void)handleDownloadAction:(NSIndexPath *)indexPath {
    
    AITFileNode *fileNode = [self.dataArray objectAtIndex:indexPath.row];
    //    self.selectedFileNode = fileNode;
    
    if(fileNode->downloader == nil && fileNode.progress == -1) {
        NSURL *url;
        NSString *filename;
        NSString *property = nil;
        switch (self.fileType) {
            case W1MFileTypeDcim:
                property = @"DCIM";
                break;
            case W1MFileTypeNormal:
                property = @"Normal";
                break;
            case W1MFileTypePhoto:
                property = @"Photo";
                break;
            case W1MFileTypeEvent:
                property = @"Event";
                break;
                
            default:
                break;
        }
        
        NSString *directory = [NSString stringWithFormat:@"%@",NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject];
        if (self.fileType == W1MFileTypePhoto) {
            directory = [directory stringByAppendingPathComponent:@"Photo"];
        } else {
            directory = [directory stringByAppendingPathComponent:@"Normal"];
        }
        
        BOOL isDirect = YES;
        BOOL dirExists =  [[NSFileManager defaultManager] fileExistsAtPath:directory isDirectory:&isDirect];
        if (NO == dirExists || NO == isDirect) {
            //   不存在目录
            [[NSFileManager defaultManager] createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        
        __weak typeof(self) weakSelf = self;
        //        [self.downloadActionSheet show];
        [[CPDownloadActionSheet manager] show];
        [CPDownloadActionSheet manager].cancelActionBlock = ^{
            [[AITFileDownloader manager] abortDownload];
        };
        
        [[AITFileDownloader manager] startDownloadFrom:fileNode.name
                                                    to:[directory stringByAppendingPathComponent:fileNode.name.lastPathComponent]
                                              progress:^(CGFloat downloadPer) {
            NSLog(@"************** %@ ****************",@(downloadPer));
            [CPDownloadActionSheet manager].percent = downloadPer;;
        } finished:^{
            NSLog(@"finished");
            [[CPDownloadActionSheet manager] dimiss];
            [[CPLoadStatusToast shareInstance] showWithStyle:CPLoadStatusStyleLoadingSuccess];
        } abort:^{
            NSLog(@"Abort");
            [[CPDownloadActionSheet manager] dimiss];
            [[CPLoadStatusToast shareInstance] showWithStyle:CPLoadStatusStyleFail];
        } error:^(NSError *error) {
            NSLog(@"Error");
            [[CPDownloadActionSheet manager] dimiss];
            [[CPLoadStatusToast shareInstance] showWithStyle:CPLoadStatusStyleFail];
        }];
        
    }
}


- (void)playLocalVideoAction:(id)sender {
    
    CPPlayerVC *playerVC = [[CPPlayerVC alloc] init];
    playerVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController presentViewController:playerVC animated:YES completion:^{
        
    }];
}

- (void)refreshAllData {
    
    NSLog(@"%s",__FUNCTION__);

    if (self.isLoading == YES) {
        [self handleHeaderFresh];
    }
    
    self.isLoading = YES;
}

- (void)switchCamAction {
    
    if (self.semSignal) {
        dispatch_semaphore_signal(self->_semSignal);
    }
    
    [self refreshAllData];
}


@end
