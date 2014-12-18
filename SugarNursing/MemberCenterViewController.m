//
//  MemberCenterViewController.m
//  SugarNursing
//
//  Created by Ian on 14-11-17.
//  Copyright (c) 2014年 Tisson. All rights reserved.
//

#import "MemberCenterViewController.h"
#import "AppDelegate+UserLogInOut.h"
#import "UIStoryboard+Storyboards.h"

static CGFloat kUserInfoCellHeight = 80;
static CGFloat kUserInfoCellMaginLeft = 20;
static CGFloat kUserInfoCellImageHeightWidth = 50;

static CGFloat kUserInfoViewMagin = 10;



static CGFloat kDefaultCellHeight = 44;
static CGFloat kLogoutCellHeight = 44;


typedef enum
{
    UserInfoCellItemTagUserImageView = 1001,
    UserInfoCellItemTagUsernameLabel,
    UserInfoCellItemTagMajorLabe,
    UserInfoCellItemTagRankLabel
}UserInfoCellViewTag;


@interface MemberCenterViewController ()

@end

@implementation MemberCenterViewController
@synthesize mainTableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.mainTableView reloadData];
}



#pragma mark ** UITableView Delegate & DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 2;
        default:
            return 1;
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
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
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    switch (indexPath.section)
    {
        case 0:
            [self performSegueWithIdentifier:@"goUserInfo" sender:nil];
            break;
        case 1:
            [self performSegueWithIdentifier:@"goAboutMe" sender:nil];
            break;
        case 2:
            if (indexPath.row == 0)
            {
                [self performSegueWithIdentifier:@"goTermsOfService" sender:nil];
            }
            else
            {
                [self performSegueWithIdentifier:@"goFeedBack" sender:nil];
            }
            break;
        case 3:
            [AppDelegate userLogOut];
        default:
            break;
    }
    
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
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.backgroundColor = [UIColor redColor];
        cell.textLabel.text = NSLocalizedString(@"Log out", nil);
        
        
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
            cell.textLabel.font = [UIFont systemFontOfSize:15];
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
    if (indexPath.section == 1) return NSLocalizedString(@"About app", nil);
    
    
    
    switch (indexPath.row)
    {
        case 0:
            return NSLocalizedString(@"Terms of service", nil);
        default:
            return NSLocalizedString(@"Advice feed back", nil);
            break;
    }
    
}



- (void)setupUserInfoCell:(UITableViewCell *)cell
{
    //用户头像
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"019"]];
    
    
    
    [imageView setFrame:CGRectMake(kUserInfoCellMaginLeft,
                                  (kUserInfoCellHeight - kUserInfoCellImageHeightWidth)/2,
                                  kUserInfoCellImageHeightWidth,
                                   kUserInfoCellImageHeightWidth)];
    [imageView setTag:UserInfoCellItemTagUserImageView];
    [cell addSubview:imageView];
    
    
    //用户名称
    UILabel *usernameLabel = [[UILabel alloc] init];
    [usernameLabel setFrame:CGRectMake(imageView.frame.origin.x + CGRectGetWidth(imageView.frame) + kUserInfoViewMagin,
                                      imageView.frame.origin.y + kUserInfoViewMagin/2,
                                      CGRectGetWidth(self.view.bounds)/1.5,
                                       CGRectGetWidth(imageView.bounds)/3)];
    [usernameLabel setText:@"王医生"];
    [usernameLabel setFont:[UIFont systemFontOfSize:14]];
    [usernameLabel setTag:UserInfoCellItemTagUsernameLabel];
    [cell addSubview:usernameLabel];
    
    
    //专业
    UILabel *majorLabel = [[UILabel alloc] init];
    [majorLabel setFont:[UIFont systemFontOfSize:14]];
    [majorLabel setText:@"神经科"];
    [majorLabel setNumberOfLines:1];
    CGSize size = [self sizeWithString:majorLabel.text
                                  font:majorLabel.font
                               maxSize:CGSizeMake(CGRectGetWidth(self.view.bounds)/2.5, 20)];
    
    [majorLabel setFrame:CGRectMake(usernameLabel.frame.origin.x,
                                   usernameLabel.frame.origin.y + usernameLabel.frame.size.height + kUserInfoViewMagin/2,
                                   size.width,
                                    size.height)];
    
    [majorLabel setTag:UserInfoCellItemTagMajorLabe];
    [cell addSubview:majorLabel];
    
    
    //级别
    UILabel *rankLabel = [[UILabel alloc] init];
    [rankLabel setFont:[UIFont systemFontOfSize:14]];
    [rankLabel setNumberOfLines:1];
    [rankLabel setTag:UserInfoCellItemTagRankLabel];
    [rankLabel setFrame:CGRectMake(majorLabel.frame.origin.x + majorLabel.bounds.size.width + kUserInfoViewMagin/2,
                                  majorLabel.frame.origin.y,
                                  CGRectGetWidth(self.view.bounds)/3,
                                   majorLabel.bounds.size.height)];
    [rankLabel setText:@"专家"];
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
