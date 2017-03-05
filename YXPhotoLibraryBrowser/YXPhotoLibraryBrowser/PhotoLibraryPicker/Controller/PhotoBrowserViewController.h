//
//  PhotoBrowserViewController.h
//  PhotoPicker
//
//  Created by cibdev on 16/5/17.
//  Copyright © 2016年 cibdev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoAsset.h"

#define Alert(_S_, ...) [[[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:(_S_), ##__VA_ARGS__] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show]

#define kDefaultMaxSelectedCount 6

@interface PhotoBrowserViewController : UIViewController

- (instancetype)initWithIndex:(NSInteger)index;

@property (strong ,nonatomic)NSArray *photoAssets;

@property (copy ,nonatomic)void(^selectItemCallback)(NSMutableDictionary *dict,NSMutableArray *selectArr);

@property (strong ,nonatomic)NSMutableDictionary *selectDic;

@property (strong ,nonatomic)NSMutableArray *selectedArray;

@property (nonatomic, assign) NSInteger maxSelectedCount;

@end
