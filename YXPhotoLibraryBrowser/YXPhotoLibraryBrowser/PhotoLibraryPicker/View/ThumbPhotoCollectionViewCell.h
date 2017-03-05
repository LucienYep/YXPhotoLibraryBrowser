//
//  ThumbPhotoCollectionViewCell.h
//  PhotoPicker
//
//  Created by cibdev on 16/5/16.
//  Copyright © 2016年 cibdev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoAsset.h"

@interface ThumbPhotoCollectionViewCell : UICollectionViewCell

@property (copy ,nonatomic)int(^selectedCallback)(BOOL selected);

@property (strong ,nonatomic)PhotoAsset *asset;

@property (nonatomic,assign)BOOL btnSelected;

@property (assign, nonatomic)BOOL full;

@property (weak, nonatomic) IBOutlet UIButton *selectedButton;

@end
