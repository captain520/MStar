//
//  MSCamMenuManager.h
//  MStar
//
//  Created by 王璋传 on 2019/4/7.
//  Copyright © 2019 王璋传. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AITCamMenu.h"

NS_ASSUME_NONNULL_BEGIN

@interface MSCamMenuManager : NSObject

+ (instancetype)manager;

- (void) LoadCamMenuXMLDoc:(NSString*)xmldoc;

@property (nonatomic, strong) AITCamMenu *cammenu;
@property (nonatomic, strong) AITCamMenu *curmenu;

@end

NS_ASSUME_NONNULL_END
