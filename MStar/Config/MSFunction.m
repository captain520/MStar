//
//  MSFunction.m
//  MStar
//
//  Created by 王璋传 on 2019/4/7.
//  Copyright © 2019 王璋传. All rights reserved.
//

#import "MSFunction.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
#import <SystemConfiguration/CaptiveNetwork.h>

@implementation MSFunction

NSString *cp_getWifiName(void) {

    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info && [info count]) { break; }
    }
    
    return [info objectForKey:(__bridge NSString*)kCNNetworkInfoKeySSID];
}

@end
