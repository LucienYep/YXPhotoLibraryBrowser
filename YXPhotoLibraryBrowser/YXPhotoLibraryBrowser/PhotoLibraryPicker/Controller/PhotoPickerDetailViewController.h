//
//  PhotoPickerDetailViewController.h
//  PhotoPicker
//
//  Created by cibdev on 16/5/16.
//  Copyright © 2016年 cibdev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoGroup.h"

@interface PhotoPickerDetailViewController : UIViewController

@property (strong ,nonatomic)PhotoGroup *group;

@property (nonatomic, assign) NSInteger maxSelectedCount;
@end
