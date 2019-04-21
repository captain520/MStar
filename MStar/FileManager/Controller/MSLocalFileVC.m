//
//  MSLocalFileVC.m
//  MStar
//
//  Created by 王璋传 on 2019/4/11.
//  Copyright © 2019 王璋传. All rights reserved.
//

#import "MSLocalFileVC.h"
#import "JYEqualCellSpaceFlowLayout.h"
#import <IDMPhotoBrowser.h>
#import <SDWebImage.h>
#import "SCVideoMainViewController.h"

/*************************************************** MSLocalFileCell ***************************************************/
@interface MSLocalFileCell()

@end

@implementation MSLocalFileCell

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = UIColor.groupTableViewBackgroundColor;
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    if (nil == self.iconImageView) {
        self.iconImageView = [UIImageView new];
        self.iconImageView.layer.cornerRadius = 5.0f;
        self.iconImageView.layer.borderWidth = 0.1f;
        self.iconImageView.layer.borderColor = MAIN_COLOR.CGColor;
        self.iconImageView.clipsToBounds = YES;
        self.iconImageView.contentMode = UIViewContentModeScaleAspectFit;

        [self.contentView addSubview:self.iconImageView];
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
    }
    
    if (nil == self.checkImageView) {
        self.checkImageView = [UIImageView new];
        self.checkImageView.image = [UIImage imageNamed:@"unchecked"];

        [self.contentView addSubview:self.checkImageView];
        [self.checkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(4);
            make.right.mas_equalTo(-4);
            make.width.mas_equalTo(25);
            make.height.mas_equalTo(25);
        }];
    }
}

@end

/*************************************************** MSLocalFileVC ***************************************************/
#import "CPActionButton.h"

@interface MSLocalFileVC ()

@property (nonatomic, strong) NSFileManager * fileManager;

@property (nonatomic, strong) NSMutableArray * dataArray;

@property (nonatomic, strong) NSMutableArray <NSIndexPath *> * selectedIndexPaths;


@end

@implementation MSLocalFileVC

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    [self initailizeBaseProperties];
    
    
    // Register cell classes
    [self.collectionView registerClass:[MSLocalFileCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    self.collectionView.backgroundColor = UIColor.whiteColor;
    
    [self loadData];
}

- (void)dealloc {
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.collectionView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - NAV_HEIGHT - 44 - self.tabBarController.tabBar.frame.size.height);
    [self loadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

#pragma mark - Initialized properties
- (void)initailizeBaseProperties {
    self.dataArray = @[].mutableCopy;
    self.selectedIndexPaths = @[].mutableCopy;
    
    self.collectionView.emptyDataSetSource = self;
    self.collectionView.emptyDataSetDelegate = self;
}
#pragma mark - setter && getter method
- (void)setIsInEdit:(BOOL)isInEdit {
    _isInEdit = isInEdit;

    
    if (NO == isInEdit && self.selectedIndexPaths.count > 0) {
        
         __weak typeof(self) weakSelf = self;
        
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        alert.showAnimationType = SCLAlertViewShowAnimationFadeIn;
        
        SCLButton *button = [alert addButton:NSLocalizedString(@"Delete",nil) actionBlock:^{
            [weakSelf deleteSelectLocalFiles];
        }];
        
        button.buttonFormatBlock = ^NSDictionary *{
            return @{@"backgroundColor" : UIColor.redColor};
        };
        
        [alert showWarning:nil subTitle:NSLocalizedString(@"DeleteCorfirm", nil) closeButtonTitle:NSLocalizedString(@"Cancel", nil) duration:0];
    }
    
    [self.collectionView reloadData];
}
- (NSFileManager *)fileManager {
    
    if (nil == _fileManager) {
        _fileManager = [NSFileManager defaultManager];
    }
    
    return _fileManager;
}

#pragma mark - Setup UI
- (void)setupUI {
    
}
#pragma mark - Delegate && dataSource method implement

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"ico_meiyoushuju"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    return [[NSAttributedString alloc] initWithString:@"暂无数据" attributes:nil];
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    [self loadData];
}


#pragma mark - load data
- (void)loadData {
    
    self.dataArray = @[].mutableCopy;

    NSString *directory = [self filePathOf:self.fileType];
    NSError *error = nil;
    NSArray *fileNames = [self.fileManager contentsOfDirectoryAtPath:directory error:&error];

    if (nil == error && fileNames.count > 0) {
        self.dataArray = fileNames.mutableCopy;
    }

    [self.collectionView reloadData];
}


- (void)handleLoadDataBlock:(NSArray *)results {
}

#pragma mark - Private method implement
- (NSString *)filePathOf:(W1MFileType)fileType {
    
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
    
    return directory;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MSLocalFileCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = UIColor.whiteColor;
    
    NSString *fileName = self.dataArray[indexPath.row];
    NSString *path = [self filePathOf:self.fileType];
    path = [path stringByAppendingPathComponent:fileName];
    
#if 1
    if (self.fileType == W1MFileTypePhoto) {
        [cell.iconImageView sd_setImageWithURL:[NSURL fileURLWithPath:path] placeholderImage:[UIImage imageNamed:@"tupian"]];
        
    } else {
        UIImage *image = [[SDImageCache sharedImageCache] imageFromCacheForKey:fileName];
        cell.iconImageView.image = image;
    }
#endif
    
//    cell.iconImageView.image = [UIImage imageNamed:self.dataArray[indexPath.row]];
    
    if (YES == self.isInEdit) {
        cell.checkImageView.hidden = NO;
        if (YES == [self.selectedIndexPaths containsObject:indexPath]) {
            cell.checkImageView.image = [UIImage imageNamed:@"checked"];
        } else {
            cell.checkImageView.image = [UIImage imageNamed:@"unchecked"];
        }
    } else {
        cell.checkImageView.hidden = YES;
    }


    return cell;
}


#pragma mark <UICollectionViewDelegate>

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 8;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(16, 16, 0, 16);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = (SCREENWIDTH - 2 * 16 - 3 * 8) / 4;

    return CGSizeMake(width, width);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s", __FUNCTION__);
    
    if (self.isInEdit == YES) {
        [self.selectedIndexPaths containsObject:indexPath] ? [self.selectedIndexPaths removeObject:indexPath] : [self.selectedIndexPaths addObject:indexPath];
        
        [collectionView reloadData];
        
//        [UIView animateWithDuration:1.0f animations:^{
//            [self.deleteActionButton mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.left.mas_equalTo(0);
//                make.right.mas_equalTo(0);
//                make.bottom.mas_equalTo(0);
//                make.height.mas_equalTo(60);
//            }];
//
//            [self.view layoutIfNeeded];
//
//        } completion:^(BOOL finished) {
//
//        }];

    } else {
        if (W1MFileTypePhoto == self.fileType) {
            [self previewImagesAt:indexPath];
        } else {
            [self showVideoPlay:indexPath];
        }
    }


}

- (void)previewImagesAt:(NSIndexPath *)indexPath {
    
    NSMutableArray *photos = @[].mutableCopy;
    [self.dataArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *filePath = [[self filePathOf:self.fileType] stringByAppendingPathComponent:obj];
        [photos addObject:[IDMPhoto photoWithFilePath:filePath]];
    }];
    
    IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:photos];
    
    [self presentViewController:browser animated:YES completion:nil];
}

- (void)showVideoPlay:(NSIndexPath *)indexPath {
    
    NSString *fileName = self.dataArray[indexPath.row];
    NSString *path = [self filePathOf:self.fileType];
    path = [path stringByAppendingPathComponent:fileName];
    
    SCVideoMainViewController *vc = [[SCVideoMainViewController alloc] initWithURL:path];
    vc.hidesBottomBarWhenPushed = YES;
    
    UIApplication.sharedApplication.keyWindow.rootViewController.hidesBottomBarWhenPushed = YES;
    
    self.navigationController.navigationBarHidden=YES;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)deleteSelectLocalFiles {
    

    [self.selectedIndexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *fileName = [self.dataArray objectAtIndex:obj.row];
        NSString *path = [self filePathOf:self.fileType];
        path = [path stringByAppendingPathComponent:fileName];
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }];
    
    [self.selectedIndexPaths removeAllObjects];

    [self loadData];
}

@end
