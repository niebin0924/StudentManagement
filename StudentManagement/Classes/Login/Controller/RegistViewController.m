//
//  RegistViewController.m
//  StudentManagement
//
//  Created by Kitty on 17/2/15.
//  Copyright © 2017年 Kitty. All rights reserved.
//

#define OnePadding      10
#define TwoPadding      20
#define ThreePadding    30
#define ControlWidth    SCREENWIDTH*0.5
#define ControlHeight   60

#import "RegistViewController.h"
#import "LoginViewController.h"

@interface RegistViewController () <UIActionSheetDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) UIScrollView *bgScrollView;
@property (nonatomic,strong) UIImageView *headImageView;
@property (nonatomic,strong) UITextField *phoneField;
@property (nonatomic,strong) UITextField *passwordField;
@property (nonatomic,strong) UITextField *codeField;
@property (nonatomic,strong) UITextField *realNameField;
@property (nonatomic,strong) UITextField *schoolField;
@property (nonatomic,strong) UITextField *classField;

@property (nonatomic,strong) UIImage *headImage;
@property (nonatomic,strong) NSString *code;

@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = KblackgroundColor;
    self.title = @"注册";
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"登录" style:UIBarButtonItemStylePlain target:self action:@selector(login)];
    
    [self initView];
    
}

- (void)initView
{
    _bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    [self.view addSubview:_bgScrollView];
//    [_bgScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
//    }];
    
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
    _headImageView.image = [UIImage imageNamed:@"headerpic"];
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius = 60.f;
    [self.bgScrollView addSubview:_headImageView];
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(120, 120));
        make.top.equalTo(@ThreePadding);
        make.centerX.equalTo(self.bgScrollView.mas_centerX);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    self.headImageView.userInteractionEnabled = YES;
    [self.headImageView addGestureRecognizer:tap];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"上传头像";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor darkGrayColor];
    [self.bgScrollView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(120, 20));
        make.top.equalTo(self.headImageView.mas_bottom).with.offset(TwoPadding);
        make.centerX.equalTo(self.headImageView.mas_centerX);
    }];
    
    // 手机号边框
    UIButton *signBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    signBtn1.backgroundColor = [UIColor whiteColor];
    [signBtn1.layer setMasksToBounds:YES];
    [signBtn1.layer setCornerRadius:4.0]; //设置矩形四个圆角半径
    [signBtn1.layer setBorderWidth:1.0];   //边框宽度
    [signBtn1.layer setBorderColor:KlayerBorder.CGColor];//边框颜色
    [self.bgScrollView addSubview:signBtn1];
    [signBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ControlWidth, ControlHeight));
        make.centerX.equalTo(self.headImageView.mas_centerX);
        make.top.equalTo(label.mas_bottom).with.offset(TwoPadding);
    }];
    UIImageView *accountImgView = [[UIImageView alloc] init];
    accountImgView.image = [UIImage imageNamed:@"icon_acc"];
    [self.bgScrollView addSubview:accountImgView];
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
    [self.bgScrollView addSubview:self.phoneField];
    [self.phoneField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ControlWidth-3*TwoPadding, ControlHeight));
        make.left.equalTo(accountImgView.mas_right).with.offset(TwoPadding);
        make.centerY.equalTo(accountImgView.mas_centerY);
    }];
    
    // 验证码边框
    UIButton *signBtn2= [UIButton buttonWithType:UIButtonTypeCustom];
    signBtn2.backgroundColor = [UIColor whiteColor];
    [signBtn2.layer setMasksToBounds:YES];
    [signBtn2.layer setCornerRadius:4.0]; //设置矩形四个圆角半径
    [signBtn2.layer setBorderWidth:1.0];   //边框宽度
    [signBtn2.layer setBorderColor:KlayerBorder.CGColor];//边框颜色
    [self.bgScrollView addSubview:signBtn2];
    [signBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ControlWidth*0.6, ControlHeight));
        make.left.equalTo(signBtn1.mas_left);
        make.top.equalTo(signBtn1.mas_bottom).with.offset(TwoPadding);
    }];
    UIImageView *codeImgView = [[UIImageView alloc] init];
    codeImgView.image = [UIImage imageNamed:@"icon_pic"];
    [self.bgScrollView addSubview:codeImgView];
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
    [self.bgScrollView addSubview:self.codeField];
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
    [self.bgScrollView addSubview:huoquCodeBtn];
    [huoquCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ControlWidth*0.4-TwoPadding, ControlHeight));
        make.left.equalTo(signBtn2.mas_right).with.offset(TwoPadding);
        make.top.equalTo(signBtn2.mas_top);
    }];
    
    // 密码边框
    UIButton *signBtn3= [UIButton buttonWithType:UIButtonTypeCustom];
    signBtn3.backgroundColor = [UIColor whiteColor];
    [signBtn3.layer setMasksToBounds:YES];
    [signBtn3.layer setCornerRadius:4.0]; //设置矩形四个圆角半径
    [signBtn3.layer setBorderWidth:1.0];   //边框宽度
    [signBtn3.layer setBorderColor:KlayerBorder.CGColor];//边框颜色
    [self.bgScrollView addSubview:signBtn3];
    [signBtn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ControlWidth, ControlHeight));
        make.left.equalTo(signBtn1.mas_left);
        make.top.equalTo(signBtn2.mas_bottom).with.offset(TwoPadding);
    }];
    UIImageView *pwdImgView = [[UIImageView alloc] init];
    pwdImgView.image = [UIImage imageNamed:@"icon_pwd"];
    [self.bgScrollView addSubview:pwdImgView];
    [pwdImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.left.equalTo(accountImgView.mas_left);
        make.top.equalTo(signBtn3.mas_top).with.offset(OnePadding);
    }];
    self.passwordField = [[UITextField alloc] init];
    self.passwordField.borderStyle = UITextBorderStyleNone;
    self.passwordField.placeholder = @"请设置密码";
    self.passwordField.secureTextEntry = YES;
    self.passwordField.font = [UIFont systemFontOfSize:18];
    self.passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordField.delegate = self;
    [self.bgScrollView addSubview:self.passwordField];
    [self.passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ControlWidth-3*TwoPadding, ControlHeight));
        make.left.equalTo(pwdImgView.mas_right).with.offset(TwoPadding);
        make.centerY.equalTo(pwdImgView.mas_centerY);
    }];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"姓名";
    nameLabel.textColor = [UIColor lightGrayColor];
    nameLabel.font = [UIFont systemFontOfSize:15];
    [self.bgScrollView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 20));
        make.left.equalTo(signBtn1.mas_left);
        make.top.equalTo(signBtn3.mas_bottom).with.offset(10);
    }];
    // 姓名边框
    UIButton *signBtn4= [UIButton buttonWithType:UIButtonTypeCustom];
    signBtn4.backgroundColor = [UIColor whiteColor];
    [signBtn4.layer setMasksToBounds:YES];
    [signBtn4.layer setCornerRadius:4.0]; //设置矩形四个圆角半径
    [signBtn4.layer setBorderWidth:1.0];   //边框宽度
    [signBtn4.layer setBorderColor:KlayerBorder.CGColor];//边框颜色
    [self.bgScrollView addSubview:signBtn4];
    [signBtn4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ControlWidth, ControlHeight));
        make.left.equalTo(signBtn1.mas_left);
        make.top.equalTo(nameLabel.mas_bottom);
    }];
    self.realNameField = [[UITextField alloc] init];
    self.realNameField.borderStyle = UITextBorderStyleNone;
    self.realNameField.placeholder = @"请输入真实名";
    self.realNameField.font = [UIFont systemFontOfSize:18];
    self.realNameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.realNameField.delegate = self;
    [self.bgScrollView addSubview:self.realNameField];
    [self.realNameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ControlWidth-TwoPadding, ControlHeight));
        make.left.equalTo(signBtn4.mas_left).with.offset(TwoPadding);
        make.centerY.equalTo(signBtn4.mas_centerY);
    }];
    
    UILabel *schoolLabel = [[UILabel alloc] init];
    schoolLabel.text = @"学校";
    schoolLabel.textColor = [UIColor lightGrayColor];
    schoolLabel.font = [UIFont systemFontOfSize:15];
    [self.bgScrollView addSubview:schoolLabel];
    [schoolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 20));
        make.left.equalTo(signBtn1.mas_left);
        make.top.equalTo(signBtn4.mas_bottom).with.offset(10);
    }];
    // 学校边框
    UIButton *signBtn5= [UIButton buttonWithType:UIButtonTypeCustom];
    signBtn5.backgroundColor = [UIColor whiteColor];
    [signBtn5.layer setMasksToBounds:YES];
    [signBtn5.layer setCornerRadius:4.0]; //设置矩形四个圆角半径
    [signBtn5.layer setBorderWidth:1.0];   //边框宽度
    [signBtn5.layer setBorderColor:KlayerBorder.CGColor];//边框颜色
    [self.bgScrollView addSubview:signBtn5];
    [signBtn5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ControlWidth, ControlHeight));
        make.left.equalTo(signBtn1.mas_left);
        make.top.equalTo(schoolLabel.mas_bottom);
    }];
    self.schoolField = [[UITextField alloc] init];
    self.schoolField.borderStyle = UITextBorderStyleNone;
    self.schoolField.placeholder = @"培训/小学/中学...";
    self.schoolField.font = [UIFont systemFontOfSize:18];
    self.schoolField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.schoolField.delegate = self;
    [self.bgScrollView addSubview:self.schoolField];
    [self.schoolField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ControlWidth-TwoPadding, ControlHeight));
        make.left.equalTo(signBtn5.mas_left).with.offset(TwoPadding);
        make.centerY.equalTo(signBtn5.mas_centerY);
    }];
    
    UILabel *classLabel = [[UILabel alloc] init];
    classLabel.text = @"年级";
    classLabel.textColor = [UIColor lightGrayColor];
    classLabel.font = [UIFont systemFontOfSize:15];
    [self.bgScrollView addSubview:classLabel];
    [classLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 20));
        make.left.equalTo(signBtn1.mas_left);
        make.top.equalTo(signBtn5.mas_bottom).with.offset(10);
    }];
    // 学校边框
    UIButton *signBtn6= [UIButton buttonWithType:UIButtonTypeCustom];
    signBtn6.backgroundColor = [UIColor whiteColor];
    [signBtn6.layer setMasksToBounds:YES];
    [signBtn6.layer setCornerRadius:4.0]; //设置矩形四个圆角半径
    [signBtn6.layer setBorderWidth:1.0];   //边框宽度
    [signBtn6.layer setBorderColor:KlayerBorder.CGColor];//边框颜色
    [self.bgScrollView addSubview:signBtn6];
    [signBtn6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ControlWidth, ControlHeight));
        make.left.equalTo(signBtn1.mas_left);
        make.top.equalTo(classLabel.mas_bottom);
    }];
    self.classField = [[UITextField alloc] init];
    self.classField.borderStyle = UITextBorderStyleNone;
    self.classField.placeholder = @"一到九年级...";
    self.classField.font = [UIFont systemFontOfSize:18];
    self.classField.returnKeyType = UIReturnKeyDone;
    self.classField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.classField.delegate = self;
    [self.bgScrollView addSubview:self.classField];
    [self.classField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ControlWidth-TwoPadding, ControlHeight));
        make.left.equalTo(signBtn6.mas_left).with.offset(TwoPadding);
        make.centerY.equalTo(signBtn6.mas_centerY);
    }];
    
    UIButton *registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    registBtn.backgroundColor = KColor;
    [registBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [registBtn.layer setMasksToBounds:YES];
//    [registBtn.layer setCornerRadius:4.0];
    [registBtn setBackgroundImage:[UIImage imageNamed:@"bt_bg_default"] forState:UIControlStateNormal];
    [registBtn setBackgroundImage:[UIImage imageNamed:@"bt_bg_sel"] forState:UIControlStateHighlighted];
    [registBtn addTarget:self action:@selector(regist) forControlEvents:UIControlEventTouchUpInside];
    [self.bgScrollView addSubview:registBtn];
    [registBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ControlWidth, ControlHeight));
        make.left.equalTo(signBtn1.mas_left);
        make.top.equalTo(signBtn6.mas_bottom).with.offset(ThreePadding);
    }];
    
    UILabel *bottomLabel = [[UILabel alloc] init];
    bottomLabel.textColor = SETCOLOR(172, 41, 51, 1);
    bottomLabel.text = @"温馨提醒：注册完成后，请等待管理员审核，审核通过另存为、打开、删除功能才能使用。";
    bottomLabel.textAlignment = NSTextAlignmentCenter;
    bottomLabel.font = [UIFont systemFontOfSize:16];
    [self.bgScrollView addSubview:bottomLabel];
    [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(700, 20));
        make.centerX.equalTo(self.headImageView.mas_centerX);
        make.top.equalTo(registBtn.mas_bottom).with.offset(60);
    }];
    
    _bgScrollView.contentSize = CGSizeMake(self.bgScrollView.width, 1000);
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

- (void)tapAction
{
    [self.view endEditing:YES];
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"照片", nil];
    [sheet showInView:self.view];
}

#pragma mark - click
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
                    
                   self.code = [NSString stringWithFormat:@"%@",[dict objectForKey:@"content"]];
                   
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

- (void)regist
{
    NSString *url = @"http://ebj.zhi-watch.com/students/students/register/state/bylf";
    NSDictionary *parameters = @{@"students_name":self.phoneField.text, @"students_mingzhi":self.realNameField.text, @"students_school":self.schoolField.text, @"students_grade":self.classField.text, @"tel_yzm":self.codeField.text, @"state":@"0", @"students_pwd":[self.passwordField.text md5String]};
    
    if (self.headImage == nil) {
        [SVProgressHUD showInfoWithStatus:@"请上传头像"];
        return;
    }
    
    [self postPictureWithUrl:url parameters:parameters image:self.headImage];
    
}

#pragma mark - 注册成功保存数据
- (void)saveAccount
{
    
}

- (void)login
{
    LoginViewController *vc = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
        if (!isCamera) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"没有摄像头" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
            return ;
        }
        //从摄像头获取活动图片
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.allowsEditing = YES;
        [self presentViewController:imagePicker animated:YES completion:^{}];
        
        
    }else if (buttonIndex == 1) {
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        UIPopoverController *popVC = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        popVC.popoverContentSize = CGSizeMake(SCREENWIDTH*0.5, SCREENWIDTH*0.5);
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
        [imagePicker shouldAutorotate];
        [[AppDefaultUtil sharedInstance] setPhotoLibary:YES];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [popVC presentPopoverFromRect:CGRectMake(SCREENWIDTH*0.5-120*0.5,30,120,120) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
            
        }else{
            [self presentViewController:imagePicker animated:YES completion:^{}];
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate
// 取消相册
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [[AppDefaultUtil sharedInstance] setPhotoLibary:NO];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    // UIImagePickerControllerOriginalImage
    UIImage *img = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    
    if(picker.sourceType==UIImagePickerControllerSourceTypeCamera){
        //        UIImageWriteToSavedPhotosAlbum(img,nil,nil,nil);
    }
    
    self.headImage = img;
    self.headImageView.image = self.headImage;
//    [self uploadHeadImage:img];
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - upload
- (void)uploadHeadImage:(UIImage *)img
{
    NSString *url = @"";
    
    NSDictionary *parameters;
    
    [self postPictureWithUrl:url parameters:parameters image:img];
}

- (void)postPictureWithUrl:(NSString *)url parameters:(NSDictionary *)parameters image:(UIImage *)image
{
    DLog(@"url=%@, parameters = %@",url,parameters);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //接收类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         @"text/plain",
                                                         nil];
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSData *imageData = UIImageJPEGRepresentation(image,0.5);
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat =@"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        
        //上传的参数(上传图片，以文件流的格式)
        [formData appendPartWithFileData:imageData
                                    name:@"file"
                                fileName:fileName
                                mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        //打印下上传进度
        DLog(@"%@",uploadProgress);
        [SVProgressHUD showWithStatus:@"正在上传图像"];
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [SVProgressHUD dismiss];
        NSDictionary *dict = responseObject;
        DLog(@"dict = %@",dict);
        if ([[dict objectForKey:@"code"]integerValue] == 0) {
            
            NSString *content = [dict objectForKey:@"content"];
            [[AppDefaultUtil sharedInstance] setStuentId:content];
            [[AppDefaultUtil sharedInstance] setAccount:self.phoneField.text];
            [[AppDefaultUtil sharedInstance] setPwd:self.passwordField.text];
            [[AppDefaultUtil sharedInstance] setRealName:self.realNameField.text];
            [[AppDefaultUtil sharedInstance] setSchoolName:self.schoolField.text];
            [[AppDefaultUtil sharedInstance] setGradeName:self.classField.text];
            [self.navigationController popViewControllerAnimated:YES];
            
            
        }else {
            [[UIApplication sharedApplication].keyWindow makeToast:[dict objectForKey:@"msg"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"上传失败"];
        //上传失败
        DLog(@"%@上传失败",error);
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
