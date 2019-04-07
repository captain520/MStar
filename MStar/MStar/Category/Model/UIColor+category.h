//
//  UIColor+category.h
//  chelian
//
//  Created by captain on 2017/8/4.
//  Copyright © 2017年 zhizai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (category)
// 颜色转换：iOS中（以#开头）十六进制的颜色转换为UIColor(RGB)
+ (UIColor *) colorWithHexString: (NSString *)color;

@end
