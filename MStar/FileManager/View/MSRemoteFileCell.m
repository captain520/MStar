//
//  MSRemoteFileCell.m
//  MStar
//
//  Created by 王璋传 on 2019/10/16.
//  Copyright © 2019 王璋传. All rights reserved.
//

#import "MSRemoteFileCell.h"
#import <SDWebImage.h>
#import "AITUtil.h"

@implementation MSRemoteFileCell {
    NSLock *cellLock;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        cellLock = [[NSLock alloc] init];
        
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    
    //  icon
    self.iconImageView = UIImageView.new;
    self.iconImageView.image = [UIImage imageNamed:@"tupian"];
    self.iconImageView.backgroundColor = TestColor;
    
    [self.contentView addSubview:self.iconImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(16);
        make.top.mas_equalTo(8);
        make.bottom.mas_equalTo(-8);
        make.width.mas_equalTo(self->_iconImageView.mas_height).multipliedBy(4./3.);;
    }];
    
    
    //  文件名
    
    self.nameLabel = UILabel.new;
    self.nameLabel.text = @"";
    self.nameLabel.textColor = C33;
    self.nameLabel.font = [UIFont systemFontOfSize:13 RPX];
    
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self->_iconImageView.mas_top);
        make.left.mas_equalTo(self->_iconImageView.mas_right).offset(8);
        make.right.mas_equalTo(-16);
    }];
    
    //  大小
    
    self.sizeLabel = UILabel.new;
    self.sizeLabel.text = @"";
    self.sizeLabel.numberOfLines = 0;
    self.sizeLabel.textColor = C99;
    self.sizeLabel.font = [UIFont systemFontOfSize:11 RPX];
    
    [self.contentView addSubview:self.sizeLabel];
    [self.sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self->_iconImageView.mas_bottom);
        make.left.mas_equalTo(self->_nameLabel.mas_left);
        make.right.mas_equalTo(-16);
    }];
}

- (void)setFileNode:(AITFileNode *)fileNode {
    _fileNode = fileNode;
    
    self.nameLabel.text = fileNode.name.lastPathComponent;
    self.sizeLabel.text = [NSByteCountFormatter stringFromByteCount:fileNode.size countStyle:NSByteCountFormatterCountStyleDecimal];
    
    if ([fileNode.format isEqualToString:@"jpeg"]) {
        
        NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://%@%@", [AITUtil getCameraAddress], [fileNode.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]] ;
        
        [self.iconImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"tupian"]];

        return;
    }

    UIImage *image = [[SDImageCache sharedImageCache] imageFromCacheForKey:fileNode.name.lastPathComponent];
    if (nil == image) {
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//
//            [self->cellLock lock];
//
//            NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://%@%@", [AITUtil getCameraAddress], [fileNode.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]] ;
//            VLCMedia *media = [VLCMedia mediaWithURL:url];
//            VLCMediaThumbnailer *thumber = [VLCMediaThumbnailer thumbnailerWithMedia:media andDelegate:self];
//            [thumber fetchThumbnail];
//        });
    } else {
//        self.iconImageView.image = image;
    }
}

- (void)mediaThumbnailerDidTimeOut:(VLCMediaThumbnailer *)mediaThumbnailer {
    [cellLock unlock];
}

- (void)mediaThumbnailer:(VLCMediaThumbnailer *)mediaThumbnailer didFinishThumbnail:(CGImageRef)thumbnail {
    UIImage *image = [UIImage imageWithCGImage:thumbnail];
    [[SDImageCache sharedImageCache] storeImage:image forKey:mediaThumbnailer.media.url.lastPathComponent completion:^{
        self.iconImageView.image = [UIImage imageWithCGImage:thumbnail];
    }];
    
    [cellLock unlock];
}

@end
