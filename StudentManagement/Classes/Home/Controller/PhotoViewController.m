//
//  PhotoViewController.m
//  StudentManagement
//
//  Created by Kitty on 17/2/24.
//  Copyright © 2017年 Kitty. All rights reserved.
//

#import "PhotoViewController.h"
#import "PhotoCollectionViewCell.h"
#import "LoadMoreCollectionViewCell.h"
#import "NBAblumTool.h"
#import "Homework.h"
#import <Photos/Photos.h>

@interface PhotoViewController () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSInteger _currPage;
    NSInteger _pageSize;
    NSInteger _selCount; // 选择图片的数量
    NSMutableArray *_photoArr;// 存放图片数组
    CGFloat _itemW;
    CGFloat _itemH;
}

@property (nonatomic,strong) NSMutableDictionary *cellDict;
@property (nonatomic,strong) NSMutableArray *allArray;
@property (nonatomic,strong) NSMutableArray *selectArray;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) NSMutableArray *thumbnailArray;
@property (nonatomic,strong) NSMutableArray *originalArray;

@end

@implementation PhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = KblackgroundColor;
    self.title = @"相册";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(sureClick)];
    
    [self initData];
    
    [self initCollectionView];
    
    PHAssetCollection *collection = self.ablumList.assetCollection;
    NSArray<PHAsset *> *assets = [[NBAblumTool sharePhotoTool] getAssetsInAssetCollection:collection ascending:NO];
    [self addModelData:assets Original:YES];
    
    [self loadMore];
}

- (void)initData
{
    _currPage = 0;
    _pageSize = 8;
    _selCount = 0;
    self.allArray = [NSMutableArray array];
    self.dataArray = [NSMutableArray array];
    self.selectArray = [NSMutableArray array];
    self.thumbnailArray = [NSMutableArray array];
    self.originalArray = [NSMutableArray array];
    self.cellDict = [NSMutableDictionary dictionary];
}

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
    [_collectionView registerNib:[UINib nibWithNibName:@"LoadMoreCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"loadMoreCell"];
    [self.view addSubview:_collectionView];
}

- (void)addModelData:(NSArray<PHAsset *> *)assets Original:(BOOL)original
{
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 同步获得图片, 只会返回1张图片
    options.synchronous = YES;
    
    for (PHAsset *asset in assets) {
        
        // 是否要原图
        CGSize size = original ? CGSizeMake(asset.pixelWidth, asset.pixelHeight) : CGSizeZero;
        
        // 从asset中获得图片
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            
            Homework *modal = [[Homework alloc] init];
            modal.img = result;
            modal.imageUrlStr = @"";
            modal.isSel = NO;
            modal.homeworkId = @"";
            modal.homeworkName = [asset valueForKey:@"filename"];
            [self.allArray addObject:modal];
//            NSLog(@"UIImage:%@, fileName:%@", result, [asset valueForKey:@"filename"]);
        }];
    }
}

#pragma mark - click
- (void)sureClick
{
    _photoArr = [NSMutableArray array];
    for (Homework *modal in self.dataArray) {
        if (modal.isSel) {
            [_photoArr addObject:modal];
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:OpenHomeworkNotification object:_photoArr];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_pageSize >= self.allArray.count) {
        return self.dataArray.count;
    }
    return self.dataArray.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.dataArray.count) {
        LoadMoreCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"loadMoreCell" forIndexPath:indexPath];
        
        return cell;
    }
    
    static NSString *identifier = @"photoCell";
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    [self.cellDict setObject:cell forKey:indexPath];
    cell.selectBtn.tag = 10 + indexPath.item;
//    [cell.selectBtn addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
    
    Homework *modal = self.dataArray[indexPath.item];
    cell.photoImageView.image = modal.img;
    cell.selectBtn.selected = modal.isSel;
    
    
    return cell;
}


#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.dataArray.count) {
        [collectionView deselectItemAtIndexPath:indexPath animated:YES];
        if (_currPage*_pageSize >= self.allArray.count) {
            [SVProgressHUD showSuccessWithStatus:@"无更多图片"];
        }else{
            [self performSelectorInBackground:@selector(loadMore) withObject:nil];
        }
        
        
        return;
    }
    
    if (self.cellDict) {
        
        PhotoCollectionViewCell *cell = self.cellDict[indexPath];
        
        cell.selectBtn.selected = !cell.selectBtn.selected;
        //        [cell.selectBtn addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
        
        Homework *modal = self.dataArray[indexPath.item];
        modal.isSel = cell.selectBtn.selected;
        
        if (cell.selectBtn.selected) {
            _selCount ++;
        }else{
            _selCount --;
        }
        [cell.selectBtn setTitle:[NSString stringWithFormat:@"√"] forState:UIControlStateSelected];
        
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)loadMore
{
    NSLog(@"loadMore.....");
    NSInteger count;
    NSMutableArray *more = [NSMutableArray array];
    if (_currPage*_pageSize+_pageSize > self.allArray.count) {
        count = self.allArray.count;
    }else{
        count = _currPage*_pageSize+_pageSize;
    }
    for (NSInteger i=_currPage*_pageSize; i<count; i++) {
        [more addObject:self.allArray[i]];
    }
    _currPage ++;
    //加载你的数据
    [self performSelectorOnMainThread:@selector(appendTableWith:) withObject:more waitUntilDone:NO];
}

- (void)appendTableWith:(NSMutableArray *)data
{
    for (int i=0; i<[data count]; i++) {
        [self.dataArray addObject:[data objectAtIndex:i]];
    }
    NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:data.count];
    for (int ind = 0; ind < [data count]; ind++) {
        NSIndexPath *newPath =  [NSIndexPath indexPathForRow:[self.dataArray indexOfObject:[data objectAtIndex:ind]] inSection:0];
        [insertIndexPaths addObject:newPath];
    }
    
//    dispatch_async(dispatch_get_main_queue(), ^{
    
        [self.collectionView insertItemsAtIndexPaths:insertIndexPaths];
//    [self.collectionView reloadItemsAtIndexPaths:insertIndexPaths];
//    });
    
}

#pragma mark - UICollectionViewDelegateFlowLayout
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([UIScreen mainScreen].bounds.size.width > 1024){
//        return CGSizeMake((SCREENWIDTH-20*6)/5, (SCREENWIDTH-20*6)/5*1.1);
//    }
//    return CGSizeMake((SCREENWIDTH-20*5)/4, (SCREENWIDTH-20*5)/4*1.1);
//}
//
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(20, 20, 20, 20);
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 20;
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 20;
//}


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
