//
//  GuideViewController.m
//  StudentManagement
//
//  Created by Kitty on 17/2/15.
//  Copyright © 2017年 Kitty. All rights reserved.
//

#import "GuideViewController.h"
#import "LoginViewController.h"
#import "WelcomeCollectionCell.h"
#import "MyPageControl.h"
#import "AppDelegate.h"

@interface GuideViewController () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>

@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic,strong) UIButton *startBtn;

@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = KblackgroundColor;
    self.dataArray = [NSMutableArray array];
//    [self.dataArray addObject:@"page_pic01"];
    [self.dataArray addObject:@"page_pic02"];
    [self.dataArray addObject:@"page_pic03"];
    [self initView];

//    [self request];
}

- (void)initView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    // 定义大小
    layout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);//[UIScreen mainScreen].bounds.size;
    // 设置垂直间距
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    // 设置滚动方向（默认垂直滚动）
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"WelcomeCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
    // 开启分页
    self.collectionView.pagingEnabled = YES;
    // 隐藏水平滚动条
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    // 取消弹簧效果
    self.collectionView.bounces = NO;
    [self.view addSubview:self.collectionView];
    
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(SCREENWIDTH*0.5*0.5, SCREENHEIGHT-100, SCREENWIDTH*0.5, 30)];
    _pageControl.currentPage = 0;
    _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    _pageControl.currentPageIndicatorTintColor = KColor;
    [self.view addSubview:_pageControl];
    _pageControl.numberOfPages = self.dataArray.count;
    
    _startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _startBtn.frame = CGRectMake((SCREENWIDTH-150)/2, SCREENHEIGHT-70, 150, 40);
    [_startBtn setTitle:@"立即启动" forState:UIControlStateNormal];
    [_startBtn setTitleColor:KColor forState:UIControlStateNormal];
    _startBtn.layer.borderWidth = 1;
    _startBtn.layer.borderColor = [[UIColor redColor] CGColor];
    _startBtn.layer.masksToBounds = YES;
    _startBtn.layer.cornerRadius = 2;
    _startBtn.hidden = YES;
    [_startBtn addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_startBtn];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    WelcomeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    cell.welImageView.image = [UIImage imageNamed:self.dataArray[indexPath.item]];
//    [cell.welImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseURL,self.dataArray[indexPath.item]]]];
    
    return cell;
}

- (void)request
{
    NSString *url = @"students/welcome/index/state/bylf";
    NetWork *network = [[NetWork alloc] init];
    NSDictionary *parameters = @{@"statr":@"bylf"};
    [network httpNetWorkWithUrl:url WithBlock:parameters block:^(NSData *data, NSError *error) {
        if (data) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if ([[dict objectForKey:@"code"] integerValue] == 0) {
                
                id jsonResult = [dict objectForKey:@"content"];
                if ([jsonResult isEqual:[NSNull null]]) {
                    
                    return ;
                }
                NSArray *result = [dict objectForKey:@"content"];
                if (result && result.count > 0) {
                    
                    for (NSInteger i=0; i<result.count; i++) {
                        
                        NSDictionary *d = [result objectAtIndex:i];
                        NSString *welcome_img = [NSString stringWithFormat:@"%@",[d objectForKey:@"welcome_img"]];
                        [self.dataArray addObject:welcome_img];
                    }
                    
                    self.pageControl.numberOfPages = self.dataArray.count;
                    
                    [self.collectionView reloadData];
                }
                
            }else {
                [[UIApplication sharedApplication].keyWindow makeToast:[dict objectForKey:@"msg"]];
            }
            
        }
        else{
            if (error) {
                
            }
        }
        
    }];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat xOffset = self.collectionView.contentOffset.x / SCREENWIDTH;
    self.pageControl.currentPage = xOffset;
    if (xOffset == self.dataArray.count - 1) {
        self.startBtn.hidden = NO;
    }else{
        self.startBtn.hidden = YES;
    }
}

- (void)start
{
    LoginViewController *login = [[LoginViewController alloc] init];
    MainNavigationController *nav = [[MainNavigationController alloc] initWithRootViewController:login];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    app.window.rootViewController = nav;
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
