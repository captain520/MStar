//
//  CPLoadStatusToast.m
//  CPSpace
//
//  Created by 王璋传 on 2019/5/5.
//  Copyright © 2019 王璋传. All rights reserved.
//

#import "CPLoadStatusToast.h"

@interface CPLoadStatusToast ()<CAAnimationDelegate>

@end

@implementation CPLoadStatusToast

+ (instancetype)shareInstance {
    static CPLoadStatusToast *obj = nil;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        obj = [CPLoadStatusToast new];
    });
    
    return obj;
}

- (id)initWithFrame:(CGRect)frame style:(CPLoadStatusStyle)style {
    if (self = [super initWithFrame:frame]) {
        self.style = style;
    }
    
    return self;
}

- (void)setStyle:(CPLoadStatusStyle)style {
    _style = style;
}

- (void)setupUI {
    
    //  设置灯箱效果
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.5];
//    self.backgroundColor = [UIColor clearColor];
//    self.backgroundColor = UIColor.redColor;

    switch (self.style) {
        case CPLoadStatusStyleLoading:
        {
            [self setupLoadingView];
        }
            break;
        case CPLoadStatusStyleLoadingSuccess:
        {
            [self setupSuccessView];
        }
            break;
        case CPLoadStatusStyleFail:
        {
            [self setupFailView];
        }
            break;
            
        default:
            break;
    }
}

- (void)setupLoadingView {
    
    UIView *bgView = [UIView new];
    bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    bgView.layer.cornerRadius = 10.0f;
    
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(100);
    }];
    
    
    UIActivityIndicatorView *activityIndicatorView = [UIActivityIndicatorView new];
    activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [activityIndicatorView startAnimating];

    [bgView addSubview:activityIndicatorView];
    [activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];

}

- (void)setupSuccessView {

//    self.backgroundColor = UIColor.clearColor;

    UIView *bgView = [UIView new];
    bgView.backgroundColor = UIColor.blackColor;
    bgView.layer.cornerRadius = 10.0f;

    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(100);
    }];
    
    UIView *bgInnerView = [UIView new];
    bgInnerView.backgroundColor = UIColor.blackColor;
    bgInnerView.layer.cornerRadius = 5.0f;
    
    [bgView addSubview:bgInnerView];
    [bgInnerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(60);
    }];
    
    CGFloat r = 30;
    CGFloat scale = r/50;

    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(r, r) radius:r startAngle:-M_PI endAngle:M_PI clockwise:YES];
    [path moveToPoint:CGPointMake(9.81 * 2 * scale, 23.71 * 2 * scale)];
    [path addLineToPoint:CGPointMake(21.6 * 2 * scale, 35.5 * 2 * scale)];
    [path addLineToPoint:CGPointMake(40.79 * 2 * scale, 16.31 * 2 * scale)];

    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.lineWidth = 3;
    shapeLayer.strokeColor = UIColor.whiteColor.CGColor;
    shapeLayer.fillColor = UIColor.clearColor.CGColor;
    shapeLayer.frame = self.bounds;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.lineCap = kCALineCapRound;

    [bgInnerView.layer addSublayer:shapeLayer];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = .75;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = YES;
    animation.fromValue = @0;
    animation.toValue = @1;
    animation.delegate = self;
    
    [shapeLayer addAnimation:animation forKey:nil];
}

- (void)setupFailView {
    
    UIView *bgView = [UIView new];
    bgView.backgroundColor = UIColor.blackColor;
    bgView.layer.cornerRadius = 10.0f;
    
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(100);
    }];
    
    UIView *bgInnerView = [UIView new];
    bgInnerView.backgroundColor = UIColor.blackColor;
    bgInnerView.layer.cornerRadius = 5.0f;
    
    [bgView addSubview:bgInnerView];
    [bgInnerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(60);
    }];
    
    CGFloat r = 30;
    CGFloat scale = r/30;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(r, r) radius:r startAngle:-M_PI endAngle:M_PI clockwise:YES];
    [path moveToPoint:CGPointMake(16 * scale, 16 * scale)];
    [path addLineToPoint:CGPointMake(45 * scale, 45 * scale)];
    [path moveToPoint:CGPointMake(16 * scale, 45 * scale)];
    [path addLineToPoint:CGPointMake(45 * scale, 16 * scale)];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.lineWidth = 3;
    shapeLayer.strokeColor = UIColor.whiteColor.CGColor;
    shapeLayer.fillColor = UIColor.clearColor.CGColor;
    shapeLayer.frame = self.bounds;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.lineCap = kCALineCapRound;
    
    [bgInnerView.layer addSublayer:shapeLayer];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = .75;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = YES;
    animation.fromValue = @0;
    animation.toValue = @1;
    animation.delegate = self;
    
    [shapeLayer addAnimation:animation forKey:nil];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dimiss];
}

- (void)show {
    
    if (self.superview) {
        [self removeFromSuperview];
    }
    
    if (nil == self.superview) {
        [self setupUI];
        [UIApplication.sharedApplication.keyWindow addSubview:self];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
    }
}

- (void)dimiss {
    
    [UIView animateWithDuration:.75f animations:^{
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - delegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self dimiss];
}

@end
