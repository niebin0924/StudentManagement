//
//  SubjectFolderViewController.m
//  StudentManagement
//
//  Created by Kitty on 17/2/17.
//  Copyright © 2017年 Kitty. All rights reserved.
//

#import "SubjectFolderViewController.h"
#import "SomeSubjectViewController.h"
#import "LocalHomeworkViewController.h"
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
            self.title = @"保存";
            break;
        case FolderTypeUpload:
            self.title = @"另存为";
            break;
        case FolderTypeOpen:
            self.title = @"复习";
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
    if (self.type == FolderTypeOut) {
        NSArray *arr = @[@"本地英语",@"本地语文",@"本地数学",@"本地历史",@"本地物理",@"本地化学",@"本地生物",@"重要一",@"重要二",@"考试一",@"考试二",@"易错题集"];
        self.dataArray = [NSMutableArray array];
        for (NSInteger i=0; i<arr.count; i++) {
            SubjectInfo *model = [[SubjectInfo alloc] init];
            model.subjectId = [NSString stringWithFormat:@"%zd",i+1];
            model.subjectName = arr[i];
            [self.dataArray addObject:model];
        }
    }else{
        self.dataArray = [NSKeyedUnarchiver unarchiveObjectWithFile:SubjectFileName];
    }
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
    SubjectInfo *model = self.dataArray[indexPath.item];
    if (self.type == FolderTypeOut) {
        NSString *subjectName;
        if ([model.subjectId isEqualToString:@"1"]) {
            subjectName = @"英语";
        }else if ([model.subjectId isEqualToString:@"2"]) {
            subjectName = @"语文";
        }else if ([model.subjectId isEqualToString:@"3"]) {
            subjectName = @"数学";
        }else if ([model.subjectId isEqualToString:@"4"]) {
            subjectName = @"历史";
        }else if ([model.subjectId isEqualToString:@"5"]) {
            subjectName = @"物理";
        }else if ([model.subjectId isEqualToString:@"6"]) {
            subjectName = @"化学";
        }else if ([model.subjectId isEqualToString:@"7"]) {
            subjectName = @"生物";
        }else if ([model.subjectId isEqualToString:@"8"]) {
            subjectName = @"重要一";
        }else if ([model.subjectId isEqualToString:@"9"]) {
            subjectName = @"重要二";
        }else if ([model.subjectId isEqualToString:@"10"]) {
            subjectName = @"考试一";
        }else if ([model.subjectId isEqualToString:@"11"]) {
            subjectName = @"考试二";
        }else if ([model.subjectId isEqualToString:@"12"]) {
            subjectName = @"易错题集";
        }
        // 本地
        NSMutableArray *fileArr = [NSMutableArray array];
        NSString *documentsPath = [DocumentsPath stringByAppendingPathComponent:subjectName];
        NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsPath error:nil];
        for (NSString *file in files) {
            if ([file hasSuffix:@"src"]) {
                [fileArr addObject:file];
            }
        }
        LocalHomeworkViewController *vc = [[LocalHomeworkViewController alloc] init];
        vc.subjectId = model.subjectId;
        vc.subjectName = subjectName;
        vc.fileArray = fileArr;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        SomeSubjectViewController *vc = [[SomeSubjectViewController alloc] init];
        vc.folderType = self.type;
        vc.subjectId = model.subjectId;
        vc.subjectName = model.subjectName;
        [self.navigationController pushViewController:vc animated:YES];
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
