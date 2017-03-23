//
//  MessageList.h
//  StudentManagement
//
//  Created by Kitty on 17/2/24.
//  Copyright © 2017年 Kitty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageList : NSObject

@property (nonatomic,copy) NSString *homeworkId;
@property (nonatomic,copy) NSString *time;
@property (nonatomic,copy) NSString *homeworkName;
@property (nonatomic,copy) NSNumber *state; // 0:未查看，1已查看，2已批注
@property (nonatomic,copy) NSString *teacherName;
@property (nonatomic,copy) NSString *tidingId;

@end
