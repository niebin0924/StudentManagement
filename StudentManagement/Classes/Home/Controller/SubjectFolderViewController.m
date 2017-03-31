//
//  SubjectFolderViewController.m
//  StudentManagement
//
//  Created by Kitty on 17/2/17.
//  Copyright © 2017年 Kitty. All rights reserved.
//

#import "SubjectFolderViewController.h"
#import "SomeSubjectViewController.h"
#import "FolderCollectionViewCell.h"

@interface SubjectFolderViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UICollectionView *collectionView;

@end

@implementation SubjectFolderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = KblackgroundColor;
    self.title = @"文件夹";
    [self initTitle];
    
    [self initData];
    
    [self initCollectionView];
    
}

- (void)initTitle
{
    switch (self.type) {
        case FolderTypeImport:
            self.title = @"导入";
            break;
        case FolderTypeOut:
            self.title = @"导出";
            break;
        case FolderTypeUpload:
            self.title = @"另存为";
            break;
        case FolderTypeOpen:
            self.title = @"打开";
            break;
        case FolderTypeDelete:
            self.title = @"删除";
            break;
        default:
            break;
    }
}

- (void)initData
{
    self.dataArray = [NSKeyedUnarchiver unarchiveObjectWithFile:SubjectFileName];
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
    
    SubjectInfo *subject = self.dataArray[indexPath.item];
    cell.nameLabel.text = subject.subjectName;
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    SubjectInfo *subject = self.dataArray[indexPath.item];
    SomeSubjectViewController *vc = [[SomeSubjectViewController alloc] init];
    vc.folderType = self.type;
    vc.subjectId = subject.subjectId;
    vc.subjectName = subject.subjectName;
    [self.navigationController pushViewController:vc animated:YES];
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
