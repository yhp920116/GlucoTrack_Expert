//
//  SendSuggestViewController.m
//  SugarNursing
//
//  Created by Ian on 14-11-27.
//  Copyright (c) 2014年 Tisson. All rights reserved.
//

#import "SendSuggestViewController.h"
#import "MsgRecord_Cell.h"
#import "AttributedLabel.h"
#import "UtilsMacro.h"
#import <MBProgressHUD.h>
#import <SSPullToRefresh.h>
#import "NoDataLabel.h"

static CGFloat cellEstimatedHeight = 200;

static NSString *loadSize = @"15";

@interface SendSuggestViewController ()<SSPullToRefreshViewDelegate,NSFetchedResultsControllerDelegate>
{
    MBProgressHUD *hud;
    
}

@property (strong, nonatomic) SSPullToRefreshView *refreshView;

@property (strong, nonatomic) NSMutableArray *serverArray;

@property (weak, nonatomic) IBOutlet AttributedLabel *titleLabel;

@property (strong, nonatomic) NSFetchedResultsController *fetchedController;
@property (assign, nonatomic) BOOL isAll;
@property (assign, nonatomic) BOOL loading;

@end

@implementation SendSuggestViewController


- (void)awakeFromNib
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.isAll = YES;
    
    
    [self configureFetchedController];
    
    if (self.fetchedController.fetchedObjects.count <= 0)
    {
        [self requestDoctorSuggestsDataWithBeforeTime:nil afterTime:nil refresh:YES];
    }
    else
    {
        Advice *advice = self.fetchedController.fetchedObjects[0];
        NSString *time = [NSString dateFormattingByBeforeFormat:@"yyyy-MM-dd HH:mm" toFormat:GC_FORMATTER_SECOND string:advice.adviceTime];
        [self requestDoctorSuggestsDataWithBeforeTime:nil afterTime:time refresh:YES];
    }
    
    [self configureMyView];
}

- (void)configureFetchedController
{
    NSPredicate *predica = [NSPredicate predicateWithFormat:@"linkManId = %@",self.linkManId];
    self.fetchedController = [Advice fetchAllGroupedBy:nil
                                              sortedBy:@"adviceTime"
                                             ascending:NO
                                         withPredicate:predica
                                              delegate:self
                                             incontext:[CoreDataStack sharedCoreDataStack].context];
}


- (void)requestDoctorSuggestsDataWithBeforeTime:(NSString *)beforeTime afterTime:(NSString *)afterTime refresh:(BOOL)refresh
{
    self.loading = YES;
    
    NSMutableDictionary *parameters = [@{@"method":@"getDoctorSuggests",
                                         @"sign":@"sign",
                                         @"sessionId":[NSString sessionID],
                                         @"linkManId":self.linkManId,
                                         @"exptId":[NSString exptId],
                                         @"start":refresh ? @"1":[NSString stringWithFormat:@"%ld",self.fetchedController.fetchedObjects.count+1],
                                         @"size":loadSize
                                         } mutableCopy];
    
    if (beforeTime && beforeTime.length > 0)
    {
        [parameters setValue:beforeTime forKey:@"beforeTime"];
    }
    else if (afterTime && afterTime.length > 0)
    {
        [parameters setValue:afterTime forKey:@"afterTime"];
    }
    

    [GCRequest getDoctorSuggestsWithParameters:parameters block:^(NSDictionary *responseData, NSError *error) {
        self.loading = NO;
        
        if (!error)
        {
            if ([responseData[@"ret_code"] isEqualToString:@"0"])
            {
                NSInteger size = [responseData[@"suggestListSize"] integerValue];
                if (size < [loadSize integerValue])
                {
                    self.isAll = YES;
                }
                else
                {
                    self.isAll = NO;
                }
                
                
                NSArray *objects = responseData[@"suggestList"];
                
                [Advice updateCoreDataWithListArray:objects identifierKey:@"adviceId"];
                
                [[CoreDataStack sharedCoreDataStack] saveContext];
                
                [self configureFetchedController];
                [self configureTableViewFooterView];
                [self.tableView reloadData];
                
                
                NSInteger total = [responseData[@"total"] integerValue];
                if (total <= self.fetchedController.fetchedObjects.count)
                {
                    self.isAll = YES;
                }
            }
            else
            {
                hud = [[MBProgressHUD alloc] initWithView:self.view];
                [self.view addSubview:hud];
                [hud show:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = [NSString localizedMsgFromRet_code:responseData[@"ret_code"] withHUD:YES];
                [hud hide:YES afterDelay:1.2];
            }
        }
        else
        {
            hud.mode = MBProgressHUDModeText;
            hud.labelText = [NSString localizedMsgFromRet_code:responseData[@"ret_code"] withHUD:YES];
            [hud hide:YES afterDelay:HUD_TIME_DELAY];
        }
    }];
    
    
}

- (void)configureMyView
{
    
    self.refreshView = [[SSPullToRefreshView alloc] initWithScrollView:self.myTextView
                                                              delegate:self];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"linkManId = %@",self.linkManId];
    NSArray *objects = [PatientInfo findAllWithPredicate:predicate inContext:[CoreDataStack sharedCoreDataStack].context];
    
    if (objects.count <= 0)
    {
        [self.titleLabel setText:[NSString stringWithFormat:@"给病人发送建议:"]];
    }
    else
    {
        PatientInfo *info = [objects objectAtIndex:0];
        NSString *userName = info.userName;
        [self.titleLabel setText:[NSString stringWithFormat:@"给%@发送建议:",userName]];
        [self.titleLabel setColor:[UIColor darkGrayColor] fromIndex:0 length:self.titleLabel.text.length];
        [self.titleLabel setColor:[UIColor colorWithRed:255.0/255 green:128.0/255 blue:0.0/255 alpha:1]
                        fromIndex:1
                           length:userName.length];
    }
    
    
    
    self.myTextView.placeholder = NSLocalizedString(@"Plese input your advice", nil);
    
    
    [[self.myTextView layer] setBorderColor:[[[UIColor lightGrayColor] colorWithAlphaComponent:0.5] CGColor]];
    [[self.myTextView layer] setBorderWidth:1.0];
}

#pragma mark - dataOperation
- (void)refreshData
{
    [self requestDoctorSuggestsDataWithBeforeTime:nil afterTime:nil refresh:YES];
}

#pragma mark - RefreshView Delegate
- (void)pullToRefreshViewDidStartLoading:(SSPullToRefreshView *)view
{
    [self refreshData];
}

- (void)pullToRefreshViewDidFinishLoading:(SSPullToRefreshView *)view
{
    
}

#pragma mark - UITalbeView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.fetchedController.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIndentifier = @"MsgRecord_Cell";
    MsgRecord_Cell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier
                                                           forIndexPath:indexPath];
    
    cell.contentLabel.preferredMaxLayoutWidth = [self contentLabelPreferredMaxLayoutWidth];
    
    [cell layoutSubviews];
    
    [self configureServerCell:cell indexPath:indexPath];
    return cell;
}

- (void)configureServerCell:(MsgRecord_Cell *)cell indexPath:(NSIndexPath *)indexPath
{
    
    Advice *advice = self.fetchedController.fetchedObjects[indexPath.row];
    cell.contentLabel.text = advice.content;
    cell.timeLabel.text = advice.adviceTime;
    
}

#pragma mark - TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellEstimatedHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self heightForBasicCellAtIndexPath:indexPath];
}

- (CGFloat)heightForBasicCellAtIndexPath:(NSIndexPath *)indexPath
{
    static MsgRecord_Cell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tableView dequeueReusableCellWithIdentifier:@"MsgRecord_Cell"];
    });
    [self configureServerCell:sizingCell indexPath:indexPath];
    return [self calculateHeightForConfiguredSizingCell:sizingCell];
}

- (CGFloat)calculateHeightForConfiguredSizingCell:(MsgRecord_Cell *)sizingCell
{
    sizingCell.bounds = CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds), cellEstimatedHeight);
    
    
    sizingCell.contentLabel.preferredMaxLayoutWidth = [self contentLabelPreferredMaxLayoutWidth];
    
    
    [sizingCell layoutSubviews];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    return size.height + 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)contentLabelPreferredMaxLayoutWidth
{
    return CGRectGetWidth(self.view.bounds) - 43 - 28;
}



- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    if (scrollView.contentOffset.y > scrollView.contentSize.height - CGRectGetHeight(scrollView.bounds))
    {
        if (!self.isAll && !self.loading)
        {
            Advice *advice = [self.fetchedController.fetchedObjects lastObject];
            [self requestDoctorSuggestsDataWithBeforeTime:advice.adviceTime afterTime:nil refresh:NO];
        }
    }
}

#pragma mark - 发送建议按钮
- (IBAction)sendAdviceButtonEvent:(id)sender
{
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    [hud show:YES];
    
    NSDictionary *parameters = @{@"method":@"sendDoctorSuggests",
                                 @"sign":@"sign",
                                 @"sessionId":[NSString sessionID],
                                 @"content":self.myTextView.text,
                                 @"linkManId":self.linkManId,
                                 @"exptId":[NSString exptId]
                                 };
    

    [GCRequest sendDoctorSuggestsWithParameters:parameters block:^(NSDictionary *responseData, NSError *error) {
        if (!error)
        {
            
            if ([responseData[@"ret_code"] isEqualToString:@"0"])
            {
                
                if (self.fetchedController.fetchedObjects.count <= 0)
                {
                    [self requestDoctorSuggestsDataWithBeforeTime:nil afterTime:nil refresh:YES];
                }
                else
                {
                    Advice *advice = self.fetchedController.fetchedObjects[0];
                    NSString *time = [NSString dateFormattingByBeforeFormat:@"yyyy-MM-dd HH:mm" toFormat:GC_FORMATTER_SECOND string:advice.adviceTime];
                    [self requestDoctorSuggestsDataWithBeforeTime:nil afterTime:time refresh:YES];
                }
                
                
                [self.myTextView setText:@""];
                
                hud.mode = MBProgressHUDModeText;
                hud.labelText = NSLocalizedString(@"Send Succeed", nil);
                [hud hide:YES afterDelay:HUD_TIME_DELAY];
                
            }
            else
            {
                hud.mode = MBProgressHUDModeText;
                hud.labelText = [NSString localizedMsgFromRet_code:responseData[@"ret_code"] withHUD:YES];
                [hud hide:YES afterDelay:HUD_TIME_DELAY];
            }
        }
        else
        {
            hud.mode = MBProgressHUDModeText;
            hud.labelText = [error localizedDescription];
            [hud hide:YES afterDelay:HUD_TIME_DELAY];
        }
    }];
}



- (void)configureTableViewFooterView
{
    if (self.fetchedController.fetchedObjects.count > 0)
    {
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    else
    {
        NoDataLabel *label = [[NoDataLabel alloc] initWithFrame:self.tableView.bounds];
        self.tableView.tableFooterView = label;
    }
}



@end
