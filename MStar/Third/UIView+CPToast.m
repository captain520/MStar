//
//  UIView+CPToast.m
//  CPSpace
//
//  Created by 王璋传 on 2019/8/30.
//  Copyright © 2019 王璋传. All rights reserved.
//

#import "UIView+CPToast.h"
#import <objc/runtime.h>

@implementation UIView (CPToast)

- (void)cp_showToast {
    
    self.userInteractionEnabled = NO;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 100, 100) cornerRadius:10];
    
    CAShapeLayer *shape = [CAShapeLayer layer];
    shape.path = path.CGPath;
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicatorView.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:.8];
    self.activityIndicatorView.layer.mask = shape;

    [self.activityIndicatorView startAnimating];
    [self addSubview:self.activityIndicatorView];
    [self.activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    
}

- (void)cp_hideToast {
    
    self.userInteractionEnabled = YES;

    if (self.activityIndicatorView.superview != nil) {
        [self.activityIndicatorView removeFromSuperview];
    }
}

#pragma mark - setter && getter metehod
- (void)setActivityIndicatorView:(UIActivityIndicatorView *)activityIndicatorView {
    objc_setAssociatedObject(self, @selector(setActivityIndicatorView:), activityIndicatorView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIActivityIndicatorView *)activityIndicatorView {
    return objc_getAssociatedObject(self, @selector(setActivityIndicatorView:));
}

@end
