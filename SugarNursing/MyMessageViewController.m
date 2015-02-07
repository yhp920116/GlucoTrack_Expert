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



@interface MyMessageViewController ()<NSFetchedResultsControllerDelegate,SSPullToRefreshViewDelegate>
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
    self.refreshView = [[SSPullToRefreshView alloc] initWithScrollView:self.myTableView delegate:self];
    
    
    [self configureFetchControllerNotice];
    [self configureFetchControllerBulletin];
    [self configureFetchControllerAgentMsg];
    
    [self configureTableViewFooterView];
    
    [self.refreshView startLoadingAndExpand:YES animated:YES];
}


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


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    NSIndexPath *indexPath = [self.myTableView indexPathForSelectedRow];
    if (indexPath)
    {
        [self.myTableView deselectRowAtIndexPath:indexPath animated:YES];
    }
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
    _selectIndexRow = indexPath.row;
    [self performSegueWithIdentifier:@"goMessageInfo" sender:nil];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    MessageInfoViewController *vc = (MessageInfoViewController *)[segue destinationViewController];
    
    
    MyMessageCell *cell = (MyMessageCell *)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_selectIndexRow inSection:0]];
    NSString *cellTitle = cell.msgTitleLabel.text;
    if ([cellTitle isEqualToString:NSLocalizedString(@"approve result", nil)])
    {
        vc.title = NSLocalizedString(@"approve result", nil);
        vc.msgType = MsgTypeNotice;
    }
    else if ([cellTitle isEqualToString:NSLocalizedString(@"system bulletin", nil)])
    {
        
        vc.title = NSLocalizedString(@"system bulletin", nil);
        vc.msgType = MsgTypeBulletin;
    }
    else if ([cellTitle isEqualToString:NSLocalizedString(@"Agent Message", nil)])
    {
        
        vc.title = NSLocalizedString(@"Agent Message", nil);
        vc.msgType = MsgTypeAgent;
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
