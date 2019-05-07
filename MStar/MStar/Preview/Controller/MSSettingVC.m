//
//  MSSettingVC.m
//  MStar
//
//  Created by 王璋传 on 2019/3/7.
//  Copyright © 2019 王璋传. All rights reserved.
//

#import "MSSettingVC.h"
#import "AITCameraCommand.h"
#import "AITCameraRequest.h"
#import "MSSettingActionVC.h"

@interface MSSettingVC ()<AITCameraRequestDelegate>
@property (nonatomic, strong)  AITCamMenu *currentMenu;

@property (nonatomic, assign) BOOL isRecordingWhenSetting;

@end

@implementation MSSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self initailizeBaseProperties];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.isRecording == YES) {
        [self sendRecordCommand:^{
            self.isRecordingWhenSetting = NO;
        }];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.isRecordingWhenSetting != self.isRecording) {
        [self sendRecordCommand:^{
//            self.isRecordingWhenSetting = YES;
        }];
    }
}

#pragma mark - Initialized properties
- (void)initailizeBaseProperties {
    self.title = NSLocalizedString(@"Setting", nil);
}
#pragma mark - setter && getter method
#pragma mark - Setup UI
- (void)setupUI {
    
}
#pragma mark - Delegate && dataSource method implement

-(void) requestFinished:(NSString*) result
{
    if ([result hasPrefix:@"0\nOK"]) {
        if (self.currentMenu.parent) {
            self.currentMenu.parent.focus = self.currentMenu.menuid;
            [self.view makeToast:NSLocalizedString(@"SetSuccess", nil) duration:1.0f position:CSToastPositionCenter];
            [self.tableView reloadData];
        } else {
            [self.view makeToast:NSLocalizedString(@"SetSuccess", nil) duration:1.0f position:CSToastPositionCenter];
        }
    } else {
        [self.view makeToast:result duration:1.0f position:CSToastPositionCenter];
    }
}
#pragma mark - load data
- (void)loadData {
    
    
    if ([MSCamMenuManager manager].cammenu) {
        
        [self.tableView reloadData];
        
    } else {
        
        __weak typeof(self) weakSelf = self;
        
        (void)[[AITCameraCommand alloc] initWithUrl:[AITCameraCommand commandGetCamMenu]
                                              block:^(NSString *result) {
                                                  [weakSelf handleLoadDataBlock:result];
                                              } fail:^(NSError *error) {
                                                  
                                              }];
    }
    
}

- (void)handleLoadDataBlock:(NSString *)result {
    if (result.length < 20) {
        return;
    }

    [[MSCamMenuManager manager] LoadCamMenuXMLDoc:result];

    [self.tableView reloadData];
}

#pragma mark - Private method implement


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [MSCamMenuManager manager].curmenu.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    // Configure the cell...
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSString *key = [MSCamMenuManager manager].cammenu.keyArray[indexPath.row];
    AITCamMenu *menu = [MSCamMenuManager manager].curmenu.items[key];
    cell.textLabel.text = NSLocalizedString(menu.title, nil);//menu.title;

    AITCamMenu *child = [menu.items valueForKey:menu.focus];
    if (child && [child isKindOfClass:[AITCamMenu class]]) {
        cell.detailTextLabel.text = NSLocalizedString(child.title, nil);//child.title;
    } else {
        cell.detailTextLabel.text = @"";
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *key = [MSCamMenuManager manager].cammenu.keyArray[indexPath.row];
    AITCamMenu *menu = [MSCamMenuManager manager].curmenu.items[key];

    if ([menu.title isEqualToString:@"SYNC TIME"]) {
        self.currentMenu = menu;
        [self setDateTime];
        return;
    }
    
    NSMutableArray <AITCamMenu *> *items = @[].mutableCopy;
    
    [menu.keyArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *objKey = menu.keyArray[idx];
        AITCamMenu *objMenu = menu.items[objKey];
        objMenu.parent = menu;
        
        [items addObject:objMenu];
    }];
    
     __weak typeof(self) weakSelf = self;
    
    MSSettingActionVC *vc = [[MSSettingActionVC alloc] init];
    vc.dataArray = items;
    vc.title = NSLocalizedString(menu.title, nil);
    vc.selectedActionBlock = ^(AITCamMenu * _Nonnull menuItem) {
        [weakSelf pickAction:menuItem];
    };

    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pickAction:(AITCamMenu *)sender {
    NSLog(@"%@",sender.title);
    self.currentMenu = sender;
    (void)[[AITCameraCommand alloc] initWithUrl:[AITCameraCommand setProperty:sender.parent.menuid Value:sender.menuid] Delegate:self];
}

-(void) setDateTime
{
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy$MM$dd$HH$mm$ss"];
    // display in 12HR/24HR (i.e. 11:25PM or 23:25) format according to User Settings
    //[dateFormatter setTimeStyle:kCFDateFormatterLongStyle];
    NSString *currentTime = [dateFormatter stringFromDate:today];
    //[dateFormatter release];
    NSLog(@"User's current time in their preference format:%@",currentTime);
    (void)[[AITCameraCommand alloc] initWithUrl:[AITCameraCommand commandSetDateTime :currentTime] Delegate:self] ;
}

- (void)sendRecordCommand:(void (^)(void))block
{
    (void)[[AITCameraCommand alloc] initWithUrl:[AITCameraCommand commandCameraRecordUrl]
                                          block:^(NSString *result) {
                                              if (YES == [result containsString:@"OK\n"]) {
                                                  !block ? : block();
                                              }
                                          } fail:^(NSError *error) {
                                              
                                          }];
}

@end
