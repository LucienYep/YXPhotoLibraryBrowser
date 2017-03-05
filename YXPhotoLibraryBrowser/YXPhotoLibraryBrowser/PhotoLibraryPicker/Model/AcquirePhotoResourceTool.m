//
//  AcquirePhotoResourceTool.m
//  PhotoPicker
//
//  Created by cibdev on 16/5/16.
//  Copyright © 2016年 cibdev. All rights reserved.
//

#import "AcquirePhotoResourceTool.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "PhotoGroup.h"

@interface AcquirePhotoResourceTool ()

@property (nonatomic , strong) ALAssetsLibrary *library;

@end

static AcquirePhotoResourceTool *_tool = nil;

static ALAssetsLibrary *_defaultLibrary = nil;

@implementation AcquirePhotoResourceTool

+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _tool = [[self alloc] init];
    });
    return _tool;
}

+ (ALAssetsLibrary *)defaultLibrary
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultLibrary = [[ALAssetsLibrary alloc] init];
    });
    return _defaultLibrary;
}

- (ALAssetsLibrary *)library
{
    if (_library == nil) {
        _library = [self.class defaultLibrary];
    }
    return _library;
}

- (void)getAllGroupWithPhoto:(void (^)(id obj))callback {
    
    NSMutableArray *groups = [NSMutableArray array];
    ALAssetsLibraryGroupsEnumerationResultsBlock resultBlock = ^(ALAssetsGroup *group,BOOL *stop){
        if (group) {
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            PhotoGroup *photoGroup = [[PhotoGroup alloc] init];
            photoGroup.group = group;
            photoGroup.groupName = [group valueForProperty:@"ALAssetsGroupPropertyName"];
            photoGroup.thumbImage = [UIImage imageWithCGImage:[group posterImage]];
            photoGroup.assetsCount = [group numberOfAssets];
            [groups addObject:photoGroup];
        }else{
            callback(groups);
        }
    };
    
    NSInteger type = ALAssetsGroupAll;
    
    [self.library enumerateGroupsWithTypes:type usingBlock:resultBlock failureBlock:nil];
}

- (void)getPhotosWithGroup:(PhotoGroup *)photoGroup callback:(void (^)(id obj))callback {
    
    NSMutableArray *assets = [NSMutableArray array];
    ALAssetsGroupEnumerationResultsBlock result = ^(ALAsset *asset , NSUInteger index , BOOL *stop){
        if (asset) {
            [assets addObject:asset];
        }else{
            callback(assets);
        }
    };
    [photoGroup.group enumerateAssetsUsingBlock:result];
}
@end
