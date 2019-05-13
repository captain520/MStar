//
//  UIViewController+Category.m
//  MStar
//
//  Created by 王璋传 on 2019/5/10.
//  Copyright © 2019 王璋传. All rights reserved.
//

#import "UIViewController+Category.h"

@implementation UIViewController (Category)

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    return UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskPortrait;
    return UIInterfaceOrientationMaskPortrait;
}

@end
