//
//  UILabel+Extension.h
//  fatereason
//
//  Created by leon on 15/6/7.
//  Copyright (c) 2015年 mingrikongjian002. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Extension)

+ (instancetype)labelWithframe:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textcolor font:(UIFont *)font backgroundColor:(UIColor *)backgroundColor textAlignment:(NSTextAlignment)textAlignment superView:(UIView *)superView tag:(int)tag;

//- (NSMutableAttributedString *)drawWithString:(NSString *)str textarr:(NSArray *)textarr;

@end
