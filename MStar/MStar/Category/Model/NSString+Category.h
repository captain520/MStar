//
//  NSString+Category.h
//  chelian
//
//  Created by captain on 2017/6/9.
//  Copyright © 2017年 zhizai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface NSString (Category)


/**
 获取富文本的Rect

 @param width 限制的宽度， 高度默认为CGFloatMax
 @param attrDict 富文本属性
 @return CGRect
 */
- (CGRect )getAttributeStrFrameWith:(CGFloat )width attrDic:(NSDictionary *)attrDict;


/**
 获取富文本的Rect

 @param width 限制的宽度， 高度默认为CGFloatMax
 @param font 字符串字体大小
 @param lineSpacing 字符串行间距
 @return CGRect
 */
- (CGRect )getAttributeStrFrameWith:(CGFloat )width font:(UIFont *)font lineSpace:(CGFloat )lineSpacing;

/**
 获取富文本的Rect

 @param width 限制的宽度， 高度默认为CGFloatMax
 @param font 字符串字体大小
 @return CGRect
 */
- (CGRect )getAttributeStrFrameWith:(CGFloat )width font:(UIFont *)font;

/**
 获取富文本的Rect

 @param width 限制的宽度， 高度默认为CGFloatMax
 @return CGRect
 */
- (CGRect )getAttributeStrFrameWith:(CGFloat )width;

/**
 获取富文本的Rect

 @return CGRect
 */
- (CGRect )getAttributeStrFrame4Default;

//  文本是否包含表情
- (BOOL)containsEmoji;

@end
