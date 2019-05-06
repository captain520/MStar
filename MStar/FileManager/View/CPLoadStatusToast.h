//
//  CPLoadStatusToast.h
//  CPSpace
//
//  Created by 王璋传 on 2019/5/5.
//  Copyright © 2019 王璋传. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CPLoadStatusStyle) {
    CPLoadStatusStyleLoading,
    CPLoadStatusStyleLoadingSuccess,
    CPLoadStatusStyleFail,
};

NS_ASSUME_NONNULL_BEGIN

@interface CPLoadStatusToast : UIView

+ (instancetype)shareInstance;

@property (nonatomic, assign) CPLoadStatusStyle style;


/**
 加载状态视图

 @param frame CGRECT 默认为CGRectZero
 @param style CPLoadStatusStyle
 @return CPLoadStatusToast
 */
//- (id)initWithFrame:(CGRect)frame style:(CPLoadStatusStyle)style;


/**
 显示toast
 */
- (void)show;


/**
 移除toast
 */
- (void)dimiss;

@end

NS_ASSUME_NONNULL_END
