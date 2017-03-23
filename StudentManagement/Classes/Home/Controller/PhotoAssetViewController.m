//
//  PhotoAssetViewController.m
//  StudentManagement
//
//  Created by Kitty on 17/3/22.
//  Copyright © 2017年 Kitty. All rights reserved.
//

#import "PhotoAssetViewController.h"
#import "PhotoViewController.h"
#import "AssetCollectionViewCell.h"
#import "NBAblumTool.h"

@interface PhotoAssetViewController () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    CGFloat _itemW;
    CGFloat _itemH;
}

@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UICollectionView *collectionView;

@end

@implementation PhotoAssetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = KblackgroundColor;
    self.title = @"选择相册";
    self.dataArray = [NSMutableArray array];
    
    [self initCollectionView];
    
    [self checkAuthorizationStatus_AfteriOS8];
}

- (void)initCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    if ([UIScreen mainScreen].bounds.size.width > 1024){
        _itemW = (SCREENWIDTH-20*5)/4;
        _itemH = (SCREENWIDTH-20*5)/4*0.9;
        
    }else{
        _itemW = (SCREENWIDTH-20*4)/3;
        _itemH = (SCREENWIDTH-20*4)/3*0.9;
    }
    layout.itemSize = CGSizeMake(_itemW, _itemH);
    layout.minimumLineSpacing = 20;
    layout.minimumInteritemSpacing = 20;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerNib:[UINib nibWithNibName:@"AssetCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
    [self.view addSubview:_collectionView];
}

#pragma mark - 权限
- (void)checkAuthorizationStatus_AfteriOS8
{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    switch (status)
    {
        case PHAuthorizationStatusNotDetermined:
        {
            [self requestAuthorizationStatus_AfteriOS8];
            break;
        }
        case PHAuthorizationStatusRestricted:
        case PHAuthorizationStatusDenied:
        {
            break;
        }
        case PHAuthorizationStatusAuthorized:
        default:
        {
            [self.dataArray addObjectsFromArray:[[NBAblumTool sharePhotoTool] getPhotoAblumList]];
            [self.collectionView reloadData];
            break;
        }
    }
}

- (void)requestAuthorizationStatus_AfteriOS8
{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (status) {
                case PHAuthorizationStatusAuthorized:
                {
                    [self.dataArray addObjectsFromArray:[[NBAblumTool sharePhotoTool] getPhotoAblumList]];
                    [self.collectionView reloadData];
                    break;
                }
                default:
                {
                    break;
                }
            }
        });
    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    AssetCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    cell.bgView.layer.borderColor = [KblackgroundColor CGColor];
    cell.bgView.layer.borderWidth = 1.f;
    
    NBAblumList *list = self.dataArray[indexPath.item];
    PHAsset *asset = list.headImageAsset;
    cell.nameLabel.text = [NSString stringWithFormat:@"%@  %ld张",list.title, list.count];
    [self getImageWithAsset:asset completion:^(UIImage *image) {
        cell.imgView.image = image;
    }];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NBAblumList *list = self.dataArray[indexPath.item];
    PhotoViewController *vc = [[PhotoViewController alloc] init];
    vc.ablumList = list;
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - private
//从这个回调中获取所有的图片
- (void)getImageWithAsset:(PHAsset *)asset completion:(void (^)(UIImage *image))completion
{
    CGSize size = [self getSizeWithAsset:asset];
    [[NBAblumTool sharePhotoTool] requestImageForAsset:asset size:size resizeMode:PHImageRequestOptionsResizeModeFast completion:completion];
}
#pragma mark - 获取图片及图片尺寸的相关方法
- (CGSize)getSizeWithAsset:(PHAsset *)asset
{
    CGFloat width  = (CGFloat)asset.pixelWidth;
    CGFloat height = (CGFloat)asset.pixelHeight;
    CGFloat scale = MIN(width, height)/MAX(width, height);
    
    return CGSizeMake(self.collectionView.frame.size.height*scale, self.collectionView.frame.size.height);
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
