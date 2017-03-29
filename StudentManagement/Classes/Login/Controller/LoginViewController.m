//
//  LoginViewController.m
//  StudentManagement
//
//  Created by Kitty on 17/2/15.
//  Copyright © 2017年 Kitty. All rights reserved.
//

#import "LoginViewController.h"
#import "RegistViewController.h"
#import "ForgetPwdViewController.h"
#import "HomeViewController.h"
#import "QCheckBox.h"

@interface LoginViewController () <QCheckBoxDelegate,UITextFieldDelegate>

@property (nonatomic,strong) UITextField *phoneField;
@property (nonatomic,strong) UITextField *passwordField;
@property (nonatomic,strong) QCheckBox *checkBox;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = KblackgroundColor;
    self.title = @"登录";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(regist)];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(keyboardHide:)];
    [self.view addGestureRecognizer:tap];
    
    [self initView];
    
    [self updateFieldData];
    
    if (![self.phoneField.text isEqualToString:@""] && ![self.passwordField.text isEqualToString:@""]) {
        [self login];
    }
    
}

- (void)updateFieldData
{
    if (![[[AppDefaultUtil sharedInstance] getAccount] isEqualToString:@""] && ![[[AppDefaultUtil sharedInstance] getAccount] isEqualToString:@"(null)"] && ![[[AppDefaultUtil sharedInstance] getAccount] isEqualToString:@"<null>"]) {
        self.phoneField.text = [[AppDefaultUtil sharedInstance] getAccount];
    }
    
    if ([[AppDefaultUtil sharedInstance] isRemeberUser]) {
        if (![[[AppDefaultUtil sharedInstance] getPwd] isEqualToString:@""] && ![[[AppDefaultUtil sharedInstance] getPwd] isEqualToString:@"(null)"] && ![[[AppDefaultUtil sharedInstance] getPwd] isEqualToString:@"<null>"]) {
            self.passwordField.text = [[AppDefaultUtil sharedInstance] getPwd];
        }
    }
    

    self.checkBox.checked = [[AppDefaultUtil sharedInstance] isRemeberUser];
    
}

- (void)initView
{
    UIImageView *logoImgView = [[UIImageView alloc] init];
    logoImgView.image = [UIImage imageNamed:@"logo"];
    logoImgView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:logoImgView];
    [logoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREENWIDTH*0.5, 30));
        make.top.equalTo(@30);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 4;
    bgView.layer.borderColor = [KlayerBorder CGColor];
    bgView.layer.borderWidth = 1;
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREENWIDTH*0.5, 120));
        make.top.equalTo(logoImgView.mas_bottom).with.offset(30);
        make.centerX.equalTo(logoImgView.mas_centerX);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = KlayerBorder;
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(bgView.width, 1));
        make.centerY.equalTo(bgView.mas_centerY);
    }];
    
    UIImageView *accountImgView = [[UIImageView alloc] init];
    accountImgView.image = [UIImage imageNamed:@"icon_acc"];
    [self.view addSubview:accountImgView];
    [accountImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.left.equalTo(bgView.mas_left).with.offset(20);
        make.top.equalTo(bgView.mas_top).with.offset(10);
    }];
    
    UIImageView *pwdImgView = [[UIImageView alloc] init];
    pwdImgView.image = [UIImage imageNamed:@"icon_pwd"];
    [self.view addSubview:pwdImgView];
    [pwdImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.left.equalTo(accountImgView.mas_left);
        make.top.equalTo(lineView.mas_top).with.offset(10);
    }];
    
    self.phoneField = [[UITextField alloc] init];
    self.phoneField.borderStyle = UITextBorderStyleNone;
    self.phoneField.placeholder = @"平台账号/手机号码";
    self.phoneField.font = [UIFont systemFontOfSize:20];
    self.phoneField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.phoneField.delegate = self;
    [self.view addSubview:self.phoneField];
    [self.phoneField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREENWIDTH*0.5-80, 60));
        make.left.equalTo(accountImgView.mas_right).with.offset(20);
        make.centerY.equalTo(accountImgView.mas_centerY);
    }];
    
    self.passwordField = [[UITextField alloc] init];
    self.passwordField.borderStyle = UITextBorderStyleNone;
    self.passwordField.placeholder = @"请输入密码";
    self.passwordField.secureTextEntry = YES;
    self.passwordField.font = [UIFont systemFontOfSize:20];
    self.passwordField.returnKeyType = UIReturnKeyDone;
    self.passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordField.delegate = self;
    [self.view addSubview:self.passwordField];
    [self.passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREENWIDTH*0.5-80, 60));
        make.left.equalTo(pwdImgView.mas_right).with.offset(20);
        make.centerY.equalTo(pwdImgView.mas_centerY);
    }];
    
    
    self.checkBox = [[QCheckBox alloc]initWithDelegate:self];
    [self.checkBox setImage:[UIImage imageNamed:@"checkbox_unchecked"] forState:UIControlStateNormal];
    [self.checkBox setImage:[UIImage imageNamed:@"checkbox_checked"] forState:UIControlStateSelected];
    [self.checkBox setTitle:@"记住密码" forState:UIControlStateNormal];
    [self.checkBox setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [self.checkBox.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0f]];
    [self.view addSubview:self.checkBox];
    [self.checkBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 30));
        make.left.equalTo(bgView.mas_left);
        make.top.equalTo(bgView.mas_bottom).with.offset(10);
    }];
    
    UIButton *forgetPwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [forgetPwdBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    forgetPwdBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [forgetPwdBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    forgetPwdBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    [forgetPwdBtn addTarget:self action:@selector(forgetPwd) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetPwdBtn];
    [forgetPwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 30));
        make.right.equalTo(bgView.mas_right);
        make.top.equalTo(bgView.mas_bottom).with.offset(10);
    }];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.backgroundColor = ButtonBgColor;
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    loginBtn.layer.masksToBounds = YES;
//    loginBtn.layer.cornerRadius = 4;
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"bt_bg_default"] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"bt_bg_sel"] forState:UIControlStateHighlighted];
    [loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREENWIDTH*0.5, 50));
        make.top.equalTo(forgetPwdBtn.mas_bottom).with.offset(20);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
}

#pragma mark - QCheckBoxDelegate
- (void)didSelectedCheckBox:(QCheckBox *)checkbox checked:(BOOL)checked
{
    [[AppDefaultUtil sharedInstance] setRemeberUser:checked];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - hide
- (void)keyboardHide:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}

#pragma mark - click
- (void)regist
{
    RegistViewController *vc = [[RegistViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)forgetPwd
{
    ForgetPwdViewController *vc = [[ForgetPwdViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)login
{
    NSString *url = @"students/students/login/state/bylf";
    
    NSDictionary *parameters = @{@"students_name":self.phoneField.text, @"students_pwd":[self.passwordField.text md5String]};
    NetWork *network = [[NetWork alloc] init];
    [network postHttpNetWorkWithUrl:url WithBlock:parameters block:^(NSData *data, NSError *error) {
        if (data) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
           if ([[dict objectForKey:@"code"] integerValue] == 0) {
               
               NSDictionary *content = [dict objectForKey:@"content"];
               NSInteger state = [[NSString stringWithFormat:@"%@",[content objectForKey:@"state"]] integerValue]; // 0没通过审核，1通过审核
               NSString *students_id = [NSString stringWithFormat:@"%@",[content objectForKey:@"students_id"]];
               NSString *students_mingzhi = [NSString stringWithFormat:@"%@",[content objectForKey:@"students_mingzhi"]];
               NSString *students_grade = [NSString stringWithFormat:@"%@",[content objectForKey:@"students_grade"]];
               NSString *students_img = [NSString stringWithFormat:@"%@",[content objectForKey:@"students_img"]];
               NSString *students_school = [NSString stringWithFormat:@"%@",[content objectForKey:@"students_school"]];
               NSString *token = [NSString stringWithFormat:@"%@",[content objectForKey:@"token"]];
               [[AppDefaultUtil sharedInstance] setStuentId:students_id];
               [[AppDefaultUtil sharedInstance] setRealName:students_mingzhi];
               [[AppDefaultUtil sharedInstance] setGradeName:students_grade];
               [[AppDefaultUtil sharedInstance] setHeadImageUrl:students_img];
               [[AppDefaultUtil sharedInstance] setSchoolName:students_school];
               [[AppDefaultUtil sharedInstance] setAccount:self.phoneField.text];
               [[AppDefaultUtil sharedInstance] setPwd:self.passwordField.text];
               [[AppDefaultUtil sharedInstance] setToken:token];
               
               id jsonResult = [content objectForKey:@"subject"];
               if ([jsonResult isEqual:[NSNull null]]) {
                   
                   return ;
               }
               NSArray *subjects = [content objectForKey:@"subject"];
               
               [self saveSubjects:subjects];
               
               
               HomeViewController *vc = [[HomeViewController alloc] init];
               vc.state = state;
               MainNavigationController *nav= [[MainNavigationController alloc] initWithRootViewController:vc];
               [self presentViewController:nav animated:YES completion:nil];
               
           }else{
               [[UIApplication sharedApplication].keyWindow makeToast:[dict objectForKey:@"msg"]];
           }
            
        }else{
            if (error) {
                
            }
        }
        
    }];
    
}

- (void)saveSubjects:(NSArray *)subjects
{
    NSMutableArray *dataArray = [NSMutableArray array];
    if (subjects && subjects.count > 0) {
        for (NSDictionary *result in subjects) {
            
            SubjectInfo *subject = [[SubjectInfo alloc] init];
            subject.subjectId = [NSString stringWithFormat:@"%@",[result objectForKey:@"subject_id"]];
            subject.subjectName = [NSString stringWithFormat:@"%@",[result objectForKey:@"subject_name"]];

            [dataArray addObject:subject];
        }
        
    }
    
    // 归档
    [NSKeyedArchiver archiveRootObject:dataArray toFile:SubjectFileName];
    
    
//    // NSUserDefaults 存储的对象全是不可变的
//    NSArray *array = [NSArray arrayWithArray:dataArray];
//    [[AppDefaultUtil sharedInstance] setSubjects:array];
    
    
    /*
    // 解档
    NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithFile:SubjectFileName];
    for (SubjectInfo *b in arr) {
        DLog(@"baby:subjectId=%@ name=%@",b.subjectId,b.subjectName);
    }
    */
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
