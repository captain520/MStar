//
//  MSRemoteFileController.h
//  MStar
//
//  Created by 王璋传 on 2019/10/16.
//  Copyright © 2019 王璋传. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MSRemoteFileControllerDelete <NSObject>

- (void)updateWithFileObject:(id)obj;


@end

@interface MSRemoteFileController : NSObject

@end

NS_ASSUME_NONNULL_END
