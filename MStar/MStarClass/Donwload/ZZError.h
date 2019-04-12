//
//  YXFError.h
//  KangKeSi
//
//  Created by hujianxiang on 15/7/1.
//  Copyright (c) 2015年 yinxiufeng. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 app 接口请求错误对象 包括两个部分一个是对iOS NSError 错误总结 另外是服务器报错的msg字段
 */
@interface ZZError : NSObject

@property(nonatomic,strong)NSString *message;

@property(nonatomic,assign)NSInteger code;

@end
