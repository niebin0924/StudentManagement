//
//  CustomeAlertViewWithCollection.m
//  弹框列表
//
//  Created by Kitty on 17/3/8.
//  Copyright © 2017年 James. All rights reserved.
//

// AlertW 宽
#define AlertW [UIScreen mainScreen].bounds.size.width*0.5
#define AlertH [UIScreen mainScreen].bounds.size.width*0.5*0.7
// 各个栏目之间的距离
#define Space 15.0

#import "CustomeAlertViewWithCollection.h"

@interface CustomeAlertViewWithCollection () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

/** 弹窗 */
@property(nonatomic,retain) UIView *alertView;
/** title */
@property(nonatomic,retain) UILabel *titleLbl;
/** 确认按钮 */
@property(nonatomic,retain) UIButton *sureBtn;
/** 取消按钮 */
@property(nonatomic,retain) UIButton *cancleBtn;
/** 横线 */
@property(nonatomic,retain) UIView *lineView;
/** 竖线 */
@property(nonatomic,retain) UIView *verLineView;

/** 存放图片 */
@property(nonatomic,retain) UICollectionView *collectionView;

@property(nonatomic,retain) NSString *title;
@property(nonatomic,retain) NSString *cancleTitle;
@property(nonatomic,retain) NSString *sureTitle;
@property(nonatomic,retain) NSIndexPath *selIndexPath;


@end

@implementation CustomeAlertViewWithCollection

-(instancetype)initWithTitle:(NSString *)title collectionCellName:(NSString *)cellName sureBtn:(NSString *)sureTitle cancleBtn:(NSString *)cancleTitle
{
    if(self == [super init])
    {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.7];
        self.alertView = [[UIView alloc]init];
        self.alertView.backgroundColor = [UIColor whiteColor];
        self.alertView.layer.cornerRadius = 5.0;
        self.alertView.frame = CGRectMake(0, 0, AlertW, 100);
        self.alertView.layer.position = self.center;
        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(remove)];
//        [self addGestureRecognizer:tap];
        
        self.title = title;
        self.cancleTitle = cancleTitle;
        self.sureTitle = sureTitle;
        
        if(title)
        {
            self.titleLbl = [self GetAdaptiveLable:CGRectMake(2*Space, 2*Space, AlertW-4*Space, 20) AndText:title andIsTitle:YES];
            self.titleLbl.textAlignment = NSTextAlignmentCenter;
            
            [self.alertView addSubview:self.titleLbl];
            
            CGFloat titleW = self.titleLbl.bounds.size.width;
            CGFloat titleH = self.titleLbl.bounds.size.height;
            
            self.titleLbl.frame = CGRectMake((AlertW-titleW)/2, 2*Space, titleW, titleH);
        }
        
        CGFloat itemWidth = (AlertW-Space*5)/4;
        CGFloat itemHeight = (AlertW-Space*5)/4;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(itemWidth, itemHeight);
        layout.minimumLineSpacing = Space; // 行间距
        layout.minimumInteritemSpacing = Space; // 垂直间距
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(Space, CGRectGetMaxY(self.titleLbl.frame)+Space, AlertW-2*Space, AlertH-5*Space-50-1) collectionViewLayout:layout];
        self.collectionView.backgroundColor = [UIColor whiteColor];
        [self.collectionView registerNib:[UINib nibWithNibName:cellName bundle:nil] forCellWithReuseIdentifier:@"Cell"];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        [self.alertView addSubview:self.collectionView];
        
        self.lineView = [[UIView alloc] init];
        self.lineView.frame = self.collectionView?CGRectMake(0, CGRectGetMaxY(self.collectionView.frame)+2*Space, AlertW, 1):CGRectMake(0, CGRectGetMaxY(self.titleLbl.frame)+2*Space, AlertW, 1);
        self.lineView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.6];
        [self.alertView addSubview:self.lineView];
        
        //两个按钮
        if (self.cancleTitle && self.sureTitle) {
            
            self.cancleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            self.cancleBtn.frame = CGRectMake(0, CGRectGetMaxY(self.lineView.frame), (AlertW-1)/2, 50);
            self.cancleBtn.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
            //            [self.cancleBtn setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]] forState:UIControlStateNormal];
            //            [self.cancleBtn setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.2]] forState:UIControlStateSelected];
            [self.cancleBtn setTitle:self.cancleTitle forState:UIControlStateNormal];
            [self.cancleBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            self.cancleBtn.tag = 1;
            [self.cancleBtn addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
            
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.cancleBtn.bounds byRoundingCorners:UIRectCornerBottomLeft cornerRadii:CGSizeMake(5.0, 5.0)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = self.cancleBtn.bounds;
            maskLayer.path = maskPath.CGPath;
            self.cancleBtn.layer.mask = maskLayer;
            
            [self.alertView addSubview:self.cancleBtn];
        }
        
        if (self.cancleTitle && self.sureTitle) {
            self.verLineView = [[UIView alloc] init];
            self.verLineView.frame = CGRectMake(CGRectGetMaxX(self.cancleBtn.frame), CGRectGetMaxY(self.lineView.frame), 1, 50);
            self.verLineView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.6];
            [self.alertView addSubview:self.verLineView];
        }
        
        if(self.sureTitle && self.cancleTitle){
            
            self.sureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            self.sureBtn.frame = CGRectMake(CGRectGetMaxX(self.verLineView.frame), CGRectGetMaxY(self.lineView.frame), (AlertW-1)/2+1, 50);
            // 该背景色
            self.sureBtn.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
            //            [self.sureBtn setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:255/255.0 green:192/255.0 blue:203/255.0 alpha:0.2]] forState:UIControlStateNormal];
            // 改颜色
            [self.sureBtn setTitleColor:[UIColor colorWithRed:28/255.0 green:186/255.0 blue:60/255.0 alpha:1] forState:UIControlStateNormal];
            //            [self.sureBtn setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.2]] forState:UIControlStateSelected];
            [self.sureBtn setTitle:self.sureTitle forState:UIControlStateNormal];
            self.sureBtn.tag = 2;
            [self.sureBtn addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
            
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.sureBtn.bounds byRoundingCorners:UIRectCornerBottomRight cornerRadii:CGSizeMake(5.0, 5.0)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = self.sureBtn.bounds;
            maskLayer.path = maskPath.CGPath;
            self.sureBtn.layer.mask = maskLayer;
            
            [self.alertView addSubview:self.sureBtn];
            
        }
        
        //只有取消按钮
        if (self.cancleTitle && !self.sureTitle) {
            
            self.cancleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            self.cancleBtn.frame = CGRectMake(0, CGRectGetMaxY(self.lineView.frame), AlertW, 50);
            //            [self.cancleBtn setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.2]] forState:UIControlStateNormal];
            //            [self.cancleBtn setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.2]] forState:UIControlStateSelected];
            self.cancleBtn.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
            [self.cancleBtn setTitle:self.cancleTitle forState:UIControlStateNormal];
            [self.cancleBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            self.cancleBtn.tag = 1;
            [self.cancleBtn addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
            
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.cancleBtn.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5.0, 5.0)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = self.cancleBtn.bounds;
            maskLayer.path = maskPath.CGPath;
            self.cancleBtn.layer.mask = maskLayer;
            
            [self.alertView addSubview:self.cancleBtn];
        }
        
        //只有确定按钮
        if(self.sureTitle && !self.cancleTitle){
            
            self.sureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            self.sureBtn.frame = CGRectMake(0, CGRectGetMaxY(self.lineView.frame), AlertW, 50);
            self.sureBtn.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
            //            [self.sureBtn setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.2]] forState:UIControlStateNormal];
            //            [self.sureBtn setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.2]] forState:UIControlStateSelected];
            [self.sureBtn setTitle:self.sureTitle forState:UIControlStateNormal];
            [self.sureBtn setTitleColor:[UIColor colorWithRed:28/255.0 green:186/255.0 blue:60/255.0 alpha:1] forState:UIControlStateNormal];
            self.sureBtn.tag = 2;
            [self.sureBtn addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
            
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.sureBtn.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5.0, 5.0)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = self.sureBtn.bounds;
            maskLayer.path = maskPath.CGPath;
            self.sureBtn.layer.mask = maskLayer;
            
            [self.alertView addSubview:self.sureBtn];
            
        }
        
        //计算高度
        CGFloat alertHeight = self.cancleTitle?CGRectGetMaxY(self.cancleBtn.frame):CGRectGetMaxY(self.sureBtn.frame);
        self.alertView.frame = CGRectMake(0, 0, AlertW, alertHeight);
        self.alertView.layer.position = self.center;
        
        [self addSubview:self.alertView];
    }
    return self;
}

-(UILabel *)GetAdaptiveLable:(CGRect)rect AndText:(NSString *)contentStr andIsTitle:(BOOL)isTitle
{
    UILabel *contentLbl = [[UILabel alloc] initWithFrame:rect];
    contentLbl.numberOfLines = 0;
    contentLbl.text = contentStr;
    contentLbl.textAlignment = NSTextAlignmentCenter;
    if (isTitle) {
        contentLbl.font = [UIFont boldSystemFontOfSize:16.0];
    }else{
        contentLbl.font = [UIFont systemFontOfSize:14.0];
    }
    
    NSMutableAttributedString *mAttrStr = [[NSMutableAttributedString alloc] initWithString:contentStr];
    NSMutableParagraphStyle *mParaStyle = [[NSMutableParagraphStyle alloc] init];
    mParaStyle.lineBreakMode = NSLineBreakByCharWrapping;
    [mParaStyle setLineSpacing:3.0];
    [mAttrStr addAttribute:NSParagraphStyleAttributeName value:mParaStyle range:NSMakeRange(0,[contentStr length])];
    [contentLbl setAttributedText:mAttrStr];
    [contentLbl sizeToFit];
    
    return contentLbl;
}

//列表cell的重用
- (id)dequeueReusableAlertCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath
{
    return [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
}

- (UICollectionViewCell *)alertCellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.collectionView reloadData];
    return [self.collectionView cellForItemAtIndexPath:indexPath];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.datasource && [self.datasource respondsToSelector:@selector(alertCollectionView:numberOfItemsInSection:)])
    {
        return [self.datasource alertCollectionView:self numberOfItemsInSection:section];
    }
    return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.datasource && [self.datasource respondsToSelector:@selector(alertCollectionView:cellForItemAtIndexPath:)]) {
        
        return [self.datasource alertCollectionView:self cellForItemAtIndexPath:indexPath];
    }
    return nil;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(alertCollectionView:didSelectItemAtIndexPath:)]) {
        
        self.selIndexPath = indexPath;
        [self.delegate alertCollectionView:self didSelectItemAtIndexPath:indexPath];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(alertCollectionView:didDeselectItemAtIndexPath:)]) {
        
        [self.delegate alertCollectionView:self didDeselectItemAtIndexPath:indexPath];
    }
}

#pragma mark - 弹出
- (void)show
{
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
    [self creatShowAnimation];
}

-(void)creatShowAnimation
{
    self.alertView.layer.position = self.center;
    self.alertView.transform = CGAffineTransformMakeScale(0.90, 0.90);
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.alertView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        
    }];
    
}


#pragma mark - 回调 只设置2 -- > 确定才回调
- (void)buttonEvent:(UIButton *)sender
{
    if (sender.tag == 2) {
        if (self.resultIndexpath) {
            self.resultIndexpath(self.selIndexPath);
        }
    }
    [self removeFromSuperview];
}

- (void)remove
{
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
