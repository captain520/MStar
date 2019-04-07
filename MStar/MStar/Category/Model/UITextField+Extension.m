//
//  UITextField+Extension.m
//  constellation
//
//  Created by mingrikongjian002 on 16/7/28.
//  Copyright © 2016年 mingrikongjian002. All rights reserved.
//

#import "UITextField+Extension.h"
@implementation UITextField (Extension)
+ (instancetype)textFieldWithframe:(CGRect)frame textColor:(UIColor *)textcolor font:(UIFont *)font backgroundColor:(UIColor *)backgroundColor textAlignment:(NSTextAlignment)textAlignment returnKeyType:(UIReturnKeyType)returnKeyType clearButtonMode:(UITextFieldViewMode)clearButtonMode attributedPlaceholder:(NSString *)attributedPlaceholder holderColor:(UIColor *)holderColor superView:(UIView *)superView tag:(int)tag
{
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.backgroundColor = backgroundColor;
    textField.textColor = textcolor;
    textField.font = font;
    textField.textAlignment = textAlignment;
    textField.returnKeyType = returnKeyType;
    textField.clearButtonMode = clearButtonMode;
    if (holderColor != nil) {
         textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:attributedPlaceholder attributes:@{NSForegroundColorAttributeName:holderColor}];
    }else{
         textField.placeholder = attributedPlaceholder;
    }
   
    [superView addSubview:textField];

    return textField;
}
@end
