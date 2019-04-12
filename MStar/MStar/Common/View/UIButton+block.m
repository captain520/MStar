//
//  UIButton+block.m
//  MStar
//
//  Created by 王璋传 on 2019/4/11.
//  Copyright © 2019 王璋传. All rights reserved.
//

#import "UIButton+block.h"
#import <objc/runtime.h>

@implementation UIButton (block)

- (void)buttonAction:(void (^)(void))block {
    objc_setAssociatedObject(self,@selector(buttonAction:), block, OBJC_ASSOCIATION_COPY);
    
    [self addTarget:self action:@selector(buttionClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttionClick:(UIButton *)sender {
    void (^block)(void) = objc_getAssociatedObject(self, @selector(buttonAction:));
    !block ? : block();
}

@end
