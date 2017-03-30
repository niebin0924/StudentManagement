//
//  Mark.m
//  StudentManagement
//
//  Created by Kitty on 17/3/8.
//  Copyright © 2017年 Kitty. All rights reserved.
//

#import "Mark.h"

@implementation Mark

// 归档
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeFloat:self.x forKey:@"x"];
    [aCoder encodeFloat:self.y forKey:@"y"];
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.content_img forKey:@"content_img"];
}

// 解档
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        
        self.x = [aDecoder decodeFloatForKey:@"x"];
        self.y = [aDecoder decodeFloatForKey:@"y"];
        self.content = [aDecoder decodeObjectForKey:@"content"];
        self.content_img = [aDecoder decodeObjectForKey:@"content_img"];
    }
    
    return self;
}


- (NSDictionary *)TurnToDict
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i<outCount; i++)
    {
        objc_property_t property = properties[i];
        const char* char_f =property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        id propertyValue = [self valueForKey:(NSString *)propertyName];
        if (propertyValue) [dict setObject:propertyValue forKey:propertyName];
    }
    free(properties);
    return dict;
}

- (void)dealloc
{
    self.content = nil;
    self.content_img = nil;
}

@end
