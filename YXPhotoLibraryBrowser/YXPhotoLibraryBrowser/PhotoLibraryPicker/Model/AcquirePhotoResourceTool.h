//
//  AcquirePhotoResourceTool.h
//  PhotoPicker
//
//  Created by cibdev on 16/5/16.
//  Copyright © 2016年 cibdev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotoGroup.h"

@interface AcquirePhotoResourceTool : NSObject

+ (instancetype)sharedInstance;

/**
 获取所有的照片组

 */
- (void)getAllGroupWithPhoto:(void (^)(id obj))callback;


/**
 获取每个组里的图片

 */
- (void)getPhotosWithGroup:(PhotoGroup *)group callback:(void (^)(id obj))callback;

@end
