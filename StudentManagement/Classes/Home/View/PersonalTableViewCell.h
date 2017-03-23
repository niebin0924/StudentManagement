//
//  PersonalTableViewCell.h
//  StudentManagement
//
//  Created by Kitty on 17/2/17.
//  Copyright © 2017年 Kitty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;
@property (weak, nonatomic) IBOutlet UITextField *contentField;

@end
