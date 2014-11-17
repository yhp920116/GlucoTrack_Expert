//
//  ServiceCenterViewController.m
//  SugarNursing
//
//  Created by Ian on 14-11-17.
//  Copyright (c) 2014年 Tisson. All rights reserved.
//

#import "ServiceCenterViewController.h"

static CGFloat kUserInfoCellHeight = 80;
static CGFloat kUserInfoCellMaginLeft = 20;
static CGFloat kUserInfoCellImageHeightWidth = 50;

static CGFloat kUserInfoViewMagin = 10;



static CGFloat kDefaultCellHeight = 60;
static CGFloat kLogoutCellHeight = 45;


typedef enum{
    UserInfoCellUserImageViewTag = 1001,
    UserInfoCellUsernameLabelTag,
    UserInfoCellMajorLabelTag,
    UserInfoCellRankLabelTag
}UserInfoCellViewTag;


@interface ServiceCenterViewController ()

@end

@implementation ServiceCenterViewController
@synthesize mainTableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    
    [self.mainTableView setContentOffset:CGPointMake(0, -10)];
}

- (void)viewDidAppear:(BOOL)animated
{
//    
//    NSLog(@"%f , %f",self.mainTableView.contentSize.width,self.mainTableView.contentSize.height);
//    NSLog(@"%f , %f",self.view.frame.origin.y,self.mainTableView.frame.origin.y);
//    
//    CGSize size = self.mainTableView.contentSize;
//    size.height += 30;
//    
//    [self.mainTableView setContentSize:size];
    
}



#pragma mark ** UITableView Delegate & DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 3;
            break;
        default:
            return 1;
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2)
    {
        return 50;
    }
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0)
    {
        return kUserInfoCellHeight;
    }
    else if (indexPath.section == 3)
    {
        return kLogoutCellHeight;
    }
    else
        return kDefaultCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    switch (indexPath.row) {
//        case <#constant#>:
//            <#statements#>
//            break;
//            
//        default:
//            break;
//    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0)
    {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoCell"];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                           reuseIdentifier:@"UserInfoCell"];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            
            [self setupUserInfoCell:cell];
        }
        
        
        
        return cell;
    }
    else if (indexPath.section == 3)
    {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                       reuseIdentifier:@"LogoutCell"];
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        cell.backgroundColor = [UIColor redColor];
        cell.textLabel.text = @"退出账号";
        
        
        return cell;
    }
    else
    {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DefaultCell"];
        
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:@"DefaultCell"];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            
            NSString *title = [self titleWithIndexPath:indexPath];
            [cell.textLabel setText:title];
        }
        
        if (indexPath.section == 0)
        {
            NSLog(@"%@",cell);
        }
        
        return cell;
    }
}



- (NSString *)titleWithIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 1:
        
            switch (indexPath.row){
                case 0:
                    return @"我的病人";
                    break;
                default:
                    return @"我的消息";
                    break;
            }
            break;
        default:
            switch (indexPath.row) {
                case 0:
                    return @"关于糖博士";
                    break;
                case 1:
                    return @"服务条款";
                default:
                    return @"意见反馈";
                    break;
            }
            break;
    }
}



- (void)setupUserInfoCell:(UITableViewCell *)cell
{
    //用户头像
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"QQ20141106-1"]];
    
    [imageView setFrame:CGRectMake(kUserInfoCellMaginLeft,
                                  (kUserInfoCellHeight - kUserInfoCellImageHeightWidth)/2,
                                  kUserInfoCellImageHeightWidth,
                                   kUserInfoCellImageHeightWidth)];
    [imageView setTag:UserInfoCellUserImageViewTag];
    [cell addSubview:imageView];
    
    
    //用户名称
    UILabel *usernameLabel = [[UILabel alloc] init];
    [usernameLabel setFrame:CGRectMake(imageView.frame.origin.x + CGRectGetWidth(imageView.frame) + kUserInfoViewMagin,
                                      imageView.frame.origin.y + kUserInfoViewMagin/2,
                                      CGRectGetWidth(self.view.bounds)/1.5,
                                       CGRectGetWidth(imageView.bounds)/3)];
    [usernameLabel setText:@"为了方便测试使用了比较长的用户名"];
    [usernameLabel setFont:[UIFont systemFontOfSize:14]];
    [usernameLabel setTag:UserInfoCellUsernameLabelTag];
    [cell addSubview:usernameLabel];
    
    
    //专业
    UILabel *majorLabel = [[UILabel alloc] init];
    [majorLabel setFont:[UIFont systemFontOfSize:14]];
    [majorLabel setText:@"阴阳失调神经失常科"];
    [majorLabel setNumberOfLines:1];
    CGSize size = [self sizeWithString:majorLabel.text
                                  font:majorLabel.font
                               maxSize:CGSizeMake(CGRectGetWidth(self.view.bounds)/2.5, 20)];
    
    NSLog(@"%f, %f",size.width,size.height);
    [majorLabel setFrame:CGRectMake(usernameLabel.frame.origin.x,
                                   usernameLabel.frame.origin.y + usernameLabel.frame.size.height + kUserInfoViewMagin/2,
                                   size.width,
                                    size.height)];
    
    [majorLabel setTag:UserInfoCellMajorLabelTag];
    [cell addSubview:majorLabel];
    
    
    //级别
    UILabel *rankLabel = [[UILabel alloc] init];
    [rankLabel setFont:[UIFont systemFontOfSize:14]];
    [rankLabel setNumberOfLines:1];
    [rankLabel setTag:UserInfoCellRankLabelTag];
    [rankLabel setFrame:CGRectMake(majorLabel.frame.origin.x + majorLabel.bounds.size.width + kUserInfoViewMagin/2,
                                  majorLabel.frame.origin.y,
                                  CGRectGetWidth(self.view.bounds)/3,
                                   majorLabel.bounds.size.height)];
    [rankLabel setText:@"资深高级神级专家"];
    [cell addSubview:rankLabel];
    
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

@end
