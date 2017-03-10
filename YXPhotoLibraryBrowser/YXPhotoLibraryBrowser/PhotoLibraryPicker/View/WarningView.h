//
//  WarningView.h
//  Picker
//
//  Created by cib on 2017/3/9.
//  Copyright © 2017年 cib. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WarningView : UIView

+ (instancetype)sharedWarningView;

@property (copy ,nonatomic)NSString *warningStr;

@end
