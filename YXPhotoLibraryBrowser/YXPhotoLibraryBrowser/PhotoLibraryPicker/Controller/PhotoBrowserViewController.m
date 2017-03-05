//
//  PhotoBrowserViewController.m
//  PhotoPicker
//
//  Created by cibdev on 16/5/17.
//  Copyright © 2016年 cibdev. All rights reserved.
//

#import "PhotoBrowserViewController.h"
#import "PhotoBrowserCollectionViewCell.h"
#import "TopToolbar.h"

static NSString *const _cellIdentifier = @"cell";

#define YX_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define YX_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define YX_MARGIN 5

@interface PhotoBrowserViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic ,assign)NSInteger index;
@property (strong ,nonatomic)UICollectionView *collectionView;
@property (strong ,nonatomic)TopToolbar *toolbar;
@property (assign, nonatomic)BOOL firstLoad;
@property (strong ,nonatomic)UILabel *indictorLabel;
@end

@implementation PhotoBrowserViewController

- (instancetype)initWithIndex:(NSInteger)index
{
    if (self = [super init]) {
        _index = index;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupCollectionView];
    [self setupTopToolbar];
    [self setupLabel];
    
}

#pragma mark - 初始化UI

- (void)setupLabel
{
    UILabel *indictorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80,21)];
    self.indictorLabel = indictorLabel;
    indictorLabel.center = CGPointMake(YX_SCREEN_WIDTH * 0.5, YX_SCREEN_HEIGHT * 0.95);
    [self.view addSubview:indictorLabel];
}

- (void)setupCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = [UIScreen mainScreen].bounds.size;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = YX_MARGIN;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.frame = CGRectMake(0, 0, YX_SCREEN_WIDTH + YX_MARGIN, YX_SCREEN_HEIGHT);
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.contentOffset = CGPointMake(_index * (YX_SCREEN_WIDTH+YX_MARGIN), 0);
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.pagingEnabled = YES;
    [collectionView registerClass:[PhotoBrowserCollectionViewCell class] forCellWithReuseIdentifier:_cellIdentifier];
    collectionView.bounces = NO;
    self.collectionView = collectionView;
    [self.view addSubview:collectionView];
    
    UITapGestureRecognizer *rec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toolbarHiddenOrNot)];
    [collectionView addGestureRecognizer:rec];
}

- (void)toolbarHiddenOrNot {
    self.toolbar.hiddenStatus = !self.toolbar.hiddenStatus;
    CGFloat duration = 0.5;
    if (self.toolbar.hiddenStatus) {
        [UIView animateWithDuration:duration animations:^{
            self.toolbar.alpha = 0;
        }];
    }else{
        [UIView animateWithDuration:duration animations:^{
            self.toolbar.alpha = 1.0;
        }];
    }
}

- (void)setupTopToolbar
{
    TopToolbar *toolbar = [[TopToolbar alloc] initWithFrame:CGRectMake(0, 0, YX_SCREEN_WIDTH, 64)];
    self.toolbar = toolbar;
    [toolbar addTarget:self backAction:@selector(backToPreVC) selectAction:@selector(selectedHandle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:toolbar];
}

#pragma mark - lazy load

-(NSMutableDictionary *)selectDic
{
    if (!_selectDic) {
        _selectDic = [NSMutableDictionary dictionary];
    }
    return _selectDic;
}

-(NSMutableArray *)selectedArray
{
    if (!_selectedArray) {
        _selectedArray = [NSMutableArray array];
    }
    return _selectedArray;
}

#pragma mark - clickAction

- (void)backToPreVC
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 
 图片的选择与撤销操作
 */
- (void)selectedHandle:(UIButton *)sender
{
    sender.selected = !sender.selected;
    PhotoBrowserCollectionViewCell *cell = [self getVisibleCell];
    if (cell) {
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
     
        if (sender.selected) {
            NSInteger maxSelectedCount = self.maxSelectedCount ? self.maxSelectedCount : kDefaultMaxSelectedCount;
            if (self.selectedArray.count >= maxSelectedCount) {
                
                Alert(@"最多可选择%ld张图片",maxSelectedCount);
                self.toolbar.selectBtn.selected = NO;
            }else{

                [self.selectedArray addObject:cell.asset];
                [self.selectDic setObject:@(YES) forKey:indexPath];
            }
        }else{
            [self.selectDic removeObjectForKey:indexPath];
            [self.selectedArray removeObject:cell.asset];
        }
        if (self.selectItemCallback) {
            self.selectItemCallback(self.selectDic,self.selectedArray);
        }

    }
    
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.photoAssets.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoBrowserCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_cellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor blackColor];
    PhotoAsset *asset = self.photoAssets[indexPath.item];
    if (!self.firstLoad) {
        if ([self.selectDic objectForKey:indexPath]) {
            self.toolbar.selectBtn.selected = YES;
        }
        self.firstLoad = YES;
        [self.indictorLabel setText:[NSString stringWithFormat:@"%d/ %d",(int)(indexPath.item + 1),(int)(self.photoAssets.count)]];
        
    }
    cell.asset = asset;
   
    return cell;
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //根据字典中IndexPath这个key判断当前图片是否被选中过
    dispatch_async(dispatch_get_main_queue(), ^{
        PhotoBrowserCollectionViewCell *cell = [self getVisibleCell];
        if (cell) {
            NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
            if ([self.selectDic objectForKey:indexPath]) {
                self.toolbar.selectBtn.selected = YES;
            }else{
                self.toolbar.selectBtn.selected = NO;
            }
            self.indictorLabel.text = [NSString stringWithFormat:@"%d / %d",(int)(indexPath.item + 1),(int)(self.photoAssets.count)];
        }

    });
}

-(PhotoBrowserCollectionViewCell *)getVisibleCell
{
    __block PhotoBrowserCollectionViewCell *cell = nil;
    [self.collectionView.visibleCells enumerateObjectsUsingBlock:^(__kindof PhotoBrowserCollectionViewCell *visibleCell, NSUInteger currentItem, BOOL * _Nonnull stop) {
        cell = visibleCell;
        *stop = YES;
    }];
    return cell;
}


@end
