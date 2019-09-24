//
//  MSRootVC.m
//  MStar
//
//  Created by 王璋传 on 2019/8/27.
//  Copyright © 2019 王璋传. All rights reserved.
//

#import "MSRootVC.h"
#import "MSProfileVC.h"
#import "MSLocalFileContentVC.h"
#import "DDWaterVaveView.h"
#import "MSTabBarVC.h"
#import <NetworkExtension/NEHotspotConfigurationManager.h>

typedef NS_ENUM(NSUInteger, MSConnectState) {
    MSConnectStatesUnkownDevice,                 //  没有正确连接到设备，之前也没连接过
    MSConnectStatesConnectedTGDevice,           // 正确连接到设备
    MSConnectStatesRecordConnnectedTGDevice,    //  没有正确连接到设备，但之前连接过
    MSConnectStatesWifiInfoReseted,    //  没有正确连接到设备，但之前连接过
};

@interface MSRootVC ()

@property (nonatomic, strong) UIImageView *cameraImageView;

@property (nonatomic, strong) UILabel *hintLB;

@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UIButton *leftMenuButton, *rightMenuButton;

@property (nonatomic, copy) NSString * dateStr;

@property (nonatomic, copy) NSString * ssid;
@property (nonatomic, copy) NSString * ssidPasswd;
@property (nonatomic, assign) MSConnectState connectState;

@property (nonatomic, assign) NSUInteger retryTimes;

@end

@implementation MSRootVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initBaseProperties];
    [self setupUI];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}


- (void)initBaseProperties {
    
//    NSURL *url = [AITCameraCommand commandUpdateUrl:@"name" EncryptionKey:@"passwd"];
//
//    (void)[[AITCameraCommand alloc] initWithUrl:url
//                                          block:^(NSString *result) {
//                                              if ([result containsString:@"OK"]) {
//                                              }
//                                          } fail:^(NSError *error) {
//
//                                          }];
    
    
    UILabel *titleLB = [UILabel new];
    titleLB.text = @"iCarEyes";
    titleLB.font = [UIFont boldSystemFontOfSize:30];
    titleLB.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:titleLB];
    [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(NAV_HEIGHT);
    }];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"MSRESET_WIFI_INFO_ACTION" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleWifiInfoReset:)
                                                 name:@"MSRESET_WIFI_INFO_ACTION" object:nil];

}

- (void)setupUI {
    
    if (nil == self.cameraImageView) {
        self.cameraImageView = [UIImageView new];
        self.cameraImageView.image = [UIImage imageNamed:@"首页相机"];

        [self.view addSubview:self.cameraImageView];
        [self.cameraImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(220);
            make.left.mas_equalTo(80);
            make.right.mas_equalTo(-80);
            make.height.mas_equalTo(self->_cameraImageView.mas_width).multipliedBy(360./650.);;
        }];
    }
    
    if (nil == self.hintLB) {
        self.hintLB = [UILabel new];
        self.hintLB.textColor = C99;
        self.hintLB.text = @"点击添加记录仪";
        self.hintLB.textAlignment = NSTextAlignmentCenter;
        self.hintLB.font = [UIFont systemFontOfSize:15];
        
        [self.view addSubview:self.hintLB];
        [self.hintLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self->_cameraImageView.mas_bottom).offset(80);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
        }];
    }
    
    if (nil == self.addButton) {
        self.addButton = [UIButton new];

        [self.addButton setImage:[UIImage imageNamed:@"添加按钮"] forState:UIControlStateNormal];
//        [self.addButton setBackgroundImage:[UIImage imageNamed:@"wifi"] forState:UIControlStateNormal];
        [self.addButton addTarget:self action:@selector(addDeviceAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:self.addButton];
        [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self->_hintLB.mas_bottom).offset(20);
            make.centerX.mas_equalTo(0);
//            make.width.mas_equalTo(80);
            make.size.mas_equalTo(CGSizeMake(80, 80));
        }];
    }
    
    if (nil == self.leftMenuButton) {
        self.leftMenuButton = [UIButton new];
        
//        [self.leftMenuButton setImage:[UIImage imageNamed:@"左边图标"] forState:UIControlStateNormal];
        [self.leftMenuButton addTarget:self action:@selector(leftMemuAction:) forControlEvents:64];

        [self.view addSubview:self.leftMenuButton];
        [self.leftMenuButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(self->_leftMenuButton.mas_width).multipliedBy(262./381.);;
        }];
        
        {
            UIImageView *imgView = [UIImageView new];
            imgView.image = [UIImage imageNamed:@"左边图标"];
            imgView.contentMode = UIViewContentModeScaleAspectFit;

            [self.leftMenuButton addSubview:imgView];
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(16);
                make.bottom.mas_equalTo(-16);
                make.width.mas_equalTo(20);
                make.height.mas_equalTo(imgView.mas_width).multipliedBy(262./381.);;
            }];
        }
    }
    
    if (nil == self.rightMenuButton) {
        self.rightMenuButton = [UIButton new];
//        self.rightMenuButton.backgroundColor = UIColor.redColor;
//
//        [self.rightMenuButton setImage:[UIImage imageNamed:@"右侧图标"] forState:UIControlStateNormal];
        [self.rightMenuButton addTarget:self action:@selector(rightMenuAction:) forControlEvents:64];
        
        [self.view addSubview:self.rightMenuButton];
        [self.rightMenuButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(self->_rightMenuButton.mas_width).multipliedBy(534./620);;
        }];
        
        {
            UIImageView *imgView = [UIImageView new];
            imgView.image = [UIImage imageNamed:@"右侧图标"];
            imgView.contentMode = UIViewContentModeScaleAspectFit;
            
            [self.rightMenuButton addSubview:imgView];
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-16);
                make.bottom.mas_equalTo(-16);
                make.width.mas_equalTo(30);
                make.height.mas_equalTo(imgView.mas_width).multipliedBy(534./620);;
            }];
        }
    }
}

#pragma mark - Set && get method


#pragma mark - Delegate method implement


#pragma mark - Private method

- (void)loadData {

    __weak typeof(self) weakSelf = self;
    
    [self syncDate:^{
        NSLog(@"---- 是本公司设备 ------");
        
        self.connectState = MSConnectStatesConnectedTGDevice;
        [weakSelf handleValidDeviceBlock];
        
    } otherDeviceBlock:^{
        NSLog(@"---- 其他 ------");
        [weakSelf handleInvalidDeviceBlock];
    }];
}

- (void)handleValidDeviceBlock {

    __weak typeof(self) weakSelf = self;

    (void)[[AITCameraCommand alloc] initWithUrl:[AITCameraCommand commandWifiInfoUrl]
                                          block:^(NSString *result) {
                                              [weakSelf saveWifiInfo:result];
                                          } fail:^(NSError *error) {
                                              ;
                                          }];
}

- (void)saveWifiInfo:(NSString *)result {
    
    if (result != nil) {
        NSLog(@"Result = %@", result) ;
        
        NSArray *lines = [result componentsSeparatedByString:@"\n"];
        
        for (NSString *line in lines) {
            
            if ([line hasPrefix:[AITCameraCommand PROPERTY_SSID]]) {
                NSArray *properties = [line componentsSeparatedByString:@"="] ;
                
                if ([properties count] == 2) {
                    //                    self.ssidText.text = [properties objectAtIndex:1] ;
                    //  获取WIFI名称
                    self.ssid = [properties objectAtIndex:1];
                    [[NSUserDefaults standardUserDefaults] setObject:self.ssid forKey:MSDEVICE_WIFI_NAME_KEY_STRING];
                }
            } else if ([line hasPrefix:[AITCameraCommand PROPERTY_ENCRYPTION_KEY]]) {
                NSArray *properties = [line componentsSeparatedByString:@"="] ;
                
                if ([properties count] == 2) {
                    //                    self.encryptionKeyText.text = [properties objectAtIndex:1] ;
                    //  获取WIIF密码
                    self.ssidPasswd = [properties objectAtIndex:1];
                    [[NSUserDefaults standardUserDefaults] setObject:self.ssidPasswd forKey:MSDEVICE_WIFI_PASSWD_KEY_STRING];
                }
            }
        }
        
    } else {
        NSLog(@"Result = nil") ;
    }
    
    if (self.ssid.length > 0) {
        self.hintLB.text = self.ssid;
        [self.addButton setImage:[UIImage imageNamed:@"摄像头"] forState:UIControlStateNormal];
    }
}

- (void)handleInvalidDeviceBlock {
    
    self.ssid = [[NSUserDefaults standardUserDefaults] valueForKey:MSDEVICE_WIFI_NAME_KEY_STRING];
    self.ssidPasswd = [[NSUserDefaults standardUserDefaults] valueForKey:MSDEVICE_WIFI_PASSWD_KEY_STRING];
    
    if (self.ssid.length > 0 && self.ssidPasswd.length > 0) {
        self.connectState = MSConnectStatesRecordConnnectedTGDevice;
        self.hintLB.text = self.ssid;
        [self.addButton setImage:[UIImage imageNamed:@"摄像头"] forState:UIControlStateNormal];
    } else {
        [self.addButton setImage:[UIImage imageNamed:@"添加按钮"] forState:UIControlStateNormal];
    }
}

- (void)handleLoadDataSuccessBlock:(id)result {
    
}

//  加载上次连接的设备
- (void)loadDeviceAction{
    
}

//  增加设备
- (void)addDeviceAction:(id)sender {

    if (self.connectState == MSConnectStatesConnectedTGDevice) {
        //  直接跳转到预览页面
        
        [self handleConnect2DeiceWifiBlock];

    } else if (self.connectState == MSConnectStatesRecordConnnectedTGDevice
               || self.connectState == MSConnectStatesWifiInfoReseted
               ) {
        // 代码内部连接WIFI
        
        if ([UIDevice currentDevice].systemVersion.integerValue >= 11) {
            [self connect2DeviceWifi];
        } else {
            [self openSettinPage];
        }

    } else if (self.connectState == MSConnectStatesUnkownDevice) {
        //  跳到设置界面
        
        [self openSettinPage];
    } else {
        [self openSettinPage];
    }

}

- (void)openSettinPage {
    
        NSURL *wifiSettingUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    
    if ([UIApplication.sharedApplication canOpenURL:wifiSettingUrl]) {
        [UIApplication.sharedApplication openURL:wifiSettingUrl];
    }
}

- (void)connect2DeviceWifi {
    
    [CPLoadStatusToast shareInstance].style = CPLoadStatusStyleLoading;
    [[CPLoadStatusToast shareInstance] show];
    
    __weak typeof(self) weakSelf = self;
    
    NEHotspotConfiguration * hotspotConfig = [[NEHotspotConfiguration alloc] initWithSSID:self.ssid passphrase:self.ssidPasswd isWEP:NO];
    //
    //    // 开始连接 (调用此方法后系统会自动弹窗确认)
    [[NEHotspotConfigurationManager sharedManager] applyConfiguration:hotspotConfig
                                                    completionHandler:^(NSError * _Nullable error) {

                                                        [[CPLoadStatusToast shareInstance] dimiss];
                                                        
                                                        if (nil == error && [cp_getWifiName() isEqualToString:weakSelf.ssid]) {
                                                            self->_connectState = MSConnectStatesConnectedTGDevice;
                                                            [weakSelf handleConnect2DeiceWifiBlock];
                                                        } else {
                                                            [weakSelf openSettinPage];
                                                        }
                                                    }];
}

- (void)handleConnect2DeiceWifiBlock {
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    MSTabBarVC *vc = [MSTabBarVC new];
    
    [self.navigationController pushViewController:vc animated:YES];
}

//  左边功能栏
- (void)leftMemuAction:(id)sender {
    NSLog(@"%s",__FUNCTION__);
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    MSProfileVC *vc = [[MSProfileVC alloc] initWithStyle:UITableViewStyleGrouped];

    [self.navigationController pushViewController:vc animated:YES];
}

//  右边功能栏
- (void)rightMenuAction:(id)sender {
    NSLog(@"%s",__FUNCTION__);
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    MSLocalFileContentVC *vc = [[MSLocalFileContentVC alloc] init];
    vc.title = NSLocalizedString(@"LocalFile", @"本地文件");
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)syncDate:(void (^)(void))familyBlock otherDeviceBlock:(void (^)(void))otherBlock {
    
    
    self.retryTimes++;
    
    NSDate *date = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy$MM$dd$HH$mm$ss"];
    NSString *dateStr = [formatter stringFromDate:date];
    
    
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc]init];
    [formatter1 setDateFormat:@"yy-MM-dd-HH-mm-ss"];
    self.dateStr = [formatter1 stringFromDate:date];
    
    __weak typeof(self) weakSelf = self;
    //    (void)[[AITCameraCommand alloc] initWithUrl:[AITCameraCommand commandSetDateTime:dateStr] Delegate:nil];
    (void)[[AITCameraCommand alloc] initWithUrl:[AITCameraCommand commandSetDateTime:dateStr]
                                          block:^(NSString *result) {
                                              if ([result containsString:@"OK"]) {
                                                  [weakSelf getFwVersion:familyBlock];
                                              } else {
                                                  
                                                  //   如果同步失败，则尝试重新同步
                                                  if (weakSelf.retryTimes < 4) {
                                                      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                          [weakSelf syncDate:familyBlock otherDeviceBlock:otherBlock];
                                                      });
                                                  } else {
                                                      !otherBlock ? : otherBlock();
                                                  }
//                                                  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                                                      [weakSelf syncDate:familyBlock otherDeviceBlock:otherBlock];
//                                                  });
                                              }
                                          } fail:^(NSError *error) {
                                              
                                              if (weakSelf.retryTimes < 4) {
                                                  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                      [weakSelf syncDate:familyBlock otherDeviceBlock:otherBlock];
                                                  });
                                              } else {
                                                  !otherBlock ? : otherBlock();
                                              }
                                          }];
}

- (void)getFwVersion:(void (^)(void))block {
    
    __weak typeof(self) weakSelf = self;
    
    (void)[[AITCameraCommand alloc] initWithUrl:[AITCameraCommand commandQuerySettings]
                                          block:^(NSString *result) {
                                              [weakSelf handleQuerySettings:result block:block];
                                          } fail:^(NSError *error) {
                                          }];
}

- (void)handleQuerySettings:(NSString *)result block:(void (^)(void))block {
    if (NO == [result containsString:@"OK\n"]) {
        return;
    }
    
    NSArray <NSString *> *cameraMenu = [result componentsSeparatedByString:@"\n"];
    [cameraMenu enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj containsString:@"Camera.Menu.FWversion="]) {
            NSString *fwversion = [obj componentsSeparatedByString:@"="].lastObject;
            NSLog(@"---- fwversion ------%@",fwversion);
            
            NSString *encrypByte = [fwversion componentsSeparatedByString:@"-"].lastObject;
            
            NSArray *dateStrs = [self.dateStr componentsSeparatedByString:@"-"];
            
            int ret = TogevisionCRC([dateStrs[0] intValue], [dateStrs[1] intValue], [dateStrs[2] intValue], [dateStrs[3] intValue], [dateStrs[4] intValue], [dateStrs[5] intValue]);
            
            if (ret == encrypByte.intValue) {
                NSLog(@"是自己的设备%d",ret);
                !block ? : block();
            } else {
                NSLog(@"不是自己的设备%d",ret);
            }
        }
    }];
}

static unsigned char TogevisionCRC(unsigned char year,unsigned char month,unsigned char day,unsigned char hour,unsigned char min,unsigned char second)
{
    return (((year^month) + day&hour)^min)+second;
}


- (void)applicationDidBecomeActive:(NSNotification *)application {
    
    [self loadData];
}

- (void)handleWifiInfoReset:(NSNotification *)ntf {
    self.connectState = MSConnectStatesWifiInfoReseted;
}

@end
