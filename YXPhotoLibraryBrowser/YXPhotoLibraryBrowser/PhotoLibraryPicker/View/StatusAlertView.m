//
//  StatusAlertView.m
//  Picker
//
//  Created by cib on 2017/3/9.
//  Copyright © 2017年 cib. All rights reserved.
//

#import "StatusAlertView.h"

static StatusAlertView *_statusAlertView = nil;
@implementation StatusAlertView

+ (instancetype)sharedStatusAlertView
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _statusAlertView = [[self alloc] init];
        [_statusAlertView setup];
    });
    return _statusAlertView;
}

- (void)setup
{
    self.text = @" 发送成功 ";
    [self sizeToFit];
    self.textColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor blackColor];
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = true;
}

- (void)show
{
    self.text = self.statusStr.length ? [NSString stringWithFormat:@" %@ ",self.statusStr] : @" 发送成功 ";
    CGFloat duration = 1;
    self.alpha = 0.0;
    CGFloat translation = 50;
    [UIView animateWithDuration:duration * 0.8 animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, translation);
        self.alpha = 1.0;
        
    } completion:^(BOOL finished) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * 1.5* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:duration * 0.8 animations:^{
                
                self.transform = CGAffineTransformIdentity;
                self.alpha = 0.0;
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        });
        
    }];
}
@end
