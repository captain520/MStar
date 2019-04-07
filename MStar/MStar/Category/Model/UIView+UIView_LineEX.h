//
//  UIView+UIView_LineEX.h
//  constellation
//
//  Created by mingrikongjian002 on 16/7/28.
//  Copyright © 2016年 mingrikongjian002. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (UIView_LineEX)
+ (instancetype)lineViewWithframe:(CGRect)frame backgroundColor:(UIColor *)backgroundColor superView:(UIView *)superView tag:(int)tag;

@property (nonatomic, assign) CGFloat EXx;
@property (nonatomic, assign) CGFloat EXy;
@property (nonatomic, assign) CGFloat EXcenterX;
@property (nonatomic, assign) CGFloat EXcenterY;
@property (nonatomic, assign) CGFloat EXwidth;
@property (nonatomic, assign) CGFloat EXheight;
@property (nonatomic, assign) CGSize EXsize;
@property (nonatomic, assign) CGPoint EXorigin;
@property (nonatomic, assign) CGFloat EXminX;
@property (nonatomic, assign) CGFloat EXminY;
@property (nonatomic, assign) CGFloat EXmaxX;
@property (nonatomic, assign) CGFloat EXmaxY;
@end
