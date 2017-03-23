//
//  MyPageControl.m
//  StudentManagement
//
//  Created by Kitty on 17/2/24.
//  Copyright © 2017年 Kitty. All rights reserved.
//

#import "MyPageControl.h"

@implementation MyPageControl

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setCurrentPage:(NSInteger)currentPage
{
    [super setCurrentPage:currentPage];
    
    for (NSUInteger subviewIndex = 0; subviewIndex < [self.subviews count]; subviewIndex++) {
        UIImageView* subview = [self.subviews objectAtIndex:subviewIndex];
        CGSize size;
        size.height = 20;
        size.width = 20;
        [subview setFrame:CGRectMake(subview.frame.origin.x, subview.frame.origin.y,
                                     size.width,size.height)];
        
    }
}

@end
