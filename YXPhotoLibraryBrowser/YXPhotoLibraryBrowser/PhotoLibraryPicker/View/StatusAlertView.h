//
//  StatusAlertView.h
//  Picker
//
//  Created by cib on 2017/3/9.
//  Copyright © 2017年 cib. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatusAlertView : UILabel

+ (instancetype)sharedStatusAlertView;

- (void)show;

@property (copy ,nonatomic)NSString *statusStr;

@end
