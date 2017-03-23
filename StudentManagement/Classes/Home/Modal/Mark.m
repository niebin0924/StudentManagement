//
//  Mark.m
//  StudentManagement
//
//  Created by Kitty on 17/3/8.
//  Copyright © 2017年 Kitty. All rights reserved.
//

#import "Mark.h"

@implementation Mark

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

@end
