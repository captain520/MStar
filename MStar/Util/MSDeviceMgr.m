//
//  MSDeviceMgr.m
//  MStar
//
//  Created by 王璋传 on 2019/9/19.
//  Copyright © 2019 王璋传. All rights reserved.
//

#import "MSDeviceMgr.h"

#import "GDataXMLNode.h"

static NSString *CAMERAID_CMD_FRONT = @"front";
static NSString *CAMERAID_CMD_REAR = @"rear";

static NSString *TAG_DCIM = @"DCIM" ;

static NSString *TAG_file = @"file" ;
static NSString *TAG_name = @"name" ;
static NSString *TAG_format = @"format" ;
static NSString *TAG_size = @"size" ;
static NSString *TAG_attr = @"attr" ;
static NSString *TAG_time = @"time" ;

static NSString *TAG_amount = @"amount" ;

@implementation MSDeviceMgr {
    NSLock *lock;
    
    NSInteger retryTimmes;
}

+ (instancetype)manager {
    
    static MSDeviceMgr *mgr = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        mgr = [[MSDeviceMgr alloc] init];
    });
    
    return mgr;
}

- (id)init {
    
    if (self = [super init]) {
        lock = [[NSLock alloc] init];
    }
    
    return self;
}


//  获取录制状态
- (void)getRecordingState:(void (^)(BOOL recordState))block {
    
    (void)[[AITCameraCommand alloc] initWithUrl:[AITCameraCommand commandQueryPreviewStatusUrl]
                                          block:^(NSString *result) {
        [self getRecordStateWith:result block:block];
    } fail:^(NSError *error) {
        !block ? : block(NO);
    }];
}

- (void)getRecordStateWith:(NSString *)result block:(void (^)(BOOL isRecording))block {
    
    BOOL cameraRecording = NO;
    
    if ([result containsString:@"OK"] == NO) {
        
        !block ? : block(cameraRecording);
        
        return;
    }
    
    
    NSDictionary *dict = [AITCameraCommand buildResultDictionary:result];
    NSString *recording = [dict objectForKey:[AITCameraCommand PROPERTY_QUERY_RECORD]];
    NSString *currentCamId = [dict objectForKey:[AITCameraCommand PROPERTY_CAMERAID]];
    if (NO == [currentCamId isEqualToString:self.camId]) {
        self.camId = currentCamId;
    }
    
    if (![recording caseInsensitiveCompare:@"Recording"]) {
        cameraRecording = YES;
    } else {
        cameraRecording = NO;
    }
    
    !block ? : block(cameraRecording);
    
    self.isRecording = cameraRecording;
}


//  打开录制
- (void)startRecrod {
    
    [self getRecordingState:^(BOOL recordState) {
        
        if (NO == recordState) {
            //  如果状态是未录制
            [self toggleRecordState];
        } else {
            //  如果状态正在录制，什么都不做
            
            self.isRecording = YES;
        }
        
    }];
}

- (void)startRecordWithBlock:(void (^)(void))block {
    [self getRecordingState:^(BOOL recordState) {
        
        if (NO == recordState) {
            //  如果状态是未录制
            [self toggleRecordState:block];
        } else {
            //  如果状态正在录制，什么都不做
            
            self.isRecording = YES;
            
            !block ? : block();
        }
        
    }];
}

//  停止录制
- (void)stopRecrod {
    
    [self getRecordingState:^(BOOL recordState) {
        
        if (NO == recordState) {
            //  如果状态是未录制
            
        } else {
            //  如果状态正在录制，切换录制状态
            [self toggleRecordState];
        }
    }];
}

//  切换录制状态
- (void)toggleRecordState {
    
    NSLog(@"开始切换录制状态");
    
    (void)[[AITCameraCommand alloc] initWithUrl:[AITCameraCommand commandCameraRecordUrl]
                                          block:^(NSString *result) {
        if (NO == [result containsString:@"OK"]) {
            sleep(1);
            [self toggleRecordState];
        }
        NSLog(@"切换录制状态：%@", result);
    } fail:^(NSError *error) {
        NSLog(@"切换录制状态：%@", error);
    }];
}

- (void)stopRecrod:(void (^)(void))block {
    
    [self getRecordingState:^(BOOL recordState) {
        
        if (NO == recordState) {
            //  如果状态是未录制
            
            !block ? : block();
        } else {
            //  如果状态正在录制，切换录制状态
            [self toggleRecordState:block];
        }
    }];
}

- (void)toggleRecordState:(void (^)(void))block {
    
    NSLog(@"开始切换录制状态");
    
    (void)[[AITCameraCommand alloc] initWithUrl:[AITCameraCommand commandCameraRecordUrl]
                                          block:^(NSString *result) {
        if ([result containsString:@"OK"]) {
            !block ? : block();
        } else {
            sleep(1);
            [self toggleRecordState:block];
        }
        NSLog(@"切换录制状态：%@", result);
    } fail:^(NSError *error) {
        NSLog(@"切换录制状态：%@", error);
        !block ? : block();
    }];
}

- (void)toggleCameId:(void (^)(BOOL done))block {
    
    NSString *destCamId = nil;
    
    if ([self.camId isEqualToString:CAMERAID_CMD_FRONT]) {
        destCamId = CAMERAID_CMD_REAR;
    } else {
        destCamId = CAMERAID_CMD_FRONT;
    }
    
    (void)[[AITCameraCommand alloc] initWithUrl:[AITCameraCommand commandSetCameraidUrl:destCamId]
                                          block:^(NSString *result) {
        [self handleSwitchBlock:result block:block];
    } fail:^(NSError *error) {
        !block ? : block(NO);
    }];
    
}

- (void)handleSwitchBlock:(NSString *)result block:(void (^)(BOOL done))block {
    
    if (result && [result containsString:@"OK\n"]) {
    !block ? : block(YES);
    } else {
        [UIApplication.sharedApplication.keyWindow makeToast:NSLocalizedString(@"No rear camera found", nil) duration:3.0 position:@"CSToastPositionCenter"];
    !block ? : block(NO);
    }
    
}


- (void)loadRemoteFile:(W1MFileType )fileType
                  page:(NSUInteger )page
                isRear:(BOOL)isRear
                 block:(void (^)(NSArray <AITFileNode *> *datas))success
                  fail:(void (^)(NSError *error))fail {
    
    NSURL *requestUrl = nil;
    
    switch (fileType) {
        case W1MFileTypeNormal:
        {
            requestUrl = [AITCameraCommand commandListFileUrl:PageSize From:(int)(page * PageSize) isRear:isRear fileType:W1MFileTypeNormal];
        }
            break;
        case W1MFileTypePhoto:
        {
            requestUrl = [AITCameraCommand commandListFileUrl:PageSize From:(int)(page * PageSize) isRear:isRear fileType:W1MFileTypePhoto];
        }
            break;
        case W1MFileTypeEvent:
            requestUrl = [AITCameraCommand commandListFileUrl:PageSize From:(int)(page * PageSize) isRear:isRear fileType:W1MFileTypeEvent];
            break;
        default:
            break;
    }
    
    //  最高尝试三次
    
    (void)[[AITCameraCommand alloc] initWithUrl:requestUrl
                                          block:^(NSString *result) {
        NSLog(@"----------result:%@",result);
        if (nil == result || [result containsString:@"404 Not Found"]) {
            if (self->retryTimmes < 10) {
//                sleep(10);
                self->retryTimmes++;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    NSLog(@"&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&:%@",@(self->retryTimmes));
                    [self loadRemoteFile:fileType page:page isRear:isRear block:success fail:fail];
                });
            } else {
                NSLog(@"retryTimmes: %@",@(self->retryTimmes));
                self->retryTimmes = 0;
                !fail ? : fail(NSError.new);
            }
        } else {
            
            self->retryTimmes = 0;
            
            NSArray *array = [self handleLoadFileInfoBlock:result];
            
            !success ? : success(array);
        }
    }fail:^(NSError *error) {
        NSLog(@"111");
        !fail ? : fail(error);
//        if (self->retryTimmes < 10) {
//            self->retryTimmes++;
//            [self loadRemoteFile:fileType page:page isRear:isRear block:success fail:fail];
//        } else {
//            self->retryTimmes = 0;
//            NSLog(@"retryTimmes: %@",@(self->retryTimmes));
//            !fail ? : fail(error);
//        }
    }];
}

- (NSArray *)handleLoadFileInfoBlock:(NSString *)result {
    
    NSMutableArray *fileNodes = @[].mutableCopy;
    
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithXMLString:[result substringToIndex:[result rangeOfString:@">" options:NSBackwardsSearch].location + 1] options:0 error:nil];
    GDataXMLElement *dcimElement = doc.rootElement ;
    //NSLog(@"dcimElement = %@\n", dcimElement.name) ;
    int amount = -1;
    NSArray *dcimChildren = [dcimElement children] ;
    for (GDataXMLElement *dcimChild in dcimChildren) {
        if ([[dcimChild name] isEqualToString:TAG_file]) {
            //                    NSArray *fileChildren = [dcimChild children] ;
            //                    for (GDataXMLElement * fileChild in fileChildren) {
            //                        NSLog(@"Child %@ = %@\n", fileChild.name, [fileChild stringValue]) ;
            //                    }
            AITFileNode *fileNode = [[AITFileNode alloc] init] ;
            fileNode.name = [[self getFirstChild:dcimChild WithName:TAG_name] stringValue] ;
            fileNode.format = [[self getFirstChild:dcimChild WithName:TAG_format] stringValue] ;
            fileNode.size = (unsigned int)[[[self getFirstChild:dcimChild WithName:TAG_size] stringValue] integerValue];
            fileNode.attr = [[self getFirstChild:dcimChild WithName:TAG_attr] stringValue] ;
            fileNode.time = [[self getFirstChild:dcimChild WithName:TAG_time] stringValue] ;
            fileNode.blValid = TRUE;
            fileNode.progress = -1;
            //            [fileNodes addObject: fileNode] ;
            if (fileNode.size > 0) {
                [fileNodes addObject:fileNode];
            }
            //                    NSLog(@"Added file \"%@\" into fileNode\n", fileNode.name) ;
        } else if ([[dcimChild name] isEqualToString:TAG_amount]) {
            amount = [[dcimChild stringValue] intValue] ;
        } else {
            NSLog(@"ERROR TRY!!");
        }
    }
    
    return fileNodes;
}

-(GDataXMLElement *) getFirstChild:(GDataXMLElement *) element WithName: (NSString*) name
{
    NSArray *elements = [element elementsForName:name] ;
    
    if (elements.count > 0) {
        
        return (GDataXMLElement *) [elements objectAtIndex:0];
    }
    
    NSLog(@"Cannot find Tag:%@", name) ;
    
    return nil ;
}

- (void)beginRecord:(void (^)(BOOL res))block  {
    
    if (self.isRecording) {
        !block ? : block(YES);
    } else {
        [self toggleRecord:^{
            self.isRecording = YES;
            !block ? : block(YES);
        }];
    }
    
}

- (void)endRecord:(void (^)(BOOL res))block  {
    
    if (self.isRecording) {
        [self toggleRecord:^{
            self.isRecording = NO;
            !block ? : block(YES);
        }];
    } else {
        !block ? : block(YES);
    }
    
}

- (void)toggleRecord:(void (^)(void))block {
    
    NSLog(@"开始切换录制状态");
    
    (void)[[AITCameraCommand alloc] initWithUrl:[AITCameraCommand commandCameraRecordUrl]
                                          block:^(NSString *result) {
        if ([result containsString:@"OK"]) {
            self.isRecording = !self.isRecording;
            !block ? : block();
        } else {
            sleep(1);
            [self toggleRecord:block];
        }
        NSLog(@"切换录制状态：%@", result);
    } fail:^(NSError *error) {
        NSLog(@"切换录制状态：%@", error);
//        !block ? : block();
    }];
}

@end
