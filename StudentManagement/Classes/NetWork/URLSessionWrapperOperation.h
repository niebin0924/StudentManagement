//
//  URLSessionWrapperOperation.h
//  StudentManagement
//
//  Created by Kitty on 17/3/10.
//  Copyright © 2017年 Kitty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLSessionWrapperOperation : NSOperation

+ (instancetype)operationWithURLSessionTask:(NSURLSessionTask*)task;

@end
