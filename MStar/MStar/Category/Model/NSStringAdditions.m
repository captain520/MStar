//
//  NSStringAdditions.m
//  dianziq
//
//  Created by lai_huanhui on 13-3-23.
//  Copyright (c) 2013年 dianziq. All rights reserved.
//

#import "NSStringAdditions.h"

@implementation NSString (NSStringAdditions)

- (BOOL)containsString:(NSString *)aString
{
	NSRange range = [[self lowercaseString] rangeOfString:[aString lowercaseString]];
	return range.location != NSNotFound;
}

//计算字符串中文长度
- (int)chineseLength
{
    float len = 0.0;
    
    for (int i = 0; i < [self length]; i++)
    {
        unichar c = [self characterAtIndex:i];
        
        if (c >= 33 && c <= 126)
            len += 0.5;
        else
            len += 1.0;
    }
    
    return (int)ceilf(len);
}

- (int)englishLength
{
    float len = 0.0;
    
    for (int i = 0; i < [self length]; i++)
    {
        unichar c = [self characterAtIndex:i];
        
        if (c >= 33 && c <= 126)
            len += 1.0;
        else
            len += 2.0;
    }
    
    return (int)ceilf(len);
}
-(NSString *)substringWithENLeng:(NSInteger)len{
    float number = 0.0;
    NSMutableString *tempStr = [[NSMutableString alloc]init];
    for (int index = 0; index < [self length]; index++)
    {
        NSString *character = [self substringWithRange:NSMakeRange(index, 1)];
        number += [character englishLength];
        if (number > len) {
            break;
        }else {
            [tempStr appendString:character];
        }
    }
    return tempStr;
}


@end



