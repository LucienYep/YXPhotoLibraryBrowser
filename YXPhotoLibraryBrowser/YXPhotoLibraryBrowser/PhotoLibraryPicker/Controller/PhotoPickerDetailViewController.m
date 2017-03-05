//
//  PhotoPickerDetailViewController.m
//  PhotoPicker
//
//  Created by cibdev on 16/5/16.
//  Copyright © 2016年 cibdev. All rights reserved.
//

#import "PhotoPickerDetailViewController.h"
#import "ThumbPhotoCollectionViewCell.h"
#import "CollectionReusableView.h"
#import "AcquirePhotoResourceTool.h"
#import "PhotoAsset.h"
#import "PhotoBrowserViewController.h"

static CGFloat YX_CELL_ROW = 4;
static CGFloat YX_CELL_MARGIN = 2;
static CGFloat YX_CELL_LINE_MARGIN = 2;
static CGFloat YX_TOOLBAR_HEIGHT = 44;

static NSString *const _cellIdentifier = @"reuseCell";
static NSString *const _footerIdentifier = @"FooterView";

//消息名,外部监听这个消息即可获得选中的图片
NSString * const sendSelectImageNotification = @"SendSelectImageNotification";

@interface PhotoPickerDetailViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic , weak) UIToolbar *toolBar;
@property (nonatomic , strong) UIButton *sendBtn;
@property (nonatomic , strong) NSMutableArray *assets;
@property (nonatomic ,assign) BOOL firstLoad;
@property (strong ,nonatomic)NSMutableArray *selectedArray;
@property (strong ,nonatomic)NSMutableDictionary *selectDic;
@end

@implementation PhotoPickerDetailViewController

-(instancetype)init{
    if (self = [super init]) {
        [self setupAssets];
    }
    return self;
}

#pragma mark - view生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self.group.groupName isEqualToString:@"Camera Roll"]) {
        self.title = @"相机胶卷";
    }else if ([self.group.groupName isEqualToString:@"My Photo Stream"]){
        self.title = @"我的照片流";
    }else{
        self.title = self.group.groupName;
    }
    
    [self setupToorBar];
    [self setupCollectionView];
    [self addNavBarCancelButton];
 
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.collectionView reloadData];
}


#pragma mark - 初始化数据,获取该组里面的所有图片

- (void)setupAssets
{
    if (!self.assets) {
        self.assets = [NSMutableArray array];
    }
   
    __block NSMutableArray *assetsM = [NSMutableArray array];
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [[AcquirePhotoResourceTool sharedInstance] getPhotosWithGroup:self.group callback:^(NSArray *assets) {
            [assets enumerateObjectsUsingBlock:^(ALAsset *asset, NSUInteger idx, BOOL *stop) {
                PhotoAsset *photoAsset = [[PhotoAsset alloc] init];
                photoAsset.asset = asset;
                [assetsM addObject:photoAsset];
            }];
            weakSelf.assets = assetsM;

        }];
    });
    
}

#pragma mark - 初始化UI

- (void)setupCollectionView
{
    CGFloat cellW = (self.view.frame.size.width - YX_CELL_MARGIN * YX_CELL_ROW + 1) / YX_CELL_ROW;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(cellW, cellW);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = YX_CELL_LINE_MARGIN;
    layout.footerReferenceSize = CGSizeMake(self.view.frame.size.width, YX_TOOLBAR_HEIGHT * 2);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.frame = self.view.bounds;
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    self.collectionView = collectionView;
    collectionView.contentInset = UIEdgeInsetsMake(0, 0, YX_TOOLBAR_HEIGHT * 2 , 0);
    [self.view insertSubview:collectionView belowSubview:self.toolBar];
    
    UINib *thumbPhotoNib = [UINib nibWithNibName:@"ThumbPhotoCollectionViewCell" bundle:nil];
    [collectionView registerNib:thumbPhotoNib forCellWithReuseIdentifier:_cellIdentifier];
    
    UINib *nib = [UINib nibWithNibName:@"CollectionReusableView" bundle:nil];
    [collectionView registerNib:nib forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:_footerIdentifier];
    
}

- (void)addNavBarCancelButton{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    [button setTitleColor:[UIColor colorWithRed:21.0/255.0 green:126/255.0 blue:255.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    button.titleEdgeInsets = UIEdgeInsetsMake(5.0, 0, 0, 0);
    button.frame = CGRectMake(0, 0, 40, 28.0f);
    
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(cancelBtnTouched) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barbutton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = barbutton;
}

- (void) setupToorBar{
    UIToolbar *toorBar = [[UIToolbar alloc] init];
    toorBar.translatesAutoresizingMaskIntoConstraints = NO;
    toorBar.barStyle = UIBarStyleBlackTranslucent;
    [self.view addSubview:toorBar];
    self.toolBar = toorBar;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(toorBar);
    NSString *widthVfl =  @"H:|-0-[toorBar]-0-|";
    NSString *heightVfl = @"V:[toorBar(44)]-0-|";
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:widthVfl options:0 metrics:0 views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:heightVfl options:0 metrics:0 views:views]];
    
    // 左视图 中间距 右视图
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *fiexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.sendBtn];
    self.sendBtn.enabled = NO;
    
    toorBar.items = @[leftItem,fiexItem,rightItem];
    
}


#pragma mark - lazy load

-(void)setAssets:(NSMutableArray *)assets
{
    _assets = assets;
    if (assets.count) {
        [self.collectionView reloadData];
    }
}
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

- (UIButton *)sendBtn{
    if (!_sendBtn) {
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        rightBtn.enabled = NO;
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        rightBtn.frame = CGRectMake(0, 0, 60, 45);
        NSString *title = [NSString stringWithFormat:@"发送(%d)",0];
        [rightBtn setTitle:title forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(sendBtnTouched) forControlEvents:UIControlEventTouchUpInside];
        self.sendBtn = rightBtn;
    }
    return _sendBtn;
}

#pragma mark - clickAction

/**
 发送操作
 */
- (void)sendBtnTouched {
    
    NSMutableArray *imageList = [NSMutableArray array];
    for (PhotoAsset *asset in self.selectedArray) {
        [imageList addObject:asset.compressionImage];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:sendSelectImageNotification object:self userInfo:@{@"imagelist":[imageList copy]}];
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)cancelBtnTouched {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.assets.count;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ThumbPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_cellIdentifier forIndexPath:indexPath];
    PhotoAsset *asset = self.assets[indexPath.item];
    __weak typeof (self) _self = self;
    __weak typeof (cell) _cell = cell;
    //选择与撤销选中图片操作
    cell.selectedCallback = ^(BOOL selected){
        
        if (!selected) {
            
            NSInteger maxSelectedCount = self.maxSelectedCount ? self.maxSelectedCount : kDefaultMaxSelectedCount;
            if (_self.selectedArray.count >= maxSelectedCount) {
          
                Alert(@"最多可选择%ld张图片",maxSelectedCount);

            }else{
                [_self.selectedArray addObject:asset];
                [_self.selectDic setObject:@(YES) forKey:indexPath];
                _cell.selectedButton.selected = ! _cell.selectedButton.selected;
       
            }
      
        }else{
      
            [_self.selectDic removeObjectForKey:indexPath];
            [_self.selectedArray removeObject:asset];
            _cell.selectedButton.selected = ! _cell.selectedButton.selected;
        }
        
        [_self updateToolbar];
        return (int)self.selectedArray.count;
    };
    if ([self.selectDic objectForKey:indexPath]) {
        cell.btnSelected = YES;
    }else{
        cell.btnSelected = NO;
    }
    
    cell.asset = asset;
    
    return cell;
}
//更新发送btn文字
- (void)updateToolbar
{
    if (!self.selectedArray.count) {
        self.sendBtn.enabled = NO;
    }else{
        self.sendBtn.enabled = YES;
    }
    [self.sendBtn setTitle:[NSString stringWithFormat:@"发送(%ld)",self.selectedArray.count] forState:UIControlStateNormal];
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    CollectionReusableView *footer = nil;
    if (kind == UICollectionElementKindSectionFooter) {
       footer  = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:_footerIdentifier forIndexPath:indexPath];
//        footer.backgroundColor = [UIColor blueColor];
        footer.countLabel.text = [NSString stringWithFormat:@"共%ld张图片",self.assets.count];
    }
    return footer;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PhotoBrowserViewController *browzerVC = [[PhotoBrowserViewController alloc] initWithIndex:indexPath.item];
    if (self.maxSelectedCount) {
        browzerVC.maxSelectedCount = self.maxSelectedCount;
    }
    browzerVC.photoAssets = [self.assets copy];
    __weak typeof(self) _self = self;
    browzerVC.selectItemCallback = ^(NSMutableDictionary *selectDic,NSMutableArray *selectArray){
        _self.selectedArray = selectArray;
        _self.selectDic = selectDic;
        [_self updateToolbar];
    };
    if (self.selectedArray.count) {
        browzerVC.selectedArray = self.selectedArray;
    }
    if (self.selectDic.count) {
        browzerVC.selectDic = self.selectDic;
    }
    [self presentViewController:browzerVC animated:YES completion:nil];
}

#pragma mark - 布局子控件
-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    //直接滑动到该组最后的图片位置
    if (self.collectionView.contentSize.height > [[UIScreen mainScreen] bounds].size.height && self.assets.count && !self.firstLoad) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.assets.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
        self.collectionView.contentOffset = CGPointMake(self.collectionView.contentOffset.x, self.collectionView.contentOffset.y + 100);
        self.firstLoad = YES;
    }
}

-(void)dealloc
{
    
}
@end
