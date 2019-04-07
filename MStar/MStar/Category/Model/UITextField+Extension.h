//
//  UITextField+Extension.h
//  constellation
//
//  Created by mingrikongjian002 on 16/7/28.
//  Copyright © 2016年 mingrikongjian002. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Extension)
+ (instancetype)textFieldWithframe:(CGRect)frame textColor:(UIColor *)textcolor font:(UIFont *)font backgroundColor:(UIColor *)backgroundColor textAlignment:(NSTextAlignment)textAlignment returnKeyType:(UIReturnKeyType)returnKeyType clearButtonMode:(UITextFieldViewMode)clearButtonMode attributedPlaceholder:(NSString *)attributedPlaceholder holderColor:(UIColor *)holderColor superView:(UIView *)superView tag:(int)tag;
@end
