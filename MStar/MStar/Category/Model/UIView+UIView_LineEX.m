//
//  UIView+UIView_LineEX.m
//  constellation
//
//  Created by mingrikongjian002 on 16/7/28.
//  Copyright © 2016年 mingrikongjian002. All rights reserved.
//

#import "UIView+UIView_LineEX.h"

@implementation UIView (UIView_LineEX)
+ (instancetype)lineViewWithframe:(CGRect)frame backgroundColor:(UIColor *)backgroundColor superView:(UIView *)superView tag:(int)tag
{
    UIView *lineView = [[UIView alloc] initWithFrame:frame];
    lineView.tag = tag;
    lineView.backgroundColor = backgroundColor;
    [superView addSubview:lineView];
    
    return lineView;
}

- (void)setEXx:(CGFloat)EXx
{
    CGRect frame = self.frame;
    frame.origin.x = EXx;
    self.frame = frame;
}

- (void)setEXy:(CGFloat)EXy
{
    CGRect frame = self.frame;
    frame.origin.y = EXy;
    self.frame = frame;
}

- (CGFloat)EXx
{
    return self.frame.origin.x;
}

- (CGFloat)EXy
{
    return self.frame.origin.y;
}

- (void)setEXcenterX:(CGFloat)EXcenterX
{
    CGPoint center = self.center;
    center.x = EXcenterX;
    self.center = center;
}

- (CGFloat)EXcenterX
{
    return self.center.x;
}

- (void)setEXCenterY:(CGFloat)EXcenterY
{
    CGPoint center = self.center;
    center.y = EXcenterY;
    self.center = center;
}

- (CGFloat)EXcenterY
{
    return self.center.y;
}

- (void)setEXWidth:(CGFloat)EXwidth
{
    CGRect frame = self.frame;
    frame.size.width = EXwidth;
    self.frame = frame;
}

- (void)setEXHeight:(CGFloat)EXheight
{
    CGRect frame = self.frame;
    frame.size.height = EXheight;
    self.frame = frame;
}

- (CGFloat)EXheight
{
    return self.frame.size.height;
}

- (CGFloat)EXwidth
{
    return self.frame.size.width;
}

- (void)setEXSize:(CGSize)EXsize
{
    CGRect frame = self.frame;
    frame.size = EXsize;
    self.frame = frame;
}

- (CGSize)EXsize
{
    return self.frame.size;
}

- (void)setEXOrigin:(CGPoint)EXorigin
{
    CGRect frame = self.frame;
    frame.origin = EXorigin;
    self.frame = frame;
}

- (CGPoint)EXorigin
{
    return self.frame.origin;
}

- (void)setEXMinX:(CGFloat)EXminX{
    CGRect frame = self.frame;
    frame.origin.x = EXminX;
    self.frame = frame;
}

- (CGFloat)EXminX{
    return CGRectGetMinX(self.frame);
}

- (void)setEXMinY:(CGFloat)EXminY{
    CGRect frame = self.frame;
    frame.origin.y = EXminY;
    self.frame = frame;
}

- (CGFloat)EXminY{
    return CGRectGetMinY(self.frame);
}

- (void)setEXMaxX:(CGFloat)EXmaxX{
    self.EXmaxX = self.EXx +self.EXwidth;
}

- (CGFloat)maxEXX{
    return CGRectGetMaxX(self.frame);
}

- (void)setEXMaxY:(CGFloat)EXmaxY{
    self.EXmaxY = self.EXy + self.EXheight;
}

- (CGFloat)EXmaxY{
    return CGRectGetMaxY(self.frame);
}
@end
