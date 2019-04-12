//
//  MSLocalFileVC.h
//  MStar
//
//  Created by 王璋传 on 2019/4/11.
//  Copyright © 2019 王璋传. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIScrollView+EmptyDataSet.h>

NS_ASSUME_NONNULL_BEGIN

@interface MSLocalFileVC : UICollectionViewController<UICollectionViewDelegateFlowLayout,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, assign) W1MFileType fileType;

@property (nonatomic, assign) BOOL isInEdit;

@end


@interface MSLocalFileCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView * iconImageView;

@property (nonatomic, strong) UIImageView * checkImageView;

@end

NS_ASSUME_NONNULL_END
