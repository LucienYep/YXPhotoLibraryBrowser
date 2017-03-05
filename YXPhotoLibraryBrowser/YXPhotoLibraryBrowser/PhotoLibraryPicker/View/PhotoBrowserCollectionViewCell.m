//
//  PhotoBrowserCollectionViewCell.m
//  PhotoPicker
//
//  Created by cibdev on 16/5/17.
//  Copyright © 2016年 cibdev. All rights reserved.
//

#import "PhotoBrowserCollectionViewCell.h"

#define screenW [UIScreen mainScreen].bounds.size.width
#define screenH [UIScreen mainScreen].bounds.size.height

@interface PhotoBrowserCollectionViewCell ()<UIScrollViewDelegate>

@property (nonatomic,strong)UIImageView *iconView;
@property (nonatomic,strong)UIScrollView *scrollView;

@end

@implementation PhotoBrowserCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    self.scrollView = scrollView;
    scrollView.frame = [UIScreen mainScreen].bounds;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.delegate = self;
    scrollView.maximumZoomScale = 2.5;
    scrollView.minimumZoomScale = 1.0;
    [self.contentView addSubview:scrollView];
    
    UIImageView *iconView = [[UIImageView alloc] init];
    self.iconView = iconView;
    [scrollView addSubview:iconView];
}

-(void)setAsset:(PhotoAsset *)asset
{
    _asset = asset;

    [self resetSetting];
    
    UIImage *orginalImage = [asset originImage];
    
    self.iconView.image = orginalImage;
    
    [self displayImage];
}

- (void)displayImage
{
    UIImage *image = self.iconView.image;
    if (!image) {
        self.iconView.frame = self.scrollView.frame;
        return;
    }
    CGFloat scale = image.size.height / image.size.width;
    
    CGFloat height = screenW * scale;
    
    self.iconView.frame = CGRectMake(0, 0, screenW, height);
    
    if (height < screenH) {
        
        CGFloat y = (screenH - height) * 0.5;
        
        self.scrollView.contentInset = UIEdgeInsetsMake(y, 0, y, 0);
    }else{
        
        self.scrollView.contentSize = CGSizeMake(0, height);
    }
}

-(void)resetSetting
{
    // 重置scrollview
    self.scrollView.contentInset = UIEdgeInsetsZero;
    self.scrollView.contentOffset = CGPointZero;
    self.scrollView.contentSize = CGSizeZero;
    
    // 重置imageview
    self.iconView.transform = CGAffineTransformIdentity;
}

#pragma mark - UIScrollViewDelegate

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.iconView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    CGFloat offsetX = (screenW - view.frame.size.width) * 0.5;
    CGFloat offsetY = (screenH - view.frame.size.height) * 0.5;
    offsetX = offsetX < 0 ? 0 : offsetX;
    offsetY = offsetY < 0 ? 0 : offsetY;
    scrollView.contentInset = UIEdgeInsetsMake(offsetY, offsetX, offsetY, offsetX);
}

@end
