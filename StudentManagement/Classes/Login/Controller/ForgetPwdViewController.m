//
//  ForgetPwdViewController.m
//  StudentManagement
//
//  Created by Kitty on 17/2/17.
//  Copyright © 2017年 Kitty. All rights reserved.
//

#define OnePadding      10
#define TwoPadding      20
#define ThreePadding    30
#define ControlWidth    SCREENWIDTH*0.5
#define ControlHeight   60

#import "ForgetPwdViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"

@interface ForgetPwdViewController () <UITextFieldDelegate>

@property (nonatomic,strong) UITextField *phoneField;
@property (nonatomic,strong) UITextField *passwordField;
@property (nonatomic,strong) UITextField *codeField;

@end

@implementation ForgetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = KblackgroundColor;
    self.title = @"忘记密码";
    
    [self initView];
}

- (void)initView
{
    // 手机号边框
    UIButton *signBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [signBtn1 setBackgroundImage:[UIImage imageNamed:@"frame_a"] forState:UIControlStateNormal];
    [self.view addSubview:signBtn1];
    [signBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ControlWidth, ControlHeight));
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(@30);
    }];
    UIImageView *accountImgView = [[UIImageView alloc] init];
    accountImgView.image = [UIImage imageNamed:@"icon_acc"];
    [self.view addSubview:accountImgView];
    [accountImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.left.equalTo(signBtn1.mas_left).with.offset(TwoPadding);
        make.top.equalTo(signBtn1.mas_top).with.offset(OnePadding);
    }];
    self.phoneField = [[UITextField alloc] init];
    self.phoneField.borderStyle = UITextBorderStyleNone;
    self.phoneField.placeholder = @"平台账号/手机号码";
    self.phoneField.font = [UIFont systemFontOfSize:18];
    self.phoneField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.phoneField.delegate = self;
    [self.view addSubview:self.phoneField];
    [self.phoneField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ControlWidth-3*TwoPadding, ControlHeight));
        make.left.equalTo(accountImgView.mas_right).with.offset(TwoPadding);
        make.centerY.equalTo(accountImgView.mas_centerY);
    }];
    
    if (![[[AppDefaultUtil sharedInstance] getAccount] isEqualToString:@""] && ![[[AppDefaultUtil sharedInstance] getAccount] isEqualToString:@"(null)"] && ![[[AppDefaultUtil sharedInstance] getAccount] isEqualToString:@"<null>"]) {
        self.phoneField.text = [[AppDefaultUtil sharedInstance] getAccount];
    }
    
    // 验证码边框
    UIButton *signBtn2= [UIButton buttonWithType:UIButtonTypeCustom];
    [signBtn2 setBackgroundImage:[UIImage imageNamed:@"frame_b"] forState:UIControlStateNormal];
    [self.view addSubview:signBtn2];
    [signBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ControlWidth*0.6, ControlHeight));
        make.left.equalTo(signBtn1.mas_left);
        make.top.equalTo(signBtn1.mas_bottom).with.offset(TwoPadding);
    }];
    UIImageView *codeImgView = [[UIImageView alloc] init];
    codeImgView.image = [UIImage imageNamed:@"icon_pic"];
    [self.view addSubview:codeImgView];
    [codeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.left.equalTo(accountImgView.mas_left);
        make.top.equalTo(signBtn2.mas_top).with.offset(OnePadding);
    }];
    self.codeField = [[UITextField alloc] init];
    self.codeField.borderStyle = UITextBorderStyleNone;
    self.codeField.placeholder = @"请输入验证码";
    self.codeField.font = [UIFont systemFontOfSize:18];
    self.codeField.keyboardType = UIKeyboardTypeNumberPad;
    self.codeField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.codeField.delegate = self;
    [self.view addSubview:self.codeField];
    [self.codeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ControlWidth*0.6-80, ControlHeight));
        make.left.equalTo(codeImgView.mas_right).with.offset(TwoPadding);
        make.centerY.equalTo(codeImgView.mas_centerY);
    }];
    
    UIButton *huoquCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    huoquCodeBtn.backgroundColor = ButtonBgColor;
    [huoquCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [huoquCodeBtn.layer setMasksToBounds:YES];
    [huoquCodeBtn.layer setCornerRadius:4.0]; //设置矩形四个圆角半径
    [huoquCodeBtn addTarget:self action:@selector(huoquVerifyCode:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:huoquCodeBtn];
    [huoquCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ControlWidth*0.4-TwoPadding, ControlHeight));
        make.left.equalTo(signBtn2.mas_right).with.offset(TwoPadding);
        make.top.equalTo(signBtn2.mas_top);
    }];
    
    // 密码边框
    UIButton *signBtn3= [UIButton buttonWithType:UIButtonTypeCustom];
    [signBtn3 setBackgroundImage:[UIImage imageNamed:@"frame_a"] forState:UIControlStateNormal];
    [self.view addSubview:signBtn3];
    [signBtn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ControlWidth, ControlHeight));
        make.left.equalTo(signBtn1.mas_left);
        make.top.equalTo(signBtn2.mas_bottom).with.offset(TwoPadding);
    }];
    UIImageView *pwdImgView = [[UIImageView alloc] init];
    pwdImgView.image = [UIImage imageNamed:@"icon_pwd"];
    [self.view addSubview:pwdImgView];
    [pwdImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.left.equalTo(accountImgView.mas_left);
        make.top.equalTo(signBtn3.mas_top).with.offset(OnePadding);
    }];
    self.passwordField = [[UITextField alloc] init];
    self.passwordField.borderStyle = UITextBorderStyleNone;
    self.passwordField.placeholder = @"请设置密码";
    self.passwordField.font = [UIFont systemFontOfSize:18];
    self.passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordField.secureTextEntry = YES;
    self.passwordField.delegate = self;
    [self.view addSubview:self.passwordField];
    [self.passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ControlWidth-3*TwoPadding, ControlHeight));
        make.left.equalTo(pwdImgView.mas_right).with.offset(TwoPadding);
        make.centerY.equalTo(pwdImgView.mas_centerY);
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

- (void)huoquVerifyCode:(UIButton *)btn
{
    __block int timeout = 60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                
                [btn setTitle:@"获取验证码" forState:UIControlStateNormal];
                [btn setAlpha:1];
                btn.userInteractionEnabled = YES;
                
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                DLog(@"____%@",strTime);
                
                [btn setTitle:[NSString stringWithFormat:@"获取验证码(%@s)",strTime] forState:UIControlStateNormal];
//                [btn setAlpha:0.8];
                btn.backgroundColor = SETCOLOR(204, 204, 204, 1);
                btn.userInteractionEnabled = NO;
                
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
    
    if ([btn.titleLabel.text isEqualToString:@"获取验证码"]) {
        
        NSString *url = @"students/students/sms/state/bylf";
        NSDictionary *parameters = @{@"students_name":self.phoneField.text};
        NetWork *network = [[NetWork alloc] init];
        [network httpNetWorkWithUrl:url WithBlock:parameters block:^(NSData *data, NSError *error) {
            
            if (data) {
                
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                if ([[dict objectForKey:@"code"] integerValue] == 0) {
                    
                    
                    
                }else {
                    [[UIApplication sharedApplication].keyWindow makeToast:[dict objectForKey:@"msg"]];
                }
                
            }else{
                if (error) {
                    
                }
            }
        }];
    }
}

- (void)sureClick
{
    NSString *url = @"students/students/forget_pwd/state/bylf";
    NSDictionary *parameters = @{@"students_name":[[AppDefaultUtil sharedInstance] getAccount], @"students_pwd":[self.passwordField.text md5String], @"tel_yzm":self.codeField.text};
    NetWork *network = [[NetWork alloc] init];
    [network postHttpNetWorkWithUrl:url WithBlock:parameters block:^(NSData *data, NSError *error) {
        if (data) {
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if ([[dict objectForKey:@"code"] integerValue] == 0) {
                
                [[AppDefaultUtil sharedInstance] setPwd:@""];
                
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
