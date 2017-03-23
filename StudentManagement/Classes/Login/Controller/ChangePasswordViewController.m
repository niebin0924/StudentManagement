//
//  ChangePasswordViewController.m
//  StudentManagement
//
//  Created by Kitty on 17/2/22.
//  Copyright © 2017年 Kitty. All rights reserved.
//

#define OnePadding      10
#define TwoPadding      20
#define ThreePadding    30
#define ControlWidth    SCREENWIDTH*0.5
#define ControlHeight   60

#import "ChangePasswordViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"

@interface ChangePasswordViewController () <UITextFieldDelegate>

@property (nonatomic,strong) UITextField *oldPwdField;
@property (nonatomic,strong) UITextField *nPwdField;
@property (nonatomic,strong) UITextField *surePwdField;

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = KblackgroundColor;
    self.title = @"修改密码";
    
    [self initView];
}

- (void)initView
{
    // 旧密码边框
    UIButton *signBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [signBtn1 setBackgroundImage:[UIImage imageNamed:@"frame_a"] forState:UIControlStateNormal];
    [self.view addSubview:signBtn1];
    [signBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ControlWidth, ControlHeight));
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(@40);
    }];
    UIImageView *accountImgView = [[UIImageView alloc] init];
    accountImgView.image = [UIImage imageNamed:@"icon_pwd"];
    [self.view addSubview:accountImgView];
    [accountImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.left.equalTo(signBtn1.mas_left).with.offset(TwoPadding);
        make.top.equalTo(signBtn1.mas_top).with.offset(OnePadding);
    }];
    self.oldPwdField = [[UITextField alloc] init];
    self.oldPwdField.borderStyle = UITextBorderStyleNone;
    self.oldPwdField.placeholder = @"旧密码";
    self.oldPwdField.font = [UIFont systemFontOfSize:18];
    self.oldPwdField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.oldPwdField.secureTextEntry = YES;
    self.oldPwdField.delegate = self;
    [self.view addSubview:self.oldPwdField];
    [self.oldPwdField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ControlWidth-3*TwoPadding, ControlHeight));
        make.left.equalTo(accountImgView.mas_right).with.offset(TwoPadding);
        make.centerY.equalTo(accountImgView.mas_centerY);
    }];
    
    // 新密码边框
    UIButton *signBtn2= [UIButton buttonWithType:UIButtonTypeCustom];
    [signBtn2 setBackgroundImage:[UIImage imageNamed:@"frame_a"] forState:UIControlStateNormal];
    [self.view addSubview:signBtn2];
    [signBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ControlWidth, ControlHeight));
        make.left.equalTo(signBtn1.mas_left);
        make.top.equalTo(signBtn1.mas_bottom).with.offset(TwoPadding);
    }];
    UIImageView *pwdImgView = [[UIImageView alloc] init];
    pwdImgView.image = [UIImage imageNamed:@"icon_pwd"];
    [self.view addSubview:pwdImgView];
    [pwdImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.left.equalTo(accountImgView.mas_left);
        make.top.equalTo(signBtn2.mas_top).with.offset(OnePadding);
    }];
    self.nPwdField = [[UITextField alloc] init];
    self.nPwdField.borderStyle = UITextBorderStyleNone;
    self.nPwdField.placeholder = @"新密码设置";
    self.nPwdField.font = [UIFont systemFontOfSize:18];
    self.nPwdField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.nPwdField.secureTextEntry = YES;
    self.nPwdField.delegate = self;
    [self.view addSubview:self.nPwdField];
    [self.nPwdField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ControlWidth-3*TwoPadding, ControlHeight));
        make.left.equalTo(pwdImgView.mas_right).with.offset(TwoPadding);
        make.centerY.equalTo(pwdImgView.mas_centerY);
    }];
    
    // 确认密码边框
    UIButton *signBtn3= [UIButton buttonWithType:UIButtonTypeCustom];
    [signBtn3 setBackgroundImage:[UIImage imageNamed:@"frame_a"] forState:UIControlStateNormal];
    [self.view addSubview:signBtn3];
    [signBtn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ControlWidth, ControlHeight));
        make.left.equalTo(signBtn1.mas_left);
        make.top.equalTo(signBtn2.mas_bottom).with.offset(TwoPadding);
    }];
    UIImageView *pwd2ImgView = [[UIImageView alloc] init];
    pwd2ImgView.image = [UIImage imageNamed:@"icon_pwd"];
    [self.view addSubview:pwd2ImgView];
    [pwd2ImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.left.equalTo(accountImgView.mas_left);
        make.top.equalTo(signBtn3.mas_top).with.offset(OnePadding);
    }];
    self.surePwdField = [[UITextField alloc] init];
    self.surePwdField.borderStyle = UITextBorderStyleNone;
    self.surePwdField.placeholder = @"确认密码";
    self.surePwdField.font = [UIFont systemFontOfSize:18];
    self.surePwdField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.surePwdField.secureTextEntry = YES;
    self.surePwdField.delegate = self;
    [self.view addSubview:self.surePwdField];
    [self.surePwdField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ControlWidth-3*TwoPadding, ControlHeight));
        make.left.equalTo(pwd2ImgView.mas_right).with.offset(TwoPadding);
        make.centerY.equalTo(pwd2ImgView.mas_centerY);
    }];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn setTitle:@"确认" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn setBackgroundImage:[UIImage imageNamed:@"bt_bg_default"] forState:UIControlStateNormal];
    [sureBtn setBackgroundImage:[UIImage imageNamed:@"bt_bg_sel"] forState:UIControlStateHighlighted];
    [sureBtn addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ControlWidth, ControlHeight));
        make.left.equalTo(signBtn1.mas_left);
        make.top.equalTo(signBtn3.mas_bottom).with.offset(ThreePadding);
    }];
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

- (void)sureClick
{
    [self.view endEditing:YES];
    
    if (![self.nPwdField.text isEqualToString:self.surePwdField.text]) {
        [SVProgressHUD showErrorWithStatus:@"两次输入密码不一致"];
        return;
    }
    
    NSString *url = @"students/students/upd_pwd/state/bylf";
    NSDictionary *parameters = @{@"students_id":[[AppDefaultUtil sharedInstance] getStudentId], @"olr_pwd":[self.oldPwdField.text md5String], @"new_pwd":[self.nPwdField.text md5String]};
    NetWork *network = [[NetWork alloc] init];
    [network postHttpNetWorkWithUrl:url WithBlock:parameters block:^(NSData *data, NSError *error) {
        if (data) {
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if ([[dict objectForKey:@"code"] integerValue] == 0) {
                
                [SVProgressHUD showSuccessWithStatus:@"修改密码成功"];
//                [[AppDefaultUtil sharedInstance] setPwd:self.surePwdField.text];
                [[AppDefaultUtil sharedInstance] setPwd:@""];
                [self.navigationController popToRootViewControllerAnimated:YES];
                
                // 跳转到登录界面重新登录
                LoginViewController *login = [[LoginViewController alloc] init];
                MainNavigationController *nav = [[MainNavigationController alloc] initWithRootViewController:login];
                AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                app.window.rootViewController = nav;
                
            }else{
                [[UIApplication sharedApplication].keyWindow makeToast:[dict objectForKey:@"msg"]];
            }
            
        }else{
            if (error) {
                
            }
        }
    }];
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
