//
//  UIImageView+Extension.h
//  fatereason
//
//  Created by leon on 15/6/7.
//  Copyright (c) 2015年 mingrikongjian002. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Extension)

+ (instancetype)imageViewWithframe:(CGRect)frame image:(UIImage *)image superView:(UIView *)superView tag:(int)tag;
+ (instancetype)imageViewWithframe:(CGRect)frame image:(UIImage *)image superView:(UIView *)superView tag:(int)tag contentMode:(UIViewContentMode)contentMode;
+ (instancetype)imageViewScaleToFillWithframe:(CGRect)frame image:(UIImage *)image superView:(UIView *)superView tag:(int)tag;
+ (instancetype)imageViewAspectFitWithframe:(CGRect)frame image:(UIImage *)image superView:(UIView *)superView tag:(int)tag;
@end
