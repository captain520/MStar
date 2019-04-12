//
//  MSSDFileLIstVC.h
//  MStar
//
//  Created by 王璋传 on 2019/3/7.
//  Copyright © 2019 王璋传. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPRefreshVC.h"

@interface MSSDFileLIstVC : CPRefreshVC

@property (nonatomic, assign) BOOL isLocalFileList;

@property (nonatomic, assign) W1MFileType fileType;

@property (nonatomic, assign) BOOL isRear;

- (void)refreshAllData;

@end
