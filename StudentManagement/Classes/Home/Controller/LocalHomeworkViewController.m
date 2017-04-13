//
//  LocalHomeworkViewController.m
//  StudentManagement
//
//  Created by Kitty on 17/4/1.
//  Copyright © 2017年 Kitty. All rights reserved.
//

#import "LocalHomeworkViewController.h"
#import "ZuoyeCollectionViewCell.h"
#import "NBPhotoPickerDatas.h"
#import "Homework.h"

@interface LocalHomeworkViewController () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSInteger _selCount;
}

@property (nonatomic,strong) NSMutableDictionary *cellDict;
@property (nonatomic,strong) NSMutableArray *workArray;
@property (nonatomic,strong) NSMutableArray *selectArray;
@property (nonatomic,strong) UICollectionView *collectionView;

@end

@implementation LocalHomeworkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(sureClick)];
    _selCount = 0;
    
    [self initCollectionView];
    
    [self loadData];
}

- (NSMutableDictionary *)cellDict
{
    if (!_cellDict) {
        _cellDict = [NSMutableDictionary dictionary];
    }
    return _cellDict;
}

- (NSMutableArray *)workArray
{
    if (!_workArray) {
        _workArray = [NSMutableArray array];
    }
    return _workArray;
}

- (NSMutableArray *)selectArray
{
    if (!_selectArray) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}

- (void)initCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //    layout.itemSize = CGSizeMake(130, 130);
    //    layout.minimumLineSpacing = 30; // 行间距
    //    layout.minimumInteritemSpacing = 80; // 垂直间距
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64) collectionViewLayout:layout];
    _collectionView.backgroundColor = KblackgroundColor;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerNib:[UINib nibWithNibName:@"ZuoyeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
    [self.view addSubview:_collectionView];
    
}

- (void)loadData
{
    NSString *documentsPath = [DocumentsPath stringByAppendingPathComponent:self.subjectName];
    for (NSString *file in self.fileArray) {
        NSString *filePath = [documentsPath stringByAppendingPathComponent:file];
        Homework *work = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        [self.workArray addObject:work];
    }
    [self.collectionView reloadData];
}

- (void)sureClick
{
    if (_selCount <=0) {
        return;
    }
    for (Homework *model in self.workArray) {
        if (model.isSel) {
            [self.selectArray addObject:model];
        }
    }
    
    NSDictionary *userInfo = @{@"subjectId":self.subjectId};
    [[NSNotificationCenter defaultCenter] postNotificationName:OpenHomeworkNotification object:self.selectArray userInfo:userInfo];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.workArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    ZuoyeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    [self.cellDict setObject:cell forKey:indexPath];
    cell.selectBtn.tag = 10 + indexPath.item;
    
    __block Homework *modal = self.workArray[indexPath.item];
    [[NBPhotoPickerDatas defaultPicker] getAssetsPhotoWithURLs:[NSURL URLWithString:modal.assetURL] callBack:^(UIImage *image) {
        cell.photoImageView.image = image;
        modal.img = image;
    }];
    cell.nameLabel.text = modal.homeworkName;
    cell.selectBtn.selected = NO;
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (self.cellDict) {
        
        ZuoyeCollectionViewCell *cell = self.cellDict[indexPath];
        
        cell.selectBtn.selected = !cell.selectBtn.selected;
        //        [cell.selectBtn addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
        Homework *modal = self.workArray[indexPath.item];
        modal.isSel = cell.selectBtn.selected;
        
        if (cell.selectBtn.selected) {
            _selCount ++;
        }else{
            _selCount --;
        }
        [cell.selectBtn setTitle:[NSString stringWithFormat:@"√"] forState:UIControlStateSelected];
        
    }
    
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([UIScreen mainScreen].bounds.size.width > 1024){
        return CGSizeMake((SCREENWIDTH-20*6)/5, (SCREENWIDTH-20*6)/5*0.7);
    }
    return CGSizeMake((SCREENWIDTH-20*5)/4, (SCREENWIDTH-20*4)/4*0.7);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(20, 20, 20, 20);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 20;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 20;
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
