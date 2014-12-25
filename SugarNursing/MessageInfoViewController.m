//
//  MessageInfoViewController.m
//  SugarNursing
//
//  Created by Ian on 14-12-24.
//  Copyright (c) 2014年 Tisson. All rights reserved.
//

#import "MessageInfoViewController.h"
#import "MsgInfo_Cell.h"

static NSString *identifier = @"MsgInfo_Cell";

static CGFloat kEstimatedCellHeight = 150;

@interface MessageInfoViewController ()
{
    NSArray *_serverData;
}
@end

@implementation MessageInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _serverData = @[@{@"date":@"今天   13:35",@"content":@"    我的公告内容我的公告内容我的公告内容我的公告内容我的公告内容我的公告内容我的公告内容我的公告内容我的公告内容我的公告内容我的公告内容我的公告内容我的公的公告内容我的公告内容我的公告内容我的公告内容我的公告内容我的公告内容我的公告内容我的公告内容我的公告内容我的公告内容我公告内容告内容我的公告内容我的公告内容我的公告内容我的公告内容我的公告内容我的公告内容我的公告内容我的公告内容"},
                    @{@"date":@"今天   13:35",@"content":@"    我的公告内容我的公告内容我的公告内容我的公告内容我的公告内容我的公告内容我的公告内容我的公告内容我的公告内容我的公告内容我公告内容"},
                    @{@"date":@"今天   13:35",@"content":@"    我的公告内容我容"}];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _serverData.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kEstimatedCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self cellHeightWithIndexPath:indexPath];
}

- (CGFloat)cellHeightWithIndexPath:(NSIndexPath *)indexPath
{
    static MsgInfo_Cell *cell = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        cell = [self.myTableView dequeueReusableCellWithIdentifier:identifier];
        
        cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.bounds), kEstimatedCellHeight);
        cell.contentView.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.bounds), kEstimatedCellHeight);
        
        [cell.contentView setNeedsLayout];
        [cell.contentView layoutIfNeeded];
    });
    
    [cell configureCellWithParameter:_serverData[indexPath.row]];
    return [self calculateCellHeight:cell];
}

- (CGFloat)calculateCellHeight:(UITableViewCell *)cell
{
    
    
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    return size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MsgInfo_Cell *cell = (MsgInfo_Cell *)[self.myTableView dequeueReusableCellWithIdentifier:identifier];
    [cell configureCellWithParameter:_serverData[indexPath.row]];
    return cell;
}

@end
