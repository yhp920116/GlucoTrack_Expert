//
//  MessageInfoViewController.m
//  SugarNursing
//
//  Created by Ian on 14-12-24.
//  Copyright (c) 2014年 Tisson. All rights reserved.
//

#import "MessageInfoViewController.h"
#import "MsgInfo_Cell.h"
#import "UtilsMacro.h"
#import <MBProgressHUD.h>
#import <SSPullToRefresh.h>
#import "NoDataLabel.h"

static NSString *identifier = @"MsgInfo_Cell";

static CGFloat kEstimatedCellHeight = 150;
static NSString *loadSize = @"15";

@interface MessageInfoViewController ()<NSFetchedResultsControllerDelegate,SSPullToRefreshViewDelegate>
{
    MBProgressHUD *hud;
    NSArray *_serverData;
}

@property (strong, nonatomic) NSFetchedResultsController *fetchController;
@property (strong, nonatomic) SSPullToRefreshView *refreshView;

@property (assign, nonatomic) BOOL isAll;
@property (assign, nonatomic) BOOL loading;



@end

@implementation MessageInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.isAll = YES;
    self.refreshView = [[SSPullToRefreshView alloc] initWithScrollView:self.myTableView delegate:self];
    
    [self configureFetchController];
    [self.myTableView reloadData];
    [self configureTableViewFooterView];
    
    
//    [self.refreshView startLoadingAndExpand:YES animated:YES];
}



- (void)configureFetchController
{
    if (self.msgType == MsgTypeNotice)
    {
        self.fetchController = [Notice fetchAllGroupedBy:nil sortedBy:@"sendTime" ascending:NO withPredicate:nil delegate:self incontext:[CoreDataStack sharedCoreDataStack].context];
    }
    else if (self.msgType == MsgTypeBulletin)
    {
        self.fetchController = [Bulletin fetchAllGroupedBy:nil sortedBy:@"sendTime" ascending:NO withPredicate:nil delegate:self incontext:[CoreDataStack sharedCoreDataStack].context];
    }
    else
    {
        self.fetchController = [AgentMsg fetchAllGroupedBy:nil sortedBy:@"sendTime" ascending:NO withPredicate:nil delegate:self incontext:[CoreDataStack sharedCoreDataStack].context];
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.myTableView reloadData];
}

- (void)pullToRefreshViewDidStartLoading:(SSPullToRefreshView *)view
{
    [self requestMsgListWithIsRefresh:YES];
}

- (void)requestMsgListWithIsRefresh:(BOOL)isRefresh
{
    
    self.loading = YES;
    
    if (self.msgType == MsgTypeNotice)
    {
        
        
        NSDictionary *parameters = @{@"method":@"getNoticeList",
                                     @"sessionToken":[NSString sessionToken],
                                     @"sign":@"sign",
                                     @"sessionId":[NSString sessionID],
                                     @"recvUser":[NSString exptId],
                                     @"messageType":@"personalAppr",
                                     @"size":loadSize,
                                     @"start":isRefresh ? @"1" : [NSString stringWithFormat:@"%ld",(unsigned long)self.fetchController.fetchedObjects.count]};
        
        NSURLSessionDataTask *task = [GCRequest getNoticeListWithParameters:parameters block:^(NSDictionary *responseData, NSError *error) {
            
            self.loading = NO;
            
            if (!error)
            {
                
                NSString *ret_code = responseData[@"ret_code"];
                if ([ret_code isEqualToString:@"0"])
                {
                    
                    NSInteger listSize = [responseData[@"noticeListSize"] integerValue];
                    if (listSize < [loadSize integerValue])
                    {
                        self.isAll = YES;
                    }
                    else
                    {
                        self.isAll = NO;
                    }
                    
                    
                    if (listSize <=0)
                    {
                        
                    }
                    else
                    {
                        
                        NSArray *notices = responseData[@"noticeList"];
                        
                        [Notice updateCoreDataWithListArray:notices identifierKey:@"noticeId"];
                        
                        [[CoreDataStack sharedCoreDataStack] saveContext];
                    }
                    
                    [self configureFetchController];
                    [self configureTableViewFooterView];
                    [self.myTableView reloadData];
                    
                    
                }
                else
                {
                    hud = [[MBProgressHUD alloc] initWithView:self.view];
                    [self.view addSubview:hud];
                    hud.mode = MBProgressHUDModeText;
                    hud.labelText = [NSString localizedMsgFromRet_code:ret_code withHUD:YES];
                    [hud show:YES];
                    [hud hide:YES afterDelay:HUD_TIME_DELAY];
                }
            }
            else
            {
                [hud hide:YES];
            }
            if (self.refreshView)
            {
                [self.refreshView finishLoading];
            }
        }];
        
        [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:self];
    }
    else if (self.msgType == MsgTypeBulletin)
    {
        
        
        UserInfo *info = [UserInfo findAllInContext:[CoreDataStack sharedCoreDataStack].context][0];
        
        NSDictionary *parameters = @{@"method":@"getBulletinList",
                                     @"sign":@"sign",
                                     @"sessionId":[NSString sessionID],
                                     @"centerId":info.centerId,
                                     @"groupId":@"3",
                                     @"size":loadSize,
                                     @"start":isRefresh ? @"1" : [NSString stringWithFormat:@"%ld",(unsigned long)self.fetchController.fetchedObjects.count]
                                     };
        
        NSURLSessionDataTask *task = [GCRequest getBulletinListWithParameters:parameters block:^(NSDictionary *responseData, NSError *error) {
            
            self.loading = NO;
            
            if (!error)
            {
                NSString *ret_code = responseData[@"ret_code"];
                if ([ret_code isEqualToString:@"0"])
                {
                    
                    NSInteger listSize = [responseData[@"bulletinListSize"] integerValue];
                    
                    if (listSize < [loadSize integerValue])
                    {
                        self.isAll = YES;
                    }
                    else
                    {
                        self.isAll = NO;
                    }
                    
                    if (listSize <=0)
                    {
                        
                    }
                    else
                    {
                        
                        NSArray *bulletinArray = responseData[@"bulletinList"];
                        [Bulletin updateCoreDataWithListArray:bulletinArray identifierKey:@"bulletinId"];
                        
                        [[CoreDataStack sharedCoreDataStack] saveContext];
                    }
                    
                    [self configureFetchController];
                    [self configureTableViewFooterView];
                    [self.myTableView reloadData];
                    
                    [hud hide:YES];
                }
                else
                {
                    hud.mode = MBProgressHUDModeText;
                    hud.labelText = [NSString localizedMsgFromRet_code:ret_code withHUD:YES];
                    [hud hide:YES afterDelay:1.2];
                }
            }
            else
            {
                [hud hide:YES];
            }
            
            
            if (self.refreshView)
            {
                [self.refreshView finishLoading];
            }
        }];
        
        
        [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:self];
    }
    else if (self.msgType == MsgTypeAgent)
    {
        
        NSDictionary *parameters = @{@"method":@"getNoticeList",
                                     @"sessionToken":[NSString sessionToken],
                                     @"sign":@"sign",
                                     @"sessionId":[NSString sessionID],
                                     @"recvUser":[NSString exptId],
                                     @"messageType":@"agentMsg",
                                     @"size":loadSize,
                                     @"start":isRefresh ? @"1" : [NSString stringWithFormat:@"%ld",(unsigned long)self.fetchController.fetchedObjects.count]};
        
        NSURLSessionDataTask *task = [GCRequest getNoticeListWithParameters:parameters block:^(NSDictionary *responseData, NSError *error) {
            
            self.loading = NO;
            
            if (!error)
            {
                
                NSString *ret_code = responseData[@"ret_code"];
                if ([ret_code isEqualToString:@"0"])
                {
                    
                    NSInteger listSize = [responseData[@"noticeListSize"] integerValue];
                    if (listSize < [loadSize integerValue])
                    {
                        self.isAll = YES;
                    }
                    else
                    {
                        self.isAll = NO;
                    }
                    
                    
                    if (listSize <=0)
                    {
                        
                    }
                    else
                    {
                        
                        NSArray *notices = responseData[@"noticeList"];
                        
                        [AgentMsg updateCoreDataWithListArray:notices identifierKey:@"noticeId"];
                        
                        [[CoreDataStack sharedCoreDataStack] saveContext];
                        
                        [self configureFetchController];
                        [self configureTableViewFooterView];
                        [self.myTableView reloadData];
                    }
                    
                }
                else
                {
                    hud = [[MBProgressHUD alloc] initWithView:self.view];
                    [self.view addSubview:hud];
                    hud.mode = MBProgressHUDModeText;
                    hud.labelText = [NSString localizedMsgFromRet_code:ret_code withHUD:YES];
                    [hud show:YES];
                    [hud hide:YES afterDelay:HUD_TIME_DELAY];
                }
            }
            else
            {
                hud.mode = MBProgressHUDModeText;
                hud.labelText = [NSString localizedMsgFromRet_code:responseData[@"ret_code"] withHUD:YES];
                [hud hide:YES afterDelay:HUD_TIME_DELAY];
            }
            
            if (self.refreshView)
            {
                [self.refreshView finishLoading];
            }
        }];
        
        [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:self];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.fetchController.fetchedObjects.count;
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
    
    [self configureCell:cell indexPath:indexPath];
    
    return [self calculateCellHeight:cell];
}

- (CGFloat)calculateCellHeight:(UITableViewCell *)cell
{
    
    
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    return size.height;
}

- (void)configureCell:(MsgInfo_Cell *)cell indexPath:(NSIndexPath *)indexPath
{
    if (self.msgType == MsgTypeNotice)
    {
        
        Notice *notice = self.fetchController.fetchedObjects[indexPath.row];
        
        [cell.contentLabel setText:notice.content];
        
        
        NSString *dayString = [NSString dateFormattingByBeforeFormat:GC_FORMATTER_SECOND toFormat:GC_FORMATTER_DAY string:notice.sendTime];
        NSString *nearDayString = [NSString compareNearDate:[NSDate dateByString:dayString dateFormat:GC_FORMATTER_DAY]];
        NSString *timeString = [NSString dateFormattingByBeforeFormat:GC_FORMATTER_SECOND toFormat:@"HH:mm" string:notice.sendTime];
        
        NSString *msgDateString = [NSString stringWithFormat:@"%@ %@",nearDayString,timeString];
        [cell.dateLabel setText:msgDateString];
    }
    else if (self.msgType == MsgTypeBulletin)
    {
        
        Bulletin *bulletin = self.fetchController.fetchedObjects[indexPath.row];
        
        
        [cell.contentLabel setText:bulletin.content];
        
        
        NSString *dayString = [NSString dateFormattingByBeforeFormat:GC_FORMATTER_SECOND toFormat:GC_FORMATTER_DAY string:bulletin.sendTime];
        NSString *nearDayString = [NSString compareNearDate:[NSDate dateByString:dayString dateFormat:GC_FORMATTER_DAY]];
        
        
        NSString *timeString = [NSString dateFormattingByBeforeFormat:GC_FORMATTER_SECOND toFormat:@"HH:mm" string:bulletin.sendTime];
        
        NSString *msgDateString = [NSString stringWithFormat:@"%@ %@",nearDayString,timeString];
        [cell.dateLabel setText:msgDateString];
    }
    else
    {
        
        AgentMsg *notice = self.fetchController.fetchedObjects[indexPath.row];
        
        [cell.contentLabel setText:notice.content];
        
        
        NSString *dayString = [NSString dateFormattingByBeforeFormat:GC_FORMATTER_SECOND toFormat:GC_FORMATTER_DAY string:notice.sendTime];
        NSString *nearDayString = [NSString compareNearDate:[NSDate dateByString:dayString dateFormat:GC_FORMATTER_DAY]];
        NSString *timeString = [NSString dateFormattingByBeforeFormat:GC_FORMATTER_SECOND toFormat:@"HH:mm" string:notice.sendTime];
        
        NSString *msgDateString = [NSString stringWithFormat:@"%@ %@",nearDayString,timeString];
        [cell.dateLabel setText:msgDateString];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MsgInfo_Cell *cell = (MsgInfo_Cell *)[self.myTableView dequeueReusableCellWithIdentifier:identifier];
    [self configureCell:cell indexPath:indexPath];
    return cell;
}


- (void)configureTableViewFooterView
{
    if (self.fetchController.fetchedObjects.count > 0)
    {
        self.myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    else
    {
        NoDataLabel *label = [[NoDataLabel alloc] initWithFrame:self.myTableView.bounds];
        label.text = (self.msgType == MsgTypeNotice ?
                      NSLocalizedString(@"have not approve result", nil) : NSLocalizedString(@"have not system bulletin", nil));
        self.myTableView.tableFooterView = label;
    }
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    if (scrollView.contentOffset.y > scrollView.contentSize.height - CGRectGetHeight(scrollView.bounds))
    {
        if (!self.isAll && !self.loading)
        {
            [self requestMsgListWithIsRefresh:NO];
        }
    }
}


@end
