//
//  MSMediaListVC.m
//  MStar
//
//  Created by 王璋传 on 2019/5/4.
//  Copyright © 2019 王璋传. All rights reserved.
//

#import "MSMediaListVC.h"
#import "MSFIleListCell.h"
#import <IDMPhotoBrowser.h>
#import <SDWebImage.h>
#import "SCVideoMainViewController.h"
#import <UIScrollView+EmptyDataSet.h>
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVAssetImageGenerator.h>
#import <AVFoundation/AVAsset.h>
#import "MSVLCPlayerVC.h"
#import "MSPhotoBrowserVC.h"

@interface MSMediaListVC ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, strong) NSFileManager * fileManager;

@end

@implementation MSMediaListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadData];
}



- (void)setupUI {
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"MSFIleListCell" bundle:nil] forCellReuseIdentifier:@"MSFIleListCell"];
}

- (NSFileManager *)fileManager {
    
    if (nil == _fileManager) {
        _fileManager = [NSFileManager defaultManager];
    }
    
    return _fileManager;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Configure the cell...
    
    MSFIleListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MSFIleListCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    NSString *fileName = self.dataArray[indexPath.row];
    NSString *path = [self filePathOf:self.fileType];
    path = [path stringByAppendingPathComponent:fileName];
    
    if (self.fileType == W1MFileTypePhoto) {
        [cell.iconImageView sd_setImageWithURL:[NSURL fileURLWithPath:path] placeholderImage:[UIImage imageNamed:@"tupian"]];
        
    } else {
//        UIImage *image = [[SDImageCache sharedImageCache] imageFromCacheForKey:fileName];
//        cell.iconImageView.image = image;
        UIImage *image = [[SDImageCache sharedImageCache] imageFromCacheForKey:fileName];
        if (nil == image) {
            //        VLCMedia *media = [VLCMedia mediaWithURL:url];
            //        VLCMediaThumbnailer *thumber = [VLCMediaThumbnailer thumbnailerWithMedia:media andDelegate:self];
            //        [thumber fetchThumbnail];
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            image =  [self thumbnailImageForVideo:[NSURL fileURLWithPath:path] atTime:0];
//            });
        }
        
        cell.iconImageView.image = image;
    }
    
    cell.nameLabel.text = fileName;
    
    unsigned long long fileBytes = [[self.fileManager attributesOfItemAtPath:path error:nil] fileSize];
    
    cell.sizeLabel.text = [NSByteCountFormatter stringFromByteCount:fileBytes countStyle:NSByteCountFormatterCountStyleFile];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s",__FUNCTION__);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *previewlAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Preview", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf previewMedia:indexPath];
    }];
    
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Delete", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf deleteMeida:indexPath];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:deleteAction];
    [alertController addAction:previewlAction];
    
    [self presentViewController:alertController animated:YES completion:^{
    }];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"noData"];
}

#pragma mark - loaddData
- (void)loadData {
    
    self.dataArray = @[].mutableCopy;
    
    NSString *directory = [self filePathOf:self.fileType];
    NSError *error = nil;
    NSArray *fileNames = [self.fileManager contentsOfDirectoryAtPath:directory error:&error];
    
    if (nil == error && fileNames.count > 0) {
        self.dataArray = fileNames.mutableCopy;
    }
    
    [self.tableView reloadData];
}

- (NSString *)filePathOf:(W1MFileType)fileType {
    
    NSString *property = nil;
    switch (self.fileType) {
        case W1MFileTypeEvent:
//            property = @"Event";
//            break;
        case W1MFileTypeDcim:
//            property = @"DCIM";
//            break;
        case W1MFileTypeNormal:
            property = @"Normal";
            break;
        case W1MFileTypePhoto:
            property = @"Photo";
            break;
            
        default:
            break;
    }
    
    NSString *directory = [NSString stringWithFormat:@"%@",NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject];
    directory = [directory stringByAppendingPathComponent:property];
    
    return directory;
}

- (void)previewMedia:(NSIndexPath *)indexPath{
    
    if (W1MFileTypePhoto == self.fileType) {
        [self previewImagesAt:indexPath];
    } else {
        [self showVideoPlay:indexPath];
    }
}

- (void)previewImagesAt:(NSIndexPath *)indexPath {
    
    NSMutableArray *photos = @[].mutableCopy;
    [self.dataArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *filePath = [[self filePathOf:self.fileType] stringByAppendingPathComponent:obj];
        [photos addObject:[IDMPhoto photoWithFilePath:filePath]];
    }];
    
    MSPhotoBrowserVC *browser = [[MSPhotoBrowserVC alloc] initWithPhotos:photos];
    [browser setInitialPageIndex:indexPath.row];

    [self presentViewController:browser animated:YES completion:nil];
}

- (void)showVideoPlay:(NSIndexPath *)indexPath {
    
    NSString *fileName = self.dataArray[indexPath.row];
    NSString *path = [self filePathOf:self.fileType];
    path = [path stringByAppendingPathComponent:fileName];
    
    MSVLCPlayerVC *vc = [[MSVLCPlayerVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.videoUrl = path;
    
    [self presentViewController:vc animated:YES completion:nil];
//    [self.navigationController presentViewController:vc animated:YES completion:nil];
//    [self.navigationController pushViewController:vc animated:YES];
    
//    SCVideoMainViewController *vc = [[SCVideoMainViewController alloc] initWithURL:path];
//    vc.hidesBottomBarWhenPushed = YES;
//
//    UIApplication.sharedApplication.keyWindow.rootViewController.hidesBottomBarWhenPushed = YES;
//
//    self.navigationController.navigationBarHidden=YES;
//
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)deleteMeida:(NSIndexPath *)indexPath {
    
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

- (void)deleteFileAt:(NSIndexPath *)indexPath {
    
    [self.dataArray removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
    
    if (self.dataArray.count == 0) {
        [self.tableView reloadData];
    }
}

- (UIImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode =AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)actualTime:NULL error:&thumbnailImageGenerationError];
    
    if(!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
    
    UIImage*thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage:thumbnailImageRef] : nil;
    if (nil != thumbnailImage) {
        
        [[SDImageCache sharedImageCache] storeImage:thumbnailImage forKey:videoURL.lastPathComponent completion:^{
            
        }];
        
    }
    
    return thumbnailImage;
}

@end
