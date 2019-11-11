//
//  MSRemoteFileVC.h
//  MStar
//
//  Created by 王璋传 on 2019/10/16.
//  Copyright © 2019 王璋传. All rights reserved.
//

#import "MSBaesTableVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface MSRemoteFileVC : MSBaesTableVC

@property (nonatomic, assign) W1MFileType fileType;

@property (nonatomic, assign) BOOL isRear;

- (void)refreshAllData;

- (void)switchCamAction;

@end

NS_ASSUME_NONNULL_END
