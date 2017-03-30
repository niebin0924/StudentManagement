//
//  CustomePopView.m
//  StudentManagement
//
//  Created by Kitty on 17/2/23.
//  Copyright © 2017年 Kitty. All rights reserved.
//

#import "CustomePopView.h"
#import "PopImageCollectionViewCell.h"

// AlertW 宽
#define AlertW 400
// 各个栏目之间的距离
#define Space 15.0

@interface CustomePopView () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate>

@property(nonatomic,retain) UIControl *control;
/** 弹窗 */
@property(nonatomic,retain) UIView *alertView;
/** title */
@property(nonatomic,retain) UILabel *titleLbl;
/** 内容 */
@property(nonatomic,retain) UILabel *msgLbl;
/** 确认按钮 */
@property(nonatomic,retain) UIButton *sureBtn;
/** 取消按钮 */
@property(nonatomic,retain) UIButton *cancleBtn;
/** 横线 */
@property(nonatomic,retain) UIView *lineView;
/** 竖线 */
@property(nonatomic,retain) UIView *verLineView;
/** 输入框 */
@property(nonatomic,retain) UITextField *textField;
/** 存放图片 */
@property(nonatomic,retain) UICollectionView *collectionView;

@property(nonatomic,retain) NSString *title;
@property(nonatomic,retain) NSString *message;
@property(nonatomic,retain) NSString *cancleTitle;
@property(nonatomic,retain) NSString *sureTitle;


@end

@implementation CustomePopView

-(instancetype)initWithTitle:(NSString *)title message:(NSString *)message sureBtn:(NSString *)sureTitle cancleBtn:(NSString *)cancleTitle
{
    if(self == [super init])
    {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.7];
        
        self.control = [[UIControl alloc] initWithFrame:self.frame];
        [self addSubview:self.control];
        
        self.alertView = [[UIView alloc]init];
        self.alertView.backgroundColor = [UIColor whiteColor];
        self.alertView.layer.cornerRadius = 5.0;
        self.alertView.frame = CGRectMake(0, 0, AlertW, 100);
        self.alertView.layer.position = self.center;

        [self.control addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];

        // pan
//        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveAction:)];
//        self.alertView.userInteractionEnabled = YES;
//        [self.alertView addGestureRecognizer:pan];
        
        self.title = title;
        self.message = message;
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
        if (message) {
            
            self.msgLbl = [self GetAdaptiveLable:CGRectMake(Space, CGRectGetMaxY(self.titleLbl.frame)+Space, AlertW-2*Space, 20) AndText:message andIsTitle:NO];
            self.msgLbl.textAlignment = NSTextAlignmentCenter;
            
            [self.alertView addSubview:self.msgLbl];
            
            CGFloat msgW = self.msgLbl.bounds.size.width;
            CGFloat msgH = self.msgLbl.bounds.size.height;
            
            self.msgLbl.frame = self.titleLbl?CGRectMake((AlertW-msgW)/2, CGRectGetMaxY(self.titleLbl.frame)+Space, msgW, msgH):CGRectMake((AlertW-msgW)/2, 2*Space, msgW, msgH);
        }
        
        self.lineView = [[UIView alloc] init];
        self.lineView.frame = self.msgLbl?CGRectMake(0, CGRectGetMaxY(self.msgLbl.frame)+2*Space, AlertW, 1):CGRectMake(0, CGRectGetMaxY(self.titleLbl.frame)+2*Space, AlertW, 1);
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
        
        [self.control addSubview:self.alertView];
    }
    return self;
}

- (void)addTextFieldWithConfigurationHandler:(void (^)(UITextField *textField))configurationHandler
{
    self.textField = [[UITextField alloc]init];
    self.textField.borderStyle = UITextBorderStyleNone;
    self.textField.tag = 3;
    self.textField.font = [UIFont systemFontOfSize:17];
//    self.textField.translatesAutoresizingMaskIntoConstraints = NO;
    self.textField.layer.borderWidth = 1;
    self.textField.layer.borderColor = [[UIColor colorWithRed:197/255.0 green:197/255.0 blue:197/255.0 alpha:1] CGColor];
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    self.textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    
    if (configurationHandler) {
        configurationHandler(_textField);
    }
        
    self.textField.frame = self.msgLbl?CGRectMake(Space, CGRectGetMaxY(self.msgLbl.frame)+Space, AlertW-2*Space, 40):CGRectMake(Space, CGRectGetMaxY(self.titleLbl.frame)+Space, AlertW-2*Space, 40);
    
    [self.alertView addSubview:self.textField];
    
    self.lineView.frame = CGRectMake(0, CGRectGetMaxY(self.textField.frame)+Space, AlertW, 1);
    
    [self layoutViews];
    
    
    
}

- (void)addCollectionViewWithConfigurationHandler:(void (^)(UICollectionView *collectionView))configurationHandler
{
    CGFloat itemWidth = (AlertW-Space*5)/3;
    CGFloat itemHeight = (AlertW-Space*5)/3 * 1.05;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    layout.minimumLineSpacing = Space; // 行间距
    layout.minimumInteritemSpacing = Space; // 垂直间距
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:layout];
    self.collectionView.userInteractionEnabled = YES;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"PopImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
    
    if (configurationHandler) {
        configurationHandler(_collectionView);
    }
    
    self.collectionView.frame = self.msgLbl?CGRectMake(Space, CGRectGetMaxY(self.msgLbl.frame)+Space, AlertW-2*Space, itemHeight+2*Space):CGRectMake(Space, CGRectGetMaxY(self.titleLbl.frame)+Space, AlertW-2*Space, itemHeight+2*Space);
    
    [self.alertView addSubview:_collectionView];
    
    self.lineView.frame = CGRectMake(0, CGRectGetMaxY(self.collectionView.frame)+Space, AlertW, 1);
    
    [self layoutViews];
}

- (void)layoutViews
{
    //两个按钮
    if (self.cancleTitle && self.sureTitle) {
        
        self.cancleBtn.frame = CGRectMake(0, CGRectGetMaxY(self.lineView.frame), (AlertW-1)/2, 50);
        self.verLineView.frame = CGRectMake(CGRectGetMaxX(self.cancleBtn.frame), CGRectGetMaxY(self.lineView.frame), 1, 50);
        self.sureBtn.frame = CGRectMake(CGRectGetMaxX(self.verLineView.frame), CGRectGetMaxY(self.lineView.frame), (AlertW-1)/2+1, 50);
    }
    
   
    //只有取消按钮
    if (self.cancleTitle && !self.sureTitle) {
        
        self.cancleBtn.frame = CGRectMake(0, CGRectGetMaxY(self.lineView.frame), AlertW, 50);
    }
    
    //只有确定按钮
    if(self.sureTitle && !self.cancleTitle){
        
        self.sureBtn.frame = CGRectMake(0, CGRectGetMaxY(self.lineView.frame), AlertW, 50);
       
    }
    
    //计算高度
    CGFloat alertHeight = self.cancleTitle?CGRectGetMaxY(self.cancleBtn.frame):CGRectGetMaxY(self.sureBtn.frame);
    self.alertView.frame = CGRectMake(0, 0, AlertW, alertHeight);
    self.alertView.layer.position = self.center;
    
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

-(UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

#pragma mark - 弹出
-(void)showPopView
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

#pragma mark - move
- (void)moveAction:(UIPanGestureRecognizer *)pan
{
    CGPoint translation = [pan translationInView:self];
    CGPoint newCenter = CGPointMake(pan.view.center.x+ translation.x,
                                    pan.view.center.y + translation.y);// 限制屏幕范围
    newCenter.y = MAX(pan.view.frame.size.height/2, newCenter.y);
    newCenter.y = MIN(self.frame.size.height - pan.view.frame.size.height/2,  newCenter.y);
    newCenter.x = MAX(pan.view.frame.size.width/2, newCenter.x);
    newCenter.x = MIN(self.frame.size.width - pan.view.frame.size.width/2,newCenter.x);
    pan.view.center = newCenter;
    [pan setTranslation:CGPointZero inView:self];
}

#pragma mark - 回调 只设置2 -- > 确定才回调
- (void)buttonEvent:(UIButton *)sender
{
    if (sender.tag == 2) {
        if (self.resultIndex) {
            self.resultIndex(sender.tag);
        }
    }
    [self removeFromSuperview];
}

- (void)remove
{
    [self removeFromSuperview];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    PopImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    NSString *imgName = self.dataArray[indexPath.item];
//    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:imgName] placeholderImage:[UIImage imageNamed:@"KNPhotoBrower.bundle/defaultPlaceHolder"]];
    
    [cell.iconImageView JYloadWebImage:imgName placeholderImage:[UIImage imageNamed:@"KNPhotoBrower.bundle/defaultPlaceHolder"]];
    
    cell.iconImageView.tag = 100 + indexPath.item;
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(popViewWithCollectionView:index:)]) {
        [self.delegate popViewWithCollectionView:collectionView index:indexPath.item];
    }
    
}

#pragma mark - UICollectionViewDelegateFlowLayout
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake((AlertW-Space*5)/4, 80);
//}
//
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
//{
//    return Space;
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//{
//    return Space;
//}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
