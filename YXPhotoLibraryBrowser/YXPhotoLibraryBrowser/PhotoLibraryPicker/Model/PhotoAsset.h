//
//  PhotoAsset.h
//  PhotoPicker
//
//  Created by cibdev on 16/5/16.
//  Copyright © 2016年 cibdev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface PhotoAsset : NSObject
@property (strong,nonatomic) ALAsset *asset;
/**
 *  缩略图
 */
- (UIImage *)thumbImage;
/**
 *  压缩原图
 */
- (UIImage *)compressionImage;
/**
 *  原图
 */
- (UIImage *)originImage;
- (UIImage *)fullResolutionImage;
/**
 *  获取是否是视频类型, Default = false
 */
@property (assign,nonatomic) BOOL isVideoType;
/**
 *  获取相册的URL
 */
- (NSURL *)assetURL;

@end
