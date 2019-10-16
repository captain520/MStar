//
//  MSRemoteFileCell.h
//  MStar
//
//  Created by 王璋传 on 2019/10/16.
//  Copyright © 2019 王璋传. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileVLCKit/MobileVLCKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MSRemoteFileCell : UITableViewCell<VLCMediaThumbnailerDelegate>

@property (strong, nonatomic) UIImageView *iconImageView;

@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *sizeLabel;

@property (nonatomic, strong) AITFileNode  *fileNode;

@end

NS_ASSUME_NONNULL_END
