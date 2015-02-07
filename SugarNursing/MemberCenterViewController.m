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
#import "CustomLabel.h"
#import "ThumbnailImageView.h"
#import "UtilsMacro.h"

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
{
    UserInfo *_info;
}



@end

@implementation MemberCenterViewController
@synthesize mainTableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    _info = [UserInfo shareInfo];
    [self.mainTableView reloadData];
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
        case 1:
            return 3;
            break;
        default:
            return 1;
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 15;
    }
    
    else return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0)
    {
        return kUserInfoCellHeight;
    }
    else if (indexPath.section == 1)
    {
        return kDefaultCellHeight;
    }
    else
    {
        return kLogoutCellHeight;
    }
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
            
            if (indexPath.row == 0)
            {
                [self performSegueWithIdentifier:@"goAboutMe" sender:nil];
            }
            else if (indexPath.row == 1)
            {
                [self performSegueWithIdentifier:@"goTermsOfService" sender:nil];
            }
            else
            {
                [self performSegueWithIdentifier:@"goFeedBack" sender:nil];
            }
            break;
        case 2:
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
        
        
        CustomLabel *usernameLabel = (CustomLabel *)[cell viewWithTag:UserInfoCellItemTagUsernameLabel];
        ThumbnailImageView *imageView = (ThumbnailImageView *)[cell viewWithTag:UserInfoCellItemTagUserImageView];
        CustomLabel *rankLabel = (CustomLabel *)[cell viewWithTag:UserInfoCellItemTagRankLabel];
        CustomLabel *majorLabel = (CustomLabel *)[cell viewWithTag:UserInfoCellItemTagMajorLabe];
        if (_info.headimageUrl && _info.headimageUrl.length>0)
        {
            [imageView setImageWithURL:[NSURL URLWithString:_info.headimageUrl] placeholderImage:nil];
        }
        else
        {
            [imageView setImage:[UIImage imageNamed:@"thumbDefault"]];
        }
        
        [usernameLabel setText:_info.exptName];
        [rankLabel setText:_info.expertLevel];
        [majorLabel setText:[Department getDepartmentNameByID:_info.departmentId]];
        CGSize size = [self sizeWithString:majorLabel.text
                                      font:majorLabel.font
                                   maxSize:CGSizeMake(CGRectGetWidth(self.view.bounds)/2.5, 20)];
        
        [majorLabel setFrame:CGRectMake(usernameLabel.frame.origin.x,
                                        usernameLabel.frame.origin.y + usernameLabel.frame.size.height + kUserInfoViewMagin/2,
                                        size.width,
                                        size.height)];
        
        
        [rankLabel setFrame:CGRectMake(majorLabel.frame.origin.x + majorLabel.bounds.size.width + kUserInfoViewMagin/2,
                                       majorLabel.frame.origin.y,
                                       CGRectGetWidth(self.view.bounds)/3,
                                       majorLabel.bounds.size.height)];

        
        
        
        return cell;
    }
    else if (indexPath.section == 1)
    {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DefaultCell"];
        
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:@"DefaultCell"];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            
            NSString *title = [self titleWithIndexPath:indexPath];
            [cell.textLabel setText:title];
            NSInteger fontSize = [[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_FONTSIZE"] integerValue];
            cell.textLabel.font = [UIFont systemFontOfSize:fontSize];
        }
        
        
        return cell;

    }
    else
    {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                       reuseIdentifier:@"LogoutCell"];
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        NSInteger fontSize = [[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_FONTSIZE"] integerValue];
        cell.textLabel.font = [UIFont systemFontOfSize:fontSize];
        cell.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:128.0/255.0 blue:0.0/255.0 alpha:1];
        cell.textLabel.text = NSLocalizedString(@"Log out", nil);
        
        
        return cell;
    }
}



- (NSString *)titleWithIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.row)
    {
        case 0:
            return NSLocalizedString(@"About app", nil);
            break;
        case 1:
            return NSLocalizedString(@"Terms of service", nil);
            break;
        default:
            return NSLocalizedString(@"Advice feed back", nil);
            break;
    }
    
}



- (void)setupUserInfoCell:(UITableViewCell *)cell
{
    //用户头像
    ThumbnailImageView *imageView = [[ThumbnailImageView alloc] initWithFrame:CGRectMake(kUserInfoCellMaginLeft,
                                                                                         (kUserInfoCellHeight - kUserInfoCellImageHeightWidth)/2,
                                                                                         kUserInfoCellImageHeightWidth,
                                                                                         kUserInfoCellImageHeightWidth)];
    [imageView setTag:UserInfoCellItemTagUserImageView];
    [cell addSubview:imageView];
    
    
    //用户名称
    CustomLabel *usernameLabel = [[CustomLabel alloc] init];
    [usernameLabel setFrame:CGRectMake(imageView.frame.origin.x + CGRectGetWidth(imageView.frame) + kUserInfoViewMagin,
                                      imageView.frame.origin.y + kUserInfoViewMagin/2,
                                      CGRectGetWidth(self.view.bounds)/1.5,
                                       CGRectGetWidth(imageView.bounds)/3)];
    
    [usernameLabel setTag:UserInfoCellItemTagUsernameLabel];
    [cell addSubview:usernameLabel];
    
    
    //专业
    CustomLabel *majorLabel = [[CustomLabel alloc] init];
    [majorLabel setNumberOfLines:1];
    [majorLabel setTag:UserInfoCellItemTagMajorLabe];
    [cell addSubview:majorLabel];
    
    
    //级别
    CustomLabel *rankLabel = [[CustomLabel alloc] init];
    [rankLabel setNumberOfLines:1];
    [rankLabel setTag:UserInfoCellItemTagRankLabel];
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
