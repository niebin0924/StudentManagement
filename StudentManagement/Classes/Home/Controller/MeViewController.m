//
//  MeViewController.m
//  StudentManagement
//
//  Created by Kitty on 17/2/17.
//  Copyright © 2017年 Kitty. All rights reserved.
//

#import "MeViewController.h"
#import "ChangePasswordViewController.h"
#import "HeadImageTableViewCell.h"
#import "PersonalTableViewCell.h"
#import "ChangePwdCell.h"
#import "PersonalModal.h"

@interface MeViewController () <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    BOOL isEdit; // 是否是编辑状态
    BOOL isUpdate; // 是否需要更新个人资料
}

@property (nonatomic,strong) NSMutableDictionary *cellDict;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIImage *headImage;

@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = KblackgroundColor;
    self.title = @"我的";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(edit:)];
    self.cellDict = [NSMutableDictionary dictionary];
//    [self initData];
    [self initTable];
    
    [self requestPersonalInfo];
}

- (void)initData
{
    
    
    NSArray *images = @[@"icon_name",@"icon_name",@"icon_school",@"icon_class", @"me_ic_passwrod"];
    NSArray *names = @[@"头像",@"姓名",@"学校",@"班级",@"密码"];
    NSArray *contents = @[[[AppDefaultUtil sharedInstance] getHeadImageUrl],[[AppDefaultUtil sharedInstance] getRealName],[[AppDefaultUtil sharedInstance] getSchoolName],[[AppDefaultUtil sharedInstance] getGradeName], @"修改"];
    
    self.dataArray = [NSMutableArray array];
    for (NSInteger i=0; i<images.count; i++) {
        PersonalModal *modal = [[PersonalModal alloc] init];
        modal.imgName = images[i];
        modal.name = names[i];
        modal.content = contents[i];
        [self.dataArray addObject:modal];
    }
}

- (void)initTable
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [self footerView];
    [_tableView registerNib:[UINib nibWithNibName:@"HeadImageTableViewCell" bundle:nil] forCellReuseIdentifier:@"headCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"PersonalTableViewCell" bundle:nil] forCellReuseIdentifier:@"personCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"ChangePwdCell" bundle:nil] forCellReuseIdentifier:@"changePwdCell"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

- (UIView *)footerView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 100)];
    view.backgroundColor = KblackgroundColor;
    
    UIButton *loginoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginoutBtn.backgroundColor = ButtonBgColor;
    [loginoutBtn setTitle:@"退出" forState:UIControlStateNormal];
    [loginoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginoutBtn.layer.masksToBounds = YES;
    loginoutBtn.layer.cornerRadius = 4;
    [loginoutBtn addTarget:self action:@selector(loginout) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:loginoutBtn];
    [loginoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREENWIDTH*0.5, 60));
        make.top.equalTo(view.mas_top).with.offset(30);
        make.centerX.equalTo(view.mas_centerX);
    }];
    
    return view;
}

- (void)requestPersonalInfo
{
    NSString *url = @"students/students/stud/state/bylf";
    NSDictionary *parameters = @{@"students_id":[[AppDefaultUtil sharedInstance] getStudentId]};
    NetWork *network = [[NetWork alloc] init];
    [network postHttpNetWorkWithUrl:url WithBlock:parameters block:^(NSData *data, NSError *error) {
        if (data) {
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if ([[dict objectForKey:@"code"] integerValue] == 0) {
                
                NSDictionary *content = [dict objectForKey:@"content"];
                NSString *students_school = [NSString stringWithFormat:@"%@",[content objectForKey:@"students_school"]];//2
                NSString *students_img = [NSString stringWithFormat:@"%@",[content objectForKey:@"students_img"]];//0
                NSString *students_name = [NSString stringWithFormat:@"%@",[content objectForKey:@"students_name"]];
                NSString *students_mingzhi = [NSString stringWithFormat:@"%@",[content objectForKey:@"students_mingzhi"]];//1
                NSString *students_grade = [NSString stringWithFormat:@"%@",[content objectForKey:@"students_grade"]];//3
                
                [[AppDefaultUtil sharedInstance] setSchoolName:students_school];
                [[AppDefaultUtil sharedInstance] setHeadImageUrl:students_img];
                [[AppDefaultUtil sharedInstance] setRealName:students_mingzhi];
                [[AppDefaultUtil sharedInstance] setGradeName:students_grade];
                
//                NSMutableArray *array = [self.dataArray mutableCopy];
//                PersonalModal *modal0 = array[0];
//                modal0.content = students_img;
//                PersonalModal *modal1 = array[1];
//                modal1.content = students_mingzhi;
//                PersonalModal *modal2 = array[2];
//                modal2.content = students_school;
//                PersonalModal *modal3 = array[3];
//                modal3.content = students_grade;
//                self.dataArray = [NSMutableArray arrayWithArray:array];
                [self initData];
                [self.tableView reloadData];
                
                
            }else {
                [[UIApplication sharedApplication].keyWindow makeToast:[dict objectForKey:@"msg"]];
            }
            
        }else{
            if (error) {
                
            }
        }
    }];
}

#pragma mark - click
- (void)edit:(UIBarButtonItem *)item
{
    if ([item.title isEqualToString:@"编辑"]) {
        
        item.title = @"确定";
        isEdit = YES;
        
        if (self.cellDict) {
            for (NSInteger i=1; i<=3; i++) {
                
                NSIndexPath *indexpath = [NSIndexPath indexPathForRow:i inSection:0];
                PersonalTableViewCell *headerCell = [self.cellDict objectForKey:indexpath];
                headerCell.contentField.enabled = YES;
                
            }
            
            
        }
    }else {
    
        [self.view endEditing:YES];
        item.title = @"编辑";
        isEdit = NO;
        if (self.cellDict) {
            for (NSInteger i=1; i<=3; i++) {
                
                NSIndexPath *indexpath = [NSIndexPath indexPathForRow:i inSection:0];
                PersonalTableViewCell *headerCell = [self.cellDict objectForKey:indexpath];
                headerCell.contentField.enabled = NO;
                
            }
            
            
        }
        
        if (!isUpdate) {
            return;
        }
        
        PersonalModal *modal1 = self.dataArray[1];
        PersonalModal *modal2 = self.dataArray[2];
        PersonalModal *modal3 = self.dataArray[3];
        
//        NSString *url =@"http://ebj.zhi-watch.com/students/img/uploads_img/state/bylf";
//        NSDictionary *parameters = @{@"students_id":[[AppDefaultUtil sharedInstance] getStudentId]};
        
        NSString *url = @"http://ebj.zhi-watch.com/students/students/upd/state/bylf";
        NSDictionary *parameters = @{@"students_id":[[AppDefaultUtil sharedInstance] getStudentId], @"students_mingzhi":modal1.content, @"students_school":modal2.content, @"students_grade":modal3.content};
        
        [self postPictureWithUrl:url parameters:parameters image:self.headImage];
        
    }
}

- (void)loginout
{
    
}

- (void)changeHeadImage
{
    if (!isEdit) {
        return;
    }
    
    [self.view endEditing:YES];
    UIActionSheet *sheeet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册",@"相机", nil];
    [sheeet showInView:self.view];
}

- (void)chagePwdClick
{
    ChangePasswordViewController *vc = [[ChangePasswordViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    isUpdate = YES;
    
    NSInteger row = textField.tag - 10;
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:row inSection:0];
    PersonalTableViewCell *cell = self.cellDict[indexpath];
    
    NSMutableArray *arr = [self.dataArray mutableCopy];
    PersonalModal *modal = arr[row];
    modal.content = cell.contentField.text;
    self.dataArray = [NSMutableArray arrayWithArray:arr];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
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
        
        
    }else if (buttonIndex == 0) {
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        UIPopoverController *popVC = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        popVC.popoverContentSize = CGSizeMake(SCREENWIDTH*0.5, SCREENWIDTH*0.5);
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
        [imagePicker shouldAutorotate];
        
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [popVC presentPopoverFromRect:CGRectMake(SCREENWIDTH-120*2,10,120,120) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
            
        }else{
            [self presentViewController:imagePicker animated:YES completion:^{}];
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate
// 取消相册
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    // UIImagePickerControllerOriginalImage
    UIImage *img = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    
    if(picker.sourceType==UIImagePickerControllerSourceTypeCamera){
        //        UIImageWriteToSavedPhotosAlbum(img,nil,nil,nil);
    }
    
    isUpdate = YES;
    self.headImage = img;
   
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:0];
    HeadImageTableViewCell *cell = self.cellDict[indexpath];
    cell.headImgView.image = self.headImage;
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)postPictureWithUrl:(NSString *)url parameters:(NSDictionary *)parameters image:(UIImage *)image
{
    DLog(@"url=%@,parameters = %@",url,parameters);
    
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
        
        NSData *imageData =UIImageJPEGRepresentation(image,0.5);
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat =@"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        
        //上传的参数(上传图片，以文件流的格式)
        [formData appendPartWithFileData:imageData
                                    name:@"students_img"
                                fileName:fileName
                                mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        //打印下上传进度
        DLog(@"%@",uploadProgress);
        [SVProgressHUD showWithStatus:@"正在提交"];
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [SVProgressHUD dismiss];
        NSDictionary *dict = responseObject;
        DLog(@"dict = %@",dict);
        
        if ([[dict objectForKey:@"code"]integerValue] == 0) {
            [SVProgressHUD showSuccessWithStatus:@"修改资料成功"];
        }else {
            [[UIApplication sharedApplication].keyWindow makeToast:[dict objectForKey:@"msg"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"修改资料失败"];
        
        DLog(@"%@修改资料失败",error);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        HeadImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"headCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        PersonalModal *modal = self.dataArray[indexPath.row];
        cell.iconImgView.image = [UIImage imageNamed:modal.imgName];
        cell.nameLabel.text = modal.name;
        //            cell.headImgView.contentMode = UIViewContentModeScaleAspectFit;
        
        if ([modal.content rangeOfString:@"http"].location != NSNotFound) {
//            [cell.headImgView sd_setImageWithURL:[NSURL URLWithString:modal.content] placeholderImage:[UIImage imageNamed:@"pic_headerpic"]];
            
            [cell.headImgView JYloadWebImage:modal.content placeholderImage:[UIImage imageNamed:@"pic_headerpic"]];
            
        }else{
//            [cell.headImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseURL,modal.content]] placeholderImage:[UIImage imageNamed:@"pic_headerpic"]];
            [cell.headImgView JYloadWebImage:[BaseURL stringByAppendingString:modal.content] placeholderImage:[UIImage imageNamed:@"pic_headerpic"]];
            
        }
        self.headImage = cell.headImgView.image;
        
        
        [self.cellDict setObject:cell forKey:indexPath];
        
        return cell;
    }
    else if (indexPath.row == self.dataArray.count-1) {
        ChangePwdCell *cell = [tableView dequeueReusableCellWithIdentifier:@"changePwdCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        PersonalModal *modal = self.dataArray[indexPath.row];
        cell.iconImageView.image = [UIImage imageNamed:modal.imgName];
        cell.titleLabel.text = modal.name;
        [cell.changePwdBtn addTarget:self action:@selector(chagePwdClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self.cellDict setObject:cell forKey:indexPath];
        
        return cell;
    }
    
    static NSString *identifier = @"personCell";
    PersonalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    PersonalModal *modal = self.dataArray[indexPath.row];
    cell.iconImageView.image = [UIImage imageNamed:modal.imgName];
    cell.nameLabel.text = modal.name;
    cell.contentField.text = modal.content;
    cell.contentField.enabled = NO;
    cell.contentField.delegate = self;
    cell.contentField.tag = 10 + indexPath.row;
    
    [self.cellDict setObject:cell forKey:indexPath];
    
    return cell;
    

}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 120;
    }
    
    return 80;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [self changeHeadImage];
    }
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
