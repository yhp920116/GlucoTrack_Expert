//
//  UserInfoViewController.m
//  SugarNursing
//
//  Created by Ian on 14-11-17.
//  Copyright (c) 2014年 Tisson. All rights reserved.
//

#import "UserInfoViewController.h"

static CGFloat kDefaultFontSize = 14;

static CGFloat kDefaultCellParameterLeftMagin = 100;
static CGFloat kDefaultCellParameterRightMagin = 40;

static CGFloat kTitleLabelRightMagin = 10;


static CGFloat kDefaultCellUserImageLengthOfSize = 40;
static CGFloat kLucencyIndicatorLengthOfSize = 35;   // <40

static CGFloat kCellHeight = 60;

static CGFloat kRowCount = 8;

static CGFloat kEditAnimationDurantion = 1;


static CGFloat kTerritoryCellTextViewMagin = 10;
static NSString *territoryString = @"数量的会计法律上的空房间是懒得发空间撒地方OK给两点开始放假快乐事登记法律的快速减肥了看到手111111111机福利的康师傅付额几个可就是登陆卖场内开始登陆界面呢";


typedef enum {
    TableViewCellBaseItemTagTitleLabel = 20001,
    TableViewCellBaseItemTagUserView,
    TableViewCellBaseItemTagIndicator
}TableViewCellBaseItemTag;


typedef enum{
    TableViewCellRowUserImage = 0,
    TableViewCellRowActualName,
    TableViewCellRowGender,
    TableViewCellRowDateOfBirth,
    TableViewCellRowRank,
    TableViewCellRowDepartments,
    TableViewCellRowID,
    TableViewCellRowTerritory
}TableViewCellRow;


@interface UserInfoViewController ()
{
    
    CGSize territoryTextViewSize;
    BOOL isChecking;
}

@end

@implementation UserInfoViewController
@synthesize mainTableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    territoryTextViewSize = [self sizeWithString:territoryString
                                            font:[UIFont systemFontOfSize:kDefaultFontSize]
                                         maxSize:CGSizeMake(CGRectGetWidth(self.view.bounds) - kDefaultCellParameterLeftMagin - kDefaultCellParameterRightMagin/2, 0)];
    //解决TextView滑动特性导致内容无法居中
    territoryTextViewSize.height +=20;
    
    isChecking = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}



#pragma mark ** UITableView Delegate & DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return kRowCount;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == TableViewCellRowTerritory)
    {
        NSLog(@"%f",territoryTextViewSize.height + kTerritoryCellTextViewMagin *2);
        return territoryTextViewSize.height + kTerritoryCellTextViewMagin *2;
    }
    
    return kCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        if (isChecking)
        {
            return 35;
        }
    }
    
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] init];
    [label setText:@"  您的资料正在审核中,无法进行编辑修改"];
    [label setFont:[UIFont systemFontOfSize:kDefaultFontSize]];
    [label setTextColor:[UIColor redColor]];
    return label;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    //添加标题
    [self setTitleItemWithCell:cell indexPath:indexPath];
    
    switch (indexPath.row)
    {
        case TableViewCellRowUserImage:   [self setupUserImageCell:cell image:[UIImage imageNamed:@"QQ20141106-1.png"]];  break;
        case TableViewCellRowActualName:  [self setupActualNameCell:cell labelText:@"王大虎"];                             break;
        case TableViewCellRowGender:      [self setupDefaultCell:cell labelText:@"男"];                                    break;
        case TableViewCellRowDateOfBirth: [self setupDefaultCell:cell labelText:@"1959-02-12"];                           break;
        case TableViewCellRowRank:        [self setupRankCell:cell labelText:@"专家"];                                     break;
        case TableViewCellRowDepartments: [self setupDefaultCell:cell labelText:@"内分泌科"];                               break;
        case TableViewCellRowID:          [self setupDefaultCell:cell labelText:@"12345678901"];                          break;
        default:                          [self setupTerritoryCell:cell labelText:territoryString];                       break;
    }
    
    
    
    
    
    return cell;
}


#pragma mark ** 头像cell
- (void)setupUserImageCell:(UITableViewCell *)cell image:(UIImage *)image
{
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [imageView setFrame:
    CGRectMake(CGRectGetWidth(self.view.bounds) - kDefaultCellParameterRightMagin - kDefaultCellUserImageLengthOfSize,
               (kCellHeight - kDefaultCellUserImageLengthOfSize)/2,
               kDefaultCellUserImageLengthOfSize,
               kDefaultCellUserImageLengthOfSize)];
    [imageView setTag:TableViewCellBaseItemTagUserView];
    [cell addSubview:imageView];
    
    
    [self setLucencyIndicatorWithCell:cell];
}   

#pragma mark ** 真实姓名cell
- (void)setupActualNameCell:(UITableViewCell *)cell labelText:(NSString *)labelText
{
    UITextField *textField = [[UITextField alloc] init];
    textField.userInteractionEnabled = NO;
    [textField setFont:[UIFont systemFontOfSize:kDefaultFontSize]];
    [textField setText:labelText];
    [textField setTextColor:[UIColor lightGrayColor]];
    
    
    [textField setFrame:CGRectMake(kDefaultCellParameterLeftMagin,
                               kCellHeight /4,
                               CGRectGetWidth(self.view.bounds)/2,
                               kCellHeight /2)];
    
    
    [textField setTag:TableViewCellBaseItemTagUserView];
    [cell addSubview:textField];
}


#pragma mark ** 默认cell (性别,出生日期,科室)
- (void)setupDefaultCell:(UITableViewCell *)cell labelText:(NSString *)labelText
{
    
    
    UILabel *label = [[UILabel alloc] init];
    [label setFont:[UIFont systemFontOfSize:kDefaultFontSize]];
    [label setText:labelText];
    [label setTextColor:[UIColor lightGrayColor]];
    
    CGSize size = [self sizeWithString:label.text
                                  font:label.font
                               maxSize:CGSizeMake(CGRectGetWidth(self.view.bounds)/2, kCellHeight)];
    
    
    
    
    [label setFrame:CGRectMake(kDefaultCellParameterLeftMagin,
                                        (kCellHeight - size.height)/2,
                                        size.width,
                                        size.height)];
    label.numberOfLines = 1;
    [label setTextAlignment:NSTextAlignmentRight];
    
    [label setTag:TableViewCellBaseItemTagUserView];
    [cell addSubview:label];
    
    
    [self setLucencyIndicatorWithCell:cell];
    
}

#pragma mark ** 级别cell
- (void)setupRankCell:(UITableViewCell *)cell labelText:(NSString *)labelText
{
    UILabel *label = [[UILabel alloc] init];
    [label setFont:[UIFont systemFontOfSize:kDefaultFontSize]];
    [label setText:labelText];
    [label setTextColor:[UIColor lightGrayColor]];
    
    CGSize size = [self sizeWithString:label.text
                                  font:label.font
                               maxSize:CGSizeMake(CGRectGetWidth(self.view.bounds)/2, kCellHeight)];
    
    
    [label setFrame:CGRectMake(kDefaultCellParameterLeftMagin,
                               (kCellHeight - size.height)/2,
                               size.width,
                               size.height)];
    label.numberOfLines = 1;
    [label setTextAlignment:NSTextAlignmentRight];
    
    [label setTag:TableViewCellBaseItemTagUserView];
    [cell addSubview:label];
}


#pragma mark ** ID cell
- (void)setupIDCell:(UITableViewCell *)cell labelText:(NSString *)labelText
{
    UILabel *label = [[UILabel alloc] init];
    [label setFont:[UIFont systemFontOfSize:kDefaultFontSize]];
    [label setText:labelText];
    
    CGSize size = [self sizeWithString:label.text
                                  font:label.font
                               maxSize:CGSizeMake(CGRectGetWidth(self.view.bounds)/2, kCellHeight)];
    
    
    
    
    [label setFrame:CGRectMake(kDefaultCellParameterLeftMagin,
                               (kCellHeight - size.height)/2,
                               size.width,
                               size.height)];
    label.numberOfLines = 1;
    [label setTextAlignment:NSTextAlignmentRight];
    
    [label setTag:TableViewCellBaseItemTagUserView];
    [cell addSubview:label];
}

#pragma mark ** 擅长领域cell
- (void)setupTerritoryCell:(UITableViewCell *)cell labelText:(NSString *)labelText
{
    
    UITextView *textView = [[UITextView alloc] init];
    [textView setFont:[UIFont systemFontOfSize:kDefaultFontSize]];
    [textView setText:labelText];
    textView.userInteractionEnabled = NO;
    
    
    [textView setFrame:CGRectMake(kDefaultCellParameterLeftMagin,
                               kTerritoryCellTextViewMagin,
                               territoryTextViewSize.width,
                               territoryTextViewSize.height)];
    
    
    [textView setTag:TableViewCellBaseItemTagUserView];
    [cell addSubview:textView];
}

#pragma mark ** 设置标题label
- (void)setTitleItemWithCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFrame:CGRectMake(0,
                                   0,
                                   kDefaultCellParameterLeftMagin - kTitleLabelRightMagin,
                                    kCellHeight)];
    [titleLabel setText:[self titleWithIndexPath:indexPath]];
    [titleLabel setTextAlignment:NSTextAlignmentRight];
    [cell addSubview:titleLabel];
}

#pragma mark ** 为cell添加透明指示器
- (void)setLucencyIndicatorWithCell:(UITableViewCell *)cell
{
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AccessoryDisclosureIndicator"]];
    [imageView setFrame:CGRectMake(CGRectGetWidth(self.view.bounds) - kDefaultCellParameterRightMagin + (kDefaultCellParameterRightMagin - kLucencyIndicatorLengthOfSize)/2,
                                  (kCellHeight - kLucencyIndicatorLengthOfSize)/2,
                                  kLucencyIndicatorLengthOfSize,
                                   kLucencyIndicatorLengthOfSize)];
    [imageView setAlpha:0];
    [imageView setTag:TableViewCellBaseItemTagIndicator];
    [cell addSubview:imageView];
}



#pragma mark ** 编辑按钮事件
- (IBAction)editButtonEvent:(id)sender
{
    for (int i=0; i < kRowCount; i++)
    {
        if (i == TableViewCellRowRank || i == TableViewCellRowID)  continue;
        
        if (i == TableViewCellRowActualName)
        {
            [self actualNameCellAnimationBegin];
            continue;
        }
        
        if (i == TableViewCellRowTerritory)
        {
            [self territoryCellAnimationBegin];
        }
        
        
        
        UITableViewCell *cell = [self.mainTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        UIView *userView = [cell viewWithTag:TableViewCellBaseItemTagUserView];
        
        //用户的资料view改变状态
        if ([userView isKindOfClass:[UILabel class]])
        {
            
            UILabel *label = (UILabel *)userView;
            
            [UIView animateWithDuration:kEditAnimationDurantion/2 animations:^{
                
                //label隐藏
                CGRect rect = label.frame;
                rect.origin.x = CGRectGetWidth(self.view.bounds)/2;
                [label setFrame:rect];
                
                label.alpha = 0;
            } completion:^(BOOL finished) {
                
                
                [UIView animateWithDuration:kEditAnimationDurantion/2 animations:^{
  
                    [label setTextColor:[UIColor blackColor]];
                    
                    //label显现
                    CGRect rect = label.frame;
                    rect.origin.x = CGRectGetWidth(self.view.bounds) - kDefaultCellParameterRightMagin - rect.size.width;
                    [label setFrame:rect];
                    label.alpha = 1;
                }];
            }];
        }
        
        
        //指示器显现
        UIView *indicatorView = [cell viewWithTag:TableViewCellBaseItemTagIndicator];
        [UIView animateWithDuration:kEditAnimationDurantion/2 animations:^{
            indicatorView.alpha = 1;
            
        }];

        
    }
}


- (void)actualNameCellAnimationBegin
{
    
    UITableViewCell *cell = [self.mainTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:TableViewCellRowActualName inSection:0]];
    UIView *userView = [cell viewWithTag:TableViewCellBaseItemTagUserView];
    
    if ([userView isKindOfClass:[UITextField class]])
    {
        UITextField *userNameTextField = (UITextField *)userView;
        
        CGRect rect = userNameTextField.frame;
        
        UIImageView *textViewBottomView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"004@2x.png"]];
        [textViewBottomView setFrame:CGRectMake(0,
                                                rect.size.height - 10,
                                                rect.size.width,
                                                10)];
        textViewBottomView.alpha = 0;
        
        [userNameTextField addSubview:textViewBottomView];
        
        
        [UIView animateWithDuration:kEditAnimationDurantion/2 animations:^{
            
            userNameTextField.alpha = 0;
        } completion:^(BOOL finished) {
            
            [userNameTextField setTextColor:[UIColor blackColor]];
            
            [UIView animateWithDuration:kEditAnimationDurantion animations:^{
                textViewBottomView.alpha = 1;
                userNameTextField.alpha = 1;
            }];
        }];
        
        
    }
}

- (void)territoryCellAnimationBegin
{
    
    UITableViewCell *cell = [self.mainTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:TableViewCellRowTerritory inSection:0]];
    UIView *userView = [cell viewWithTag:TableViewCellBaseItemTagUserView];
    
    if ([userView isKindOfClass:[UITextView class]])
    {
        UITextView *textView = (UITextView *)userView;
        
        
        
        UIGraphicsBeginImageContext(cell.frame.size);
        UIBezierPath *path = [UIBezierPath bezierPath];
        
        path.lineWidth = 1.0;
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.lineWidth = 1.0;
        layer.strokeColor = [[UIColor lightGrayColor] CGColor];
        
        [cell.layer addSublayer:layer];
        
        
        CGPoint upleftPoint  = CGPointMake(textView.frame.origin.x, textView.frame.origin.y);
        
        CGPoint upRightPoint = CGPointMake(textView.frame.origin.x + textView.frame.size.width,
                                           textView.frame.origin.y);
        
        CGPoint bottomLeftPoint = CGPointMake(textView.frame.origin.x,
                                              textView.frame.origin.y + textView.frame.size.height);
        
        CGPoint bottomRightPoint = CGPointMake(textView.frame.origin.x + textView.frame.size.width,
                                               textView.frame.origin.y + textView.frame.size.height);
        
        
        
        [path moveToPoint:upleftPoint];
        
        [path addLineToPoint:upRightPoint];
        
        [path moveToPoint:upRightPoint];
        
        [path addLineToPoint:bottomRightPoint];
        
        [path moveToPoint:bottomRightPoint];
        
        [path addLineToPoint:bottomLeftPoint];
        
        [path moveToPoint:bottomLeftPoint];
        
        [path addLineToPoint:upleftPoint];
        
        
        layer.path = path.CGPath;
        
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.duration = 1;
        animation.fromValue = @(0);
        animation.toValue = @(1);
        
        [layer addAnimation:animation forKey:@"strokeEndAnimation"];
        
        UIGraphicsEndImageContext();
    }
}

#pragma mark ** 获取标题
- (NSString *)titleWithIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.row)
    {
            
        case 0:
            return @"头像";
            break;
        case 1:
            return @"真实姓名";
            break;
        case 2:
            return @"性别";
            break;
        case 3:
            return @"出生日期";
            break;
        case 4:
            return @"级别";
            break;
        case 5:
            return @"科室";
            break;
        case 6:
            return @"ID";
            break;
        default:
            return @"擅长领域";
            break;
    }
}


#pragma mark  **  根据string计算label大小
- (CGSize)sizeWithString:(NSString*)string font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attribute = @{NSFontAttributeName: font};
    
    CGSize textSize = [string boundingRectWithSize:maxSize
                                           options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                        attributes:attribute
                                           context:nil].size;
    return textSize;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
