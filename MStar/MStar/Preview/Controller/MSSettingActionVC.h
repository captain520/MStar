//
//  MSSettingActionVC.h
//  MStar
//
//  Created by 王璋传 on 2019/5/4.
//  Copyright © 2019 王璋传. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MSSettingActionVC : UITableViewController

@property (nonatomic, strong) NSMutableArray <AITCamMenu *>* dataArray;

@property (nonatomic, copy) void (^selectedActionBlock)(AITCamMenu *menuItem);

@property (nonatomic, assign) NSInteger selectedIndex;

@end

NS_ASSUME_NONNULL_END
