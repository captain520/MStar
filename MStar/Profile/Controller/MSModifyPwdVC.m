//
//  MSModifyPwdVC.m
//  MStar
//
//  Created by 王璋传 on 2019/5/5.
//  Copyright © 2019 王璋传. All rights reserved.
//

#import "MSModifyPwdVC.h"

@interface MSModifyPwdVC ()<AITCameraRequestDelegate>

@property (nonatomic, copy) NSString * ssid;
@property (nonatomic, copy) NSString * ssidPasswd;

@end

@implementation MSModifyPwdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initailizeBaseProperties];
}

#pragma mark - Initialized properties
- (void)initailizeBaseProperties {
    
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"save"] style:UIBarButtonItemStyleDone target:self action:@selector(saveAction:)];
    
    (void)[[AITCameraCommand alloc] initWithUrl:[AITCameraCommand commandWifiInfoUrl] Delegate:self] ;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.ssidTF becomeFirstResponder];
}
#pragma mark - setter && getter method
#pragma mark - Setup UI
- (void)setupUI {
    
}
#pragma mark - Delegate && dataSource method implement
-(void) requestFinished:(NSString*) result
{
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
                    self.ssidTF.text = self.ssid;
                }
            } else if ([line hasPrefix:[AITCameraCommand PROPERTY_ENCRYPTION_KEY]]) {
                NSArray *properties = [line componentsSeparatedByString:@"="] ;
                
                if ([properties count] == 2) {
                    //                    self.encryptionKeyText.text = [properties objectAtIndex:1] ;
                    //  获取WIIF密码
                    self.ssidPasswd = [properties objectAtIndex:1];
                    self.pwdTF.text = self.ssidPasswd;
                }
            }
        }
        
    } else {
        NSLog(@"Result = nil") ;
    }
}
#pragma mark - load data
- (void)loadData {
    
}
- (void)handleLoadDataBlock:(NSArray *)results {
}

#pragma mark - Private method implement

- (void)saveAction:(id)sender {
    NSLog(@"");

    [self.view endEditing:YES];
    //TODO: 发送修改命令
//    (void)[[AITCameraCommand alloc] initWithUrl:[AITCameraCommand commandUpdateUrl:self.ssidTF.text EncryptionKey:self.pwdTF.text] View:self.view] ;
    
    __weak typeof(self) weakSelf = self;
    
    NSURL *url = [AITCameraCommand commandUpdateUrl:self.ssidTF.text EncryptionKey:self.pwdTF.text];
    
    (void)[[AITCameraCommand alloc] initWithUrl:url
                                          block:^(NSString *result) {
//                                              if ([result containsString:@"OK"]) {
//                                                  [weakSelf back2HomePageVC];
//                                              }
                                              [weakSelf handleModifyBlcok:result];
                                          } fail:^(NSError *error) {
                                              [weakSelf.view makeToast:error.localizedDescription duration:2.0f position:CSToastPositionCenter];
                                          }];
}

- (void)handleModifyBlcok:(NSString *)result {
//    commandReactivateUrl
    
    __weak typeof(self) weakSelf = self;
    
    if ([result containsString:@"OK"]) {

        (void)[[AITCameraCommand alloc] initWithUrl:[AITCameraCommand commandReactivateUrl]
                                              block:^(NSString *result) {
                                                  [weakSelf back2HomePageVC];
                                              } fail:^(NSError *error) {
                                                  [weakSelf.view makeToast:error.localizedDescription duration:2.0f position:CSToastPositionCenter];
                                              }] ;

    }
    
}

- (void)handleSaveActionBlock:(NSString *)result {
    
    if ([result containsString:@"OK"]) {
        [self back2HomePageVC];
    } else {
        [self.view makeToast:NSLocalizedString(@"SendCommandFail", nil) duration:2.0f position:CSToastPositionCenter];
    }
}

- (void)back2HomePageVC {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MSRESET_WIFI_INFO_ACTION" object:nil];

    [self.navigationController.parentViewController.navigationController popToRootViewControllerAnimated:YES];
}

@end
