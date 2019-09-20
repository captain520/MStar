//
//  CPDownloadActionSheet.m
//  CPSpace
//
//  Created by 王璋传 on 2019/5/5.
//  Copyright © 2019 王璋传. All rights reserved.
//

#import "CPDownloadActionSheet.h"

@interface CPDownloadActionSheet ()

@property (nonatomic, strong) UIButton * cancelItem;

@property (nonatomic, strong) UIProgressView * progressView;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) UILabel * percentLabel;


@end

@implementation CPDownloadActionSheet

+ (instancetype)manager {
    
    static CPDownloadActionSheet *obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [CPDownloadActionSheet new];
    });
    
    return obj;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initailizeBaseProperties];
    }
    
    return self;
}

#pragma mark - Initialized properties
- (void)initailizeBaseProperties {
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.5f];
}
#pragma mark - setter && getter method

- (void)setPercent:(CGFloat)percent {
    _percent = percent;
    
    self.shapeLayer.strokeEnd = percent;
    self.percentLabel.text = [NSString stringWithFormat:@"%.2f%%",percent * 100];
}

#pragma mark - Setup UI
- (void)setupUI {
    
    if (nil == self.cancelItem) {
        self.cancelItem = [UIButton new];
        self.cancelItem.backgroundColor = UIColor.whiteColor;
        self.cancelItem.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.cancelItem setTitleEdgeInsets:UIEdgeInsetsMake(-UIApplication.sharedApplication.statusBarFrame.size.height + 20, 0, 0, 0)];
        [self.cancelItem setTitle:NSLocalizedString(@"Cancel", nil)  forState:UIControlStateNormal];
        [self.cancelItem addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.cancelItem setTitleColor:UIColor.redColor forState:UIControlStateNormal];

        [self addSubview:self.cancelItem];
        [self.cancelItem mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(44 + UIApplication.sharedApplication.statusBarFrame.size.height - 20);
        }];
    }
    
    UIView *bgView = [UIView new];
    bgView.backgroundColor = UIColor.whiteColor;
    
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.cancelItem.mas_top).offset(-.5);
        make.height.mas_equalTo(44 * 4);
    }];
    
    {
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(44, 44) radius:44 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = path.CGPath;
        shapeLayer.lineWidth = 5;
        shapeLayer.strokeColor = UIColor.lightGrayColor.CGColor;
        shapeLayer.fillColor = UIColor.clearColor.CGColor;
        shapeLayer.frame = CGRectMake(UIScreen.mainScreen.bounds.size.width/2 - 44, 44, 2 * 44, 2 * 44);
        
        [bgView.layer insertSublayer:shapeLayer atIndex:0];
    }
    
    {
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(44, 44) radius:44 startAngle:-M_PI_2 endAngle:3 * M_PI / 2 clockwise:YES];
        
        self.shapeLayer = [CAShapeLayer layer];
        self.shapeLayer.path = path.CGPath;
        self.shapeLayer.lineWidth = 5;
        self.shapeLayer.strokeColor = UIColor.blackColor.CGColor;
        self.shapeLayer.fillColor = UIColor.clearColor.CGColor;
        self.shapeLayer.frame = CGRectMake(UIScreen.mainScreen.bounds.size.width/2 - 44, 44, 2 * 44, 2 * 44);
        self.shapeLayer.strokeStart = 0;
        self.shapeLayer.strokeEnd = 0;
        
//        [bgView.layer insertSublayer:shapeLayer atIndex:1];
        [bgView.layer addSublayer:self.shapeLayer];
    }
    
    if (nil == self.percentLabel) {
        self.percentLabel = [UILabel new];
        self.percentLabel.text  = @"0.00%";
        self.percentLabel.font = [UIFont systemFontOfSize:11];

        [bgView addSubview:self.percentLabel];
        [self.percentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.centerY.mas_equalTo(0);
        }];
    }
}
#pragma mark - Delegate && dataSource method implement

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self dimiss];
}
#pragma mark - load data
- (void)loadData {
    
}
- (void)handleLoadDataBlock:(NSArray *)results {
}

#pragma mark - Private method implement

- (void)show {
    
    self.hidden = NO;

    if (self.superview == nil) {
        [self setupUI];
        
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
    }
    
}

- (void)dimiss {

    self.hidden = YES;
    self.percent = 0;
//    if (nil != self.superview) {
//        [self removeFromSuperview];
//    }
}

- (void)cancelAction:(id)sender {
    
    !self.cancelActionBlock ? : self.cancelActionBlock();
    
    [self dimiss];
}

@end
