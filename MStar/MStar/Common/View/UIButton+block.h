//
//  UIButton+block.h
//  MStar
//
//  Created by 王璋传 on 2019/4/11.
//  Copyright © 2019 王璋传. All rights reserved.
//



NS_ASSUME_NONNULL_BEGIN

@interface UIButton (block)

- (void)buttonAction:(void (^)(void))block;

@end

NS_ASSUME_NONNULL_END
