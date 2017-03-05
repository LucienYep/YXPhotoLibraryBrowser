//
//  PhotoPickerGroupViewController.m
//  PhotoPicker
//
//  Created by cibdev on 16/5/16.
//  Copyright © 2016年 cibdev. All rights reserved.
//

#import "PhotoPickerGroupViewController.h"
#import "AcquirePhotoResourceTool.h"
#import "PhotoGroup.h"
#import "PhotoPickerDetailViewController.h"

@interface PhotoPickerGroupViewController ()

@property (nonatomic,strong)NSArray *groups;

@end

@implementation PhotoPickerGroupViewController

-(instancetype)init
{
    if (self = [super init]) {
        [self setupData];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"照片";
    [self addNavBarCancelButton];
}

#pragma mark -  初始化数据,获取所有的照片组

- (void)setupData
{
    __weak typeof(self) _self = self;
    __block PhotoGroup *group = nil;
    [[AcquirePhotoResourceTool sharedInstance] getAllGroupWithPhoto:^(NSArray *groups) {
        if (groups.count) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.groups = [[groups reverseObjectEnumerator] allObjects];
                for (PhotoGroup *photoGroup in groups) {
                    if ([photoGroup.groupName isEqualToString:@"相机胶卷"] || [photoGroup.groupName isEqualToString:@"Camera Roll"]) {
                        group = photoGroup;
                        break;
                    }
                }
                if (!group) {
                    group = [groups lastObject];
                }
                //获取完直接跳到图片列表界面
                PhotoPickerDetailViewController *detailVC = [[PhotoPickerDetailViewController alloc] init];
                if (self.maxSelectedCount) {
                    detailVC.maxSelectedCount = self.maxSelectedCount;
                }
                detailVC.group = group;
                [_self.navigationController pushViewController:detailVC animated:NO];
            });
        }
    }];

}

-(void)setGroups:(NSArray *)groups
{
    _groups = groups;
    [self.tableView reloadData];
}

- (void)addNavBarCancelButton{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    [button setTitleColor:[UIColor colorWithRed:21.0/255.0 green:126/255.0 blue:255.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    button.titleEdgeInsets = UIEdgeInsetsMake(3.0, 0, 0, 0);
    button.frame = CGRectMake(0, 0, 40.0f, 28.0f);
    
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(cancelBtnTouched) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barbutton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = barbutton;
}

- (void)cancelBtnTouched {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.groups.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"photoGroup";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    PhotoGroup *group = self.groups[indexPath.row];
    if ([group.groupName isEqualToString:@"Camera Roll"]) {
        cell.textLabel.text = @"相机胶卷";
    }else if ([group.groupName isEqualToString:@"My Photo Stream"]){
        cell.textLabel.text = @"我的照片流";
    }else{
        cell.textLabel.text = group.groupName;
    }
    
    cell.imageView.image = group.thumbImage;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"(%ld)",(long)group.assetsCount];
    if (group.assetsCount) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoGroup *group = self.groups[indexPath.row];
    PhotoPickerDetailViewController *detailVC = [[PhotoPickerDetailViewController alloc] init];
    if (self.maxSelectedCount) {
        
        detailVC.maxSelectedCount = self.maxSelectedCount;
    }
    detailVC.group = group;
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

@end
