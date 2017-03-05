//
//  ThumbPhotoCollectionViewCell.m
//  PhotoPicker
//
//  Created by cibdev on 16/5/16.
//  Copyright © 2016年 cibdev. All rights reserved.
//

#import "ThumbPhotoCollectionViewCell.h"

@interface ThumbPhotoCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;

//@property (weak, nonatomic) IBOutlet UIButton *selectedButton;

@end

@implementation ThumbPhotoCollectionViewCell

- (IBAction)selectedClick:(UIButton *)sender {

//    self.btnSelected = sender.selected;
    if (self.selectedCallback) {
        self.selectedCallback(sender.selected);
    }

}

-(void)setAsset:(PhotoAsset *)asset
{
    _asset = asset;
    self.full = NO;
    self.selectedButton.selected = self.btnSelected;
    self.thumbImageView.image = [asset thumbImage];
    
}

@end
