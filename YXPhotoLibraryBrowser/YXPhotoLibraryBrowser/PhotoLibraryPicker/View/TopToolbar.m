//
//  TopToolbar.m
//  PhotoPicker
//
//  Created by cibdev on 16/5/20.
//  Copyright © 2016年 cibdev. All rights reserved.
//

#import "TopToolbar.h"

@interface TopToolbar ()

@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation TopToolbar
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64);
        self.backgroundColor = [UIColor clearColor];
        
        UIView *bgView = [[UIView alloc] initWithFrame:self.bounds];
        [bgView setBackgroundColor:[UIColor blackColor]];
        [bgView setAlpha:0.6];
        [self addSubview:bgView];
        
        self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.backBtn setFrame:CGRectMake(0, 20, 60, 50)];
        [self.backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 20, 25, 24)];
        [self.backBtn setImage:[UIImage imageNamed:@"btn_back_imagePicker"] forState:UIControlStateNormal];
        [self addSubview:self.backBtn];
        
        self.selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.selectBtn setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 40 - 15, 20, 40, 40)];
        [self.selectBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 8, 8, 0)];
        [self.selectBtn setImage:[UIImage imageNamed:@"checkbox_pic_non2"]forState:UIControlStateNormal];
        [self.selectBtn setImage:[UIImage imageNamed:@"checkbox_pic2"] forState:UIControlStateSelected];
        [self addSubview:self.selectBtn];

    }
    return self;
}

- (void)addTarget:(id)target backAction:(SEL)backAction selectAction:(SEL)selectAction forControlEvents:(UIControlEvents)controlEvents{
    [self.backBtn addTarget:target action:backAction forControlEvents:controlEvents];
    [self.selectBtn addTarget:target action:selectAction forControlEvents:controlEvents];
}

@end
