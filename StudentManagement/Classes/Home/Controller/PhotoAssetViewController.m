//
//  PhotoAssetViewController.m
//  StudentManagement
//
//  Created by Kitty on 17/3/22.
//  Copyright © 2017年 Kitty. All rights reserved.
//

#import "PhotoAssetViewController.h"
#import "PhotoCollectionViewCell.h"
#import "AssetHeaderCollectionReusableView.h"
#import "NBPhotoPickerDatas.h"
#import "NBPhotoPickerGroup.h"
#import "NBPhotoAssets.h"
#import "Homework.h"


@interface PhotoAssetViewController () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    CGFloat _itemW;
    CGFloat _itemH;
    NSInteger _selCount; // 选择图片的数量
    BOOL _isFirstLoadding;
    NSMutableArray *_photoArr;// 存放图片数组
}

@property (nonatomic,strong) NSMutableDictionary *cellDict;
@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) NSMutableArray *assets;
@property (nonatomic,strong) NSMutableArray<NBPhotoAssets*> *selectAssets;

@end

@implementation PhotoAssetViewController

- (void)viewWillAppear:(BOOL)animated
{
//    [self.collectionView reloadData];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    // 赋值给上一个控制器,以便记录上次选择的照片
    if (self.selectedAssetsBlock) {
        self.selectedAssetsBlock(self.selectAssets);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(sureClick)];
    
    self.dataArray = [NSMutableArray array];
    _selCount = 0;
    self.cellDict = [NSMutableDictionary dictionary];
    
    [self initCollectionView];
    
    // 获取相册
    [self setupAssets];
}

#pragma mark - click
- (void)sureClick
{
    _photoArr = [NSMutableArray array];
    for (NBPhotoAssets *asset in self.dataArray) {
        if (asset.isSel) {
            Homework *modal = [[Homework alloc] init];
            modal.img = asset.compressionImage;
            modal.imageName = @"";
            modal.isSel = asset.isSel;
            //asset.assetURL: assets-library://asset/asset.JPG?id=2D08F9F8-9B8F-4C31-8E2C-03099CEAB42D&ext=JPG
            [_photoArr addObject:modal];
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:OpenHomeworkNotification object:_photoArr];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

#pragma mark - getter && setter
- (NSMutableArray *)selectAssets{
    if (!_selectAssets) {
        _selectAssets = [NSMutableArray array];
    }
    return _selectAssets;
}

- (void)setSelectPickerAssets:(NSArray *)selectPickerAssets{
    
//    if (selectPickerAssets == nil) {
//        return;
//    }
    
    NSSet *set = [NSSet setWithArray:selectPickerAssets];
    _selectPickerAssets = [set allObjects];
    
    if (!self.assets) {
        self.assets = [NSMutableArray arrayWithArray:selectPickerAssets];
    }else{
        [self.assets addObjectsFromArray:selectPickerAssets];
    }
    
    self.selectAssets = [selectPickerAssets mutableCopy];
//    self.collectionView.lastDataArray = nil;
//    self.collectionView.isRecoderSelectPicker = YES;
//    self.collectionView.selectAssets = self.selectAssets;
    NSInteger count = self.selectAssets.count;
    
    
}

- (void)setAssetsGroup:(NBPhotoPickerGroup *)assetsGroup{
    if (!assetsGroup.groupName.length) return ;
    
    _assetsGroup = assetsGroup;
    
    self.title = assetsGroup.groupName;
    
    // 获取Assets
    //    [self setupAssets];
}

#pragma mark - UI
- (void)initCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    if ([UIScreen mainScreen].bounds.size.width > 1024){
        _itemW = (SCREENWIDTH-20*6)/5;
        _itemH = (SCREENWIDTH-20*6)/5*1.1;
        
    }else{
        _itemW = (SCREENWIDTH-20*5)/4;
        _itemH = (SCREENWIDTH-20*5)/4*1.1;
    }
    layout.itemSize = CGSizeMake(_itemW, _itemH);
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerNib:[UINib nibWithNibName:@"PhotoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"photoCell"];
    [_collectionView registerClass:[AssetHeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerView"];
    [self.view addSubview:_collectionView];
}

- (void)layoutCollectionView
{
    if (!_isFirstLoadding && self.collectionView.contentSize.height > [[UIScreen mainScreen] bounds].size.height) {
        
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.dataArray.count-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
        // 展示图片数
        self.collectionView.contentOffset = CGPointMake(self.collectionView.contentOffset.x, self.collectionView.contentOffset.y+100);
        _isFirstLoadding = YES;
    }
}

#pragma mark 初始化所有的组
- (void) setupAssets{
    if (!self.assets) {
        self.assets = [NSMutableArray array];
    }
    
    __block NSMutableArray *assetsM = [NSMutableArray array];
    __weak typeof(self) weakSelf = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [[NBPhotoPickerDatas defaultPicker] getGroupPhotosWithGroup:self.assetsGroup finished:^(NSArray *assets) {
            
            [assets enumerateObjectsUsingBlock:^(ALAsset *asset, NSUInteger idx, BOOL *stop) {
                NBPhotoAssets *lgAsset = [[NBPhotoAssets alloc] init];
                lgAsset.asset = asset;
                lgAsset.isSel = NO;
                [assetsM addObject:lgAsset];
            }];
            weakSelf.dataArray = assetsM;
            [weakSelf.collectionView reloadData];
            [self.assets setArray:assetsM];
        }];
    });
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"photoCell";
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    [self.cellDict setObject:cell forKey:indexPath];
    
    NBPhotoAssets *asset = self.dataArray[indexPath.item];
    cell.photoImageView.image= asset.thumbImage;
    cell.selectBtn.selected = asset.isSel;
    
    [self layoutCollectionView];
    
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionFooter) {
        
        AssetHeaderCollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerView" forIndexPath:indexPath];
        footerView.count = self.dataArray.count;
        reusableView = footerView;
    }
    return reusableView;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.cellDict) {
        
        PhotoCollectionViewCell *cell = self.cellDict[indexPath];
        
        cell.selectBtn.selected = !cell.selectBtn.selected;
        //        [cell.selectBtn addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
        
        NBPhotoAssets *modal = self.dataArray[indexPath.item];
        modal.isSel = cell.selectBtn.selected;
        
        if (cell.selectBtn.selected) {
            _selCount ++;
        }else{
            _selCount --;
        }
        [cell.selectBtn setTitle:[NSString stringWithFormat:@"√"] forState:UIControlStateSelected];
        
    }
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    
    if (section == 0) {
        return CGSizeMake(self.view.frame.size.width, 100);
    }
    else {
        return CGSizeMake(0, 0);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
