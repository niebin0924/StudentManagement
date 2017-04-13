//
//  Homework.m
//  StudentManagement
//
//  Created by Kitty on 17/3/2.
//  Copyright © 2017年 Kitty. All rights reserved.
//

#import "Homework.h"

@implementation Homework

// 归档
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.assetURL forKey:@"assetURL"];
    [aCoder encodeObject:self.pizhuArray forKey:@"pizhuArray"];
    [aCoder encodeObject:self.homeworkName forKey:@"homeworkName"];
    [aCoder encodeObject:self.pathStr forKey:@"pathStr"];
}

// 解档
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.assetURL = [aDecoder decodeObjectForKey:@"assetURL"];
        self.homeworkName = [aDecoder decodeObjectForKey:@"homeworkName"];
        self.pizhuArray = [aDecoder decodeObjectForKey:@"pizhuArray"];
        self.pathStr = [aDecoder decodeObjectForKey:@"pathStr"];
    }
    
    return self;
}

- (void)dealloc
{
    self.assetURL = nil;
    self.homeworkName = nil;
    self.pizhuArray = nil;
    self.pathStr = nil;
}


@end
