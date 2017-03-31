//
//  PiZhuViewController.m
//  StudentManagement
//
//  Created by Kitty on 17/2/17.
//  Copyright © 2017年 Kitty. All rights reserved.
//

#import "PiZhuViewController.h"
#import "FEPlaceHolderTextView.h"
#import "TZTestCell.h"
#import "Mark.h"
#import "LGPhoto.h"


@interface PiZhuViewController () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIActionSheetDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,LGPhotoPickerViewControllerDelegate>
{
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    
    CGFloat _itemWH;
    CGFloat _margin;
}

@property (nonatomic, strong) FEPlaceHolderTextView *textView;
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) LGPhotoPickerViewController *pickerVc;

@property (nonatomic, assign) BOOL showTakePhotoBtnSwitch; // < 在内部显示拍照按钮
@property (nonatomic, assign) BOOL showSheetSwitch; // < 显示一个sheet,把拍照按钮放在外面


@end

@implementation PiZhuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"批注";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(sumbit)];
    
    [self initData];
    
    [self initTextView];
    
    [self configCollectionView];
}

//- (BOOL)shouldAutorotate {
//    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
//    
//    if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
//        return NO;
//    }
//    return  YES;
//}
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskLandscape;
//}
//
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
//{
//    return UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationLandscapeRight;
//}

- (LGPhotoPickerViewController *)pickerVc
{
    if (!_pickerVc) {
        self.pickerVc = [[LGPhotoPickerViewController alloc] initWithShowType:LGShowImageTypeImagePicker];
        self.pickerVc.status = PickerViewShowStatusCameraRoll;
        self.pickerVc.maxCount = 3;   // 最多能选3张图片
        self.pickerVc.delegate = self;
    }
    return _pickerVc;
}

- (void)initData
{
    _selectedPhotos = [NSMutableArray array];
    _selectedAssets = [NSMutableArray array];
    
    self.showTakePhotoBtnSwitch = YES;
    self.showSheetSwitch = NO;
    
    _margin = 10;
    _itemWH = (self.view.width - 3 * _margin - 10) / 4 - _margin;
}

- (void)initTextView
{
    self.textView = [[FEPlaceHolderTextView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-_itemWH-64-100)];
    self.textView.font = [UIFont systemFontOfSize:18];
    self.textView.textColor = [UIColor blackColor];
    self.textView.textAlignment = NSTextAlignmentLeft;
    self.textView.delegate = self;
    self.textView.scrollEnabled = YES;
    self.textView.placeholder = @"题目解析";
    [self.view addSubview:self.textView];
}

- (void)configCollectionView {
    // 如不需要长按排序效果，将LxGridViewFlowLayout类改成UICollectionViewFlowLayout即可
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.itemSize = CGSizeMake(_itemWH, _itemWH);
    layout.minimumInteritemSpacing = _margin;
    layout.minimumLineSpacing = _margin;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.textView.frame), self.view.width, _itemWH+20) collectionViewLayout:layout];
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
}

/*
- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}
*/

#pragma mark - UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _selectedPhotos.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    cell.videoImageView.hidden = YES;
    if (indexPath.row == _selectedPhotos.count) {
        cell.imageView.image = [UIImage imageNamed:@"add_pic"];
        cell.deleteBtn.hidden = YES;
        cell.gifLable.hidden = YES;
    } else {
        cell.imageView.image = _selectedPhotos[indexPath.row];
        cell.asset = _selectedAssets[indexPath.row];
        cell.deleteBtn.hidden = NO;
    }
   
    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _selectedPhotos.count) {
       
        [self pushImagePickerController];
        
    } else { // preview photos or video / 预览照片或者视频

        
       
    }
}

#pragma mark - LxGridViewDataSource

/// 以下三个方法为长按排序相关代码
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.item < _selectedPhotos.count;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath canMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    return (sourceIndexPath.item < _selectedPhotos.count && destinationIndexPath.item < _selectedPhotos.count);
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    UIImage *image = _selectedPhotos[sourceIndexPath.item];
    [_selectedPhotos removeObjectAtIndex:sourceIndexPath.item];
    [_selectedPhotos insertObject:image atIndex:destinationIndexPath.item];
    
    id asset = _selectedAssets[sourceIndexPath.item];
    [_selectedAssets removeObjectAtIndex:sourceIndexPath.item];
    [_selectedAssets insertObject:asset atIndex:destinationIndexPath.item];
    
    [_collectionView reloadData];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) { // take photo / 去拍照
        [self takePhoto];
    } else if (buttonIndex == 1) {
        [self pushImagePickerController];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) { // 去设置界面，开启相机访问权限
        if (IOS8_OR_LATER) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        } else {
            NSURL *privacyUrl;
            if (alertView.tag == 1) {
                privacyUrl = [NSURL URLWithString:@"prefs:root=Privacy&path=PHOTOS"];
            } else {
                privacyUrl = [NSURL URLWithString:@"prefs:root=Privacy&path=CAMERA"];
            }
            if ([[UIApplication sharedApplication] canOpenURL:privacyUrl]) {
                [[UIApplication sharedApplication] openURL:privacyUrl];
            } else {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"抱歉" message:@"无法跳转到隐私设置页面，请手动前往设置页面，谢谢" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
        }
    }
}

#pragma mark - LGPhotoPickerViewControllerDelegate

- (void)pickerViewControllerDoneAsstes:(NSArray *)assets isOriginal:(BOOL)original{
    /*
     //assets的元素是LGPhotoAssets对象，获取image方法如下:
     NSMutableArray *thumbImageArray = [NSMutableArray array];
     NSMutableArray *originImage = [NSMutableArray array];
     NSMutableArray *fullResolutionImage = [NSMutableArray array];
     
     for (LGPhotoAssets *photo in assets) {
     //缩略图
     [thumbImageArray addObject:photo.thumbImage];
     //原图
     [originImage addObject:photo.originImage];
     //全屏图
     [fullResolutionImage addObject:fullResolutionImage];
     }
     */
    
//    NSInteger num = (long)assets.count;
//    NSString *isOriginal = original? @"YES":@"NO";
    if (_selectedPhotos.count > 0) {
        [_selectedPhotos removeAllObjects];
    }
    if (_selectedAssets.count > 0) {
        [_selectedAssets removeAllObjects];
    }
    for (LGPhotoAssets *photo in assets) {
        //缩略图
        [_selectedPhotos addObject:photo.compressionImage];
        [_selectedAssets addObject:photo.asset];
    }
    
    [self.collectionView reloadData];
}


#pragma mark - TZImagePickerController

- (void)pushImagePickerController {
    
    self.pickerVc.selectPickers = _selectedPhotos;
//    self.showType = LGShowImageTypeImagePicker;
    [self.pickerVc showPickerVc:self];

}

#pragma mark - UIImagePickerController
- (void)takePhoto {
    // 调用相机
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerVc.sourceType = sourceType;
        
        [self presentViewController:_imagePickerVc animated:YES completion:nil];
    } else {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}



#pragma mark - 提交
- (void)sumbit
{
    // 归档
    self.mark.content = self.textView.text;
    
    NSMutableArray *images = [NSMutableArray array];
    NSMutableArray *paths = [NSMutableArray array];
    for (NSInteger i=0; i<_selectedPhotos.count; i++) {
        
        UIImage *image = _selectedPhotos[i];
        ALAsset *asset = _selectedAssets[i];
        
        [images addObject:image];
        [paths addObject:asset.defaultRepresentation.url.absoluteString];
    }
    self.mark.images = images;
    self.mark.content_img = paths;
    
    if (self.markBlock) {
        self.markBlock(self.mark);
    }
    
    /*
    // 方法：把图片直接保存到沙盒中，然后再把路径存储起来，等到用图片的时候先获取图片的路径，再通过路径拿到图片
    NSMutableArray *paths = [NSMutableArray array];
    for (NSInteger i=0; i<_selectedPhotos.count; i++) {
        UIImage *image = _selectedPhotos[i];
        PHAsset *asset = _selectedAssets[i];
        NSString *fileName = [asset valueForKey:@"filename"];
        //获取沙盒路径，
        NSString *path_sandox = NSHomeDirectory();
        //设置一个图片的存储路径
        NSString *imagePath = [path_sandox stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@",fileName]];
        //把图片直接保存到指定的路径（同时应该把图片的路径imagePath存起来，下次就可以直接用来取）
        [UIImageJPEGRepresentation(image, 1) writeToFile:imagePath atomically:YES];
        
        [paths addObject:[NSString stringWithFormat:@"/Documents/%@",fileName]];
    }
    NSLog(@"paths:%@",paths);
    */
    
    NSLog(@"mark:%@",self.mark.images);
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Click Event

- (void)deleteBtnClik:(UIButton *)sender {
    [_selectedPhotos removeObjectAtIndex:sender.tag];
    [_selectedAssets removeObjectAtIndex:sender.tag];
    
    [_collectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
        [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [_collectionView reloadData];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - Private
/*
/// 打印图片名字
- (void)printAssetsName:(NSArray *)assets {
    NSString *fileName;
    for (id asset in assets) {
        if ([asset isKindOfClass:[PHAsset class]]) {
            PHAsset *phAsset = (PHAsset *)asset;
            fileName = [phAsset valueForKey:@"filename"];
            
            NSRange range = [phAsset.localIdentifier rangeOfString:@"/"];
            NSString *newString = [phAsset.localIdentifier substringToIndex:range.location];
            NSString *appendedString=[NSString stringWithFormat:@"%@%@%@",@"assets-library://asset/asset.JPG?id=",newString,@"&ext=JPG"];
            
            PHContentEditingInputRequestOptions *editOptions = [[PHContentEditingInputRequestOptions alloc] init];
            [phAsset requestContentEditingInputWithOptions:editOptions completionHandler:^(PHContentEditingInput * _Nullable contentEditingInput, NSDictionary * _Nonnull info) {
                NSURL *imageURL = contentEditingInput.fullSizeImageURL;
 
               //  file:///Users/Kitty/Library/Developer/CoreSimulator/Devices/F378BEAC-61F2-423B-9065-623D9106F555/data/Media/DCIM/100APPLE/IMG_0006.JPG
                 
              //   file:///var/mobile/Media/DCIM/100APPLE/IMG_0029.JPG
 
                NSLog(@"%@%@",imageURL,appendedString);
            }];
            
        } else if ([asset isKindOfClass:[ALAsset class]]) {
            ALAsset *alAsset = (ALAsset *)asset;
            fileName = alAsset.defaultRepresentation.filename;
        }
        NSLog(@"图片名字:%@",fileName);
    }
}
*/

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
