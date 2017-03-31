//
//  PiZhuViewController.h
//  StudentManagement
//
//  Created by Kitty on 17/2/17.
//  Copyright © 2017年 Kitty. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Mark;

typedef void(^ReturnMarkBlock)(Mark *);

@interface PiZhuViewController : UIViewController

@property (nonatomic,copy) ReturnMarkBlock markBlock;
@property (nonatomic,strong) Mark *mark;

@end
