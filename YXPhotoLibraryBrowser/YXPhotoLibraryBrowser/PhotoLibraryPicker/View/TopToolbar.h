//
//  TopToolbar.h
//  PhotoPicker
//
//  Created by cibdev on 16/5/20.
//  Copyright © 2016年 cibdev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopToolbar : UIView

@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *selectBtn;

@property (assign, nonatomic)BOOL hiddenStatus;

- (void)addTarget:(id)target backAction:(SEL)backAction selectAction:(SEL)selectAction forControlEvents:(UIControlEvents)controlEvents;

@end
