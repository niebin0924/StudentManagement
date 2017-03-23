//
//  NetWork.h
//  jiutianguan
//
//  Created by 董仕林 on 15/11/24.
//  Copyright © 2015年 董仕林. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^NetBlock) (NSData *data,NSError *error);

@interface NetWork : NSObject

@property(nonatomic,strong) NetBlock netBlock;

// get
- (NSURLSessionDataTask *)httpNetWorkWithUrl:(NSString *)url WithBlock:(NSDictionary *)dic block:(NetBlock )block;


// post
- (NSURLSessionDataTask *)postHttpNetWorkWithUrl:(NSString *)url WithBlock:(NSDictionary *)parameters block:(NetBlock )block;

// post json
- (NSURLSessionDataTask *)postJsonRequestWithUrl:(NSString *)url WithBlock:(NSDictionary *)parameters block:(NetBlock )block;

// 上传图片
- (NSURLSessionDataTask *)uploadImage:(UIImage *)image WithUrl:(NSString *)url WithBlock:(NSDictionary *)parameters blok:(NetBlock)block;

@end
