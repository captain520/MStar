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

@interface MSSettingVC ()<AITCameraRequestDelegate>
@property (nonatomic, strong)  AITCamMenu *currentMenu;
@end

@implementation MSSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self initailizeBaseProperties];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            [[[SCLAlertView alloc] initWithNewWindow] showSuccess:self.currentMenu.parent.title subTitle:NSLocalizedString(@"SetSuccess", nil) closeButtonTitle:nil duration:2];
            [self.tableView reloadData];
        } else {
            [[[SCLAlertView alloc] initWithNewWindow] showSuccess:self.currentMenu.title subTitle:NSLocalizedString(@"SetSuccess", nil) closeButtonTitle:nil duration:2];
        }
        
        
        NSLog(@"");
    } else {
        [[[SCLAlertView alloc] initWithNewWindow] showError:self.currentMenu.parent.title subTitle:result closeButtonTitle:nil duration:2];
    }
//    if (curmenu.parent != nil) {
//        curmenu = curmenu.parent;
//        [self.navigationController popViewControllerAnimated:YES];
//    }
}
#pragma mark - load data
- (void)loadData {
    
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

    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    alert.showAnimationType = SCLAlertViewShowAnimationFadeIn;

    [menu.keyArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *objKey = menu.keyArray[idx];
        AITCamMenu *objMenu = menu.items[objKey];
        objMenu.parent = menu;
        SCLButton *button = [alert addButton:objMenu.title actionBlock:^{
            [self pickAction:objMenu];
        }];
        button.buttonFormatBlock = ^NSDictionary* (void)
        {
            NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
            
            buttonConfig[@"backgroundColor"] = [UIColor whiteColor];
            buttonConfig[@"textColor"] = [UIColor blackColor];
            buttonConfig[@"borderWidth"] = @1.0f;
            buttonConfig[@"borderColor"] = MAIN_COLOR;
            
            return buttonConfig;
        };
    }];

    alert.backgroundType = SCLAlertViewBackgroundBlur;
    [alert showTitle:menu.title subTitle:nil style:SCLAlertViewStyleEdit closeButtonTitle:@"cancel" duration:0];
    
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

@end
