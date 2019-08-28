//
//  MSAboutUsHeader.m
//  MStar
//
//  Created by 王璋传 on 2019/5/22.
//  Copyright © 2019 王璋传. All rights reserved.
//

#import "MSAboutUsHeader.h"

@implementation MSAboutUsHeader

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    
    self.iconIV = [UIImageView new];
    self.iconIV.image = [UIImage imageNamed:@"mlogo"];
    [self.contentView addSubview:self.iconIV];
    [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(-30);
    }];
    
    
    self.nameLB = [UILabel new];
    self.nameLB.font = [UIFont boldSystemFontOfSize:20];
    self.nameLB.text = @"iCarEyes";
    [self.contentView addSubview:self.nameLB];
    [self.nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self->_iconIV.mas_bottom).offset(10);
    }];
}

@end
