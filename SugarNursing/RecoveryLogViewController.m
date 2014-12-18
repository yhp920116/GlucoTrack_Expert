//
//  RecoveryLogViewController.m
//  SugarNursing
//
//  Created by Ian on 14-11-26.
//  Copyright (c) 2014年 Tisson. All rights reserved.
//

#import "RecoveryLogViewController.h"
#import <MBProgressHUD.h>


static NSString *recoveryCellIdentifier = @"RecoveryLogCell";


typedef enum{
    RecoveryCellItemTagDateLabel = 96834,
    RecoveryCellItemTagTitleLabel,
    RecoveryCellItemTagDetailLabel
}RecoveryCellItemTag;

@interface RecoveryLogViewController ()
{
    MBProgressHUD *hud;
    
    NSArray *_serverArray;
}

@end

@implementation RecoveryLogViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    NSArray *data = @[
                      @{@"date":@"15:00",@"title":@"血糖",@"content":@[@"11.1mmol/L 乏力、恶心"]},
                      @{@"date":@"15:15",@"title":@"糖化血红蛋白",@"content":@[@"9%"]},
                      @{@"date":@"15:47",@"title":@"运动",@"content":@[@"跑步 69分钟 消耗655大卡"]},
                      @{@"date":@"18:30",@"title":@"晚餐",@"content":@[@"共摄入266大卡",@"主食 米饭 100克 116大卡",@"黄瓜炒蛋 200克 150大卡"]},
                      @{@"date":@"21:30",@"title":@"服药",@"content":@[@"降糖药 格列齐特 不服药/口服 80毫克"]}
                      ];
    _serverArray = [NSArray arrayWithArray:data];
    
    self.myTableView.tableFooterView = nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _serverArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSArray *contentArray = [[_serverArray objectAtIndex:indexPath.row] objectForKey:@"content"];
    return contentArray.count * 18 + 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:recoveryCellIdentifier];
    
    if (!cell)
    {
        cell = [self configureRecoveryLogCell];
    }
    
    [self setupRecoveryCell:cell indexPath:indexPath];
    
    return cell;
}


- (UITableViewCell *)configureRecoveryLogCell
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:recoveryCellIdentifier];
    
    UILabel *dateLabel = [[UILabel alloc] init];
    [dateLabel setFrame:CGRectMake(10,
                                   2,
                                   50,
                                   40)];
    [dateLabel setFont:[UIFont systemFontOfSize:14]];
    [dateLabel setTag:RecoveryCellItemTagDateLabel];
    [cell addSubview:dateLabel];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFrame:CGRectMake(dateLabel.frame.origin.x + dateLabel.frame.size.width + 5,
                                  dateLabel.frame.origin.y,
                                  80,
                                  40)];
    [titleLabel setFont:[UIFont systemFontOfSize:14]];
    [titleLabel setTag:RecoveryCellItemTagTitleLabel];
    [cell addSubview:titleLabel];
    
    
    UILabel *detailLabel = [[UILabel alloc] init];
    [detailLabel setTag:RecoveryCellItemTagDetailLabel];
    [detailLabel setFont:[UIFont systemFontOfSize:13]];
    [cell addSubview:detailLabel];
    
    return cell;
}


- (void)setupRecoveryCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dataDic = _serverArray[indexPath.row];
    
    UILabel *dateLabel = (UILabel *)[cell viewWithTag:RecoveryCellItemTagDateLabel];
    dateLabel.text = [dataDic objectForKey:@"date"];
    
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:RecoveryCellItemTagTitleLabel];
    titleLabel.text = [dataDic objectForKey:@"title"];
    
    NSArray *contentArray = [dataDic objectForKey:@"content"];
    UILabel *detailLabel = (UILabel *)[cell viewWithTag:RecoveryCellItemTagDetailLabel];
    detailLabel.numberOfLines = contentArray.count;
    detailLabel.text = [contentArray componentsJoinedByString:@"\n"];
    
    CGFloat maxLength = CGRectGetWidth(self.view.bounds) - titleLabel.frame.origin.x - titleLabel.frame.size.width -20;
    
    [detailLabel setFrame:CGRectMake(titleLabel.frame.origin.x + titleLabel.frame.size.width +10,
                                    titleLabel.frame.origin.y + 10,
                                    maxLength,
                                    contentArray.count * 18)];
}

- (IBAction)selectDateButtonEvent:(id)sender
{
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = self.datePicker;
    [self.view addSubview:hud];
    
    [hud show:YES];
}

- (IBAction)datePickerValueChanged:(id)sender
{
    
    [hud hide:YES];
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
