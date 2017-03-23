//
//  PiZhuViewController.h
//  StudentManagement
//
//  Created by Kitty on 17/2/17.
//  Copyright © 2017年 Kitty. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ReturnPathUrl)(NSString *, NSString *);

@interface PiZhuViewController : UIViewController

@property (nonatomic,copy) ReturnPathUrl pathBlock;

@end
