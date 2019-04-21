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
@property (nonatomic, strong) M13ProgressHUD * hud;
@property (nonatomic, assign) BOOL hasLoaded;

@end

@implementation MSSDFileLIstVC

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
        
        [self loadData];
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
}
#pragma mark - setter && getter method
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
    
    cmd_tag = CAMERA_FILE_LIST;
    
    int index = (int)(self.pageSize * self.currentPage);
    switch (self.fileType) {
        case W1MFileTypeNormal:
        cameraCommand = [[AITCameraCommand alloc] initWithUrl:[AITCameraCommand commandListFileUrl:(int)(self.pageSize) From:index isRear:self.isRear fileType:W1MFileTypeNormal] Delegate:self] ;
            break;
        case W1MFileTypePhoto:
            cameraCommand = [[AITCameraCommand alloc] initWithUrl:[AITCameraCommand commandListFileUrl:(int)(self.pageSize) From:index isRear:self.isRear fileType:W1MFileTypePhoto] Delegate:self] ;
            break;
        case W1MFileTypeEvent:
            cameraCommand = [[AITCameraCommand alloc] initWithUrl:[AITCameraCommand commandListFileUrl:(int)(self.pageSize) From:index isRear:self.isRear fileType:W1MFileTypeEvent] Delegate:self] ;
            break;
        default:
            break;
    }
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
    if (self.isLocalFileList == NO) {
        [cell.downloadBT setImage:[UIImage imageNamed:@"download"] forState:UIControlStateNormal];
        [cell.downloadBT addTarget:self action:@selector(downloadAction:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [cell.downloadBT setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [cell.downloadBT addTarget:self action:@selector(playLocalVideoAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    

    AITFileNode *node = [self.dataArray objectAtIndex:indexPath.row];
    cell.nameLabel.text = [node.name lastPathComponent];
    cell.sizeLabel.text = [NSByteCountFormatter stringFromByteCount:node.size countStyle:NSByteCountFormatterCountStyleDecimal];
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://%@%@", [AITUtil getCameraAddress], [node.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]] ;
    if (W1MFileTypePhoto == self.fileType) {
        [cell.iconImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"tupian"]];
    } else {
        cell.url = url;
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    alert.showAnimationType = SCLAlertViewShowAnimationFadeIn;
    
     __weak typeof(self) weakSelf = self;
    
    [alert addButton:NSLocalizedString(@"Delete", nil) actionBlock:^{
        [weakSelf handleDeleteActionBlock:indexPath];
    }];
    
    [alert addButton:NSLocalizedString(@"Downlaod", nil) actionBlock:^{
        [weakSelf handleDownloadAction:indexPath];
    }];
    
    NSString *previewTitle = nil;
    
    if (self.fileType == W1MFileTypePhoto) {
        previewTitle = @"Preview";
    } else {
        previewTitle = @"Play";
    }
    [alert addButton:NSLocalizedString(previewTitle, nil) actionBlock:^{
        [weakSelf handlePlayAction:indexPath];
    }];
    
    SCLButton *button = [alert addButton:NSLocalizedString(@"Cancel", nil) actionBlock:^{
        
    }];
    
    button.buttonFormatBlock = ^NSDictionary *{
        return @{@"backgroundColor" : C99};
    };

    [alert showCustom:self image:[UIImage imageNamed:@"logo"] color:MAIN_COLOR title:nil subTitle:NSLocalizedString(@"PleaseChooseYourAction", nil) closeButtonTitle:nil duration:0.0f];

//    if (self.isLocalFileList == NO) {
//        return;
//    } else {
//        [self playLocalVideoAction:nil];
//    }
}

- (void)handleDeleteActionBlock:(NSIndexPath *)indexPath {
    AITFileNode *file = [self.dataArray objectAtIndex:indexPath.row];
    cmd_tag = CAMERA_FILE_DELETE;
    cameraCommand = [[AITCameraCommand alloc] initWithUrl:[AITCameraCommand commandDelFileUrl:[file.name stringByReplacingOccurrencesOfString: @"/" withString:@"$"]] Delegate:self] ;
    
    [self.dataArray removeObject:file];
    
    [self.tableView reloadData];
}

- (void)handlePlayAction:(NSIndexPath *)indexPath {
    
    AITFileNode *node = [self.dataArray objectAtIndex:indexPath.row];
//    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://%@%@", [AITUtil getCameraAddress], [node.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]] ;
    NSString *url = [NSString stringWithFormat:@"http://%@%@", [AITUtil getCameraAddress], [node.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    if (self.fileType == W1MFileTypePhoto) {

        NSMutableArray *photos = @[].mutableCopy;
        [photos addObject:[IDMPhoto photoWithURL:[NSURL URLWithString:url]]];

        IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:photos];
        
        [self presentViewController:browser animated:YES completion:nil];

    } else {
        
        SCVideoMainViewController *vc = [[SCVideoMainViewController alloc] initWithURL:url];
        vc.hidesBottomBarWhenPushed = YES;
        vc.playName = node.name.lastPathComponent;

        UIApplication.sharedApplication.keyWindow.rootViewController.hidesBottomBarWhenPushed = YES;
        
        self.navigationController.navigationBarHidden=YES;
        
        [self.navigationController pushViewController:vc animated:YES];
    }

//    CPPlayerVC *playerVC = [[CPPlayerVC alloc] init];
//    playerVC.hidesBottomBarWhenPushed = YES;
//    playerVC.liveurl = [NSString stringWithFormat:@"http://%@%@", [AITUtil getCameraAddress], [node.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//
//    [self.navigationController presentViewController:playerVC animated:YES completion:^{
//
//    }];
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
        directory = [directory stringByAppendingPathComponent:property];
        BOOL isDirect = YES;
        BOOL dirExists =  [[NSFileManager defaultManager] fileExistsAtPath:directory isDirectory:&isDirect];
        if (NO == dirExists || NO == isDirect) {
           //   不存在目录
            [[NSFileManager defaultManager] createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil];
        }

        // Create downloader
        url = [NSURL URLWithString: [NSString stringWithFormat:@"http://%@%@", [AITUtil getCameraAddress], [fileNode.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]] ;
        filename = [fileNode.name substringFromIndex:[fileNode.name rangeOfString:@"/" options:NSBackwardsSearch].location + 1] ;
        fileNode->downloader = [[AITFileDownloader alloc] initWithUrl:url Path:[directory stringByAppendingPathComponent:filename]];
        fileNode.progress = 0.0;
        [fileNode->downloader startDownload];
        cancelButton.hidden = NO;
        self.hud.hidden = NO;

        
        dlTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateUI:) userInfo:fileNode repeats:YES];
    }
}

- (void)updateUI:(NSTimer *)timer {
    
    AITFileNode *fileNode = timer.userInfo;
    

    if (nil == self.hud) {
        
        self.hud = [[M13ProgressHUD alloc] initWithProgressView:[[M13ProgressViewRing alloc] init]];
        
        // Configure the progress view
        self.hud.progressViewSize = CGSizeMake(60.0, 60.0);
        self.hud.animationPoint = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height / 2);
        
        // Add the HUD to the window. (Or any UIView)
        UIWindow *window = UIApplication.sharedApplication.keyWindow;
        [window addSubview:self.hud];
        
        // Show the HUD
        [self.hud show:YES];
        
        cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        cancelButton.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height / 2 + 38);
        [cancelButton setImage:[UIImage imageNamed:@"iccancel"] forState:UIControlStateNormal];

        [self.hud addSubview:cancelButton];
        [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.hud.progressView.mas_bottom).offset(80);
            make.centerX.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(60, 60));
        }];
    }
    
    if (nil == self.hud.superview) {
        UIWindow *window = UIApplication.sharedApplication.keyWindow;
        [window addSubview:self.hud];
        [self.hud show:YES];
    }
    
    [cancelButton buttonAction:^{
        fileNode->downloader->abort = YES;
    }];
    
    //Update the HUD progress
    
    [self.hud setProgress:1.* fileNode->downloader->offsetInFile/fileNode->downloader->bodyLength animated:YES];
    
    // Update the HUD status
    self.hud.status = @"Processing";
    
    NSLog(@"----------:%.2f%%",100.* fileNode->downloader->offsetInFile/fileNode->downloader->bodyLength);
    
    if (fileNode->downloader->offsetInFile == -1 || YES == fileNode->downloader->abort) {
        

        if (NO == fileNode->downloader->abort) {
            dispatch_async(dispatch_get_main_queue(), ^{
                SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
                alert.showAnimationType = SCLAlertViewShowAnimationFadeIn;
                [alert showError:NSLocalizedString(@"DownlaodFail", nil) subTitle:nil closeButtonTitle:nil duration:2];
            });
        }
        
        if (YES == fileNode->downloader->abort) {
            cancelButton.hidden = YES;
            [fileNode->downloader abortDownload];

        }
        
        [dlTimer invalidate];
        dlTimer = nil;
        fileNode.progress = -1;
        fileNode->downloader = nil;
        [self.hud dismiss:YES];
        
        return;
        
    } else if (fileNode->downloader->offsetInFile == fileNode->downloader->bodyLength) {
        dispatch_async(dispatch_get_main_queue(), ^{
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            alert.showAnimationType = SCLAlertViewShowAnimationFadeIn;
            [alert showSuccess:NSLocalizedString(@"DownlaodSuccess", nil) subTitle:nil closeButtonTitle:nil duration:2];
        });
        
        [dlTimer invalidate];
        dlTimer = nil;
        fileNode.progress = -1;
        fileNode->downloader = nil;
        // Hide the HUD
        cancelButton.hidden = YES;
        [self.hud dismiss:YES];
        
        return;
    }
    
    if (fileNode->downloader->handle == nil) {
        
        [dlTimer invalidate];
        dlTimer = nil;
        fileNode.progress = -1;
        fileNode->downloader = nil;
        
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        alert.showAnimationType = SCLAlertViewShowAnimationFadeIn;
        [alert showError:NSLocalizedString(@"UnknowErorr", nil) subTitle:nil closeButtonTitle:nil duration:2];
        
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

- (void)refreshAllData {
    [self.dataArray removeAllObjects];
    self.currentPage = 0;
    
    [self loadData];
}


@end
