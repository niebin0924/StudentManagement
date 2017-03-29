//
//  PhotoGroupViewController.m
//  StudentManagement
//
//  Created by Kitty on 17/3/28.
//  Copyright © 2017年 Kitty. All rights reserved.
//

#import "PhotoGroupViewController.h"
#import "PhotoAssetViewController.h"
#import "AssetCollectionViewCell.h"
#import "NBPhotoPickerDatas.h"
#import "NBPhotoPickerGroup.h"

@interface PhotoGroupViewController () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    CGFloat _itemW;
    CGFloat _itemH;
}

@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic, copy) NSString *selectGroupURL;

@end

@implementation PhotoGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = KblackgroundColor;
    self.title = @"选择相册";
    //    self.dataArray = [NSMutableArray array];
    
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied) {
        // 判断没有权限获取用户相册的话，就提示个View
        UIImageView *lockView = [[UIImageView alloc] init];
        lockView.image = [UIImage imageNamed:@"lock.png"];
        lockView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 200);
        lockView.contentMode = UIViewContentModeCenter;
        [self.view addSubview:lockView];
        
        UILabel *lockLbl = [[UILabel alloc] init];
        lockLbl.text = @"您屏蔽了选择相册的权限，开启请去系统设置->隐私->我的App来打开权限";
        lockLbl.numberOfLines = 0;
        lockLbl.textAlignment = NSTextAlignmentCenter;
        lockLbl.frame = CGRectMake(20, 0, self.view.frame.size.width - 40, self.view.frame.size.height);
        [self.view addSubview:lockLbl];
    }else{
        [self initCollectionView];
        // 获取图片
        [self getImgGruop];
    }
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
    //    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerNib:[UINib nibWithNibName:@"AssetCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
    [self.view addSubview:_collectionView];
}

#pragma mark - 权限
/*
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
            [self getImgGruop];
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
                    [self getImgGruop];
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
*/
 
- (void)getImgGruop
{
    NBPhotoPickerDatas *datas = [NBPhotoPickerDatas defaultPicker];
    __weak typeof(self) weakSelf = self;
    
    // 获取所有的图片URLs
    [datas getAllGroupWithPhotos:^(NSArray *groups) {
        self.dataArray = [[groups reverseObjectEnumerator] allObjects];
        
        //        [self gotoHistoryGroup];
        
        weakSelf.collectionView.dataSource = self;
        [weakSelf.collectionView reloadData];
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
    
    NBPhotoPickerGroup *group = self.dataArray[indexPath.item];
   
    cell.nameLabel.text = [NSString stringWithFormat:@"%@  %ld张",group.groupName, group.assetsCount];
    cell.imgView.image = group.thumbImage;
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NBPhotoPickerGroup *group = self.dataArray[indexPath.item];
    self.selectGroupURL = [[group.group valueForProperty:ALAssetsGroupPropertyURL] absoluteString];
    
    PhotoAssetViewController *vc = [[PhotoAssetViewController alloc] init];
    vc.selectedAssetsBlock = ^(NSMutableArray *selectedAssets){
        //回传选择的照片，实现选择记忆
        self.selectAsstes = selectedAssets;
    };
    vc.selectPickerAssets = self.selectAsstes;
    vc.assetsGroup = group;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)dealloc
{
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;
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
