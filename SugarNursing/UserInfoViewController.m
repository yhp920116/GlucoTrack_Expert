//
//  UserInfoViewController.m
//  SugarNursing
//
//  Created by Ian on 14-11-17.
//  Copyright (c) 2014年 Tisson. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UIViewController+Notifications.h"
#import <MBProgressHUD.h>


static CGFloat kDefaultCellParameterLeftMagin = 100;
static CGFloat kDefaultCellParameterRightMagin = 40;
static CGFloat kTitleLabelRightMagin = 10;
static CGFloat kTerritoryCellTextViewMagin = 10;



static CGFloat kDefaultCellUserImageLengthOfSize = 40;    //用户图片宽高
static CGFloat kLucencyIndicatorLengthOfSize = 35;   //指示器宽高 (<40)

static CGFloat kCellHeight = 60;
static CGFloat kUploadCellHeight = 40;
static CGFloat kRowCount = 8;


static CGFloat kDefaultFontSize = 14;


static CGFloat kAnimationDurantion = 1;



static NSString *territoryString = @"数量的会计法律上的了开发速度就两款发动机是肯定就发了多少份简历看多久了罚款就是的浪费就是的离开房间多少了开发交流的刷卡缴费空房间是懒得发空间撒地方OK给两点开始放假快乐事登记法律的快速减肥了看到手111111111机福利的康师傅付额几个可就是登陆卖场内开始登陆界面呢";


typedef enum {
    TableViewCellBaseItemTagTitleLabel = 20001,
    TableViewCellBaseItemTagUserView,
    TableViewCellBaseItemTagIndicator,
    TableViewCellBaseItemTagSecondView
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
    MBProgressHUD *hud;
    
    NSMutableArray *departmentsArray;
    
    
    CGSize territoryTextViewSize;
    BOOL isChecking;
    
}

@property (nonatomic, assign) BOOL editing;

@property (nonatomic, strong) UIView *activeView;

@end

@implementation UserInfoViewController
@synthesize mainTableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    departmentsArray = [NSMutableArray array];
    
    NSMutableDictionary *componentDic = [NSMutableDictionary dictionary];
    [componentDic setObject:@"内科" forKey:@"componentTitle"];
    
    NSMutableArray *rowArray = [NSMutableArray array];
    [rowArray addObject:@"神经内科"];
    [rowArray addObject:@"呼吸内科"];
    [rowArray addObject:@"心内科"];
    [rowArray addObject:@"肾内科"];
    [rowArray addObject:@"普通内科"];
    [componentDic setObject:rowArray forKey:@"content"];
    [departmentsArray addObject:componentDic];
    
    componentDic = [NSMutableDictionary dictionary];
    [componentDic setObject:@"外科" forKey:@"componentTitle"];
    
    rowArray = [NSMutableArray array];
    [rowArray addObject:@"皮肤科"];
    [rowArray addObject:@"五官科"];
    [rowArray addObject:@"普通外科"];
    
    [componentDic setObject:rowArray forKey:@"content"];
    [departmentsArray addObject:componentDic];
    
    
    
    
//    isChecking = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}


- (void)keyBoardWillShow:(NSNotification *)notification
{
    
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.mainTableView.contentInset = contentInsets;
    self.mainTableView.scrollIndicatorInsets = contentInsets;
    
    
    
    CGRect textFieldRect = [self.mainTableView convertRect:self.activeView.bounds fromView:self.activeView];
    [self.mainTableView scrollRectToVisible:textFieldRect animated:YES];
}

- (void)keyBoardWillHide:(NSNotification *)notification
{
    
    UIEdgeInsets inset = UIEdgeInsetsZero;
    self.mainTableView.contentInset = inset;
    self.mainTableView.scrollIndicatorInsets = inset;
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.mainTableView reloadData];
}


#pragma mark - UITextField & UITextView    Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeView = textField;
}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.activeView = textView;
    return YES;
}


#pragma mark - UIPickerView DataSource & Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0)
    {
        return departmentsArray.count;
    }
    else
    {
        NSInteger selectRowLeft = [pickerView selectedRowInComponent:0];
        
        NSArray *rowArray = [[departmentsArray objectAtIndex:selectRowLeft] objectForKey:@"content"];
        return rowArray.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    if (component == 0)
    {
        NSDictionary *department = [departmentsArray objectAtIndex:row];
        NSString *componentTitle = [department objectForKey:@"componentTitle"];
        return componentTitle;
    }
    else
    {
        NSInteger selectRowLeft = [pickerView selectedRowInComponent:0];
        NSDictionary *department = [departmentsArray objectAtIndex:selectRowLeft];
        NSArray *rowArray = [department objectForKey:@"content"];
        NSString *title = [rowArray objectAtIndex:row];
        return title;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if (component == 0)
    {
        
        [self.departmentsPicker reloadComponent:1];
    }
}

- (IBAction)confirmButtonEvent:(id)sender
{
    
    NSInteger selectComponent = [self.departmentsPicker selectedRowInComponent:0];
    NSInteger selectRow = [self.departmentsPicker selectedRowInComponent:1];
    
    
    NSDictionary *department = [departmentsArray objectAtIndex:selectComponent];
    NSArray *rowArray = [department objectForKey:@"content"];
    NSString *title = [rowArray objectAtIndex:selectRow];
    
    
    if (title && title.length > 0)
    {
        UITableViewCell *cell = [self.mainTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:TableViewCellRowDepartments
                                                                                             inSection:0]];
        UILabel *label = (UILabel *)[cell viewWithTag:TableViewCellBaseItemTagUserView];
        [label setText:title];
    }
    
    [hud hide:YES];
}


- (IBAction)cancelButtonEvent:(id)sender
{
    
    [hud hide:YES];
}

#pragma mark - UITableView Delegate & DataSource
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
    if (self.activeView && [self.activeView isFirstResponder] && scrollView == self.mainTableView)
    {
        [self.activeView resignFirstResponder];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        
        return kRowCount;
    }
    else
    {
        if (self.editing)
        {
            return 1;
        }
    }
    
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.editing)
    {
        return 2;
    }
    else
    {
        return 1;
    }
    
//    return self.editing ? 2 : 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        
        if (indexPath.row == TableViewCellRowTerritory)
        {
            
            territoryTextViewSize = [self sizeWithString:territoryString
                                                    font:[UIFont systemFontOfSize:kDefaultFontSize]
                                                 maxSize:CGSizeMake(CGRectGetWidth(self.view.bounds) - kDefaultCellParameterLeftMagin - kDefaultCellParameterRightMagin/2, 0)];
            
            return territoryTextViewSize.height + kTerritoryCellTextViewMagin *2  +20;
        }
        
        return kCellHeight;
    }
    else
    {
        
        return kUploadCellHeight;
    }
    
    return 0;
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
    
    if (section == 0)
    {
        
        if (isChecking)
        {
            
            UILabel *label = [[UILabel alloc] init];
            [label setText:@"  您的资料正在审核中,无法进行编辑修改"];
            [label setFont:[UIFont systemFontOfSize:kDefaultFontSize]];
            [label setTextColor:[UIColor redColor]];
            return label;
        }
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0)
    {
        
        if (self.editing)
        {
            switch (indexPath.row)
            {
                case TableViewCellRowGender:        [self selectActualNameCellEvent];    break;
                case TableViewCellRowDateOfBirth:   [self selectDateOfBirthCellEvent];   break;
                case TableViewCellRowDepartments:   [self selectDepartmentsCellEvent];   break;
                default:
                    break;
            }
        }
    }
    else
    {
        
        [self selectUploadRequestCellEvent];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell;
    
    if (indexPath.section == 0)
    {
        
        switch (indexPath.row)
        {
            case TableViewCellRowUserImage:   cell = [self setupUserImageCellWithImage:[UIImage imageNamed:@"019"]];   break;
            case TableViewCellRowActualName:  cell = [self setupActualNameCellWithLabelText:@"WangBigTiger"];                break;
            case TableViewCellRowGender:      cell = [self setupGenderCellWithLabelText:@"男"];                               break;
            case TableViewCellRowDateOfBirth: cell = [self setupDateOfBirthCellWithLabelText:@"1959-02-12"];                  break;
            case TableViewCellRowRank:        cell = [self setupRankCellWithLabelText:@"专家"];                                break;
            case TableViewCellRowDepartments: cell = [self setupDepartmentsCellWithLabelText:@"内分泌科"];                     break;
            case TableViewCellRowID:          cell = [self setupIDCellWithLabelText:@"12345678901"];                          break;
            default:                          cell = [self setupTerritoryCellWithLabelText:territoryString];                  break;
        }
        
        //添加标题
        [self setTitleItemWithCell:cell indexPath:indexPath];
    }
    else
    {
        
        if (self.editing)
        {
            cell = [self setupUploadRequestCell];
        }
    }
    
    
    
    return cell;
}

#pragma mark - 自定义Cell创建

#pragma mark 提交审批cell
- (UITableViewCell *)setupUploadRequestCell
{
    
    UITableViewCell *cell = [self.mainTableView dequeueReusableCellWithIdentifier:@"UploadRequestCell"];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UploadRequestCell"];
        cell.textLabel.text = @"提交审批";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.backgroundColor = [UIColor colorWithRed:2.0f/255.0f green:136.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
        
    }
    
    return cell;
}

#pragma mark 头像cell
- (UITableViewCell *)setupUserImageCellWithImage:(UIImage *)image
{
    
    static NSString *identifier = @"UserImageCell";
    UITableViewCell *cell = [self.mainTableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [imageView setTag:TableViewCellBaseItemTagUserView];
        [cell addSubview:imageView];
        
        
        UIImageView *indicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"005"]];
        [indicator setTag:TableViewCellBaseItemTagIndicator];
        [cell addSubview:indicator];
    }
    
    
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:TableViewCellBaseItemTagUserView];
    [imageView setFrame:
     CGRectMake(CGRectGetWidth(self.view.bounds) - kDefaultCellParameterRightMagin - kDefaultCellUserImageLengthOfSize,
                (kCellHeight - kDefaultCellUserImageLengthOfSize)/2,
                kDefaultCellUserImageLengthOfSize,
                kDefaultCellUserImageLengthOfSize)];
    
    
    [self setLucencyIndicatorWithCell:cell];
    
    
    
    UIView *indicator = [cell viewWithTag:TableViewCellBaseItemTagIndicator];
    if (self.editing)
    {
        indicator.alpha = 1;
    }
    else
    {
        indicator.alpha = 0;
    }
    
    
    return cell;
}



#pragma mark 真实姓名cell
- (UITableViewCell *)setupActualNameCellWithLabelText:(NSString *)labelText
{
    static NSString *identifier = @"ActualNameCell";
    UITableViewCell *cell = [self.mainTableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell)
    {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UITextField *textField = [[UITextField alloc] init];
        textField.delegate = self;
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
        
        
        
        CGRect rect = textField.frame;
        UIImageView *textFieldBottomView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"004"]];
        [textFieldBottomView setFrame:CGRectMake(rect.origin.x - 5,
                                                 rect.origin.y + rect.size.height - 10,
                                                 rect.size.width,
                                                 7)];
        textFieldBottomView.tag = TableViewCellBaseItemTagSecondView;
        
        [cell addSubview:textFieldBottomView];
    }
    
    UITextField *textField = (UITextField *)[cell viewWithTag:TableViewCellBaseItemTagUserView];
    [textField setTextColor:[UIColor lightGrayColor]];
    [textField setUserInteractionEnabled:NO];
    
    UIImageView *bottomView = (UIImageView *)[cell viewWithTag:TableViewCellBaseItemTagSecondView];
    if (self.editing)
    {
        
        [textField setTextColor:[UIColor blackColor]];
        [textField setUserInteractionEnabled:YES];
        
        [bottomView setImage:[UIImage imageNamed:@"003"]];
    }
    else
    {
        [bottomView setImage:[UIImage imageNamed:@"004"]];
        NSLog(@"%@",bottomView);
    }
    
    return cell;
}


#pragma mark 性别cell
- (UITableViewCell *)setupGenderCellWithLabelText:(NSString *)labelText
{
    static NSString *identifier = @"GenderCell";
    UITableViewCell *cell = [self.mainTableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        
        UILabel *label = [[UILabel alloc] init];
        [label setTag:TableViewCellBaseItemTagUserView];
        [label setFont:[UIFont systemFontOfSize:kDefaultFontSize]];
        label.numberOfLines = 1;
        [cell addSubview:label];
        
        
        UIImageView *indicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"005"]];
        [indicator setTag:TableViewCellBaseItemTagIndicator];
        [cell addSubview:indicator];
    }
    
    
    [self setupDefaulCell:cell labelText:labelText];
    [self setLucencyIndicatorWithCell:cell];
    
    
    if (self.editing)
    {
        
        UILabel *label = (UILabel *)[cell viewWithTag:TableViewCellBaseItemTagUserView];
        
        
        [label setTextAlignment:NSTextAlignmentRight];
        
        
        [label setTextColor:[UIColor blackColor]];
        
        CGRect rect = label.frame;
        rect.origin.x = CGRectGetWidth(self.view.bounds) - kDefaultCellParameterRightMagin - rect.size.width;
        [label setFrame:rect];
        label.alpha = 1;
        
        UIView *indicatorView = [cell viewWithTag:TableViewCellBaseItemTagIndicator];
        indicatorView.alpha = 1;
    }
    
    return cell;
}

#pragma mark 出生日期cell
- (UITableViewCell *)setupDateOfBirthCellWithLabelText:(NSString *)labelText
{
    
    static NSString *identifier = @"DateOfBirthCell";
    UITableViewCell *cell = [self.mainTableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell)
    {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        
        UILabel *label = [[UILabel alloc] init];
        [label setTag:TableViewCellBaseItemTagUserView];
        [label setFont:[UIFont systemFontOfSize:kDefaultFontSize]];
        label.numberOfLines = 1;
        [label setTextAlignment:NSTextAlignmentLeft];
        [cell addSubview:label];
        
        
        UIImageView *indicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"005"]];
        [indicator setTag:TableViewCellBaseItemTagIndicator];
        indicator.alpha = 0;
        [cell addSubview:indicator];
    }
    
    
    [self setupDefaulCell:cell labelText:labelText];
    [self setLucencyIndicatorWithCell:cell];
    
    
    if (self.editing)
    {
        
        UILabel *label = (UILabel *)[cell viewWithTag:TableViewCellBaseItemTagUserView];
        
        
        [label setTextAlignment:NSTextAlignmentRight];
        
        
        [label setTextColor:[UIColor blackColor]];
        
        CGRect rect = label.frame;
        rect.origin.x = CGRectGetWidth(self.view.bounds) - kDefaultCellParameterRightMagin - rect.size.width;
        [label setFrame:rect];
        label.alpha = 1;
        
        UIView *indicatorView = [cell viewWithTag:TableViewCellBaseItemTagIndicator];
        indicatorView.alpha = 1;
    }
    
    return cell;
}

#pragma mark 科室cell
- (UITableViewCell *)setupDepartmentsCellWithLabelText:(NSString *)labelText
{
    static NSString *identifier = @"DepartmentsCell";
    UITableViewCell *cell = [self.mainTableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell)
    {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        UILabel *label = [[UILabel alloc] init];
        [label setTag:TableViewCellBaseItemTagUserView];
        [label setFont:[UIFont systemFontOfSize:kDefaultFontSize]];
        label.numberOfLines = 1;
        [label setTextAlignment:NSTextAlignmentLeft];
        [cell addSubview:label];
        
        
        UIImageView *indicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"005"]];
        [indicator setTag:TableViewCellBaseItemTagIndicator];
        indicator.alpha = 0;
        [cell addSubview:indicator];
    }
    
    [self setupDefaulCell:cell labelText:labelText];
    [self setLucencyIndicatorWithCell:cell];
    
    
    if (self.editing)
    {
        
        UILabel *label = (UILabel *)[cell viewWithTag:TableViewCellBaseItemTagUserView];
        
        
        [label setTextAlignment:NSTextAlignmentRight];
        
        
        [label setTextColor:[UIColor blackColor]];
        
        CGRect rect = label.frame;
        rect.origin.x = CGRectGetWidth(self.view.bounds) - kDefaultCellParameterRightMagin - rect.size.width;
        [label setFrame:rect];
        label.alpha = 1;
        
        UIView *indicatorView = [cell viewWithTag:TableViewCellBaseItemTagIndicator];
        indicatorView.alpha = 1;
    }
    
    return cell;
}



#pragma mark  级别cell
- (UITableViewCell *)setupRankCellWithLabelText:(NSString *)labelText
{
    static NSString *identifier = @"RankCell";
    UITableViewCell *cell = [self.mainTableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell)
    {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
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
    
    return cell;
}


#pragma mark  ID cell
- (UITableViewCell *)setupIDCellWithLabelText:(NSString *)labelText
{
    static NSString *identifier = @"IDCell";
    UITableViewCell *cell = [self.mainTableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell)
    {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
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
    
    return cell;
}

#pragma mark  擅长领域cell
- (UITableViewCell *)setupTerritoryCellWithLabelText:(NSString *)labelText
{
    static NSString *identifier = @"TerritoryCell";
    UITableViewCell *cell = [self.mainTableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell)
    {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UITextView *textView = [[UITextView alloc] init];
        textView.delegate = self;
        [textView setFont:[UIFont systemFontOfSize:kDefaultFontSize]];
        [textView setTag:TableViewCellBaseItemTagUserView];
        [textView setText:labelText];
        [cell addSubview:textView];
        
        self.activeView = textView;
    }
    
    UITextView *textView = (UITextView *)[cell viewWithTag:TableViewCellBaseItemTagUserView];
    
    territoryTextViewSize = [self sizeWithString:territoryString
                                            font:[UIFont systemFontOfSize:kDefaultFontSize]
                                         maxSize:CGSizeMake(CGRectGetWidth(self.view.bounds) - kDefaultCellParameterLeftMagin - kDefaultCellParameterRightMagin/2, 0)];
    
    [textView setFrame:CGRectMake(kDefaultCellParameterLeftMagin,
                                  kTerritoryCellTextViewMagin,
                                  territoryTextViewSize.width,
                                  territoryTextViewSize.height + 10)];
    if (self.editing)
    {
        
        
        textView.textColor = [UIColor blackColor];
        textView.userInteractionEnabled = YES;
    }
    else
    {
        [textView setTextColor:[UIColor lightGrayColor]];
        textView.userInteractionEnabled = NO;
    }
    
    
    return cell;
}


#pragma mark 设置默认cell的label
- (void)setupDefaulCell:(UITableViewCell *)cell labelText:(NSString *)labelText
{
    UILabel *label = (UILabel *)[cell viewWithTag:TableViewCellBaseItemTagUserView];
    [label setText:labelText];
    [label setTextColor:[UIColor lightGrayColor]];
    [label setTextAlignment:NSTextAlignmentLeft];
    
    CGSize size = [self sizeWithString:label.text
                                  font:label.font
                               maxSize:CGSizeMake(CGRectGetWidth(self.view.bounds)/2, kCellHeight)];
    
    
    [label setFrame:CGRectMake(kDefaultCellParameterLeftMagin,
                               (kCellHeight - size.height)/2,
                               CGRectGetWidth(self.view.bounds)/2,
                               size.height)];
}


#pragma mark - 设置标题label
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

#pragma mark - 设置透明指示器
- (void)setLucencyIndicatorWithCell:(UITableViewCell *)cell
{
    
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:TableViewCellBaseItemTagIndicator];
    [imageView setFrame:CGRectMake(CGRectGetWidth(self.view.bounds) - kDefaultCellParameterRightMagin + (kDefaultCellParameterRightMagin - kLucencyIndicatorLengthOfSize)/2,
                                   (kCellHeight - kLucencyIndicatorLengthOfSize)/2,
                                   kLucencyIndicatorLengthOfSize,
                                   kLucencyIndicatorLengthOfSize)];
    [imageView setAlpha:0];
}



#pragma mark - Cell点击事件

#pragma mark 提交审批
- (void)selectUploadRequestCellEvent
{
    
    hud = [[MBProgressHUD alloc] init];
    [self.view addSubview:hud];
    
    [hud showAnimated:YES whileExecutingBlock:^{
        sleep(2);
        
        hud.mode = MBProgressHUDModeText;
        hud.labelText = NSLocalizedString(@"Has been submitted successfully, please wait patiently for a review", nil);
        sleep(1);
        
    } completionBlock:^{
        isChecking = YES;
        self.editing = NO;
        [self.mainTableView reloadData];
        
    }];
}



#pragma mark 真实姓名
- (void)selectActualNameCellEvent
{
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    [hud setMode:MBProgressHUDModeCustomView];
    [hud setCustomView:self.genderPicker];
    
    [hud show:YES];
}

- (IBAction)selectGender:(UIButton *)sender
{
    
    UITableViewCell *cell = [self.mainTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:TableViewCellRowGender
                                                                                         inSection:0]];
    UILabel *genderLabel = (UILabel *)[cell viewWithTag:TableViewCellBaseItemTagUserView];
    [genderLabel setText:sender.currentTitle];
    [hud hide:YES];
}

#pragma mark 出生日期
- (void)selectDateOfBirthCellEvent
{
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    [hud setMode:MBProgressHUDModeCustomView];
    hud.customView = self.datePicker;
    [hud show:YES];
}

- (IBAction)selectDate:(UIDatePicker *)sender
{
    
    NSDate *date = [sender date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    
    UITableViewCell *cell = [self.mainTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:TableViewCellRowDateOfBirth
                                                                                         inSection:0]];
    UILabel *dateLabel = (UILabel *)[cell viewWithTag:TableViewCellBaseItemTagUserView];
    [dateLabel setText:dateString];
    
    [hud hide:YES];
}


#pragma mark 科室事件
- (void)selectDepartmentsCellEvent
{
    
    hud = [[MBProgressHUD alloc] init];
    [self.view addSubview:hud];
    
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = self.departmentsContentView;
    [hud show:YES];
}




#pragma mark - 编辑按钮事件
- (IBAction)editButtonEvent:(id)sender
{
    
    if (!isChecking)
    {
        
        self.editing = YES;
    }
}



- (void)setEditing:(BOOL)editing
{
    
    if (_editing != editing)
    {
        _editing = editing;
        
        if (_editing)
        {
            
            [self editingStateAnimation];
            
            [self registerForKeyboardNotification:@selector(keyBoardWillShow:) :@selector(keyBoardWillHide:)];
            
            [self insertUploadRequestCell];
            
            UITableViewCell *cell = [self.mainTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:TableViewCellRowActualName
                                                                                                 inSection:0]];
            UITextField *textField = (UITextField *)[cell viewWithTag:TableViewCellBaseItemTagUserView];
            textField.userInteractionEnabled = YES;
            
            
            cell = [self.mainTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:TableViewCellRowTerritory
                                                                                inSection:0]];
            UITextView *textView = (UITextView *)[cell viewWithTag:TableViewCellBaseItemTagUserView];
            textView.userInteractionEnabled = YES;
        }
    }
}



#pragma mark - 插入提交审批按钮
- (void)insertUploadRequestCell
{
    [self.mainTableView beginUpdates];
    [self.mainTableView insertSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.mainTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.mainTableView endUpdates];
}

#pragma mark - 编辑状态动画
- (void)editingStateAnimation
{
    
    for (int i=0; i < kRowCount; i++)
    {
        
        switch (i)
        {
            case TableViewCellRowUserImage:   [self normalCellAnimationBegin:i];      break;
            case TableViewCellRowGender:      [self normalCellAnimationBegin:i];      break;
            case TableViewCellRowDateOfBirth: [self normalCellAnimationBegin:i];      break;
            case TableViewCellRowDepartments: [self normalCellAnimationBegin:i];      break;
            case TableViewCellRowTerritory:   [self territoryCellAnimationBegin];     break;
            case TableViewCellRowActualName:  [self actualNameCellAnimationBegin];    break;
            case TableViewCellRowRank:        break;
            case TableViewCellRowID:          break;
            default:    break;
        }
    }
}


- (void)normalCellAnimationBegin:(NSInteger)row
{
    
    UITableViewCell *cell = [self.mainTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
    UIView *userView = [cell viewWithTag:TableViewCellBaseItemTagUserView];
    
    //用户的资料view改变状态
    if ([userView isKindOfClass:[UILabel class]])
    {
        
        UILabel *label = (UILabel *)userView;
        
        [UIView animateWithDuration:kAnimationDurantion/2 animations:^{
            
            //label隐藏
            CGRect rect = label.frame;
            rect.origin.x = CGRectGetWidth(self.view.bounds)/2;
            [label setFrame:rect];
            
            label.alpha = 0;
        } completion:^(BOOL finished) {
            [label setTextAlignment:NSTextAlignmentRight];
            
            [UIView animateWithDuration:kAnimationDurantion/2 animations:^{
                
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
    [UIView animateWithDuration:kAnimationDurantion/2 animations:^{
        indicatorView.alpha = 1;
        
    }];
    
}

- (void)actualNameCellAnimationBegin
{
    
    UITableViewCell *cell = [self.mainTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:TableViewCellRowActualName inSection:0]];
    UIView *userView = [cell viewWithTag:TableViewCellBaseItemTagUserView];
    
    if ([userView isKindOfClass:[UITextField class]])
    {
        UITextField *userNameTextField = (UITextField *)userView;
        
        
        UIImageView *textViewBottomView = (UIImageView *)[cell viewWithTag:TableViewCellBaseItemTagSecondView];
        [textViewBottomView setImage:[UIImage imageNamed:@"003"]];
        textViewBottomView.alpha = 0;
        NSLog(@"%@",textViewBottomView);
        
        
        [UIView animateWithDuration:kAnimationDurantion/2 animations:^{
            
            userNameTextField.alpha = 0;
        } completion:^(BOOL finished) {
            
            [userNameTextField setTextColor:[UIColor blackColor]];
            
            [UIView animateWithDuration:kAnimationDurantion animations:^{
                textViewBottomView.alpha = 1;
                userNameTextField.alpha = 1;
            }];
        }];
        
        
    }
}

- (void)territoryCellAnimationBegin
{
    
    UITableViewCell *cell = [self.mainTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:TableViewCellRowTerritory inSection:0]];
    UITextView *userView = (UITextView *)[cell viewWithTag:TableViewCellBaseItemTagUserView];
    
    
    [UIView animateWithDuration:kAnimationDurantion/2 animations:^{
        userView.alpha = 0;
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:kAnimationDurantion/2 animations:^{
            
            userView.textColor = [UIColor blackColor];
            userView.alpha = 1;
        }];
    }];
    
    
    
//    if ([userView isKindOfClass:[UITextView class]])
//    {
//        UITextView *textView = (UITextView *)userView;
//        
//        
//        
//        UIGraphicsBeginImageContext(cell.frame.size);
//        UIBezierPath *path = [UIBezierPath bezierPath];
//        
//        path.lineWidth = 1.0;
//        
//        CAShapeLayer *layer = [CAShapeLayer layer];
//        layer.lineWidth = 1.0;
//        layer.strokeColor = [[UIColor lightGrayColor] CGColor];
//        
//        [cell.layer addSublayer:layer];
//        
//        
//        CGPoint upleftPoint  = CGPointMake(textView.frame.origin.x, textView.frame.origin.y);
//        
//        CGPoint upRightPoint = CGPointMake(textView.frame.origin.x + textView.frame.size.width,
//                                           textView.frame.origin.y);
//        
//        CGPoint bottomLeftPoint = CGPointMake(textView.frame.origin.x,
//                                              textView.frame.origin.y + textView.frame.size.height);
//        
//        CGPoint bottomRightPoint = CGPointMake(textView.frame.origin.x + textView.frame.size.width,
//                                               textView.frame.origin.y + textView.frame.size.height);
//        
//        
//        [path moveToPoint:upleftPoint];
//        
//        [path addLineToPoint:upRightPoint];
//        
//        [path moveToPoint:upRightPoint];
//        
//        [path addLineToPoint:bottomRightPoint];
//        
//        [path moveToPoint:bottomRightPoint];
//        
//        [path addLineToPoint:bottomLeftPoint];
//        
//        [path moveToPoint:bottomLeftPoint];
//        
//        [path addLineToPoint:upleftPoint];
//        
//        
//        layer.path = path.CGPath;
//        
//        
//        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//        animation.duration = 1;
//        animation.fromValue = @(0);
//        animation.toValue = @(1);
//        
//        [layer addAnimation:animation forKey:@"strokeEndAnimation"];
//        
//        UIGraphicsEndImageContext();
//    }
}

#pragma mark - 获取标题
- (NSString *)titleWithIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.row)
    {
            
        case 0:
            return NSLocalizedString(@"Head portrait", nil);
            break;
        case 1:
            return NSLocalizedString(@"Real name", nil);
            break;
        case 2:
            return NSLocalizedString(@"Sex", nil);
            break;
        case 3:
            return NSLocalizedString(@"Date of birth", nil);
            break;
        case 4:
            return NSLocalizedString(@"Level", nil);
            break;
        case 5:
            return NSLocalizedString(@"Department", nil);
            break;
        case 6:
            return NSLocalizedString(@"ID", nil);
            break;
        default:
            return NSLocalizedString(@"Skilled territory", nil);
            break;
    }
}


#pragma mark  -  根据string计算label大小
- (CGSize)sizeWithString:(NSString*)string font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attribute = @{NSFontAttributeName: font};
    
    CGSize textSize = [string boundingRectWithSize:maxSize
                                           options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                        attributes:attribute
                                           context:nil].size;
    return textSize;
}


@end
