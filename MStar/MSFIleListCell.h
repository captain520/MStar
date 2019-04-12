//
//  MSFIleListCell.h
//  MStar
//
//  Created by 王璋传 on 2019/3/7.
//  Copyright © 2019 王璋传. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileVLCKit/MobileVLCKit.h>

@interface MSFIleListCell : UITableViewCell<VLCMediaThumbnailerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *downloadBT;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UIButton *donwloadButton;

@property (nonatomic, strong) NSURL *url;

@end
