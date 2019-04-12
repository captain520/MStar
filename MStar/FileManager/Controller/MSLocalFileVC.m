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

@interface MSLocalFileVC ()

@property (nonatomic, strong) NSFileManager * fileManager;

@property (nonatomic, strong) NSMutableArray * dataArray;

@property (nonatomic, strong) NSMutableArray * selectedIndexPaths;

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

#pragma mark - Initialized properties
- (void)initailizeBaseProperties {
    self.dataArray = @[].mutableCopy;
    self.selectedIndexPaths = @[].mutableCopy;
    
    self.collectionView.emptyDataSetSource = self;
    self.collectionView.emptyDataSetDelegate = self;
}
#pragma mark - setter && getter method
//- (void)setIsInEdit:(BOOL)isInEdit {
//    _isInEdit = isInEdit;
//
//    [self.collectionView reloadData];
//}
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


#pragma mark - load data
- (void)loadData {
    
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
    
    if (self.fileType == W1MFileTypePhoto) {
        [cell.iconImageView sd_setImageWithURL:[NSURL fileURLWithPath:path] placeholderImage:[UIImage imageNamed:@"tupian"]];

    } else {
        UIImage *image = [[SDImageCache sharedImageCache] imageFromCacheForKey:fileName];
        cell.iconImageView.image = image;
    }
    
    if (YES == self.isInEdit) {
        cell.checkImageView.hidden = NO;
        cell.checkImageView.image = [UIImage imageNamed:[self.selectedIndexPaths containsObject:indexPath] ? @"checked" : @"unchecked"];
    } else {
        cell.checkImageView.hidden = YES;
    }

    // Configure the cell
    
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

@end
