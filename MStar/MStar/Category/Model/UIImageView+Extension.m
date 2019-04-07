//
//  UIImageView+Extension.m
//  fatereason
//
//  Created by leon on 15/6/7.
//  Copyright (c) 2015年 mingrikongjian002. All rights reserved.
//

#import "UIImageView+Extension.h"

@implementation UIImageView (Extension)

+ (instancetype)imageViewWithframe:(CGRect)frame image:(UIImage *)image superView:(UIView *)superView tag:(int)tag
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image = image;
    imageView.tag = tag;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.backgroundColor = [UIColor clearColor];
    [superView addSubview:imageView];
    
    return imageView;
}

+ (instancetype)imageViewWithframe:(CGRect)frame image:(UIImage *)image superView:(UIView *)superView tag:(int)tag contentMode:(UIViewContentMode)contentMode;
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image = image;
    imageView.tag = tag;
    imageView.contentMode = contentMode;
    imageView.clipsToBounds = YES;
    imageView.backgroundColor = [UIColor clearColor];
    [superView addSubview:imageView];
    
    return imageView;
}

+ (instancetype)imageViewAspectFitWithframe:(CGRect)frame image:(UIImage *)image superView:(UIView *)superView tag:(int)tag
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image = image;
    imageView.tag = tag;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.clipsToBounds = YES;
    imageView.backgroundColor = [UIColor clearColor];
    [superView addSubview:imageView];
    
    return imageView;
}

+ (instancetype)imageViewScaleToFillWithframe:(CGRect)frame image:(UIImage *)image superView:(UIView *)superView tag:(int)tag
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image = image;
    imageView.tag = tag;
    imageView.contentMode = UIViewContentModeScaleToFill;
    imageView.clipsToBounds = YES;
    imageView.backgroundColor = [UIColor clearColor];
    [superView addSubview:imageView];
    
    return imageView;
}
@end
