//
//  Homework.h
//  StudentManagement
//
//  Created by Kitty on 17/3/2.
//  Copyright © 2017年 Kitty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Homework : NSObject

@property (nonatomic,copy) NSString *teacherId;
// 当这个参数用于上传作业时,homeworkId=0表示上传 homeworkId!=0表示更新
@property (nonatomic,copy) NSString *homeworkId;
@property (nonatomic,copy) NSString *homeworkName;
@property (nonatomic,copy) NSString *imageUrlStr;
@property (nonatomic,copy) UIImage  *img;
@property (nonatomic,copy) NSString *addTime;
@property (nonatomic,copy) NSArray *pizhuArray;
@property (nonatomic,assign) BOOL isDel; // 0否 1是
@property (nonatomic,assign) BOOL isMark; // 0否 1是
@property (nonatomic,assign) BOOL isSel; // 是否被选中

@end
