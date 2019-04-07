//
//  UIButton+Extension.m
//  fatereason
//
//  Created by leon on 15/6/7.
//  Copyright (c) 2015年 mingrikongjian002. All rights reserved.
//

#import "UIButton+Extension.h"

@implementation UIButton (Extension)

+ (instancetype)buttonWithframe:(CGRect)frame bgNorImg:(UIImage *)norimg bgHighImg:(UIImage *)selimg superView:(UIView *)superView tag:(int)tag
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.tag = tag + 100;
    [button setBackgroundImage:norimg forState:UIControlStateNormal];
    [button setBackgroundImage:selimg forState:UIControlStateHighlighted];
    [button setBackgroundImage:selimg forState:UIControlStateSelected];
    button.exclusiveTouch = YES;
    [superView addSubview:button];
    
    return button;
}

+ (instancetype)button2Withframe:(CGRect)frame bgNorImg:(UIImage *)norimg bgHighImg:(UIImage *)selimg superView:(UIView *)superView tag:(int)tag
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.tag = tag + 100;
    [button setBackgroundImage:norimg forState:UIControlStateNormal];
    [button setBackgroundImage:selimg forState:UIControlStateHighlighted];
    [button setBackgroundImage:norimg forState:UIControlStateSelected];
    button.exclusiveTouch = YES;
    [superView addSubview:button];
    
    return button;
}

+ (instancetype)buttonWithframe:(CGRect)frame norImg:(UIImage *)norimg selImg:(UIImage *)selimg superView:(UIView *)superView tag:(int)tag
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.tag = tag + 100;
//    button.backgroundColor = [UIColor blackColor];
    [button setImage:norimg forState:UIControlStateNormal];
    [button setImage:selimg forState:UIControlStateHighlighted];
    [button setImage:selimg forState:UIControlStateSelected];
    button.exclusiveTouch = YES;
//    button.userInteractionEnabled = YES;
    [superView addSubview:button];
    
    return button;
}

- (void)setTitleFontSize:(CGFloat)fontSize color:(UIColor *)color title:(NSString *)title
{
    self.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateHighlighted];
    
    [self setTitleColor:color forState:UIControlStateNormal];
    [self setTitleColor:color forState:UIControlStateHighlighted];
}

@end
