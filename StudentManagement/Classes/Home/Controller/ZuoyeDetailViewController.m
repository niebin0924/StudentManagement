//
//  ZuoyeDetailViewController.m
//  StudentManagement
//
//  Created by Kitty on 17/2/23.
//  Copyright © 2017年 Kitty. All rights reserved.
//

#define Padding     30

#import "ZuoyeDetailViewController.h"

@interface ZuoyeDetailViewController ()

@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *stuLabel;
@property (nonatomic,strong) UILabel  *teachLabel;
@property (nonatomic,strong) UILabel *stateLabel;
@property (nonatomic,strong) UILabel *markLabel;
@property (nonatomic,strong) UILabel *lookTimeLabel;
@property (nonatomic,strong) UILabel *markTimeLabel;

@end

@implementation ZuoyeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = KblackgroundColor;
    self.title = @"作业详情";
    
    [self initView];
    
    [self request];
}

- (void)initView
{
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@20);
        make.left.equalTo(@20);
        make.right.equalTo(@-20);
        make.height.equalTo(@340);
    }];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.text = @"";
    _timeLabel.textColor = [UIColor lightGrayColor];
    [bgView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.mas_left).with.offset(Padding);
        make.top.equalTo(bgView.mas_top).with.offset(10);
        make.height.equalTo(@20);
    }];
    
    UILabel *line1 = [[UILabel alloc] init];
    line1.backgroundColor = KColor;
    [bgView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@1);
        make.top.equalTo(_timeLabel.mas_bottom).with.offset(10);
        make.left.equalTo(bgView.mas_left);
        make.right.equalTo(bgView.mas_right);
    }];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.text = @"文件名: ";
    [bgView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_timeLabel.mas_left);
        make.height.equalTo(@20);
        make.top.equalTo(_timeLabel.mas_bottom).with.offset(Padding);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterPizhu)];
    self.nameLabel.userInteractionEnabled = YES;
    [self.nameLabel addGestureRecognizer:tap];
    
    _stuLabel = [[UILabel alloc] init];
    _stuLabel.text = @"学生: ";
    [bgView addSubview:_stuLabel];
    [_stuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_timeLabel.mas_left);
        make.height.equalTo(@20);
        make.top.equalTo(_nameLabel.mas_bottom).with.offset(Padding);
    }];
    
    _stateLabel = [[UILabel alloc] init];
    _stateLabel.text = @"状态: ";
    [bgView addSubview:_stateLabel];
    [_stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_timeLabel.mas_left);
        make.height.equalTo(@20);
        make.top.equalTo(_stuLabel.mas_bottom).with.offset(Padding);
    }];
    
    _teachLabel = [[UILabel alloc] init];
    _teachLabel.text = @"教师: ";
    [bgView addSubview:_teachLabel];
    [_teachLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_timeLabel.mas_left);
        make.height.equalTo(@20);
        make.top.equalTo(_stateLabel.mas_bottom).with.offset(Padding);
    }];
    
    _markLabel = [[UILabel alloc] init];
    _markLabel.text = @"批注: 个";
    [bgView addSubview:_markLabel];
    [_markLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_timeLabel.mas_left);
        make.height.equalTo(@20);
        make.top.equalTo(_teachLabel.mas_bottom).with.offset(Padding);
    }];
    
    UILabel *line2 = [[UILabel alloc] init];
    line2.backgroundColor = KColor;
    [bgView addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@1);
        make.top.equalTo(_markLabel.mas_bottom).with.offset(15);
        make.left.equalTo(bgView.mas_left);
        make.right.equalTo(bgView.mas_right);
    }];
    
    _lookTimeLabel = [[UILabel alloc] init];
    _lookTimeLabel.text = @"查看时间: ";
    [bgView addSubview:_lookTimeLabel];
    [_lookTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_timeLabel.mas_left);
        make.height.equalTo(@20);
        make.width.equalTo(@((SCREENWIDTH-20*2-30*2) / 2));
        make.top.equalTo(_markLabel.mas_bottom).with.offset(Padding);
    }];
    
    _markTimeLabel = [[UILabel alloc] init];
    _markTimeLabel.text = @"批注时间: ";
    [bgView addSubview:_markTimeLabel];
    [_markTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_lookTimeLabel.mas_right);
        make.height.equalTo(@20);
        make.width.equalTo(@((SCREENWIDTH-20*2-30*2) / 2));
        make.top.equalTo(_markLabel.mas_bottom).with.offset(Padding);
    }];
}

- (void)request
{
    NSString *url = @"students/tidings/content/state/bylf";
    NSDictionary *parameters = @{@"tidings_id":self.tidingId, @"students_id":[[AppDefaultUtil sharedInstance] getStudentId]};
    NetWork *network = [[NetWork alloc] init];
    [network postHttpNetWorkWithUrl:url WithBlock:parameters block:^(NSData *data, NSError *error) {
        if (data) {
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if ([[dict objectForKey:@"code"] integerValue] == 0) {
                
                id jsonResult = [dict objectForKey:@"content"];
                if ([jsonResult isEqual:[NSNull null]]) {
                    
                    return ;
                }
                NSDictionary *results = [dict objectForKey:@"content"];
                
                NSString *time = [NSString stringWithFormat:@"%@",[results objectForKey:@"time"]];
                self.timeLabel.text = [self timeWithTimeIntervalString:time];
                self.nameLabel.text = [NSString stringWithFormat:@"文件名：%@",[results objectForKey:@"homework_name"]];
                self.stuLabel.text = [NSString stringWithFormat:@"学生：%@",[results objectForKey:@"students_name"]];
                NSNumber *state = [[NSString stringWithFormat:@"%@",[results objectForKey:@"state"]] numberValue];
                // 0:未查看，1已查看，2已批注
                if ([state isEqual:@0]) {
                    self.stateLabel.text = @"状态：未查看";
                }else if ([state isEqual:@1]) {
                    self.stateLabel.text = @"状态：已查看";
                }else if ([state isEqual:@2]) {
                    self.stateLabel.text = @"状态：已批注";
                }
                self.teachLabel.text = [NSString stringWithFormat:@"教师：%@",[results objectForKey:@"teacher_name"]];
                NSString *pizhu_count = [NSString stringWithFormat:@"%@",[results objectForKey:@"pizhu_count"]];
                self.markLabel.text = [NSString stringWithFormat:@"批注：%@个",pizhu_count];
                NSRange range = [self.markLabel.text rangeOfString:pizhu_count];
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:self.markLabel.text];
                [str addAttribute:NSForegroundColorAttributeName value:KColor range:range];
                self.markLabel.attributedText = str;
               
                NSString *seltime = [NSString stringWithFormat:@"%@",[results objectForKey:@"seltime"]];
                self.lookTimeLabel.text = [NSString stringWithFormat:@"查看时间：%@",[self timeWithTimeIntervalString:seltime]];
                
                
                NSString *pztime = [NSString stringWithFormat:@"%@",[results objectForKey:@"pztime"]];
                self.markTimeLabel.text = [NSString stringWithFormat:@"批注时间：%@",[self timeWithTimeIntervalString:pztime]];
                
                
                
            }else{
                
            }
            
        }else {
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
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    // 毫秒值转化为秒
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[time doubleValue]/ 1000.0];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}

- (void)enterPizhu
{
    
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
