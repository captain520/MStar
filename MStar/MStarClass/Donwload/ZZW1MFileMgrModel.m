//
//  ZZW1MFileMgrModel.m
//  chelian
//
//  Created by captain on 2017/7/7.
//  Copyright © 2017年 zhizai. All rights reserved.
//

#import "ZZW1MFileMgrModel.h"
#import "AITCameraCommand.h"
#import <XMLReader.h>

static AITCameraCommand *cameraCommand = nil;

@implementation ZZW1MFileMgrModel

+(NSString *)getLocalNameWithTime:(NSString *)date
{
    date = [date stringByReplacingOccurrencesOfString:@"-" withString:@""];
    date = [date stringByReplacingOccurrencesOfString:@" " withString:@""];
    date = [date stringByReplacingOccurrencesOfString:@"/" withString:@""];
    date = [NSString stringWithFormat:@"%@.MOV",date];
    return date;
}

+ (void)fetchW1MFileList:(W1MFileType )fileType block:(void (^)(NSDictionary *dataDict))block fail:(void (^)(ZZError *error))failBlock {
    cameraCommand = [[AITCameraCommand alloc] initWithUrl:[AITCameraCommand commandListAllFileUrl:fileType]  block:^(NSString *result) {
        if (block) {
            NSError *error = nil;
            block([XMLReader dictionaryForXMLString:result error:&error]);
        }
    } fail:^(ZZError *error) {
        !failBlock ? : failBlock(error);
    }];
}

+ (void)fetchW1MDcimFileList:(void (^)(NSDictionary *dataDict))block fail:(void (^)(ZZError *error))failBlock {
    
    cameraCommand = [[AITCameraCommand alloc] initWithUrl:[AITCameraCommand commandListFileUrl:0 pageSize:DefaultFileSizePerPage fileType:W1MFileTypeDcim] block:^(NSString *result) {
        if (block) {
            NSError *error = nil;
            block([XMLReader dictionaryForXMLString:result error:&error]);
        }
    } fail:^(ZZError *error) {
        !failBlock ? : failBlock(error);
    }];
}

+ (void)fetchW1MFileList:(NSInteger )pageNum fileType:(W1MFileType )fileType block:(void (^)(NSDictionary *dataDict))block fail:(void (^)(ZZError *error))failBlock {
    
    cameraCommand = [[AITCameraCommand alloc] initWithUrl:[AITCameraCommand commandListFileUrl:pageNum pageSize:DefaultFileSizePerPage fileType:fileType]  block:^(NSString *result) {
        if (block) {
            NSError *error = nil;
            block([XMLReader dictionaryForXMLString:result error:&error]);
        }
    } fail:^(ZZError *error) {
        
        !failBlock ? : failBlock(error);
        
    }];
    
}

+ (void)deleteFileWithPath:(NSString *)fileName block:(void (^)(NSDictionary *result))block fail:(void (^)(ZZError *error))failBlock {
    cameraCommand = [[AITCameraCommand alloc] initWithUrl:[AITCameraCommand commandDelFileUrl:[fileName stringByReplacingOccurrencesOfString: @"/" withString:@"$"]] block:^(NSString *result) {
        if (block) {
            
            NSError *error = nil;
            
            block([XMLReader dictionaryForXMLString:result error:&error]);
        }
    } fail:^(ZZError *error) {
        !failBlock ? : failBlock(error);
    }] ;
}

@end
