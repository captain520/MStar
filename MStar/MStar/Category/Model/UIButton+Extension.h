//
//  UIButton+Extension.h
//  fatereason
//
//  Created by leon on 15/6/7.
//  Copyright (c) 2015年 mingrikongjian002. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Extension)

+ (instancetype)buttonWithframe:(CGRect)frame bgNorImg:(UIImage *)norimg bgHighImg:(UIImage *)selimg superView:(UIView *)superView tag:(int)tag;

+ (instancetype)button2Withframe:(CGRect)frame bgNorImg:(UIImage *)norimg bgHighImg:(UIImage *)selimg superView:(UIView *)superView tag:(int)tag;

+ (instancetype)buttonWithframe:(CGRect)frame norImg:(UIImage *)norimg selImg:(UIImage *)selimg superView:(UIView *)superView tag:(int)tag;

- (void)setTitleFontSize:(CGFloat)fontSize color:(UIColor *)color title:(NSString *)title;

@end
