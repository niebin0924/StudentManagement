//
//  HomeViewController.m
//  StudentManagement
//
//  Created by Kitty on 17/2/17.
//  Copyright © 2017年 Kitty. All rights reserved.
//


#import "HomeViewController.h"
#import "LocalHomeworkViewController.h"
#import "PhotoGroupViewController.h"
#import "SubjectFolderViewController.h"
#import "CaptureViewController.h"
#import "PiZhuViewController.h"
#import "ZuoyeViewController.h"
#import "InformationViewController.h"
#import "MeViewController.h"
#import "ImageTextButton.h"
#import "CustomePopView.h"
#import "CustomeAlertViewWithCollection.h"
#import "FolderCollectionViewCell.h"
#import "Homework.h"
#import "Mark.h"
#import "URLSessionWrapperOperation.h"
//#import "HXCutPictureViewController.h"
#import "PopImageCollectionViewCell.h"
#import "KNPhotoBrower.h"
#import "DACircularProgressView.h"
#import "MAImageViewTool.h"
#import "Reachability.h"
#import "NBPhotoPickerDatas.h"
#import "FileHelper.h"

@interface HomeViewController () <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,CustomeAlertViewDataSource,CustomeAlertViewDelegate,CustomePopViewDelegate,CustomeAlertViewWithCollectionDelegate,KNPhotoBrowerDelegate>
{
    CGFloat _scaleX;
    CGFloat _scaleY;
    
    NSString *_subjectId;
    NSString *_homeworkId;
    NSInteger _openedIndex;//当前工作区展示的下标
    BOOL _isUpdate;//是否是更新作业
    NSInteger _startPizhuCount;//当前工作区最开始的批注个数
    NSInteger _pizhuIndex;//点击的是哪一个批注label
    BOOL _isUpload;//是否是上传 0本地 1上传
}

@property (nonatomic,strong) NSMutableArray *points;
@property (nonatomic,strong) UIImageView *openedImgView;
@property (nonatomic,strong) UIImage *clipedImage;

@property (nonatomic,strong) UIScrollView *bgScrollView;
@property (nonatomic,strong) UIImageView *defaultImgView;
@property (nonatomic,strong) UILabel *tipLabel;
@property (nonatomic,strong) UIButton *dot;
@property (nonatomic,strong) UILabel *pizhu;
@property (nonatomic,strong) UIScrollView *pizhuScrollView;

// ipa下载地址
@property (nonatomic,strong) NSString *downloadUrl;

// 打开的多张图片UIImage数组
@property (nonatomic,strong) NSMutableArray <Homework *>*openImageArray;
// scrollView中打开的UIImageView数组
@property (nonatomic,strong) NSMutableArray *imgViewArray;

// 存储学科cell
@property (nonatomic,strong) NSMutableDictionary *subjectCellDict;
// 学科目录数组
@property (nonatomic,strong) NSMutableArray *subjectsArray;

// 多个批注上传的本地图片路径(二维数组)
@property (nonatomic,strong) NSMutableArray *pathArray;
// 保存批注的数组
@property (nonatomic,strong) NSMutableArray <Mark *>*pizhuArray;

// 保存批注的个数
@property (nonatomic,strong) NSMutableArray *pizhuCountArray;

/***********     浏览批注图片       ***********/
@property (nonatomic, strong) NSMutableArray *itemsArr;

@end

@implementation HomeViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestMessageCount];
    [self checkUpdate];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self clearCache];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = KblackgroundColor;
    self.title = @"主页";
    [self createDocumentFolder];
    _openedIndex = 0;
    _pizhuIndex = -1;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showHomework:) name:OpenHomeworkNotification object:nil];
    
    [self initMenuView];
    
    [self initView];
    // 1088 * 608
    _scaleX = 1088.0 / (self.view.width - 160);
    _scaleY = 608.0 / (self.view.height - 100);
    
}

- (void)createDocumentFolder
{
    NSArray *arr = @[@"英语",@"语文",@"数学",@"历史",@"物理",@"化学",@"生物",@"重要一",@"重要二",@"考试一",@"考试二",@"易错题集"];
    for (NSInteger i=0; i<arr.count; i++) {
        [FileHelper createDir:DocumentsPath DirStr:arr[i]];
    }
    
}

#pragma mark - init
- (NSMutableArray *)points
{
    if (!_points) {
        _points = [NSMutableArray array];
    }
    return _points;
}

- (NSMutableDictionary *)subjectCellDict
{
    if (!_subjectCellDict) {
        _subjectCellDict = [NSMutableDictionary dictionary];
    }
    return _subjectCellDict;
}

- (NSMutableArray *)imgViewArray
{
    if (!_imgViewArray) {
        _imgViewArray = [NSMutableArray array];
    }
    return _imgViewArray;
}

- (NSMutableArray<Mark *> *)pizhuArray
{
    if (!_pizhuArray) {
        _pizhuArray = [NSMutableArray array];
    }
    return _pizhuArray;
}

- (NSMutableArray *)pizhuCountArray
{
    if (!_pizhuCountArray) {
        _pizhuCountArray = [NSMutableArray array];
    }
    return _pizhuCountArray;
}

- (NSMutableArray *)pathArray
{
    if (!_pathArray) {
        _pathArray = [NSMutableArray array];
    }
    return _pathArray;
}

- (NSMutableArray *)itemsArr{
    if (!_itemsArr) {
        _itemsArr = [NSMutableArray array];
    }
    return _itemsArr;
}

#pragma mark - 接收通知
- (void)showHomework:(NSNotification *)notfi
{
    id object = notfi.object;
    NSDictionary *userInfo = notfi.userInfo;
    _subjectId = [userInfo objectForKey:@"subjectId"];
    if ([object isKindOfClass:[NSArray class]]) {
        NSMutableArray *result = (NSMutableArray *)object;
        
        self.defaultImgView.hidden = YES;
        self.tipLabel.hidden = YES;
        if (self.openImageArray && self.openImageArray.count > 0) {
            // 先清空工作区的ImgView
            for (NSInteger i=0; i<self.openImageArray.count; i++) {
                UIImageView *imgView = [self.bgScrollView viewWithTag:10+i];
                [imgView removeFromSuperview];
            }
        }
        
        self.openImageArray = result;
        
        // 初始化批注个数
        if (self.pizhuCountArray && self.pizhuCountArray.count > 0) {
            [self.pizhuCountArray removeAllObjects];
        }
        for (NSInteger i=0; i<self.openImageArray.count; i++) {
            Homework *model = self.openImageArray[i];
            NSArray *pizhu = model.pizhuArray;
            if (pizhu && pizhu.count > 0) {
                [self.pizhuCountArray addObject:@(pizhu.count+1)];
            }else {
                [self.pizhuCountArray addObject:@1];
            }
            // 初始化pathArray
//            [self.pathArray addObject:[NSNull null]];
        }
        // 初始化展示给用户的首页图片
        _openedIndex = 0;
        [self addImgViewInBgScrollView];
    }
    
    
    Homework *model = self.openImageArray[_openedIndex];
    if (userInfo != nil) {
        // 代表是有批注的
        _isUpdate = YES;
        self.pizhuArray = [model.pizhuArray mutableCopy];
        _startPizhuCount = self.pizhuArray.count;
        
        [self addPizhuDot];
        [self addBottomPizhuViewWithHomework:self.openImageArray[_openedIndex]];
    }else{
        _startPizhuCount = 0;
    }
    
    

}

- (void)addImgViewInBgScrollView
{
    self.bgScrollView.contentSize = CGSizeMake(self.bgScrollView.width*self.openImageArray.count, self.bgScrollView.height);
    [self.bgScrollView setContentOffset:CGPointMake(self.bgScrollView.width*_openedIndex, 0) animated:NO];
    
    for (NSInteger i=0; i<self.openImageArray.count; i++) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i*self.bgScrollView.width, 0, self.bgScrollView.width, self.bgScrollView.height)];
        imgView.tag = 10 + i;
        imgView.contentMode = UIViewContentModeScaleToFill;
        [self.bgScrollView addSubview:imgView];
        
        [self.imgViewArray addObject:imgView];
        
        // 在图片上标注批注点Tap
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPizhu:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;//手指数
        imgView.userInteractionEnabled = YES;
        [imgView addGestureRecognizer:tap];
        
        id object = self.openImageArray[i];
        if ([object isKindOfClass:[Homework class]]) {
            // 打开
            Homework *modal = object;
            if ((modal.pathStr&&![modal.pathStr isEqualToString:@""])) {
                
                // 从沙盒中读取图片
                NSString *path = [DocumentsPath stringByAppendingPathComponent:modal.pathStr];
                imgView.image = [[UIImage alloc] initWithContentsOfFile:path];
                
            }
            else if ([modal.imageUrlStr isEqualToString:@""] || (modal.assetURL && ![modal.assetURL isEqualToString:@""])) {
                // 从相册读取
                imgView.image = modal.img;
                
            }else{
                if ([modal.imageUrlStr rangeOfString:@"http"].location != NSNotFound) {
                    
                    [imgView JYloadWebImage:modal.imageUrlStr placeholderImage:[UIImage imageNamed:@"KNPhotoBrower.bundle/defaultPlaceHolder"]];

                }else {
                    
                    [imgView JYloadWebImage:[BaseURL stringByAppendingString:modal.imageUrlStr] placeholderImage:[UIImage imageNamed:@"KNPhotoBrower.bundle/defaultPlaceHolder"]];
                    
                }
                modal.img = imgView.image;
            }
            
            if (i == _openedIndex) {
                self.openedImgView = imgView;
            }
            
        }

    }
    
}

- (void)tapPizhu:(UITapGestureRecognizer *)tap
{
    UIImageView *imgView = (UIImageView *)tap.view;
    CGPoint point = [tap locationInView:imgView];
    NSNumber *numberCount = [self.pizhuCountArray objectAtIndex:imgView.tag-10];
    UIButton *pizhuBtn = [imgView viewWithTag:100+[numberCount integerValue]];
    Mark *model;
    if (pizhuBtn == nil) {
        pizhuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        pizhuBtn.tag = 100 + [numberCount integerValue];
        pizhuBtn.layer.cornerRadius = 10;
        pizhuBtn.layer.masksToBounds = YES;
        pizhuBtn.backgroundColor = [UIColor redColor];
        [pizhuBtn setTitle:[NSString stringWithFormat:@"%zd",[numberCount integerValue]] forState:UIControlStateNormal];
        [imgView addSubview:pizhuBtn];
        
        model = [[Mark alloc] init];
        [self.pizhuArray addObject:model];
        
    }else{
        model = self.pizhuArray[numberCount.integerValue-1];
    }
    
    pizhuBtn.frame = CGRectMake(point.x, point.y, 20, 20);
    model.x = point.x * _scaleX;
    model.y = point.y * _scaleY;
    
}

- (void)addPizhuDot
{
    for (NSInteger i=0; i<self.openImageArray.count; i++) {
        
        UIImageView *imgView = [self.bgScrollView viewWithTag:10 + i];
        Homework *model = self.openImageArray[i];
        NSArray *pizhu = model.pizhuArray;
        for (NSInteger j=1; j<=pizhu.count; j++) {
            Mark *mark = pizhu[j-1];
            UIButton *pizhuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            pizhuBtn.frame = CGRectMake(mark.x/_scaleX, mark.y/_scaleY, 20, 20);
            pizhuBtn.tag = 100 + j;
            pizhuBtn.layer.cornerRadius = 10;
            pizhuBtn.layer.masksToBounds = YES;
            pizhuBtn.backgroundColor = [UIColor redColor];
            [pizhuBtn setTitle:[NSString stringWithFormat:@"%zd",j] forState:UIControlStateNormal];
            [imgView addSubview:pizhuBtn];
        }
        
        
    }
}

- (void)updateBgScrollViewData
{
    if ((_openedIndex==self.openImageArray.count-1) && (_openedIndex==0)) {
        // 只打开了一张图片
        UIImageView *imgView = [self.bgScrollView viewWithTag:10+_openedIndex];
        [imgView removeFromSuperview];
        [self.openImageArray removeObjectAtIndex:_openedIndex];
        self.bgScrollView.contentSize = CGSizeMake(self.bgScrollView.width, self.bgScrollView.height);
        self.openedImgView = nil;
        self.openImageArray = nil;
        self.defaultImgView.hidden = NO;
        self.tipLabel.hidden = NO;
        
    }else if (_openedIndex == self.openImageArray.count-1) {
        // 删除了最后一张图片
        UIImageView *imgView = [self.bgScrollView viewWithTag:10+_openedIndex];
        [imgView removeFromSuperview];
        [self.openImageArray removeObjectAtIndex:_openedIndex];//先把该图片删除
        self.bgScrollView.contentSize = CGSizeMake(self.bgScrollView.width*self.openImageArray.count, self.bgScrollView.height);
        [self.bgScrollView setContentOffset:CGPointMake(self.bgScrollView.width*(_openedIndex-1), 0) animated:YES];
        
        UIImageView *imgView2 = [self.bgScrollView viewWithTag:10+_openedIndex-1];
        self.openedImgView = imgView2;//展示前一张图片
        _openedIndex --;
        
    }else {
        
        UIImageView *imgView = [self.bgScrollView viewWithTag:10+_openedIndex];
        [imgView removeFromSuperview];
        for (NSInteger i=_openedIndex+1; i<self.openImageArray.count; i++) {
            UIImageView *view = [self.bgScrollView viewWithTag:10+i];
            view.tag = 10 + i - 1;
            view.frame = CGRectMake((i-1)*self.bgScrollView.width, 0, self.bgScrollView.width, self.bgScrollView.height);
        }
        [self.openImageArray removeObjectAtIndex:_openedIndex];//先把该图片删除
        
        self.bgScrollView.contentSize = CGSizeMake(self.bgScrollView.width*self.openImageArray.count, self.bgScrollView.height);
        [self.bgScrollView setContentOffset:CGPointMake(self.bgScrollView.width*(_openedIndex), 0) animated:NO];
        
        UIImageView *imgView2 = [self.bgScrollView viewWithTag:10+_openedIndex];
        self.openedImgView = imgView2;//展示下一张图片
        
    }
}

- (void)addBottomPizhuViewWithHomework:(Homework *)model
{
    NSInteger count = 0;
    NSArray *pizhu = model.pizhuArray;
    if (pizhu && pizhu.count > 0) {
        count = pizhu.count;
    }
    
    // 先删除label
    NSArray *arr = _pizhuScrollView.subviews;
    for (id object in arr) {
        if ([object isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)object;
            [label removeFromSuperview];
        }
    }
    
    for (NSInteger i=0; i<count; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10 + i*70, 0, 60, 30)];
        label.tag = 200 + i;
        label.text = [NSString stringWithFormat:@"批注%zd",i+1];
        label.textColor = [UIColor redColor];
        label.font = [UIFont systemFontOfSize:20];
        [_pizhuScrollView addSubview:label];
        
        // 点击label 弹出批注详情
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popPizhuDetail:)];
        label.userInteractionEnabled = YES;
        [label addGestureRecognizer:tap];
    }
    _pizhuScrollView.contentSize = CGSizeMake(10*(count+1) + 60*count, _pizhuScrollView.height);
    _pizhu.text = [NSString stringWithFormat:@"批注（共%ld条）: ",count];
}

- (void)popPizhuDetail:(UITapGestureRecognizer *)tap
{
    UILabel *label = (UILabel *)tap.view;
    NSInteger index = label.tag - 200;
    Homework *model = self.openImageArray[_openedIndex];
    NSArray *pizhu = model.pizhuArray;
    Mark *mark = pizhu[index];
    _pizhuIndex = index;
    CustomePopView *alertView = [[CustomePopView alloc] initWithTitle:@"批注" message:mark.content sureBtn:@"关闭" cancleBtn:nil];
    alertView.delegate = self;
    alertView.resultIndex = ^(NSInteger index, id object)
    {
        // 回调 -- 处理
        //        NSLog(@"%s",__func__);
        [self clearCache];
    };
    
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger i=0; i<mark.path_img.count; i++) {
        NSString *path = mark.path_img[i];
        if ([path isEqual:[NSNull null]]) {
            [arr addObject:mark.content_img[i]];
        }else{
            [arr addObject:path];
        }
    }
    alertView.dataArray = arr;
    [alertView addCollectionViewWithConfigurationHandler:^(UICollectionView *collectionView) {
        
    }];
    [alertView showPopView];
}

// CustomePopViewDelegate
- (void)popViewWithCollectionView:(UICollectionView *)collectionView index:(NSInteger)currentIndex
{
    if (self.itemsArr && self.itemsArr.count > 0) {
        [self.itemsArr removeAllObjects];
    }
    Homework *model = self.openImageArray[_openedIndex];
    NSArray *pizhu = model.pizhuArray;
    Mark *mark = pizhu[_pizhuIndex];
    for (NSString *urlStr in mark.content_img) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[mark.content_img indexOfObject:urlStr] inSection:0];
        PopImageCollectionViewCell *cell = (PopImageCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        
        KNPhotoItems *items = [[KNPhotoItems alloc] init];
        NSInteger index = [mark.content_img indexOfObject:urlStr];
        NSString *pathStr = mark.path_img[index];
        if (![pathStr isEqual:[NSNull null]]) {
            
            // 从沙盒中读取图片
            NSString *path = [DocumentsPath stringByAppendingPathComponent:pathStr];
            items.sourceImage = [[UIImage alloc] initWithContentsOfFile:path];
            
        }
        else if ([urlStr rangeOfString:@"assets-library"].location != NSNotFound) {
            
            [[NBPhotoPickerDatas defaultPicker] getAssetsPhotoWithURLs:[NSURL URLWithString:urlStr] callBack:^(UIImage *image) {
                items.sourceImage = image;
            }];
            
        }else{
            items.url = urlStr;
        }
        
        items.sourceView = cell.iconImageView;
        [self.itemsArr addObject:items];
    }
    
    KNPhotoBrower *photoBrower = [[KNPhotoBrower alloc] init];
    [photoBrower setDelegate:self];
    [photoBrower setItemsArr:[self.itemsArr copy]];
    [photoBrower setCurrentIndex:currentIndex];
    
    /****************  为了 循环利用 而做出的 新的属性  *****************/
    //    [photoBrower setDataSourceUrlArr:[self.itemsArr copy]];
    //    [photoBrower setSourceViewForCellReusable:collectionView];
    /****************  为了 循环利用 而做出的 新的属性  *****************/
    
    
    [photoBrower present];
}

// KNPhotoBrowerDelegate
- (void)photoBrowerWillDismiss
{
    [[SDImageCache sharedImageCache] clearDisk];
}

#pragma mark - initView
- (void)initMenuView
{
    NSArray *arr = @[@"导入",@"裁剪",@"批注",@"复习",@"删除",@"作业",@"消息",@"我的",@"保存",@"上传"];
    NSArray *imgNames = @[@"icon_import",@"icon_crop",@"icon_postil",@"icon_open",@"icon_delete",@"icon_job",@"icon_message",@"icon_user",@"icon_out",@"icon_upload"];
    
    UIView *menuView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 44)];
    menuView.backgroundColor = KColor;
    
    for (NSInteger i=0; i<arr.count; i++) {
        ImageTextButton *imgTextBtn = [[ImageTextButton alloc] initWithFrame:CGRectMake((SCREENWIDTH - 600 - 360) / 2 + i*100, 0, 60, 44) image:[UIImage imageNamed:imgNames[i]] title:arr[i]];
        imgTextBtn.backgroundColor = [UIColor clearColor];
        [imgTextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        imgTextBtn.buttonTitleWithImageAlignment = UIButtonTitleWithImageAlignmentUp;
        [imgTextBtn addTarget:self action:@selector(changeValue:) forControlEvents:UIControlEventTouchUpInside];
        imgTextBtn.tag = 10 + i;
        [menuView addSubview:imgTextBtn];
        
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn.frame = CGRectMake((SCREENWIDTH - 600 - 360) / 2 + i*100, 0, 60, 44);
//        [btn setTitle:arr[i] forState:UIControlStateNormal];
//        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        btn.titleLabel.font = [UIFont systemFontOfSize:15];
//        [btn setImage:[UIImage imageNamed:imgNames[i]] forState:UIControlStateNormal];
//        btn.imageView.frame = CGRectMake(0, 0, 30, 30);
//        btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
//        [btn setImageEdgeInsets:UIEdgeInsetsMake(-20, 0, 0, 0)];
//        [btn setTitleEdgeInsets:UIEdgeInsetsMake(30, -45, 0, 0)];
//        [btn addTarget:self action:@selector(changeValue:) forControlEvents:UIControlEventTouchUpInside];
//        btn.tag = 10 + i;
        
        if (i == 6) {
            _dot = [UIButton buttonWithType:UIButtonTypeCustom];
            _dot.frame = CGRectMake(40, 0, 20, 20);
            [_dot setBackgroundImage:[UIImage imageNamed:@"bg_mark"] forState:UIControlStateNormal];
            _dot.hidden = YES;
            [imgTextBtn addSubview:_dot];
        }
        
        [menuView addSubview:imgTextBtn];
    }
    
    self.navigationItem.titleView = menuView;
}

- (void)initView
{
    self.bgScrollView = [[UIScrollView alloc] init];
    self.bgScrollView.backgroundColor = [UIColor whiteColor];
    self.bgScrollView.pagingEnabled = YES;
    self.bgScrollView.scrollEnabled = NO;
    [self.view addSubview:self.bgScrollView];
    [self.bgScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(20, 80, 80, 80));
    }];
    
    _defaultImgView = [[UIImageView alloc] init];
    _defaultImgView.image = [UIImage imageNamed:@"homepic"];
    _defaultImgView.contentMode = UIViewContentModeScaleAspectFit;
    [self.bgScrollView addSubview:_defaultImgView];
    [_defaultImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgScrollView.mas_centerX);
        make.centerY.equalTo(self.bgScrollView.mas_centerY);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openHomework)];
    self.defaultImgView.userInteractionEnabled = YES;
    [self.defaultImgView addGestureRecognizer:tap];
    
    _tipLabel = [[UILabel alloc] init];
    _tipLabel.text = @"打开作业";
    _tipLabel.textColor = SETCOLOR(8, 93, 29, 1);
    _tipLabel.font = [UIFont systemFontOfSize:30];
    [self.bgScrollView addSubview:_tipLabel];
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgScrollView.mas_centerX);
        make.centerY.equalTo(self.bgScrollView.mas_centerY).with.offset(80);
    }];
    
    
//    _openedImgView = [[UIImageView alloc] init];
//    _openedImgView.contentMode = UIViewContentModeScaleToFill;
//    [self.bgScrollView addSubview:_openedImgView];
//    [_openedImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
//    }];
//    _openedImgView.hidden = YES;
    
    
    UIButton *lastBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [lastBtn setBackgroundImage:[UIImage imageNamed:@"bt_left"] forState:UIControlStateNormal];
    [lastBtn addTarget:self action:@selector(lastClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:lastBtn];
    [lastBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(120, 120));
        make.centerY.equalTo(self.bgScrollView.mas_centerY);
        make.left.equalTo(@20);
    }];
    
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"bt_right"] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(120, 120));
        make.centerY.equalTo(self.bgScrollView.mas_centerY);
        make.right.equalTo(@-20);
    }];
    
    _pizhu = [[UILabel alloc] init];
    _pizhu.text = @"批注（共0条）: ";
    _pizhu.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:_pizhu];
    [_pizhu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgScrollView.mas_left);
        make.top.equalTo(self.bgScrollView.mas_bottom).with.offset(30);
    }];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"left_arrow"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(10, 20));
        make.centerY.equalTo(_pizhu.mas_centerY);
        make.left.equalTo(_pizhu.mas_right).with.offset(40);
    }];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"right_arrow"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightBtn];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(10, 20));
        make.centerY.equalTo(_pizhu.mas_centerY);
        make.right.equalTo(self.bgScrollView.mas_right);
    }];
    
    _pizhuScrollView = [[UIScrollView alloc] init];
    _pizhuScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_pizhuScrollView];
    [_pizhuScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftBtn.mas_right).with.offset(40);
        make.right.equalTo(rightBtn.mas_left).with.offset(-40);
        make.centerY.equalTo(_pizhu.mas_centerY);
        make.height.equalTo(@30);
    }];
    
}


// 上一张作业
- (void)lastClick
{
    if (!self.defaultImgView.hidden) {
        return;
    }
    NSInteger index = -1;
    index = self.bgScrollView.contentOffset.x / self.bgScrollView.width;
    if (index > 0) {
        [self.bgScrollView setContentOffset:CGPointMake(self.bgScrollView.width*(index-1), 0) animated:YES];
        
        self.openedImgView = [self.bgScrollView viewWithTag:10+index-1];
        _openedIndex = index - 1;
        [self addBottomPizhuViewWithHomework:self.openImageArray[_openedIndex]];
        
        Homework *model = self.openImageArray[_openedIndex];
        self.pizhuArray = [model.pizhuArray mutableCopy];
    }

}

// 下一张作业
- (void)nextClick
{
    if (!self.defaultImgView.hidden) {
        return;
    }
    NSInteger index = -1;
    index = self.bgScrollView.contentOffset.x / self.bgScrollView.width;
    if (!(index == self.openImageArray.count-1)) {
        [self.bgScrollView setContentOffset:CGPointMake(self.bgScrollView.width*(index+1), 0) animated:YES];
        
        self.openedImgView = [self.bgScrollView viewWithTag:10+index+1];
        _openedIndex = index + 1;
        [self addBottomPizhuViewWithHomework:self.openImageArray[_openedIndex]];
        
        Homework *model = self.openImageArray[_openedIndex];
        self.pizhuArray = [model.pizhuArray mutableCopy];
    }
}

// 上一个批注
- (void)leftClick
{
    if (self.pizhuScrollView.width < self.pizhuScrollView.contentSize.width) {
        [self.pizhuScrollView setContentOffset:CGPointMake(self.pizhuScrollView.contentOffset.x-70, 0) animated:YES];
    }
    
}

// 下一个批注
- (void)rightClick
{
    if (self.pizhuScrollView.width < self.pizhuScrollView.contentSize.width) {
        [self.pizhuScrollView setContentOffset:CGPointMake(self.pizhuScrollView.contentOffset.x+70, 0) animated:YES];
    }
    
}

#pragma mark - 功能选择
- (void)changeValue:(ImageTextButton *)btn
{
    switch (btn.tag) {
        case 10: // 导入
        {
            [self import];
        }
            break;
        case 11: // 裁切
        {
            [self capture];
        }
            break;
        case 12: // 批注
        {
            [self postil];
        }
            break;
        case 13: // 打开
        {
            [self openHomework];
        }
            break;
        case 14: // 删除
        {
            [self delete];
        }
            break;
        case 15:
        {
            ZuoyeViewController *vc = [[ZuoyeViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 16:
        {
            InformationViewController *vc = [[InformationViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case 17:
        {
            MeViewController *vc = [[MeViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 18: // 保存本地
        {
            _isUpload = 0;
            [self saveWorkToLocal];
            
        }
            break;
        case 19: // 上传
        {
            _isUpload = 1;
            [self upload];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 导入
- (void)import
{
    UIActionSheet *sheeet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"选择相册",@"拍照",@"本地", nil];
    [sheeet showInView:self.view];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
        if (!isCamera) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"没有摄像头" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
            return ;
        }
        //从摄像头获取活动图片
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.allowsEditing = YES;
        [self presentViewController:imagePicker animated:YES completion:^{}];
        
        
    }else if (buttonIndex == 0) {
#if 0
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        UIPopoverController *popVC = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        popVC.popoverContentSize = CGSizeMake(SCREENWIDTH*0.5, 180);
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
        [imagePicker shouldAutorotate];
        [[AppDefaultUtil sharedInstance] setPhotoLibary:YES];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [popVC presentPopoverFromRect:CGRectMake(SCREENWIDTH*0.5-120*0.5,30,120,120) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
            
        }else{
            [self presentViewController:imagePicker animated:YES completion:^{}];
        }
#endif
        
        PhotoGroupViewController *vc = [[PhotoGroupViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }else if (buttonIndex == 2){
        
        SubjectFolderViewController *vc = [[SubjectFolderViewController alloc] init];
        vc.type = FolderTypeOut;
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }
}

#pragma mark UIImagePickerControllerDelegate
// 完成拍照后的回调方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    // 如果是拍照
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image;
        // 如果允许编辑则获得编辑后的照片，否则获取原始照片
        if (picker.allowsEditing) {
            // 获取编辑后的照片
            image = [info objectForKey:UIImagePickerControllerEditedImage];
        }
        else{
            // 获取原始照片
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        
        
        [self cameraWithImage:image];
        
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 拍照获取照片
- (void)cameraWithImage:(UIImage *)image
{
    self.defaultImgView.hidden = YES;
    self.tipLabel.hidden = YES;
    if (self.openImageArray && self.openImageArray.count > 0) {
        // 先清空工作区的ImgView
        for (NSInteger i=0; i<self.openImageArray.count; i++) {
            UIImageView *imgView = [self.bgScrollView viewWithTag:10+i];
            [imgView removeFromSuperview];
        }
    }
    
    NSMutableArray *result = [NSMutableArray array];
    Homework *model = [[Homework alloc] init];
    model.img = image;
    model.imageUrlStr = @"";
    model.isSel = NO;
    model.homeworkId = @"";
    [result addObject:model];
    
    self.openImageArray = result;
    // 初始化批注个数
    if (self.pizhuCountArray && self.pizhuCountArray.count > 0) {
        [self.pizhuCountArray removeAllObjects];
    }
    [self.pizhuCountArray addObject:@1];
    // 初始化pathArray
    [self.pathArray addObject:[NSNull null]];
    // 初始化展示给用户的首页图片
    _openedIndex = 0;
    [self addImgViewInBgScrollView];
}


#pragma mark - 裁切
- (void)capture
{
    // 如果图片有了批注,就不能进行裁切
    if (self.openedImgView!=nil) {
        Homework *model = self.openImageArray[_openedIndex];
        NSArray *pizhu = model.pizhuArray;
        if (!(pizhu && pizhu.count > 0)) {
            
//            HXCutPictureViewController *vc = [[HXCutPictureViewController alloc] initWithCropImage:self.openedImgView.image  cropSize:self.openedImgView.frame.size title:@"裁剪" isLast:YES];
//            vc.completion = ^(HXCutPictureViewController *vc, UIImage *finishImage) {
//                self.openedImgView.image = finishImage;
//            };
            CaptureViewController *vc = [[CaptureViewController alloc] init];
            vc.image = self.openedImgView.image;
            vc.completion = ^(UIImage *editImage) {
                self.openedImgView.image = editImage;
                [self saveCaptureImage];
            };
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        
    }
}

- (void)saveCaptureImage
{
    NSString *fileName = [NSString stringWithFormat:@"%@.png",[self getCurrentTimestamp]];
    [UIImagePNGRepresentation(self.openedImgView.image) writeToFile:[DocumentsPath stringByAppendingPathComponent:fileName] atomically:YES];
    
    NSMutableArray *copyArr = [self.openImageArray mutableCopy];
    Homework *model = copyArr[_openedIndex];
    model.pathStr = fileName;
    model.assetURL = @"";
}

- (NSString *)getCurrentTimestamp
{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a = [date timeIntervalSince1970] * 1000;
    NSString *timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    return timeString;
}

#pragma mark - 批注
- (void)postil
{
    // 如果有了批注序号,才能进入批注详情
    if (self.pizhuCountArray && self.pizhuCountArray.count <= 0) {
        return;
    }
    UIImageView *imgView = [self.bgScrollView viewWithTag:10+_openedIndex];
    NSMutableArray *copyArray = [self.pizhuCountArray mutableCopy];
    __block NSNumber *numberCount = [copyArray objectAtIndex:_openedIndex];
    
    UIButton *pizhuBtn = [imgView viewWithTag:100+[numberCount integerValue]];
    if (pizhuBtn != nil) {
        typeof(self) __weak weakSelf = self;
        PiZhuViewController *vc = [[PiZhuViewController alloc] init];
        vc.mark = self.pizhuArray[[numberCount integerValue]-1];
        vc.markBlock = ^ (Mark *mark){
            
//            [weakSelf.pathArray replaceObjectAtIndex:_openedIndex withObject:[NSMutableArray arrayWithObject:paths]];
//            NSMutableArray *arr = [self.pizhuArray mutableCopy];
//            Mark *model = arr[[numberCount integerValue]-1];
//            model.content = text;
            weakSelf.pizhuArray[[numberCount integerValue]-1] = mark;
            
            // 第一个批注完成，进入下一个批注
            NSInteger count = [numberCount integerValue];
            count ++;
            numberCount = [NSNumber numberWithInteger:count];
            [copyArray replaceObjectAtIndex:_openedIndex withObject:numberCount];
            self.pizhuCountArray = copyArray;
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 打开
- (void)openHomework
{
    if (self.state == 0) {
        [SVProgressHUD showErrorWithStatus:@"还未通过审核"];
        return;
    }
    SubjectFolderViewController *vc = [[SubjectFolderViewController alloc] init];
    vc.type = FolderTypeOpen;
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark - 删除
- (void)delete
{
    if (self.state == 0) {
        [SVProgressHUD showErrorWithStatus:@"还未通过审核"];
        return;
    }
    
    // 如果当前工作区有图片才能删除
    if (self.openedImgView != nil) {
        Homework *modal = self.openImageArray[_openedIndex];
        if ([modal.homeworkId isEqualToString:@""]) {
            return;
        }
        CustomePopView *alertView = [[CustomePopView alloc] initWithTitle:@"删除" message:@"确定要删除该图片及其批注?" sureBtn:@"删除" cancleBtn:@"取消"];
        alertView.resultIndex = ^(NSInteger index, id object)
        {
            // 回调 -- 处理
            //        NSLog(@"%s",__func__);
            [self deleteRequest];
        };
        [alertView showPopView];
        
    }

}

#pragma mark - 导出到本地
- (void)saveWorkToLocal
{
    // 如果工作区有图片,导出到本地
    if (self.openedImgView != nil) {
//        UIImageWriteToSavedPhotosAlbum(self.openedImgView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        
        if (self.subjectsArray && self.subjectsArray.count > 0) {
            [self.subjectsArray removeAllObjects];
            [self.subjectCellDict removeAllObjects];
        }else{
            self.subjectsArray = [NSMutableArray array];
        }
        NSArray *arr = @[@"本地英语",@"本地语文",@"本地数学",@"本地历史",@"本地物理",@"本地化学",@"本地生物",@"重要一",@"重要二",@"考试一",@"考试二",@"易错题集"];
        for (NSInteger i=0; i<arr.count; i++) {
            SubjectInfo *model = [[SubjectInfo alloc] init];
            model.subjectId = [NSString stringWithFormat:@"%zd",i+1];
            model.subjectName = arr[i];
            [self.subjectsArray addObject:model];
        }
    
        CustomeAlertViewWithCollection *alertView = [[CustomeAlertViewWithCollection alloc] initWithTitle:@"保存" collectionCellName:@"FolderCollectionViewCell" sureBtn:@"确定" cancleBtn:@"取消"];
        alertView.datasource = self;
        alertView.delegate = self;
        alertView.indexDelegate = self;
        [alertView show];
        
    }
}

- (void)saveWork:(NSString *)homeworkName
{
    NSMutableArray *copyArr = [self.openImageArray mutableCopy];
    Homework *model = copyArr[_openedIndex];
    model.homeworkName = homeworkName;
    model.pizhuArray = [self.pizhuArray copy];
    NSLog(@"%@ mark:%@",model,model.pizhuArray);
//    self.openImageArray = copyArr;
    
    NSString *subjectName;
    if ([_subjectId isEqualToString:@"1"]) {
        subjectName = @"英语";
    }else if ([_subjectId isEqualToString:@"2"]) {
        subjectName = @"语文";
    }else if ([_subjectId isEqualToString:@"3"]) {
        subjectName = @"数学";
    }else if ([_subjectId isEqualToString:@"4"]) {
        subjectName = @"历史";
    }else if ([_subjectId isEqualToString:@"5"]) {
        subjectName = @"物理";
    }else if ([_subjectId isEqualToString:@"6"]) {
        subjectName = @"化学";
    }else if ([_subjectId isEqualToString:@"7"]) {
        subjectName = @"生物";
    }else if ([_subjectId isEqualToString:@"8"]) {
        subjectName = @"重要一";
    }else if ([_subjectId isEqualToString:@"9"]) {
        subjectName = @"重要二";
    }else if ([_subjectId isEqualToString:@"10"]) {
        subjectName = @"考试一";
    }else if ([_subjectId isEqualToString:@"11"]) {
        subjectName = @"考试二";
    }else if ([_subjectId isEqualToString:@"12"]) {
        subjectName = @"易错题集";
    }
    // 归档
    NSString *documentsPath = [DocumentsPath stringByAppendingPathComponent:subjectName];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.src",model.homeworkName]];
   
    BOOL ret = [NSKeyedArchiver archiveRootObject:model toFile:filePath];
    if (ret) {
        NSLog(@"作业归档成功");
        [self.pizhuCountArray removeObjectAtIndex:_openedIndex];
        [self updateBgScrollViewData];
    }else {
        NSLog(@"作业归档失败");
    }
    
    /*
    // 解档
    Homework *work = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    NSLog(@"%@ mark:%@",work,work.pizhuArray);
     */
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    if (error == nil) {
        
        CustomePopView *alertView = [[CustomePopView alloc] initWithTitle:@"导出" message:@"文件已导出成功" sureBtn:@"确定" cancleBtn:nil];
        [alertView showPopView];
        
    }else{
        
        CustomePopView *alertView = [[CustomePopView alloc] initWithTitle:@"导出" message:@"文件导出失败" sureBtn:@"确定" cancleBtn:nil];
        [alertView showPopView];
    }
    
}

#pragma mark - 上传
- (void)upload
{
    if (self.state == 0) {
        [SVProgressHUD showErrorWithStatus:@"还未通过审核"];
        return;
    }
    if (self.openedImgView != nil) {
        
        if (self.subjectsArray && self.subjectsArray.count > 0) {
            [self.subjectsArray removeAllObjects];
            [self.subjectCellDict removeAllObjects];
        }
        self.subjectsArray = [NSKeyedUnarchiver unarchiveObjectWithFile:SubjectFileName];
        
        CustomeAlertViewWithCollection *alertView = [[CustomeAlertViewWithCollection alloc] initWithTitle:@"上传" collectionCellName:@"FolderCollectionViewCell" sureBtn:@"确定" cancleBtn:@"取消"];
        alertView.datasource = self;
        alertView.delegate = self;
        alertView.indexDelegate = self;
        [alertView show];
    }
}

#pragma mark CustomeAlertViewWithCollectionDelegate
- (void)CustomeAlertViewWithCollection:(NSIndexPath *)indexpath
{
    if (![[Reachability reachabilityForInternetConnection] isReachable]) {
        [SVProgressHUD showErrorWithStatus:@"请连接网络"];
        return;
    }
    if (indexpath == nil) {
        return;
    }
    
    SubjectInfo *modal = self.subjectsArray[indexpath.item];
    if (_subjectId!=nil && ![_subjectId isEqualToString:modal.subjectId]) {
        [SVProgressHUD showInfoWithStatus:@"请勾选正确的科目"];
        return;
    }
    _subjectId = modal.subjectId;
    if (_isUpload) {
        
        [self uploadImage];
        
    }else{
        CustomePopView *alertView = [[CustomePopView alloc] initWithTitle:@"保存到本地" message:nil sureBtn:@"确定" cancleBtn:@"取消"];
        [alertView addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"请输入作业名";
        }];
        [alertView showPopView];
        
        alertView.resultIndex = ^(NSInteger index, UITextField *textField)
        {
            if (textField && [textField.text isEqualToString:@""]) {
                [SVProgressHUD showErrorWithStatus:@"请输入作业名"];
            }else{
                [self saveWork:textField.text];
            }
        };
    }
    
    
}

#pragma mark - request
- (void)checkUpdate
{
    NSString *url = @"students/app/iphone/state/bylf";
    NSString *versionString = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];      //获取项目版本号
    NSDictionary *parameters = @{@"verCode":versionString};
    NetWork *network = [[NetWork alloc] init];
    [network httpNetWorkWithUrl:url WithBlock:parameters block:^(NSData *data, NSError *error) {
        if (data) {
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if ([[dict objectForKey:@"code"] integerValue] == 0) {
                
                NSDictionary *content = [dict objectForKey:@"content"];
                self.downloadUrl = [NSString stringWithFormat:@"%@",[content objectForKey:@"app_url"]];
                NSString *edition = [NSString stringWithFormat:@"%@",[content objectForKey:@"edition"]];
                
                if([versionString floatValue] < [edition floatValue]){
                
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"应用更新" message:@"您的应用有新的版本" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"更新", nil];
                    [alertView show];
                
                }
                
            }else {
                [[UIApplication sharedApplication].keyWindow makeToast:[dict objectForKey:@"msg"]];
            }
            
        }else{
            if (error) {
                
            }
        }
    }];
    
}

- (void)requestMessageCount
{
    NSString *url = @"students/tidings/new_count/state/bylf";
    NSDictionary *parameters = @{@"students_id":[[AppDefaultUtil sharedInstance] getStudentId]};
    NetWork *network = [[NetWork alloc] init];
    [network postHttpNetWorkWithUrl:url WithBlock:parameters block:^(NSData *data, NSError *error) {
        if (data) {
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if ([[dict objectForKey:@"code"] integerValue] == 0) {
                
                NSString *content = [NSString stringWithFormat:@"%@",[dict objectForKey:@"content"]];
                if ([content isEqualToString:@"0"]) {
                    
                    self.dot.hidden = YES;
                    
                }else{
                    self.dot.hidden = NO;
                    [self.dot setTitle:content forState:UIControlStateNormal];
                }
                
            }else{
                
            }
            
        }else{
            if (error) {
                
            }
        }
    }];
}

// 先上传图片
- (void)uploadImage
{
    //        [self runDispatch];
    
    NSString *url = @"students/img/uploads_img/state/bylf";
    NSDictionary *parameters = @{@"students_id":[[AppDefaultUtil sharedInstance] getStudentId]};
    
    NSArray *images = [self images];
    
    // 准备保存结果的数组，元素个数与上传的图片个数相同，先用 NSNull 占位
    NSMutableArray *result = [NSMutableArray array];
    for (NSArray *arr in images) {
        NSMutableArray *aaa = [NSMutableArray array];
        for (UIImage *image in arr) {
            [aaa addObject:[NSNull null]];
            NSLog(@"image:%@",image);
        }
        [result addObject:aaa];
    }
    
    
    dispatch_group_t group = dispatch_group_create();
    
    for (NSInteger i = 0; i < images.count; i++) {
        
        NSArray *array = images[i];
        for (NSInteger j=0; j<array.count; j++) {
            
            dispatch_group_enter(group);
            
            NetWork *network = [[NetWork alloc] init];
            [network uploadImage:array[j] WithUrl:url WithBlock:parameters blok:^(NSData *data, NSError *error) {
                
                if (error) {
                    NSLog(@"第 [%d][%d] 张图片上传失败: %@", (int)i + 1,(int)j + 1, error);
                    dispatch_group_leave(group);
                } else {
                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                    NSLog(@"第 [%d][%d] 张图片上传成功: %@", (int)i + 1,(int)j + 1, dict);
                    @synchronized (result) { // NSMutableArray 是线程不安全的，所以加个同步锁
                        result[i][j] = dict;
                    }
                    dispatch_group_leave(group);
                }
                
            }];
        }
        
    }
    
    NSMutableArray *imageUrls = [NSMutableArray array];
    if (_isUpdate) {
        Homework *model = self.openImageArray[_openedIndex];
        if ([model.imageUrlStr rangeOfString:@"http"].location == NSNotFound) {
            model.imageUrlStr = [BaseURL stringByAppendingString:model.imageUrlStr];
        }
        NSMutableArray *aaa = [NSMutableArray arrayWithObjects:model.imageUrlStr, nil];
        [imageUrls addObject:aaa];
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"上传完成!");
        for (NSArray *arr in result) {
            NSMutableArray *secends = [NSMutableArray array];
            for (NSDictionary *response in arr) {
                NSLog(@"response:%@", response);
                NSString *imgUrl = [response objectForKey:@"content"];
                [secends addObject:imgUrl];
            }
            [imageUrls addObject:secends];
        }
        
        
        // 上传图片完成之后,先提交json数据
        [self uploadToServer:imageUrls];
        
    });
    
    
    
    
}

// 然后上传批注以json格式
- (void)uploadToServer:(NSMutableArray *)imageUrls
{
    NSString *homework_img = imageUrls[0][0]; // 首页要上传的作业
    NSMutableArray *arr = [self.pizhuArray mutableCopy];
    NSMutableArray *dictArr = [NSMutableArray array];
    for (NSInteger i=1; i<imageUrls.count; i++) {
        NSArray *content_img = imageUrls[i];
        Mark *model = arr[i-1+_startPizhuCount];
        model.content_img = content_img;
        [dictArr addObject:[model TurnToDict]];
    }
    
    NSArray *pizhu = [NSArray arrayWithArray:dictArr];
    
    NSString *url = @"students/img/index/state/bylf";
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[[AppDefaultUtil sharedInstance] getStudentId] forKey:@"students_id"];
    [parameters setObject:[NSString stringWithFormat:@"%d",_isUpdate] forKey:@"homework_id"];
    [parameters setObject:_subjectId forKey:@"subject_id"];
    [parameters setObject:homework_img forKey:@"homework_img"];
    [parameters setObject:pizhu forKey:@"pizhu"];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *dict = @{@"work":jsonString};
    
    NetWork *network = [[NetWork alloc] init];
    [network postJsonRequestWithUrl:url WithBlock:dict block:^(NSData *data, NSError *error) {
        if (data) {
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if ([[dict objectForKey:@"code"] integerValue] == 0) {
                
                [SVProgressHUD showSuccessWithStatus:@"上传成功"];
                [self.pizhuCountArray removeObjectAtIndex:_openedIndex];
                [self updateBgScrollViewData];
                
                
            }else{
                [[UIApplication sharedApplication].keyWindow makeToast:[dict objectForKey:@"msg"]];
            }
            
        }else{
            if (error) {
                
            }
        }
    }];
    
    
}



- (void)deleteRequest
{
    Homework *modal = self.openImageArray[_openedIndex];
    
    NSString *url = @"students/subject/homework_del/state/bylf";
    NSDictionary *parameters = @{@"students_id":[[AppDefaultUtil sharedInstance] getStudentId], @"subject_id":_subjectId, @"homework_id":modal.homeworkId};
    NetWork *network = [[NetWork alloc] init];
    [network postHttpNetWorkWithUrl:url WithBlock:parameters block:^(NSData *data, NSError *error) {
        if (data) {
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if ([[dict objectForKey:@"code"] integerValue] == 0) {
                
                [SVProgressHUD showSuccessWithStatus:@"删除成功"];
                [self updateBgScrollViewData];
                
            }else {
                [[UIApplication sharedApplication].keyWindow makeToast:[dict objectForKey:@"msg"]];
            }
            
        }else{
            if (error) {
                
            }
        }
    }];
}

#pragma mark - upload task
- (NSURLSessionUploadTask*)uploadTaskWithImage:(UIImage*)image completion:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionBlock {
    // 构造 NSURLRequest
    NSDictionary *parameters = @{@"students_id":[[AppDefaultUtil sharedInstance] getStudentId]};
    NSError *error = NULL;
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:@"http://ebj.zhi-watch.com/students/img/uploads_img/state/bylf" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
        [formData appendPartWithFileData:imageData name:@"img" fileName:@"fileName" mimeType:@"image/jpeg"];
    } error:&error];
    
    // 可在此处配置验证信息
//    [request setValue:[[AppDefaultUtil sharedInstance]getToken] forHTTPHeaderField:@"token"];
    [request setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    // 将 NSURLRequest 与 completionBlock 包装为 NSURLSessionUploadTask
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
        [SVProgressHUD showWithStatus:@"上传中..."];
    } completionHandler:completionBlock];
    
    return uploadTask;
}

- (void)runDispatch
{
    // 需要上传的数据
    NSArray *images = [self images];
    
    // 准备保存结果的数组，元素个数与上传的图片个数相同，先用 NSNull 占位
    NSMutableArray *result = [NSMutableArray array];
    for (UIImage *image in images) {
        [result addObject:[NSNull null]];
    }
    
    dispatch_group_t group = dispatch_group_create();
    
    for (NSInteger i = 0; i < images.count; i++) {
        
        dispatch_group_enter(group);
        
        NSURLSessionUploadTask *uploadTask = [self uploadTaskWithImage:images[i] completion:^(NSURLResponse *response, NSDictionary* responseObject, NSError *error) {
            if (error) {
                NSLog(@"第 %d 张图片上传失败: %@", (int)i + 1, error);
                dispatch_group_leave(group);
            } else {
                NSLog(@"第 %d 张图片上传成功: %@", (int)i + 1, responseObject);
                @synchronized (result) { // NSMutableArray 是线程不安全的，所以加个同步锁
                    result[i] = responseObject;
                }
                dispatch_group_leave(group);
            }
        }];
        [uploadTask resume];
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"上传完成!");
        for (id response in result) {
            NSLog(@"response:%@", response);
        }
        
        // 上传图片完成之后,先删除本地图片,再提交json数据
        [self deletSandboxImages];
        
    });
}

- (void)runDispatch2
{
    // 需要上传的数据
    NSArray *images = [self images];
    
    NSDictionary *parameters = @{@"students_id":[[AppDefaultUtil sharedInstance] getStudentId]};
    
    // 准备保存结果的数组，元素个数与上传的图片个数相同，先用 NSNull 占位
    NSMutableArray *result = [NSMutableArray array];
    for (UIImage *image in images) {
        [result addObject:[NSNull null]];
    }
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 3;
    
    NSBlockOperation *completionOperation = [NSBlockOperation blockOperationWithBlock:^{
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{ // 回到主线程执行，方便更新 UI 等
            NSLog(@"上传完成!");
            for (id response in result) {
                NSLog(@"%@", response);
            }
            
            // 上传图片完成之后,先删除本地图片,再提交json数据
            [self deletSandboxImages];
            
        }];
    }];
    
    for (NSInteger i = 0; i < images.count; i++) {
        
        NSURLSessionUploadTask* uploadTask = [self uploadTaskWithImage:images[i] completion:^(NSURLResponse *response, NSDictionary* responseObject, NSError *error) {
            if (error) {
                NSLog(@"第 %d 张图片上传失败: %@", (int)i + 1, error);
            } else {
                NSLog(@"第 %d 张图片上传成功: %@", (int)i + 1, responseObject);
                @synchronized (result) { // NSMutableArray 是线程不安全的，所以加个同步锁
                    result[i] = responseObject;
                }
            }
        }];
        
        URLSessionWrapperOperation *uploadOperation = [URLSessionWrapperOperation operationWithURLSessionTask:uploadTask];
        
        [completionOperation addDependency:uploadOperation];
        [queue addOperation:uploadOperation];
    }
    
    [queue addOperation:completionOperation];
    
}

- (NSArray *)images
{
    NSMutableArray *array = [NSMutableArray array];
    if (!_isUpdate) {
        // 首页作业图片
        NSMutableArray *aaa = [NSMutableArray arrayWithObjects:self.openedImgView.image, nil];
        [array addObject:aaa];
    }
    
    
    for (NSInteger i=_startPizhuCount; i<self.pizhuArray.count; i++) {
        
        Mark *mark = self.pizhuArray[i];
        NSMutableArray *seconds = [mark.images copy];
//        for (NSString *str in mark.content_img) {
        
//            [[NBPhotoPickerDatas defaultPicker] getAssetsPhotoWithURLs:[NSURL URLWithString:str] callBack:^(UIImage *obj) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [seconds addObject:obj];
//                });
//                
//            }];
//        }
        [array addObject:seconds];
    }
    
    /*
    NSMutableArray *array = [NSMutableArray array];
    // self.openedImgView.image
    NSMutableArray *aaa = [NSMutableArray arrayWithObjects:self.openedImgView.image, nil];
    [array addObject:aaa];
    
    NSMutableArray *imagePaths = self.pathArray[_openedIndex];
    for (NSString *imagePath in imagePaths) {//批注个数
        NSMutableArray *seconds = [NSMutableArray array];
        NSArray *arr = [imagePath componentsSeparatedByString:@","];
        for (NSString *path in arr) {//每个批注上传的图片
            // 读取沙盒路径图片
            NSString *pathfile=[NSString stringWithFormat:@"%@%@",NSHomeDirectory(),path];
            // 拿到沙盒路径图片
            UIImage *image = [[UIImage alloc]initWithContentsOfFile:pathfile];
            [seconds addObject:image];
        }
        [array addObject:seconds];
    }
     */
    
    return array;
}

- (void)deletSandboxImages
{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    
    NSMutableArray *imagePaths = self.pathArray[_openedIndex];
    for (NSString *imagePath in imagePaths) {
        NSArray *arr = [imagePath componentsSeparatedByString:@","];
        for (NSString *path in arr) {
            // 读取沙盒路径图片
            NSString *pathfile=[NSString stringWithFormat:@"%@%@",NSHomeDirectory(),path];
            
            [fileManager removeItemAtPath:pathfile error:nil];
        }
        
        
    }
}

#pragma mark - CustomeAlertViewDataSource
- (NSInteger)alertCollectionView:(CustomeAlertViewWithCollection *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.subjectsArray.count;
}

- (UICollectionViewCell *)alertCollectionView:(CustomeAlertViewWithCollection *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    FolderCollectionViewCell *cell = [collectionView dequeueReusableAlertCellWithIdentifier:identifier forIndexPath:indexPath];
    [self.subjectCellDict setObject:cell forKey:indexPath];
    
    SubjectInfo *modal = self.subjectsArray[indexPath.item];
    cell.iconImageView.image = [UIImage imageNamed:@"icon_file"];
    cell.nameLabel.text = modal.subjectName;
    
    return cell;
}

#pragma mark - CustomeAlertViewDelegate
- (void)alertCollectionView:(CustomeAlertViewWithCollection *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.subjectCellDict) {
        
        FolderCollectionViewCell *cell = [self.subjectCellDict objectForKey:indexPath];
        cell.iconImageView.image = [UIImage imageNamed:@"tick"];
    }
}

- (void)alertCollectionView:(CustomeAlertViewWithCollection *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.subjectCellDict) {
        
        FolderCollectionViewCell *cell = [self.subjectCellDict objectForKey:indexPath];
        cell.iconImageView.image = [UIImage imageNamed:@"icon_file"];
    }
}

#pragma mark - 更新
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.downloadUrl]];
    }
}

/*
#pragma mark - touch

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self addTouchPoint:touches];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self addTouchPoint:touches];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self addTouchPoint:touches];
    CGPoint startPoint = [self.points.firstObject CGPointValue];
    CGPoint endPoint = [self.points.lastObject CGPointValue];
    CGRect rect = [self getRectWithStartPoint:startPoint endPoint:endPoint];
    self.clipedImage = [self clipImageWithImage:self.openedImgView.image inRect:rect];
}

#pragma mark - method
- (void)addTouchPoint:(NSSet *)touches
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.openedImgView];
    [self.points addObject:[NSValue valueWithCGPoint:point]];
}

- (CGRect)getRectWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint
{
    CGPoint orignal = CGPointMake(endPoint.x > startPoint.x ? startPoint.x:endPoint.x, endPoint.y > startPoint.y ? startPoint.y:endPoint.y);
    
    CGFloat width = fabs(startPoint.x - endPoint.x);
    CGFloat height = fabs(startPoint.y - endPoint.y);
    return CGRectMake(orignal.x , orignal.y , width, height);
}

#pragma mark - image clip
// 图片剪切
- (UIImage*)clipImageWithImage:(UIImage*)image inRect:(CGRect)rect {
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    
    UIGraphicsBeginImageContext(image.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextDrawImage(context, rect, imageRef);
    
    UIImage* clipImage = [UIImage imageWithCGImage:imageRef];
    
    //    CGImageCreateWithImageInRect(CGImageRef  _Nullable image, <#CGRect rect#>)
    
    //    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();      // 不同的方式
    
    UIGraphicsEndImageContext();
    
    //    NSData* data = [NSData dataWithData:UIImagePNGRepresentation(clipImage)];
    
    //    BOOL flag = [data writeToFile:@"/Users/gua/Desktop/Image/后.png" atomically:YES];
    
    //    GGLogDebug(@"========压缩后=======%@",clipImage);
    
    return clipImage;
    
}

// 图片压缩
- (UIImage*)imageCompressImage:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth {
    
    CGSize imageSize = sourceImage.size;
    
    CGFloat width = imageSize.width;
    
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = defineWidth;
    
    CGFloat targetHeight = (targetWidth / width) * height;
    
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    
    [sourceImage drawInRect:CGRectMake(0,0,targetWidth, targetHeight)];
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
    
}
*/

- (void)clearCache
{
    [[SDImageCache sharedImageCache] clearDisk];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}
 
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self clearCache];
    // 移除手势
    NSArray *arr = [self.view gestureRecognizers];
    for (UIGestureRecognizer *ges in arr) {
        [self.view removeGestureRecognizer:ges];
    }
    
    self.points = nil;
    self.openedImgView = nil;
    self.bgScrollView = nil;
    self.pizhuScrollView = nil;
    
    self.openImageArray = nil;
    self.imgViewArray = nil;
    self.subjectCellDict = nil;
    self.subjectsArray = nil;
    
    self.pathArray = nil;
    self.pizhuArray = nil;
    self.pizhuCountArray = nil;
    
    self.itemsArr = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [self clearCache];
    
    self.imgViewArray = nil;
    self.subjectCellDict = nil;
    self.subjectsArray = nil;
    
    self.pathArray = nil;
    self.pizhuArray = nil;
    self.pizhuCountArray = nil;
    
    self.itemsArr = nil;
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
