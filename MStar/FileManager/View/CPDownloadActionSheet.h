//
//  CPDownloadActionSheet.h
//  CPSpace
//
//  Created by 王璋传 on 2019/5/5.
//  Copyright © 2019 王璋传. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CPDownloadActionSheet : UIView

+ (instancetype)manager;

/**
 取消回调block
 */
@property (nonatomic, copy) void (^cancelActionBlock)(void);



/**
 进度百分比 0~1，显示需要X100+ %%
 */
@property (nonatomic, assign) CGFloat percent;  //  0~1

/**
 加载视图
 */
- (void)show;

/**
 移除视图
 */
- (void)dimiss;

@end

NS_ASSUME_NONNULL_END
