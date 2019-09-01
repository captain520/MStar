//
//  UIView+CPToast.h
//  CPSpace
//
//  Created by 王璋传 on 2019/8/30.
//  Copyright © 2019 王璋传. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (CPToast)

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

- (void)cp_showToast;
- (void)cp_hideToast;

@end

NS_ASSUME_NONNULL_END
