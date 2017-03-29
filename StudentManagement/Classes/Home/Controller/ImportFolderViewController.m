//
//  ImportFolderViewController.m
//  StudentManagement
//
//  Created by Kitty on 17/3/3.
//  Copyright © 2017年 Kitty. All rights reserved.
//

#import "ImportFolderViewController.h"
#import "FolderCollectionViewCell.h"
#import "CustomePopView.h"

@interface ImportFolderViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    NSIndexPath *_selIndexPath;
    NSString *_subjectId;
}

@property (nonatomic,strong) NSMutableDictionary *cellDict;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UICollectionView *collectionView;

@end

@implementation ImportFolderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = KblackgroundColor;
    self.title = @"上传";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(sureClick)];
    
    [self initData];
    
    [self initCollectionView];
}

- (void)initData
{
    self.cellDict = [NSMutableDictionary dictionary];
    self.dataArray = [NSKeyedUnarchiver unarchiveObjectWithFile:SubjectFileName];
    
//    NSArray *arr = [[AppDefaultUtil sharedInstance] getSubjects];
//    for (NSData *data in arr) {
//        SubjectInfo *subject = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//        [self.dataArray addObject:subject];
//    }
}

- (void)initCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //    layout.itemSize = CGSizeMake(130, 130);
    //    layout.minimumLineSpacing = 30; // 行间距
    //    layout.minimumInteritemSpacing = 80; // 垂直间距
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerNib:[UINib nibWithNibName:@"FolderCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
    [self.view addSubview:_collectionView];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    FolderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    [self.cellDict setObject:cell forKey:indexPath];
    
    SubjectInfo *subject = self.dataArray[indexPath.item];
    cell.iconImageView.image = [UIImage imageNamed:@"icon_file"];
    cell.nameLabel.text = subject.subjectName;
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (self.cellDict) {
        SubjectInfo *subject = self.dataArray[indexPath.item];
        _subjectId = subject.subjectId;
        
        _selIndexPath = indexPath;
        
        FolderCollectionViewCell *cell = [self.cellDict objectForKey:indexPath];
        cell.iconImageView.image = [UIImage imageNamed:@"tick"];
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.cellDict) {
        
        FolderCollectionViewCell *cell = [self.cellDict objectForKey:indexPath];
        cell.iconImageView.image = [UIImage imageNamed:@"icon_file"];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([UIScreen mainScreen].bounds.size.width > 1024){
        return CGSizeMake((SCREENWIDTH-60*6)/5, (SCREENWIDTH-60*6)/5*0.7);
    }
    return CGSizeMake((SCREENWIDTH-60*5)/4, (SCREENWIDTH-60*5)/4*0.7);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(30, 30, 0, 20);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 20;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 40;
}

#pragma mark - click
- (void)sureClick
{
    // 2.Block传值(代码块属性不为空)
    if (self.valueBlock) {
        self.valueBlock(_subjectId);
    }
    [self.navigationController popViewControllerAnimated:YES];
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
