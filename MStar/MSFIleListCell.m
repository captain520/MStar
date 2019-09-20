//
//  MSFIleListCell.m
//  MStar
//
//  Created by 王璋传 on 2019/3/7.
//  Copyright © 2019 王璋传. All rights reserved.
//

#import "MSFIleListCell.h"
#import <SDWebImage.h>

#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVAssetImageGenerator.h>
#import <AVFoundation/AVAsset.h>

@implementation MSFIleListCell {
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setUrl:(NSURL *)url {
    _url = url;
    
    UIImage *image = [[SDImageCache sharedImageCache] imageFromCacheForKey:url.lastPathComponent];
    if (nil == image) {
//        VLCMedia *media = [VLCMedia mediaWithURL:url];
//        VLCMediaThumbnailer *thumber = [VLCMediaThumbnailer thumbnailerWithMedia:media andDelegate:self];
//        [thumber fetchThumbnail];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

            NSLock *lock = [[NSLock alloc] init];
            [lock lock];
            
            VLCMedia *media = [VLCMedia mediaWithURL:url];
            VLCMediaThumbnailer *thumber = [VLCMediaThumbnailer thumbnailerWithMedia:media andDelegate:self];
            [thumber fetchThumbnail];
//            NSLock *lock = [[NSLock alloc] init];
//            [lock lock];
//            [self thumbnailImageForVideo:url atTime:0];
            [lock unlock];
        });
    } else {
        self.iconImageView.image = image;
    }
}

- (void)mediaThumbnailerDidTimeOut:(VLCMediaThumbnailer *)mediaThumbnailer {
    NSLog(@"%@",mediaThumbnailer);
}

- (void)mediaThumbnailer:(VLCMediaThumbnailer *)mediaThumbnailer didFinishThumbnail:(CGImageRef)thumbnail {
    [self.url lastPathComponent];
    UIImage *image = [UIImage imageWithCGImage:thumbnail];
    [[SDImageCache sharedImageCache] storeImage:image forKey:mediaThumbnailer.media.url.lastPathComponent completion:^{
        self.iconImageView.image = [UIImage imageWithCGImage:thumbnail];
    }];
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
        
        [[SDImageCache sharedImageCache] storeImage:thumbnailImage forKey:self.url.absoluteString.lastPathComponent completion:^{
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.iconImageView.image = thumbnailImage;
        });
    }
    
    return thumbnailImage;
}

@end
