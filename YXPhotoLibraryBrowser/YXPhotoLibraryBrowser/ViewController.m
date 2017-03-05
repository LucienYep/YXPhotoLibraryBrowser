//
//  ViewController.m
//  YXPhotoLibraryBrowser
//
//  Created by yexingxing on 2017/3/1.
//  Copyright © 2017年 Lucien. All rights reserved.
//

#import "ViewController.h"
#import "PhotoPickerGroupViewController.h"

extern NSString * sendSelectImageNotification;
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getImages:) name:sendSelectImageNotification object:nil];
}

- (void)getImages:(NSNotification *)notify
{
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    PhotoPickerGroupViewController *groupVC = [[PhotoPickerGroupViewController alloc] init];
    groupVC.maxSelectedCount = 5;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:groupVC];
    [self presentViewController:nav animated:true completion:nil];
}


@end

