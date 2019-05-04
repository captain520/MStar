//
//  MSMediaListVC.h
//  MStar
//
//  Created by 王璋传 on 2019/5/4.
//  Copyright © 2019 王璋传. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MSMediaListVC : UITableViewController

@property (nonatomic, assign) W1MFileType fileType;

@property (nonatomic, strong) NSMutableArray * dataArray;

@end

NS_ASSUME_NONNULL_END
