//
//  StudentInfo.h
//  StudentManagement
//
//  Created by Kitty on 17/2/17.
//  Copyright © 2017年 Kitty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StudentInfo : NSObject

@property (nonatomic,copy) NSString *studentId;
//@property (nonatomic,copy) NSString *studentAccount;
@property (nonatomic,copy) NSString *studentImageName;
@property (nonatomic,copy) NSString *realName;
@property (nonatomic,copy) NSString *schoolName;
@property (nonatomic,copy) NSString *gradeName;
@property (nonatomic,copy) NSNumber *state; // 0没通过审核，1通过审核

@end
