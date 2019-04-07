//
//  NSString+Category.m
//  chelian
//
//  Created by captain on 2017/6/9.
//  Copyright © 2017年 zhizai. All rights reserved.
//

#import "NSString+Category.h"

@implementation NSString (Category)

- (CGRect )getAttributeStrFrameWith:(CGFloat )width attrDic:(NSDictionary *)attrDict {
     return  [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrDict context:nil];
}

- (CGRect )getAttributeStrFrameWith:(CGFloat )width font:(UIFont *)font lineSpace:(CGFloat )lineSpacing {
    
    NSMutableDictionary *attrDict = @{}.mutableCopy;
    
    
    NSMutableParagraphStyle *pstyle = [NSMutableParagraphStyle new];
    [pstyle setParagraphStyle:[NSParagraphStyle defaultParagraphStyle]];
    pstyle.lineSpacing = lineSpacing;
    
    [attrDict setValue:pstyle forKey:NSParagraphStyleAttributeName];
    
    
    if (!font) {
        font = [UIFont systemFontOfSize:17.0f];
    }
    
    [attrDict setValue:font forKey:NSFontAttributeName];
    
    return [self getAttributeStrFrameWith:width attrDic:attrDict];
}

- (CGRect )getAttributeStrFrameWith:(CGFloat )width font:(UIFont *)font {
    return [self getAttributeStrFrameWith:width font:font lineSpace:5.0f];
}

- (CGRect )getAttributeStrFrameWith:(CGFloat )width {
    return [self getAttributeStrFrameWith:width font:[UIFont systemFontOfSize:15.0f]];
}

- (CGRect )getAttributeStrFrame4Default {
    return [self getAttributeStrFrameWith:(UIScreen.mainScreen.bounds.size.width - 16.0f/*左边距*/ - 16.0f/*右边距*/)];
}

// 过滤所有表情
- (BOOL)containsEmoji {
    
//    if ([self isNineKeyBoard:self]) {
//        return NO;
//    }

    __block BOOL returnValue = NO;
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }
             
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
         }
     }];
    
    return returnValue;
}

/**
 判断是不是九宫格
 @param string  输入的字符
 @return YES(是九宫格拼音键盘)
 */
-(BOOL)isNineKeyBoard:(NSString *)string
{
    NSString *other = @"➋➌➍➎➏➐➑➒";
    int len = (int)string.length;
    for(int i=0;i<len;i++)
    {
        if(!([other rangeOfString:string].location != NSNotFound))
            return NO;
    }
    return YES;
}

@end
