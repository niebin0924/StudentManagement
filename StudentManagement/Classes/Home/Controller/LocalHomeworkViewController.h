//
//  LocalHomeworkViewController.h
//  StudentManagement
//
//  Created by Kitty on 17/4/1.
//  Copyright © 2017年 Kitty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocalHomeworkViewController : UIViewController

@property (nonatomic,strong) NSString *subjectId;
@property (nonatomic,strong) NSString *subjectName;
@property (nonatomic,strong) NSArray *fileArray;

@end
