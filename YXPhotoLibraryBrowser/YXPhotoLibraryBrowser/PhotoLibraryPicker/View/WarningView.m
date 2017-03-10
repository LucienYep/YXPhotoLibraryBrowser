//
//  WarningView.m
//  Picker
//
//  Created by cib on 2017/3/9.
//  Copyright © 2017年 cib. All rights reserved.
//

#import "WarningView.h"

@interface WarningView ()
@property (nonatomic ,weak) UILabel *alertLabel;

@end

static WarningView *_warningView = nil;
@implementation WarningView

+ (instancetype)sharedWarningView
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _warningView = [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _warningView.backgroundColor = [UIColor colorWithWhite:.2 alpha:.35];
        _warningView.userInteractionEnabled = false;
        [_warningView setupAlertView];
    });
    return _warningView;
}


- (void)setupAlertView
{
    UILabel *alertLabel = [[UILabel alloc] init];
    self.alertLabel = alertLabel;
    NSString *formatStr = @" 您的操作暂时无法完成 ";
    _alertLabel.text = formatStr;
    [_alertLabel sizeToFit];
    _alertLabel.center = self.center;
    alertLabel.textColor = [UIColor whiteColor];
    alertLabel.backgroundColor = [UIColor blackColor];
    alertLabel.layer.cornerRadius = 5;
    alertLabel.layer.masksToBounds = true;
    [self addSubview:alertLabel];
}

-(void)setWarningStr:(NSString *)warningStr
{
    _warningStr = warningStr;
    _warningView.superview.userInteractionEnabled = false;
    _warningView.alpha = 1.0;
    NSString *formatStr = [NSString stringWithFormat:@" %@ ",self.warningStr];
    _alertLabel.text = formatStr;
   
    CGFloat translationOffset = 30;
    CGFloat shakeDuration = 0.15;
    float repeatCount = 2;
    CAKeyframeAnimation *ani = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation"];
    ani.values = @[@0,@(-translationOffset),@0,@(translationOffset),@0];
    ani.duration = shakeDuration;
    ani.repeatCount = repeatCount;
    [_alertLabel.layer addAnimation:ani forKey:nil];
    
    CGFloat alphaDuration = 1.0;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(alphaDuration/2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       
        [UIView animateWithDuration:alphaDuration animations:^{
            _warningView.alpha = 0.0;
        } completion:^(BOOL finished) {
             _warningView.superview.userInteractionEnabled = true;
             [_warningView removeFromSuperview];
        }];
        
    });
}


@end
