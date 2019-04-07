//
//  AITUtil.m
//  WiFiCameraViewer
//
//  Created by Clyde on 2013/11/2.
//  Copyright (c) 2013年 a-i-t. All rights reserved.
//

#import "AITUtil.h"
#import <TargetConditionals.h>
#import "Reachability.h"

#include <ifaddrs.h>
#include <arpa/inet.h>

#include <netinet/in.h>
#include <sys/sysctl.h>

#if TARGET_IPHONE_SIMULATOR
#include <net/route.h>
#else
#include "route.h"
#endif

#include <net/if.h>
#include <string.h>



#define CTL_NET         4               /* network, see socket.h */

#define ROUNDUP(a) ((a) > 0 ? (1 + (((a) - 1) | (sizeof(long) - 1))) : sizeof(long))

@implementation AITUtil

+ (NSString *)getCameraAddress
{
    NSString *address = @"error";
    
    in_addr_t addr ;
    //return @"192.168.0.159";
    if ([AITUtil getdefaultgateway:&addr] >= 0) {
        address = [NSString stringWithUTF8String:inet_ntoa(*((struct in_addr*)&addr))];
    }
    return address;
}

+ (int) getdefaultgateway: (in_addr_t *) addr
{
    
#if TARGET_IPHONE_SIMULATOR
#define IF_NAME "en1"
#else
#define IF_NAME "en0"
#endif

    int mib[] = {CTL_NET, PF_ROUTE, 0, AF_INET,
        NET_RT_FLAGS, RTF_GATEWAY};
    size_t l;
    char * buf, * p;
    struct rt_msghdr * rt;
    struct sockaddr * sa;
    struct sockaddr * sa_tab[RTAX_MAX];
    int i;
    int ret = -1;
    if(sysctl(mib, sizeof(mib)/sizeof(int), 0, &l, 0, 0) < 0) {
        return -1;
    }
    if(l>0) {
        buf = malloc(l);
        if(sysctl(mib, sizeof(mib)/sizeof(int), buf, &l, 0, 0) < 0) {
            return -1;
        }
        for(p=buf; p<buf+l; p+=rt->rtm_msglen) {
            rt = (struct rt_msghdr *)p;
            sa = (struct sockaddr *)(rt + 1);
            for(i=0; i<RTAX_MAX; i++) {
                if(rt->rtm_addrs & (1 << i)) {
                    sa_tab[i] = sa;
                    sa = (struct sockaddr *)((char *)sa + ROUNDUP(sa->sa_len));
                } else {
                    sa_tab[i] = NULL;
                }
            }
            
            if( ((rt->rtm_addrs & (RTA_DST|RTA_GATEWAY)) == (RTA_DST|RTA_GATEWAY))
               && sa_tab[RTAX_DST]->sa_family == AF_INET
               && sa_tab[RTAX_GATEWAY]->sa_family == AF_INET) {
                
                
                if(((struct sockaddr_in *)sa_tab[RTAX_DST])->sin_addr.s_addr == 0) {
                    char ifName[128];
                    if_indextoname(rt->rtm_index,ifName);
                    
                    if(strcmp(IF_NAME,ifName)==0){
                        
                        *addr = ((struct sockaddr_in *)(sa_tab[RTAX_GATEWAY]))->sin_addr.s_addr;
                        ret = 0;
                    }
                }
            }
        }
        free(buf);
    }
    return ret;
}

+ (void) setButtonBorder: (UIButton*) button
{
    button.layer.cornerRadius = 5 ;
    button.layer.borderWidth = 1 ;
    button.layer.borderColor = button.titleLabel.textColor.CGColor ;
}

+ (BOOL) isWiFiEnabled {

    Reachability *reachability = [Reachability reachabilityForLocalWiFi];
    [reachability startNotifier];
    
    NetworkStatus status = [reachability currentReachabilityStatus];
    
    if (status == ReachableViaWiFi)
    {
        return true ;
    } else {
        
        return false ;
    }
}

@end
