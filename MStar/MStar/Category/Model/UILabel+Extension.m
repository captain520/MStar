//
//  UILabel+Extension.m
//  fatereason
//
//  Created by leon on 15/6/7.
//  Copyright (c) 2015年 mingrikongjian002. All rights reserved.
//

#import "UILabel+Extension.h"
//#import "UtilityObject.h"
//#import "DrawTextAttributeModel.h"
@implementation UILabel (Extension)

+ (instancetype)labelWithframe:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textcolor font:(UIFont *)font backgroundColor:(UIColor *)backgroundColor textAlignment:(NSTextAlignment)textAlignment superView:(UIView *)superView tag:(int)tag
{
    UILabel *Label = [[UILabel alloc] initWithFrame:frame];
    Label.userInteractionEnabled= YES;
    Label.tag = tag;
    Label.text = text;
    Label.textColor = textcolor;
    Label.textAlignment = textAlignment;
    Label.font = font;
    Label.backgroundColor = backgroundColor;
    [superView addSubview:Label];
    
    return Label;
}

//- (NSMutableAttributedString *)drawWithString:(NSString *)str textarr:(NSArray *)textarr
//{
//    NSArray *arr = [[UtilityObject emojiStringArray] autorelease];
//
////    if (![UtilityObject isBlankString:str]) {
//        NSMutableString *mulstr =[[NSMutableString alloc] initWithString:str];
//        
//        
//        NSString *markL       = @"f";
//        
//        NSString *string      = [NSString stringWithString:mulstr];
//        NSMutableArray *array = [[NSMutableArray alloc] init];
//        NSMutableArray *stack = [[NSMutableArray alloc] init];
//        
//        int i = 0;
//        while (string.length)
//        {
//            NSString *s = [string substringWithRange:NSMakeRange(0, 1)];
//            string = [string substringFromIndex:1];
//            
//            if (([s isEqualToString:markL]) || ((stack.count > 0) && [stack[0] isEqualToString:markL]))
//            {
//                if (([s isEqualToString:markL]) && ((stack.count > 0) && [stack[0] isEqualToString:markL]))
//                {
//                    [stack removeAllObjects];
//                }
//                
//                [stack addObject:s];
//                
//                if (stack.count == 4)
//                {
//                    NSMutableString *emojiStr = [[NSMutableString alloc] init];
//                    for (NSString *c in stack)
//                    {
//                        [emojiStr appendString:c];
//                    }
//                    
//                    if ([arr containsObject:emojiStr])
//                    {
//                        NSRange range = NSMakeRange(i + 1 - emojiStr.length, emojiStr.length);
//                        
//                        [mulstr replaceCharactersInRange:range withString:@"&"];
//                        
//                        NSString *location = [NSString stringWithFormat:@"%d",i + 1 - emojiStr.length];
//                        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//                        [dic setValue:emojiStr forKey:@"wwwwww"];
//                        [dic setValue:location forKey:@"location"];
//                        [array addObject:dic];
//                        i -= emojiStr.length-1;
//                    }
//                    
//                    [stack removeAllObjects];
//                }
//            }
//            i++;
//        }
//        
//        str = [NSString stringWithFormat:@"%@",mulstr];
//        str = [str stringByReplacingOccurrencesOfString:@"&" withString:@""];
//        self.text = str;
//        
//        NSMutableAttributedString * mutStr = [[NSMutableAttributedString alloc] initWithString:str];
//        
//        if (![UtilityObject isBlankArray:textarr]) {
//            for (int i = 0; i < textarr.count; i ++) {
//                NSRange userrange = [str rangeOfString:((DrawTextAttributeModel *)textarr[i]).text];
//                [mutStr addAttribute:NSFontAttributeName value:((DrawTextAttributeModel *)textarr[i]).textfont range:userrange];
//                [mutStr addAttribute:NSForegroundColorAttributeName value:((DrawTextAttributeModel *)textarr[i]).textcolor range:userrange];
//            }
//        }
//        
//        if (![UtilityObject isBlankArray:array]) {
//            for (int i = 0; i < array.count; i ++) {
//                
//                //添加表情
//                UIImage * image1 = [UIImage imageNamed:array[i][@"wwwwww"]];
//                NSTextAttachment * attachment1 = [[NSTextAttachment alloc] init];
//                attachment1.bounds = CGRectMake(0, -2, self.font.ascender, self.font.ascender);
//                attachment1.image = image1;
//                NSAttributedString * attachStr1 = [NSAttributedString attributedStringWithAttachment:attachment1];
//                [mutStr insertAttributedString:attachStr1 atIndex:[array[i][@"location"] integerValue]];
//                
//            }
//            
//        }
//        
//        
//        return [mutStr copy];
////    }else{
////        return nil;
////    }
//
//}



@end
