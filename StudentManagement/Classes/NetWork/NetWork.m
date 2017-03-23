//
//  NetWork.m
//  jiutianguan
//
//  Created by 董仕林 on 15/11/24.
//  Copyright © 2015年 董仕林. All rights reserved.
//

#import "NetWork.h"
#import "SVProgressHUD.h"
#import "AFAppDotNetAPIClient.h"
#import "Reachability.h"

@implementation NetWork

- (NSURLSessionDataTask *)httpNetWorkWithUrl:(NSString *)url WithBlock:(NSDictionary *)parameters block:(NetBlock )block
{
    //检查网络
    if (![[Reachability reachabilityForInternetConnection] isReachable])
    {
        UIAlertView *alertViews = [[UIAlertView alloc] initWithTitle:@"该功能需要连接网络才能使用，请检查您的网络连接状态" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertViews show];
        return nil;
    }
    self.netBlock = block;
    
    // SVProgressHUDMaskType 介绍： 1. SVProgressHUDMaskTypeNone : 当提示显示的时间，用户仍然可以做其他操作，比如View 上面的输入等 2. SVProgressHUDMaskTypeClear : 用户不可以做其他操作 3. SVProgressHUDMaskTypeBlack :　用户不可以做其他操作，并且背景色是黑色 4. SVProgressHUDMaskTypeGradient : 用户不可以做其他操作，并且背景色是渐变的  SVProgressHUD 全部方法：
    
//    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    
    // 请求头
//    [[AFAppDotNetAPIClient sharedClient].requestSerializer setValue:[[AppDefaultUtil sharedInstance] getToken] forHTTPHeaderField:@"token"];
    
    return [[AFAppDotNetAPIClient sharedClient] GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * __unused task, id JSON) {
        DLog(@"数据请求成功http://ebj.zhi-watch.com/%@%@",url,parameters);
        [SVProgressHUD dismiss];
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingAllowFragments error:nil];
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"jsonStr=%@-----%@", jsonStr,url);
        
        if (self.netBlock) {
            
            self.netBlock(JSON, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [SVProgressHUD dismiss];
        DLog(@"error = %@",error);
        [[UIApplication sharedApplication].keyWindow makeToast:@"服务器异常"];
        if (self.netBlock) {
            self.netBlock(nil, error);
        }
    }];

}

- (NSURLSessionDataTask *)postHttpNetWorkWithUrl:(NSString *)url WithBlock:(NSDictionary *)parameters block:(NetBlock )block
{
    //检查网络
    if (![[Reachability reachabilityForInternetConnection] isReachable])
    {
        UIAlertView *alertViews = [[UIAlertView alloc] initWithTitle:@"该功能需要连接网络才能使用，请检查您的网络连接状态" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertViews show];
        return nil;
    }
    self.netBlock = block;
    
    if ([url rangeOfString:@"forget_pwd"].location == NSNotFound || [url rangeOfString:@"login"].location == NSNotFound || [url rangeOfString:@"sms"].location == NSNotFound){
        // 登录 忘记密码 发送验证码不需要发送token
        [[AFAppDotNetAPIClient sharedClient].requestSerializer setValue:[[AppDefaultUtil sharedInstance] getToken] forHTTPHeaderField:@"token"];
    }
    
    
    return [[AFAppDotNetAPIClient sharedClient] POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"数据请求成功http://ebj.zhi-watch.com/%@%@",url,parameters);
        [SVProgressHUD dismiss];
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"jsonStr=%@-----%@", jsonStr,url);
        
        if (self.netBlock) {
            
            self.netBlock(responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        DLog(@"error = %@",error);
        [[UIApplication sharedApplication].keyWindow makeToast:@"服务器异常"];
        if (self.netBlock) {
            self.netBlock(nil, error);
        }
    }];
    

}

- (NSURLSessionDataTask *)postJsonRequestWithUrl:(NSString *)url WithBlock:(NSDictionary *)parameters block:(NetBlock )block
{
    //检查网络
    if (![[Reachability reachabilityForInternetConnection] isReachable])
    {
        UIAlertView *alertViews = [[UIAlertView alloc] initWithTitle:@"该功能需要连接网络才能使用，请检查您的网络连接状态" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertViews show];
        return nil;
    }
    self.netBlock = block;
    
    [[AFAppDotNetAPIClient sharedClient].requestSerializer setValue:[[AppDefaultUtil sharedInstance] getToken] forHTTPHeaderField:@"token"];
    
    return [[AFAppDotNetAPIClient sharedClient] POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"数据请求成功http://ebj.zhi-watch.com/%@%@",url,parameters);
        [SVProgressHUD dismiss];
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"jsonStr=%@-----%@", jsonStr,url);
        
        if (self.netBlock) {
            
            self.netBlock(responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        DLog(@"error = %@",error);
        [[UIApplication sharedApplication].keyWindow makeToast:@"服务器异常"];
        if (self.netBlock) {
            self.netBlock(nil, error);
        }
    }];
}

- (NSURLSessionDataTask *)uploadImage:(UIImage *)image WithUrl:(NSString *)url WithBlock:(NSDictionary *)parameters blok:(NetBlock)block
{
    //检查网络
    if (![[Reachability reachabilityForInternetConnection] isReachable])
    {
        UIAlertView *alertViews = [[UIAlertView alloc] initWithTitle:@"该功能需要连接网络才能使用，请检查您的网络连接状态" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertViews show];
        return nil;
    }
    self.netBlock = block;
    
    return [[AFAppDotNetAPIClient sharedClient] POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        // formData: 专门用于拼接需要上传的数据,在此位置生成一个要上传的数据体
        NSData *imageData = UIImageJPEGRepresentation(image, 1);
        
        // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
        // 要解决此问题，
        // 可以在上传时使用当前的系统事件作为文件名
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 设置时间格式
        [formatter setDateFormat:@"yyyyMMddHHmmss"];
        NSString *dateString = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString  stringWithFormat:@"%@.jpg", dateString];
        /*
         *该方法的参数
         1. appendPartWithFileData：要上传的照片[二进制流]
         2. name：对应网站上[upload.php中]处理文件的字段（比如array_img）
         3. fileName：要保存在服务器上的文件名
         4. mimeType：上传的文件的类型
         */
        if (imageData != nil) {
            [formData appendPartWithFileData:imageData name:@"img" fileName:fileName mimeType:@"image/jpeg"];
        }
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        [SVProgressHUD showWithStatus:@"正在上传"];
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"数据请求成功http://ebj.zhi-watch.com/%@%@",url,parameters);
        [SVProgressHUD dismiss];
        
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
//        NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//        NSLog(@"jsonStr=%@-----%@", jsonStr,url);
        
        if (self.netBlock) {
            self.netBlock(responseObject, nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"上传失败"];
        DLog(@"%@上传失败",error);
        if (self.netBlock) {
            self.netBlock(nil, error);
        }
        
    }];
}

@end
