//
//  SomeSubjectViewController.m
//  StudentManagement
//
//  Created by Kitty on 17/2/17.
//  Copyright © 2017年 Kitty. All rights reserved.
//

#import "SomeSubjectViewController.h"
#import "ZuoyeCollectionViewCell.h"
#import "Homework.h"
#import "Mark.h"

@interface SomeSubjectViewController () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSInteger _currPage;
    NSInteger _selCount;
}

@property (nonatomic,strong) NSMutableDictionary *cellDict;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *selectArray;

@end

@implementation SomeSubjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = KblackgroundColor;
    self.title = self.subjectName;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(sureClick)];
    
    [self initData];
    
    [self initCollectionView];
    
}

- (void)initData
{
    _currPage = 1;
    _selCount = 0;
    self.cellDict = [NSMutableDictionary dictionary];
    self.dataArray = [NSMutableArray array];
    self.selectArray = [NSMutableArray array];
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
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self openSubject];
    }];
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self openSubject];
    }];
    [self.collectionView.mj_header beginRefreshing];
}

- (void)openSubject
{
    if ([self.collectionView.mj_header isRefreshing]) {
        _currPage = 1;
        [self.dataArray removeAllObjects];
        
    }else if ([self.collectionView.mj_footer isRefreshing]){
        _currPage ++;
    }
    
    
    NSString *url = @"students/subject/content/state/bylf";
    NSDictionary *parameters = @{@"students_id":[[AppDefaultUtil sharedInstance] getStudentId], @"subject_id":self.subjectId, @"page_size":@"20", @"page":[NSString stringWithFormat:@"%zd",_currPage]};
    NetWork *network = [[NetWork alloc] init];
    [network postHttpNetWorkWithUrl:url WithBlock:parameters block:^(NSData *data, NSError *error) {
        if (data) {
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if ([[dict objectForKey:@"code"] integerValue] == 0) {
                
                [self.collectionView.mj_header endRefreshing];
                [self.collectionView.mj_footer endRefreshing];
                
                id jsonResult = [dict objectForKey:@"content"];
                if ([jsonResult isEqual:[NSNull null]]) {
                    
                    return ;
                }
                NSArray *content = [dict objectForKey:@"content"];
                if (content && content.count > 0) {
                    
                    [self jsonData:content];
                    
                }else{
                    _currPage = 1;
                }
                
            }else {
                [[UIApplication sharedApplication].keyWindow makeToast:[dict objectForKey:@"msg"]];
                [self.collectionView.mj_header endRefreshing];
                [self.collectionView.mj_footer endRefreshing];
            }
            
        }else{
            if (error) {
                
            }
        }
    }];
}

#pragma mark - private
- (void)jsonData:(NSArray *)content
{
    for (NSDictionary *result in content) {
        
        Homework *modal = [[Homework alloc] init];
        modal.homeworkId = [NSString stringWithFormat:@"%@",[result objectForKey:@"homework_id"]];
        modal.teacherId = [NSString stringWithFormat:@"%@",[result objectForKey:@"teacher_id"]];
        modal.homeworkName = [NSString stringWithFormat:@"%@",[result objectForKey:@"homework_name"]];
        modal.imageUrlStr = [NSString stringWithFormat:@"%@",[result objectForKey:@"homework_img"]];
        modal.isDel = [[NSString stringWithFormat:@"%@",[result objectForKey:@"is_del"]] boolValue];
        modal.isMark = [NSString stringWithFormat:@"%@",[result objectForKey:@"is_pizhu"]];
        NSString *time = [NSString stringWithFormat:@"%@",[result objectForKey:@"addtime"]];
        modal.addTime = [self timeWithTimeIntervalString:time];
        // 批注
        NSArray *pizhu = [result objectForKey:@"pizhu"];
        NSMutableArray *array = [NSMutableArray array];
        if (pizhu && pizhu.count > 0) {
            for (NSDictionary *dic in pizhu) {
                Mark *mark = [[Mark alloc] init];
                mark.x = [[NSString stringWithFormat:@"%@",[dic objectForKey:@"x"]] floatValue];
                mark.y = [[NSString stringWithFormat:@"%@",[dic objectForKey:@"y"]] floatValue];
                mark.content = [NSString stringWithFormat:@"%@",[dic objectForKey:@"content"]];
                mark.content_img = [dic objectForKey:@"content_img"];
                [array addObject:mark];
            }
        }
        modal.pizhuArray = array;
        [self.dataArray addObject:modal];
    }
    
    [self.collectionView reloadData];

}

- (NSString *)timeWithTimeIntervalString:(NSString *)time
{
    // 格式化时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    // 毫秒值转化为秒
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[time doubleValue]/ 1000.0];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}

- (void)sureClick
{
    if (self.folderType == FolderTypeOpen) {
        [self openHomework];
    }else if (self.folderType == FolderTypeImport) {
        
    }
}

- (void)openHomework
{
    if (_selCount <=0) {
        return;
    }
    
    NSMutableArray *homeworkIds = [NSMutableArray array];
    for (Homework *modal in self.dataArray) {
        if (modal.isSel) {
            [homeworkIds addObject:modal.homeworkId];
            [self.selectArray addObject:modal];
        }
    }
    
    NSDictionary *userInfo = @{@"subjectId":self.subjectId};
    [[NSNotificationCenter defaultCenter] postNotificationName:OpenHomeworkNotification object:self.selectArray userInfo:userInfo];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (void)selectClick:(UIButton *)btn
{
    if (btn.selected) {
    
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    ZuoyeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    [self.cellDict setObject:cell forKey:indexPath];
    cell.selectBtn.tag = 10 + indexPath.item;
    
    Homework *modal = self.dataArray[indexPath.item];
    if ([modal.imageUrlStr rangeOfString:@"http"].location != NSNotFound) {
//        [cell.photoImageView sd_setImageWithURL:[NSURL URLWithString:modal.imageUrlStr] placeholderImage:[UIImage imageNamed:@"KNPhotoBrower.bundle/defaultPlaceHolder"]];
        
        [cell.photoImageView JYloadWebImage:modal.imageUrlStr placeholderImage:[UIImage imageNamed:@"KNPhotoBrower.bundle/defaultPlaceHolder"]];
        
    }else{
//        [cell.photoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseURL,modal.imageUrlStr]]];
        
        [cell.photoImageView JYloadWebImage:[BaseURL stringByAppendingString:modal.imageUrlStr] placeholderImage:[UIImage imageNamed:@"KNPhotoBrower.bundle/defaultPlaceHolder"]];
    }
    
    
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
