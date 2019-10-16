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
#import "AITCameraCommand.h"
#import "GDataXMLNode.h"
#import "AITFileNode.h"
#import <MJRefresh.h>
#import "AITUtil.h"
#import <MobileVLCKit/MobileVLCKit.h>
#import <M13ProgressHUD.h>
#import <M13ProgressViewRing.h>
#import "UIButton+block.h"
#import <Masonry.h>
#import "SCVideoMainViewController.h"
#import <IDMPhotoBrowser.h>
#import "CPDownloadActionSheet.h"
#import "MSPhotoBrowserVC.h"
#import "MSVLCPlayerVC.h"

static NSString *TAG_DCIM = @"DCIM" ;

static NSString *TAG_file = @"file" ;
static NSString *TAG_name = @"name" ;
static NSString *TAG_format = @"format" ;
static NSString *TAG_size = @"size" ;
static NSString *TAG_attr = @"attr" ;
static NSString *TAG_time = @"time" ;

static NSString *TAG_amount = @"amount" ;

typedef enum
{
    CAMERA_FILE_LIST,
    CAMERA_FILE_DELETE,
    CAMERA_FILE_STREAM
} CAMERA_cmd_t;

@interface MSSDFileLIstVC ()<AITCameraRequestDelegate,VLCMediaThumbnailerDelegate> {
    AITCameraCommand *cameraCommand ;
    CAMERA_cmd_t   cmd_tag;
    
    UIButton *cancelButton;
    
    NSTimer *dlTimer;
}

@property (nonatomic, strong)AITFileNode *selectedFileNode;
//@property (nonatomic, strong) M13ProgressHUD * hud;
@property (nonatomic, assign) BOOL hasLoaded;
@property (nonatomic, strong) CPDownloadActionSheet *downloadActionSheet;;

@end

@implementation MSSDFileLIstVC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self initailizeBaseProperties];
    [self setupUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.hasLoaded == NO) {
        self.hasLoaded = YES;
        
        //        [self loadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Initialized properties
- (void)initailizeBaseProperties {
    self.dataArray = @[].mutableCopy;
    
    self.pageSize = 10;
    self.currentPage = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAllData) name:@"ItemSelectedNotification" object:nil];
}
#pragma mark - setter && getter method

- (CPDownloadActionSheet *)downloadActionSheet {
    if (nil == _downloadActionSheet) {
        _downloadActionSheet = [CPDownloadActionSheet new];
    }
    
    return _downloadActionSheet;
}
#pragma mark - Setup UI
- (void)setupUI {
    [self.tableView registerNib:[UINib nibWithNibName:@"MSFIleListCell" bundle:nil] forCellReuseIdentifier:@"MSFIleListCell"];
}
#pragma mark - Delegate && dataSource method implement

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    [self refreshAllData];
}

-(GDataXMLElement *) getFirstChild:(GDataXMLElement *) element WithName: (NSString*) name
{
    NSArray *elements = [element elementsForName:name] ;
    
    if (elements.count > 0) {
        
        return (GDataXMLElement *) [elements objectAtIndex:0];
    }
    
    NSLog(@"Cannot find Tag:%@", name) ;
    
    return nil ;
}

-(void) requestFinished:(NSString*) result
{
    if (cameraCommand == nil)
        return ;
    if (cmd_tag == CAMERA_FILE_LIST) {
        //int index = 0;
        if (result) {
            if ([result containsString:@"404 Not Found"]) {
                [self performSelector:@selector(loadData) withObject:nil afterDelay:2];
            } else {
                [self handleLoadFileListBlock:result];
            }
        } else {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [self.tableView.mj_footer setHidden:YES];
            
            [self performSelector:@selector(loadData) withObject:nil afterDelay:2];
        }
        
    } else if (cmd_tag == CAMERA_FILE_DELETE) {
        
    } else if (cmd_tag == CAMERA_FILE_STREAM) {
        
    }
}

- (void)handleLoadFileListBlock:(NSString *)result {
    
    NSMutableArray *fileNodes = @[].mutableCopy;
    
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithXMLString:[result substringToIndex:[result rangeOfString:@">" options:NSBackwardsSearch].location + 1] options:0 error:nil];
    GDataXMLElement *dcimElement = doc.rootElement ;
    //NSLog(@"dcimElement = %@\n", dcimElement.name) ;
    int amount = -1;
    NSArray *dcimChildren = [dcimElement children] ;
    for (GDataXMLElement *dcimChild in dcimChildren) {
        if ([[dcimChild name] isEqualToString:TAG_file]) {
            //                    NSArray *fileChildren = [dcimChild children] ;
            //                    for (GDataXMLElement * fileChild in fileChildren) {
            //                        NSLog(@"Child %@ = %@\n", fileChild.name, [fileChild stringValue]) ;
            //                    }
            AITFileNode *fileNode = [[AITFileNode alloc] init] ;
            fileNode.name = [[self getFirstChild:dcimChild WithName:TAG_name] stringValue] ;
            fileNode.format = [[self getFirstChild:dcimChild WithName:TAG_format] stringValue] ;
            fileNode.size = (unsigned int)[[[self getFirstChild:dcimChild WithName:TAG_size] stringValue] integerValue];
            fileNode.attr = [[self getFirstChild:dcimChild WithName:TAG_attr] stringValue] ;
            fileNode.time = [[self getFirstChild:dcimChild WithName:TAG_time] stringValue] ;
            fileNode.blValid = TRUE;
            fileNode.progress = -1;
            //            [fileNodes addObject: fileNode] ;
            [fileNodes addObject:fileNode];
            //                    NSLog(@"Added file \"%@\" into fileNode\n", fileNode.name) ;
        } else if ([[dcimChild name] isEqualToString:TAG_amount]) {
            amount = [[dcimChild stringValue] intValue] ;
        } else {
            NSLog(@"ERROR TRY!!");
        }
    }
    
    
    if (fileNodes.count > 0) {
        [self.dataArray addObjectsFromArray:fileNodes];
    }
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
    if (fileNodes.count < self.pageSize) {
        [self.tableView.mj_footer setHidden:YES];
    } else {
        [self.tableView.mj_footer setHidden:NO];
    }
    
    [self.tableView reloadData];
}
#pragma mark - load data

- (void)loadData {
    
    __weak typeof(self) weakSelf = self;
    
    [[MSDeviceMgr manager] stopRecrod:^{
        [weakSelf loadData:NO];
    }];
}

- (void)loadData:(BOOL )isAllRefresh {
    
    [[MSDeviceMgr manager] stopRecrod:^{
        
        
        NSLog(@"************ %s %s******************",__FILE__,__FUNCTION__);
        
        cmd_tag = CAMERA_FILE_LIST;
        
        __weak typeof(self) weakSelf = self;
        
        int index = (int)(self.pageSize * self.currentPage);
        NSURL *requestUrl = nil;
        switch (self.fileType) {
            case W1MFileTypeNormal:
            {
                requestUrl = [AITCameraCommand commandListFileUrl:(int)(self.pageSize) From:index isRear:self.isRear fileType:W1MFileTypeNormal];
            }
                break;
            case W1MFileTypePhoto:
            {
                requestUrl = [AITCameraCommand commandListFileUrl:(int)(self.pageSize) From:index isRear:self.isRear fileType:W1MFileTypePhoto];
            }
                break;
            case W1MFileTypeEvent:
                requestUrl = [AITCameraCommand commandListFileUrl:(int)(self.pageSize) From:index isRear:self.isRear fileType:W1MFileTypeEvent];
                break;
            default:
                break;
        }
        
        if (requestUrl == nil) {
            return;
        }
        
        isAllRefresh ? : [self.navigationController.view cp_showToast];
        
        (void)[[AITCameraCommand alloc] initWithUrl:requestUrl
                                              block:^(NSString *result) {
            
            [weakSelf.navigationController.view cp_hideToast];
            
            if (result.length > 10) {
                if ([result containsString:@"Not"]) {
                    [[MSDeviceMgr manager] stopRecrod:^{
                        [weakSelf loadData:isAllRefresh];
                    }];
                    NSLog(@"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
                } else {
                    [weakSelf handleLoadFileListBlock:result];
                }
            } else {
                [weakSelf handleErrorBlock];
            }
            
            
        } fail:^(NSError *error) {
            [weakSelf handleErrorBlock];
            [weakSelf.navigationController.view cp_hideToast];
            
        }];
    }];
}

- (void)handleErrorBlock {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
    [self.tableView.mj_footer setHidden:YES];
    
    [self.tableView reloadData];
}

#pragma mark - Private method implement


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdenitifier = @"MSFIleListCell";
    
    MSFIleListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdenitifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.iconImageView.image = [UIImage imageNamed:@"tupian"];
    if (self.isLocalFileList == NO) {
        [cell.downloadBT setImage:[UIImage imageNamed:@"download"] forState:UIControlStateNormal];
        [cell.downloadBT addTarget:self action:@selector(downloadAction:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [cell.downloadBT setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [cell.downloadBT addTarget:self action:@selector(playLocalVideoAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    if (indexPath.row < self.dataArray.count) {
        
        AITFileNode *node = [self.dataArray objectAtIndex:indexPath.row];
        cell.nameLabel.text = [node.name lastPathComponent];
        cell.sizeLabel.text = [NSByteCountFormatter stringFromByteCount:node.size countStyle:NSByteCountFormatterCountStyleDecimal];
        NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://%@%@", [AITUtil getCameraAddress], [node.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]] ;
        if (W1MFileTypePhoto == self.fileType) {
            [cell.iconImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"tupian"]];
        } else {
            cell.url = url;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

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
    cameraCommand = [[AITCameraCommand alloc] initWithUrl:[AITCameraCommand commandDelFileUrl:[file.name stringByReplacingOccurrencesOfString: @"/" withString:@"$"]] Delegate:self] ;
    
    [self.dataArray removeObject:file];
    
    [self.tableView reloadData];
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
    [self.dataArray removeAllObjects];
    self.currentPage = 0;
    
    [self loadData:YES];
}


@end
