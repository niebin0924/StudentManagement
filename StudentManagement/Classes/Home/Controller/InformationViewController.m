//
//  InformationViewController.m
//  StudentManagement
//
//  Created by Kitty on 17/2/17.
//  Copyright © 2017年 Kitty. All rights reserved.
//

#import "InformationViewController.h"
#import "InformationDetailViewController.h"
#import "InfoHeaderTableViewCell.h"
#import "InfoTableViewCell.h"
#import "MessageList.h"

@interface InformationViewController () <UITableViewDataSource,UITableViewDelegate>
{
    NSInteger _currPage;
}

@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation InformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = KblackgroundColor;
    self.title = @"消息";
    
    [self initData];

    [self initTable];
    
    [self initBtns];
    
    [self request];
}

- (void)initData
{
    self.dataArray = [NSMutableArray array];
    _currPage = 1;
}

- (void)initTable
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(20, 10, SCREENWIDTH-20*2, SCREENHEIGHT-200) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerNib:[UINib nibWithNibName:@"InfoHeaderTableViewCell" bundle:nil] forCellReuseIdentifier:@"headerCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"InfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"InfoCell"];
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
}

- (void)initBtns
{
    UIButton *previousBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    previousBtn.frame = CGRectMake(20, CGRectGetMaxY(self.tableView.frame)+30, 120, 50);
    [previousBtn setBackgroundImage:[UIImage imageNamed:@"bt_previous_page"] forState:UIControlStateNormal];
    [previousBtn addTarget:self action:@selector(previousClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:previousBtn];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake(SCREENWIDTH-20-120, CGRectGetMaxY(self.tableView.frame)+30, 120, 50);
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"bt_next_page"] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
}

#pragma mark -request
- (void)request
{
    NSString *url = @"students/tidings/lists/state/bylf";
    NSDictionary *parameters = @{@"students_id":[[AppDefaultUtil sharedInstance] getStudentId], @"page":[NSString stringWithFormat:@"%zd",_currPage], @"page_size":@"20", @"looked_s":@"0"};
    NetWork *network = [[NetWork alloc] init];
    [network postHttpNetWorkWithUrl:url WithBlock:parameters block:^(NSData *data, NSError *error) {
       
        if (data) {
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if ([[dict objectForKey:@"code"] integerValue] == 0) {
                
                id jsonResult = [dict objectForKey:@"content"];
                if ([jsonResult isEqual:[NSNull null]]) {
                    
                    return ;
                }
                NSArray *results = [dict objectForKey:@"content"];
                if (results && results.count > 0) {
                    for (NSDictionary *d in results) {
                        
                        MessageList *modal = [[MessageList alloc] init];
                        modal.homeworkId = [NSString stringWithFormat:@"%@",[d objectForKey:@"homework_id"]];
                        modal.tidingId = [NSString stringWithFormat:@"%@",[d objectForKey:@"tidings_id"]];
                        modal.homeworkName = [NSString stringWithFormat:@"%@",[d objectForKey:@"homework_name"]];
                        modal.teacherName = [NSString stringWithFormat:@"%@",[d objectForKey:@"teacher_name"]];
                        modal.state = [[NSString stringWithFormat:@"%@",[d objectForKey:@"state"]] numberValue];
                        // 0:未查看，1已查看，2已批注
                        NSString *time = [NSString stringWithFormat:@"%@",[d objectForKey:@"time"]];
                        modal.time = [self timeWithTimeIntervalString:time];
                        
                        [self.dataArray addObject:modal];
                        
                    }
                    
                    
                    [self.tableView reloadData];
                    
                }else {
                    [SVProgressHUD showSuccessWithStatus:@"无新消息"];
                }
                
                
                
            }else{
                
            }
            
        }else{
            if (error) {
                
            }
        }
    }];
}

- (NSString *)timeWithTimeIntervalString:(NSString *)time
{
    // 格式化时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    // 毫秒值转化为秒
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[time doubleValue]/ 1000.0];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}

- (void)previousClick
{
    if (_currPage > 1) {
        _currPage ++;
        [self request];
    }
}

- (void)nextClick
{
    _currPage --;
    [self request];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *identifier = @"headerCell";
        InfoHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        
        return cell;
    }
    
    static NSString *identifier = @"InfoCell";
    InfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    MessageList *modal = self.dataArray[indexPath.row-1];
    cell.timeLabel.text = modal.time;
    cell.teacherLabel.text = modal.teacherName;
    // 0:未查看，1已查看，2已批注
    if ([modal.state isEqual:@0]) {
        cell.stateLabel.text = @"未查看";
    }else if ([modal.state isEqual:@1]) {
        cell.stateLabel.text = @"已查看";
    }else if ([modal.state isEqual:@2]) {
        cell.stateLabel.text = @"已批注";
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MessageList *modal = self.dataArray[indexPath.row-1];
    
    InformationDetailViewController *vc = [[InformationDetailViewController alloc] init];
    vc.homeworkId = modal.homeworkId;
    vc.tidingId = modal.tidingId;
    [self.navigationController pushViewController:vc animated:YES];
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
