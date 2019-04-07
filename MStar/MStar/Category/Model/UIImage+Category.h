//
//  UIImage+Category.h
//  chat
//
//  Created by yinxiufeng on 15/5/23.
//  Copyright (c) 2015年 yinxiufeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Category)


+(instancetype)stretchableImage:(NSString *)imageName;

- (UIImage*)imageRotatedByDegrees:(CGFloat)degrees;

+ (UIImage *)imageWithColor:(UIColor *)color;

+ (UIImage *)imageWithColor:(UIColor *)color CGSize:(CGSize)size;

- (UIImage *)roundedCornerImageWithCornerRadius:(CGFloat)cornerRadius;
@end
