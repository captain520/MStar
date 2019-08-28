//
//  CPUtil.m
//  MStar
//
//  Created by 王璋传 on 2019/8/28.
//  Copyright © 2019 王璋传. All rights reserved.
//

#import "CPUtil.h"

@implementation CPUtil

NSString *cp_getWifiName2222(void) {
    
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        
        if (info && [info count]) { break; }
    }
    
    NSString *wifiName = nil;
    
    NSDictionary *networkInfo = (NSDictionary*)info;
    
    wifiName = [networkInfo objectForKey:(__bridge NSString*)kCNNetworkInfoKeySSID];
    
    return wifiName;
}

@end
