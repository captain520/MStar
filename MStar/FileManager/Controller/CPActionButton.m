//
//  CPActionButton.m
//  CPSpace
//
//  Created by 王璋传 on 2019/4/1.
//  Copyright © 2019 王璋传. All rights reserved.
//

#import "CPActionButton.h"

@implementation CPActionButton

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initializedBaseProperties];
    }
    
    return self;
}

- (void)initializedBaseProperties {
    self.layer.cornerRadius = 5.0f;
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor colorWithRed:3./255 green:169./255 blue:244./255 alpha:1];
    self.titleLabel.textColor = UIColor.whiteColor;
    self.titleLabel.font = [UIFont systemFontOfSize:15];
}

@end
