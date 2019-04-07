//
//  NSStringAdditions.h
//  dianziq
//
//  Created by lai_huanhui on 13-3-23.
//  Copyright (c) 2013年 dianziq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NSStringAdditions)
/**
 *  判断是否包含某个字符串
 */
- (BOOL)containsString:(NSString *)aString;
/**
 * 计算字符串的中文长度
 */
- (int)chineseLength;
/**
 *  计算字符的英文长度
 */
- (int)englishLength;
/**
 *  根据英文长度截取字符串
 */
-(NSString *)substringWithENLeng:(NSInteger)len;

@end


