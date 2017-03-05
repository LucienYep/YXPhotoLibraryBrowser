//
//  PhotoGroup.h
//  PhotoPicker
//
//  Created by cibdev on 16/5/16.
//  Copyright © 2016年 cibdev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface PhotoGroup : NSObject

/**
 *  组名
 */
@property (nonatomic , copy) NSString *groupName;

/**
 *  缩略图
 */
@property (nonatomic , strong) UIImage *thumbImage;

/**
 *  组里面的图片个数
 */
@property (nonatomic , assign) NSInteger assetsCount;

/**
 *  类型 : Saved Photos...
 */
@property (nonatomic , copy) NSString *type;

@property (nonatomic , strong) ALAssetsGroup *group;

@end
