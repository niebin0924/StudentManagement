//
//  SubjectInfo.m
//  StudentManagement
//
//  Created by Kitty on 17/2/24.
//  Copyright © 2017年 Kitty. All rights reserved.
//

#import "SubjectInfo.h"

@implementation SubjectInfo

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.subjectId forKey:@"subjectId"];
    [aCoder encodeObject:self.subjectName forKey:@"subjectName"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        
        self.subjectId = [aDecoder decodeObjectForKey:@"subjectId"];
        self.subjectName = [aDecoder decodeObjectForKey:@"subjectName"];
    }
    
    return self;
}

@end
