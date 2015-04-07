//
//  MyMessageViewController.m
//  SugarNursing
//
//  Created by Ian on 14-11-25.
//  Copyright (c) 2014年 Tisson. All rights reserved.
//

#import "MyMessageViewController.h"
#import "MyMessageCell.h"
#import "UtilsMacro.h"
#import "MessageInfoViewController.h"
#import "NoDataLabel.h"
#import <MBProgressHUD.h>
#import <SSPullToRefresh.h>
#import "MsgRemind.h"
#import "M13BadgeView.h"
#import "NotificationName.h"


@interface MyMessageViewController ()<NSFetchedResultsControllerDelegate,SSPullToRefreshViewDelegate,MBProgressHUDDelegate>
{
    NSInteger _selectIndexRow;
    MBProgressHUD *hud;
    NSInteger _finishLog;
}

@property (strong, nonatomic) NSFetchedResultsController *fetchControllerNotice;
@property (strong, nonatomic) NSFetchedResultsController *fetchControllerBulletin;
@property (strong, nonatomic) NSFetchedResultsController *fetchControllerAgentMsg;

@property (strong, nonatomic) SSPullToRefreshView *refreshView;

@end

@implementation MyMessageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadMsgTableView) name:NOT_RELOADMSGMENU object:nil];
    
    self.refreshView = [[SSPullToRefreshView alloc] initWithScrollView:self.myTableView delegate:self];
    
    
    [self configureFetchControllerNotice];
    [self configureFetchControllerBulletin];
    [self configureFetchControllerAgentMsg];
    
    [self configureTableViewFooterView];
    
    [self.refreshView startLoadingAndExpand:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    
    if (self.isAPNS)
    {
        self.isAPNS = NO;
        [self performSegueWithIdentifier:@"goMessageInfo" sender:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.myTableView reloadData];
}

- (void)reloadMsgTableView
{
    [self.myTableView reloadData];
}


#pragma mark - FetchedController
- (void)configureFetchControllerNotice
{
    self.fetchControllerNotice = [Notice fetchAllGroupedBy:nil sortedBy:@"sendTime" ascending:NO withPredicate:nil delegate:self incontext:[CoreDataStack sharedCoreDataStack].context];
}

- (void)configureFetchControllerBulletin
{
    self.fetchControllerBulletin = [Bulletin fetchAllGroupedBy:nil sortedBy:@"sendTime" ascending:NO withPredicate:nil delegate:nil incontext:[CoreDataStack sharedCoreDataStack].context];
}

- (void)configureFetchControllerAgentMsg
{
    self.fetchControllerAgentMsg = [AgentMsg fetchAllGroupedBy:nil sortedBy:@"sendTime" ascending:NO withPredicate:nil delegate:nil incontext:[CoreDataStack sharedCoreDataStack].context];
}

//- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
//{
//    [self.myTableView reloadData];
//    [self configureTableViewFooterView];
//}


#pragma mark - MBProgressHUD Delegate
- (void)hudWasHidden:(MBProgressHUD *)hud2
{
    hud2 = nil;
}


#pragma mark - Refresh View
- (void)pullToRefreshViewDidStartLoading:(SSPullToRefreshView *)view
{
    [self refreshData];
}

- (void)refreshData
{
    [self requestNotice];
    [self requestBulletin];
    [self requestAgentMsg];
}



#pragma mark - Net Working
- (void)requestNotice
{
    
    
    NSDictionary *parameters = @{@"method":@"getNoticeList",
                                 @"sign":@"sign",
                                 @"sessionId":[NSString sessionID],
                                 @"recvUser":[NSString exptId],
                                 @"messageType":@"personalAppr",
                                 @"size":@"15",
                                 @"start":@"1"};
    
    [GCRequest getNoticeListWithParameters:parameters block:^(NSDictionary *responseData, NSError *error) {
        
        
        if (!error)
        {
            
            NSString *ret_code = responseData[@"ret_code"];
            if ([ret_code isEqualToString:@"0"])
            {
                NSArray *notices = responseData[@"noticeList"];
                
                [Notice updateCoreDataWithListArray:notices identifierKey:@"noticeId"];
                
                [[CoreDataStack sharedCoreDataStack] saveContext];
                [self configureFetchControllerNotice];
                [self.myTableView reloadData];
                [self configureTableViewFooterView];
                
            }
            else
            {
                
            }
        }
        else
        {
            
        }
        
        _finishLog++;
        if (_finishLog >=3)
        {
            _finishLog = 0;
            if (self.refreshView)
            {
                [self.refreshView finishLoading];
            }
        }
        
    }];
    
    
}



- (void)requestAgentMsg
{
    
    
    NSDictionary *parameters = @{@"method":@"getNoticeList",
                                 @"sign":@"sign",
                                 @"sessionId":[NSString sessionID],
                                 @"recvUser":[NSString exptId],
                                 @"messageType":@"agentMsg",
                                 @"size":@"15",
                                 @"start":@"1"};
    
    [GCRequest getNoticeListWithParameters:parameters block:^(NSDictionary *responseData, NSError *error) {
        
        
        if (!error)
        {
            
            NSString *ret_code = responseData[@"ret_code"];
            if ([ret_code isEqualToString:@"0"])
            {
                NSArray *notices = responseData[@"noticeList"];
                
                [AgentMsg updateCoreDataWithListArray:notices identifierKey:@"noticeId"];
                
                [[CoreDataStack sharedCoreDataStack] saveContext];
                
                [self configureFetchControllerAgentMsg];
                [self.myTableView reloadData];
                [self configureTableViewFooterView];
            }
            else
            {
                
            }
        }
        else
        {
            
        }
        
        _finishLog++;
        if (_finishLog >=3)
        {
            _finishLog = 0;
            if (self.refreshView)
            {
                [self.refreshView finishLoading];
            }
        }
        
    }];
    
    
}


- (void)requestBulletin
{
    
    UserInfo *info = [UserInfo findAllInContext:[CoreDataStack sharedCoreDataStack].context][0];
    
    NSDictionary *parameters = @{@"method":@"getBulletinList",
                                 @"sign":@"sign",
                                 @"sessionId":[NSString sessionID],
                                 @"centerId":info.centerId,
                                 @"groupId":@"3",
                                 @"recvUser":[NSString exptId],
                                 @"size":@"15",
                                 @"start":@"1"};
    
    [GCRequest getBulletinListWithParameters:parameters block:^(NSDictionary *responseData, NSError *error)
     {
         
         if (!error)
         {
             NSString *ret_code = responseData[@"ret_code"];
             if ([ret_code isEqualToString:@"0"])
             {
                 
                 NSArray *bulletinArray = responseData[@"bulletinList"];
                 [Bulletin updateCoreDataWithListArray:bulletinArray identifierKey:@"bulletinId"];
                 
                 [[CoreDataStack sharedCoreDataStack] saveContext];
                 [self configureFetchControllerBulletin];
                 [self.myTableView reloadData];
                 [self configureTableViewFooterView];
                 
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
             hud.mode = MBProgressHUDModeText;
             hud.labelText = [NSString localizedMsgFromRet_code:responseData[@"ret_code"] withHUD:YES];
             [hud hide:YES afterDelay:HUD_TIME_DELAY];
         }
         
         
         _finishLog++;
         if (_finishLog >=3)
         {
             _finishLog = 0;
             if (self.refreshView)
             {
                 [self.refreshView finishLoading];
             }
         }
     }];
    
}





#pragma mark - UITableView Delegate & DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowCount = 0;
    if (self.fetchControllerNotice.fetchedObjects.count >0)
    {
        rowCount ++;
    }
    if (self.fetchControllerBulletin.fetchedObjects.count >0)
    {
        rowCount ++;
    }
    if (self.fetchControllerAgentMsg.fetchedObjects.count >0)
    {
        rowCount ++;
    }
    
    
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MyMessageCell";
    
    MyMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    [self configureCellWithCell:cell indexPath:indexPath];
    return cell;
    
}

- (void)configureCellWithCell:(MyMessageCell *)cell indexPath:(NSIndexPath *)indexPath
{
    
    MsgRemind *msgRemind = [MsgRemind shareMsgRemind];

    if (indexPath.row == 0 && self.fetchControllerNotice.fetchedObjects.count >0)
    {
        NSString *title = NSLocalizedString(@"Approve Result", nil);
        cell.msgTitleLabel.text = title;
        
        
        NSArray *objects = self.fetchControllerNotice.fetchedObjects;
        if (objects.count>0)
        {
            
            Notice *notice = objects[0];
            [cell.msgDetailLabel setText:notice.content];
            
            
            NSString *dayString = [NSString dateFormattingByBeforeFormat:GC_FORMATTER_SECOND toFormat:GC_FORMATTER_DAY string:notice.sendTime];
            NSString *nearDayString = [NSString compareNearDate:[NSDate dateByString:dayString dateFormat:GC_FORMATTER_DAY]];
            
            
            NSString *timeString = [NSString dateFormattingByBeforeFormat:GC_FORMATTER_SECOND toFormat:@"HH:mm" string:notice.sendTime];
            
            NSString *msgDateString = [NSString stringWithFormat:@"%@ %@",nearDayString,timeString];
            [cell.msgDateLabel setText:msgDateString];
            
            
            [cell.msgImageView setImage:[UIImage imageNamed:@"Approve"]];
            NSInteger messageCount =  [msgRemind.messageApproveRemindCount integerValue];
            
            [self addBadgeViewWithView:cell.msgImageView messageCount:messageCount];
        }
        else
        {
            [cell.msgDetailLabel setText:NSLocalizedString(@"No Data", nil)];
            [cell.msgDateLabel setText:@""];
        }
    }
    else if (indexPath.row <=1 && self.fetchControllerBulletin.fetchedObjects.count >0)
    {
        NSString *title = NSLocalizedString(@"System Bulletin", nil);
        cell.msgTitleLabel.text = title;
        
        NSArray *objects = self.fetchControllerBulletin.fetchedObjects;
        if ([Bulletin existWithContext:[CoreDataStack sharedCoreDataStack].context])
        {
            
            Bulletin *bulletin = objects[0];
            [cell.msgDetailLabel setText:bulletin.content];
            
            
            NSString *dayString = [NSString dateFormattingByBeforeFormat:GC_FORMATTER_SECOND toFormat:GC_FORMATTER_DAY string:bulletin.sendTime];
            NSString *nearDayString = [NSString compareNearDate:[NSDate dateByString:dayString dateFormat:GC_FORMATTER_DAY]];
            
            
            NSString *timeString = [NSString dateFormattingByBeforeFormat:GC_FORMATTER_SECOND toFormat:@"HH:mm" string:bulletin.sendTime];
            
            NSString *msgDateString = [NSString stringWithFormat:@"%@ %@",nearDayString,timeString];
            [cell.msgDateLabel setText:msgDateString];
            
            
            [cell.msgImageView setImage:[UIImage imageNamed:@"Bulletin"]];
            
            NSInteger messageCount =  [msgRemind.messageBulletinRemindCount integerValue];

            [self addBadgeViewWithView:cell.msgImageView messageCount:messageCount];
        }
        else
        {
            [cell.msgDetailLabel setText:NSLocalizedString(@"No Data", nil)];
            [cell.msgDateLabel setText:@""];
        }
    }
    else if (self.fetchControllerAgentMsg.fetchedObjects.count >0)
    {
        NSString *title = NSLocalizedString(@"Agent Message", nil);
        cell.msgTitleLabel.text = title;
        
        
        NSArray *objects = self.fetchControllerAgentMsg.fetchedObjects;
        if (objects.count>0)
        {
            
            AgentMsg *agentMsg = objects[0];
            [cell.msgDetailLabel setText:agentMsg.content];
            
            
            NSString *dayString = [NSString dateFormattingByBeforeFormat:GC_FORMATTER_SECOND toFormat:GC_FORMATTER_DAY string:agentMsg.sendTime];
            NSString *nearDayString = [NSString compareNearDate:[NSDate dateByString:dayString dateFormat:GC_FORMATTER_DAY]];
            
            
            NSString *timeString = [NSString dateFormattingByBeforeFormat:GC_FORMATTER_SECOND toFormat:@"HH:mm" string:agentMsg.sendTime];
            
            NSString *msgDateString = [NSString stringWithFormat:@"%@ %@",nearDayString,timeString];
            [cell.msgDateLabel setText:msgDateString];
            
            [cell.msgImageView setImage:[UIImage imageNamed:@"Agent"]];
            
            
            NSInteger messageCount =  [msgRemind.messageAgentRemindCount integerValue];
            [self addBadgeViewWithView:cell.msgImageView messageCount:messageCount];
        }
        else
        {
            [cell.msgDetailLabel setText:NSLocalizedString(@"No Data", nil)];
            [cell.msgDateLabel setText:@""];
        }
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MyMessageCell *cell = (MyMessageCell *)[self.myTableView cellForRowAtIndexPath:indexPath];
    NSString *cellTitle = cell.msgTitleLabel.text;
    self.goMsgTitle = cellTitle;
    
    if ([cellTitle isEqualToString:NSLocalizedString(@"Approve Result", nil)])
    {
        self.goMsgType  = MsgTypeApprove;
    }
    else if ([cellTitle isEqualToString:NSLocalizedString(@"System Bulletin", nil)])
    {
        self.goMsgType = MsgTypeBulletin;
    }
    else if ([cellTitle isEqualToString:NSLocalizedString(@"Agent Message", nil)])
    {
        self.goMsgType = MsgTypeAgent;
    }

    
    [self performSegueWithIdentifier:@"goMessageInfo" sender:nil];
}

#pragma mark - Other

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    MessageInfoViewController *vc = (MessageInfoViewController *)[segue destinationViewController];
    
    vc.title = self.goMsgTitle;
    vc.msgType = self.goMsgType;
}



- (void)addBadgeViewWithView:(UIView *)view messageCount:(NSInteger)count
{
    if (count>0)
    {
        
        NSInteger badgeWidthHeitght = 20.0;
        
        M13BadgeView *_badgeView = [[M13BadgeView alloc] initWithFrame:CGRectMake(0,
                                                                                  0,
                                                                                  badgeWidthHeitght,
                                                                                  badgeWidthHeitght)];
        _badgeView.tag = 1001;
        _badgeView.hidesWhenZero = YES;
        _badgeView.text = [NSString stringWithFormat:@"%ld",count];
        [view addSubview:_badgeView];
        
        _badgeView.horizontalAlignment = M13BadgeViewHorizontalAlignmentRight;
    }
    else
    {
        M13BadgeView *_badgeView = (M13BadgeView *)[view viewWithTag:1001];
        if (_badgeView)
        {
            [_badgeView removeFromSuperview];
            [self.myTableView reloadData];
        }
    }
}




- (void)configureTableViewFooterView
{
    
    if (self.fetchControllerNotice.fetchedObjects.count <= 0 && self.fetchControllerBulletin.fetchedObjects.count <= 0 && self.fetchControllerAgentMsg.fetchedObjects.count <= 0)
    {
        NoDataLabel *label = [[NoDataLabel alloc] initWithFrame:self.myTableView.bounds];
        self.myTableView.tableFooterView = label;
    }
    else
    {
        self.myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
}



- (IBAction)back:(UIStoryboardSegue *)sender
{
    
}

@end
