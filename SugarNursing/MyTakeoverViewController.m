//
//  MyTakeoverViewController.m
//  SugarNursing
//
//  Created by Ian on 14-12-30.
//  Copyright (c) 2014年 Tisson. All rights reserved.
//

#import "MyTakeoverViewController.h"
#import "TakeoverStandby_Cell.h"
#import <MBProgressHUD.h>
#import "UIStoryboard+Storyboards.h"
#import "UtilsMacro.h"
#import <SSPullToRefreshView.h>
#import "NoDataLabel.h"
#import "SinglePatient_ViewController.h"

static const NSString *loadSize = @"15";


typedef enum
{
    TableViewTagHosting = 101,
    TableViewTagTakeover
}TableViewTag;


@interface MyTakeoverViewController ()<NSFetchedResultsControllerDelegate,SSPullToRefreshViewDelegate,UIAlertViewDelegate>
{
    MBProgressHUD *hud;
    
    NSInteger _selectRow;
}


@property (strong, nonatomic) NSFetchedResultsController *fetchController;
@property (strong, nonatomic) SSPullToRefreshView *refreshView;
@property (strong, nonatomic) NSString *queryFlag;
@property (strong, nonatomic) NSMutableDictionary *loadedArray;
@property (strong, nonatomic) NSMutableDictionary *isAllArray;
@property (assign, nonatomic) BOOL loading;



@end

@implementation MyTakeoverViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setup];
    
    [self configureFetchController];
    [self configureTableViewFooterView];
    
    [self.refreshView startLoadingAndExpand:YES animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    NSIndexPath *indexPath = [self.takeoverTableView indexPathForSelectedRow];
    if (indexPath)
    {
        [self.takeoverTableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
}



- (void)setup
{
    
    self.refreshView = [[SSPullToRefreshView alloc] initWithScrollView:self.takeoverTableView delegate:self];
    self.queryFlag = @"01";
    
    self.loadedArray = [@{@"01":[NSNumber numberWithBool:NO],
                          @"02":[NSNumber numberWithBool:NO],
                          @"03":[NSNumber numberWithBool:NO],
                          @"04":[NSNumber numberWithBool:NO]} mutableCopy];
    
    self.isAllArray = [@{@"01":[NSNumber numberWithBool:NO],
                         @"02":[NSNumber numberWithBool:NO],
                         @"03":[NSNumber numberWithBool:NO],
                         @"04":[NSNumber numberWithBool:NO]} mutableCopy];
}


- (void)reloadMyTableViewData
{
    [self configureFetchController];
    [self configureTableViewFooterView];
    [self.takeoverTableView reloadData];
    
    
    BOOL isLoaded = [[self.loadedArray objectForKey:self.queryFlag] boolValue];
    if (!isLoaded)
    {
        [self requestTakeoverWithQueryFlag:self.queryFlag isRefresh:YES block:^{
            
            [self configureFetchController];
            [self configureTableViewFooterView];
            
            [self.takeoverTableView reloadData];
        }];
        
    }
}


#pragma mark - dataOperation
- (void)refreshData
{
    
    [self configureFetchController];
    
    [self.takeoverTableView reloadData];
    
    
    
    [self requestTakeoverWithQueryFlag:self.queryFlag isRefresh:YES block:^{
        
        [self configureFetchController];
        [self configureTableViewFooterView];
        
        [self.takeoverTableView reloadData];
        
    }];
    
    
    if (self.refreshView)
    {
        [self.refreshView finishLoading];
    }
}

#pragma mark - RefreshView Delegate
- (void)pullToRefreshViewDidStartLoading:(SSPullToRefreshView *)view
{
    [self refreshData];
}

- (void)pullToRefreshViewDidFinishLoading:(SSPullToRefreshView *)view
{
    
}




- (void)configureFetchController
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"queryFlag = %@",self.queryFlag];
    self.fetchController = [Takeover fetchAllGroupedBy:nil sortedBy:@"reqtId" ascending:NO withPredicate:predicate delegate:self incontext:[CoreDataStack sharedCoreDataStack].context];
}



- (IBAction)stateSegmentValueChanged:(id)sender
{
    
    UISegmentedControl *seg = (UISegmentedControl *)sender;
    switch (seg.selectedSegmentIndex)
    {
        case 0:
            self.queryFlag = @"01";
            break;
        case 1:
            self.queryFlag = @"02";
            break;
        case 2:
            self.queryFlag = @"04";
            break;
        case 3:
            self.queryFlag = @"03";
            break;
        default:
            break;
    }
    
    [self reloadMyTableViewData];
}


- (void)requestTakeoverWithQueryFlag:(NSString *)queryFlag isRefresh:(BOOL)isRefresh block:(void(^)())block
{
    [self configureFetchController];
    self.loading = YES;
    
    
    NSDictionary *parameter = @{@"method":@"getTakeOverList",
                                @"sessionToken":[NSString sessionToken],
                                @"sign":@"sign",
                                @"sessionId":[NSString sessionID],
                                @"exptId":[NSString exptId],
                                @"queryFlag":queryFlag,
                                @"size":loadSize,
                                @"start":isRefresh ? @"1" : [NSString stringWithFormat:@"%ld",self.fetchController.fetchedObjects.count+1]
                                };
    
    
    [GCRequest getTakeOverListWithParameters:parameter block:^(NSDictionary *responseData, NSError *error) {
        if (!error)
        {
            
            if ([responseData[@"ret_code"] isEqualToString:@"0"])
            {
                [hud hide:YES];
                
                [self.loadedArray setObject:[NSNumber numberWithBool:YES] forKey:queryFlag];
                
                NSInteger size = [responseData[@"takeOverListSize"] integerValue];
                if (size <= 0)
                {
                    
                    [self configureFetchController];
                    [self.takeoverTableView reloadData];
                }
                else
                {
                    if (size < [loadSize integerValue])
                    {
                        [self.isAllArray setObject:[NSNumber numberWithBool:YES] forKey:queryFlag];
                    }
                    
                    
                    if (isRefresh)
                    {
                        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"queryFlag = %@",queryFlag];
                        NSArray *deleteArray = [Takeover findAllWithPredicate:predicate
                                                                    inContext:[CoreDataStack sharedCoreDataStack].context];
                        for (Takeover *takeover in deleteArray)
                        {
                            [takeover deleteEntityInContext:[CoreDataStack sharedCoreDataStack].context];
                        }
                    }
                    
                    NSArray *array = responseData[@"takeOverList"];
                    
                    NSMutableArray *objects = [@[] mutableCopy];
                    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        NSMutableDictionary *dic = [obj mutableCopy];
                        [dic setObject:queryFlag forKey:@"queryFlag"];
                        [dic sexFormattingToUserForKey:@"linkManSex"];
                        [objects addObject:dic];
                    }];
                    
                    [Takeover updateCoreDataWithListArray:objects identifierKey:@"reqtId"];
                    
                    [[CoreDataStack sharedCoreDataStack] saveContext];
                    
                    
                    block();
                }
            }
            else
            {
                [self configureFetchController];
                [self.takeoverTableView reloadData];
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
            [self configureFetchController];
            [self.takeoverTableView reloadData];
            
            hud.mode = MBProgressHUDModeText;
            hud.labelText = [NSString localizedMsgFromRet_code:responseData[@"ret_code"] withHUD:YES];
            [hud hide:YES afterDelay:HUD_TIME_DELAY];
        }
        
        self.loading = NO;
        if (self.refreshView)
        {
            [self.refreshView finishLoading];
        }
    }];
    
}



- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.contentOffset.y + CGRectGetHeight(scrollView.frame) > scrollView.contentSize.height)
    {
        BOOL isAll = [[self.isAllArray objectForKey:self.queryFlag] boolValue];
        if (!isAll && !self.loading)
        {
            [self requestTakeoverWithQueryFlag:self.queryFlag isRefresh:NO block:^{
                
                [self configureFetchController];
                
                [self.takeoverTableView reloadData];
            }];
        }
    }
}


- (TakeoverStandby_Cell *)getTakeoverStandbyCellWithIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *standyIdentifier = @"TakeoverStandby_Cell";
    
    Takeover *takeover = [self.fetchController.fetchedObjects objectAtIndex:indexPath.row];
    TakeoverStandby_Cell *cell = [self.takeoverTableView dequeueReusableCellWithIdentifier:standyIdentifier];
    [cell configureCellWithContent:[self configureContentStringWithTakeover:self.fetchController.fetchedObjects[indexPath.row]]
                       acceptBlock:^(TakeoverStandby_Cell *cell) {
                           
                           NSString *message = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"sure to confirm takeover", nil),takeover.linkManUserName];
                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warm prompt", nil) message:message delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"Confirm", nil),nil];
                           _selectRow = [self.takeoverTableView indexPathForCell:cell].row;
                           alert.tag = 1;
                           [alert show];
                                                  }
                       refuseBlock:^(TakeoverStandby_Cell *cell) {
                           
                           
                           NSString *message = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"sure to refuse takeover", nil),takeover.linkManUserName];
                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warm prompt", nil) message:message delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"Confirm", nil),nil];
                           _selectRow = [self.takeoverTableView indexPathForCell:cell].row;
                           alert.tag = 2;
                           [alert show];

                       }];
    
    cell.contentLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.view.bounds) - 16 - 8;
    [cell layoutSubviews];
    
    return cell;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        
        if (alertView.tag == 1)
        {
            
            [self acceptTakeoverWithRow:_selectRow];
        }
        else
        {
            [self refuseTakeoverWithRow:_selectRow];
        }
    }
}


- (void)acceptTakeoverWithRow:(NSInteger)row
{
    hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:hud];
    [hud show:YES];
    
    Takeover *takeover = [self.fetchController.fetchedObjects objectAtIndex:row];
    
    NSDictionary *parameters = @{@"method":@"apprTrusteeship",
                                 @"sign":@"sign",
                                 @"sessionId":[NSString sessionID],
                                 @"apprRet":@"1",
                                 @"exptId":[NSString exptId],
                                 @"reqtId":takeover.reqtId};
    
    [GCRequest apprTrusteeshipWithParameters:parameters block:^(NSDictionary *responseData, NSError *error) {
        if (!error)
        {
            if ([responseData[@"ret_code"] isEqualToString:@"0"])
            {
                
                [takeover deleteEntityInContext:[CoreDataStack sharedCoreDataStack].context];
                [[CoreDataStack sharedCoreDataStack] saveContext];
                [self configureFetchController];
                [self.takeoverTableView reloadData];
                
                
                hud.mode = MBProgressHUDModeText;
                hud.labelText = NSLocalizedString(@"you are confirm the trusteeship", nil);
                [hud hide:YES afterDelay:HUD_TIME_DELAY];
            }
            else
            {
                hud.mode = MBProgressHUDModeText;
                hud.labelText = [NSString localizedMsgFromRet_code:responseData[@"ret_code"] withHUD:YES];
                [hud hide:YES afterDelay:1.2];
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

- (void)refuseTakeoverWithRow:(NSInteger)row
{
    
    hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:hud];
    [hud show:YES];
    
    Takeover *takeover = [self.fetchController.fetchedObjects objectAtIndex:row];
    
    NSDictionary *parameters = @{@"method":@"apprTrusteeship",
                                 @"sign":@"sign",
                                 @"sessionId":[NSString sessionID],
                                 @"apprRet":@"0",
                                 @"exptId":[NSString exptId],
                                 @"reqtId":takeover.reqtId};
    
    [GCRequest apprTrusteeshipWithParameters:parameters block:^(NSDictionary *responseData, NSError *error) {
        if (!error)
        {
            if ([responseData[@"ret_code"] isEqualToString:@"0"])
            {
                [takeover deleteEntityInContext:[CoreDataStack sharedCoreDataStack].context];
                [[CoreDataStack sharedCoreDataStack] saveContext];
                [self configureFetchController];
                [self.takeoverTableView reloadData];
                
                hud.mode = MBProgressHUDModeText;
                hud.labelText = NSLocalizedString(@"you are refuse the trusteeship", nil);
                [hud hide:YES afterDelay:HUD_TIME_DELAY];
            }
            else
            {
                hud.mode = MBProgressHUDModeText;
                hud.labelText = [NSString localizedMsgFromRet_code:responseData[@"ret_code"] withHUD:YES];
                [hud hide:YES afterDelay:1.2];
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




#pragma mark - UITableView Delegate & DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.fetchController.fetchedObjects.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView.tag == TableViewTagTakeover && self.takeoverSegment.selectedSegmentIndex == 0)
    {
        
        return 130;
    }
    
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.takeoverSegment.selectedSegmentIndex == 0)
    {
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        return [self getTakeoverStandbyCellWithIndexPath:indexPath];
    }
    else
    {
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        
        static NSString *identifier = @"MyTakeoverCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel *attLabel = [[UILabel alloc] init];
            [attLabel setFrame:CGRectMake(10, 10, CGRectGetWidth(self.view.bounds) - 20, 90 - 20 - 1)];
            attLabel.numberOfLines = 0;
            attLabel.preferredMaxLayoutWidth = attLabel.bounds.size.width;
            attLabel.font = [UIFont systemFontOfSize:13];
            attLabel.tag = 1004;
            [cell addSubview:attLabel];
        }
        
        
        if ([self.queryFlag isEqualToString:@"01"] || [self.queryFlag isEqualToString:@"02"])
        {
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
        else
        {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        Takeover *takeover = self.fetchController.fetchedObjects[indexPath.row];
        NSAttributedString *content = [self configureContentStringWithTakeover:takeover];
        
        UILabel *label = (UILabel *)[cell viewWithTag:1004];
        [label setAttributedText:content];
        
        
        return cell;
        
    }
    
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self.queryFlag isEqualToString:@"01"] || [self.queryFlag isEqualToString:@"02"])
    {
        
        Takeover *takeover = [self.fetchController.fetchedObjects objectAtIndex:indexPath.row];
        SinglePatient_ViewController *singleVC = [[UIStoryboard myPatientStoryboard] instantiateViewControllerWithIdentifier:@"SinglePatientVC"];
        singleVC.linkManId = takeover.linkManId;
        singleVC.isMyPatient = [self.queryFlag isEqualToString:@"01"] ? NO : YES;
        if ([NSProcessInfo instancesRespondToSelector:@selector(isOperatingSystemAtLeastVersion:)])
        {
            [self showViewController:singleVC sender:nil];
        }
        else
        {
            [self.navigationController pushViewController:singleVC animated:YES];
        }
    }
}


- (NSAttributedString *)configureContentStringWithTakeover:(Takeover *)takeover
{
    NSString *jointString;
    NSAttributedString *attString;
    
    NSDate *birthDay = [NSDate dateByString:takeover.linkManBirthday dateFormat:@"yyyyMMdd"];
    NSString *age = [NSString ageWithDateOfBirth:birthDay];
    
    if ([takeover.queryFlag isEqualToString:@"01"])
    {
        jointString = [NSString stringWithFormat:
                       @"%@%@%@%@%@%@ (%@ %@%@) %@, %@:%@%@%@",
                       NSLocalizedString(@"doctor", nil),
                       takeover.reqtExptName,
                       NSLocalizedString(@"from", nil),
                       [NSString dateFormattingByBeforeFormat:@"yyyyMMddHHmmss" toFormat:@"YYYY-MM-dd" string:takeover.reqtTime],
                       NSLocalizedString(@"put the patient", nil),
                       takeover.linkManUserName,
                       takeover.linkManSex,
                       age,
                       NSLocalizedString(@"old", nil),
                       NSLocalizedString(@"trusteeship to me", nil),
                       NSLocalizedString(@"estimated trusteeship time", nil),
                       [NSString dateFormattingByBeforeFormat:@"yyyyMMddHHmmss" toFormat:@"YYYY-MM-dd" string:takeover.trusBeginTime],
                       NSLocalizedString(@"to", nil),
                       [NSString dateFormattingByBeforeFormat:@"yyyyMMddHHmmss" toFormat:@"YYYY-MM-dd" string:takeover.trusEndTime]
                       ];
    }
    else if ([takeover.queryFlag isEqualToString:@"02"])
    {
        jointString = [NSString stringWithFormat:
                       @"%@%@%@%@%@%@ (%@ %@%@) ,%@:%@%@%@",
                       NSLocalizedString(@"from", nil),
                       [NSString dateFormattingByBeforeFormat:@"yyyyMMddHHmmss" toFormat:@"YYYY-MM-dd" string:takeover.reqtTime],
                       NSLocalizedString(@"takeover doctor", nil),
                       takeover.reqtExptName,
                       NSLocalizedString(@"her patient", nil),
                       takeover.linkManUserName,
                       takeover.linkManSex,
                       age,
                       NSLocalizedString(@"old", nil),
                       NSLocalizedString(@"takeover time", nil),
                       [NSString dateFormattingByBeforeFormat:@"yyyyMMddHHmmss" toFormat:@"YYYY-MM-dd" string:takeover.trusBeginTime],
                       NSLocalizedString(@"to", nil),
                       [NSString dateFormattingByBeforeFormat:@"yyyyMMddHHmmss" toFormat:@"YYYY-MM-dd" string:takeover.trusEndTime]];
        
    }
    else if ([takeover.queryFlag isEqualToString:@"04"])
    {
        jointString = [NSString stringWithFormat:
                       @"%@%@%@%@%@%@ (%@ %@%@)",
                       NSLocalizedString(@"from", nil),
                       [NSString dateFormattingByBeforeFormat:@"yyyyMMddHHmmss" toFormat:@"YYYY-MM-dd" string:takeover.reqtTime],
                       NSLocalizedString(@"refuse doctor", nil),
                       takeover.reqtExptName,
                       NSLocalizedString(@"her patient", nil),
                       takeover.linkManUserName,
                       takeover.linkManSex,
                       age,
                       NSLocalizedString(@"old", nil)];
    }
    else if ([takeover.queryFlag isEqualToString:@"03"])
    {
        jointString = [NSString stringWithFormat:
                       @"%@%@%@%@%@%@ (%@ %@%@) %@, %@:%@%@%@",
                       NSLocalizedString(@"doctor", nil),
                       takeover.reqtExptName,
                       NSLocalizedString(@"from", nil),
                       [NSString dateFormattingByBeforeFormat:@"yyyyMMddHHmmss" toFormat:@"YYYY-MM-dd" string:takeover.reqtTime],
                       NSLocalizedString(@"put the patient", nil),
                       takeover.linkManUserName,
                       takeover.linkManSex,
                       age,
                       NSLocalizedString(@"old", nil),
                       NSLocalizedString(@"trusteeship to me", nil),
                       NSLocalizedString(@"estimated trusteeship time", nil),
                       [NSString dateFormattingByBeforeFormat:@"yyyyMMddHHmmss" toFormat:@"YYYY-MM-dd" string:takeover.trusBeginTime],
                       NSLocalizedString(@"to", nil),
                       [NSString dateFormattingByBeforeFormat:@"yyyyMMddHHmmss" toFormat:@"YYYY-MM-dd" string:takeover.trusEndTime]];
    }
    
    NSRange range = [jointString rangeOfString:takeover.reqtExptName];
    attString = [self configureAttributedString:jointString range:range];
    range = [jointString rangeOfString:takeover.linkManUserName];
    attString = [self configureAttributedString:attString range:range];
    
    return attString;
}


- (NSMutableAttributedString *)configureAttributedString:(id)string range:(NSRange)range
{
    if ([string isKindOfClass:[NSAttributedString class]])
    {
        NSAttributedString *attString = (NSAttributedString *)string;
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:attString];
        [attributedString setAttributes:@{NSForegroundColorAttributeName:[UIColor orangeColor]} range:range];
        return attributedString;
    }
    else if ([string isKindOfClass:[NSString class]])
    {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:(NSString *)string];
        [attributedString setAttributes:@{NSForegroundColorAttributeName:[UIColor orangeColor]} range:range];
        return attributedString;
    }
    else
    {
        return nil;
    }
}


- (void)configureTableViewFooterView
{
    if (self.fetchController.fetchedObjects.count > 0)
    {
        self.takeoverTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    else
    {
        NoDataLabel *label = [[NoDataLabel alloc] initWithFrame:self.takeoverTableView.bounds];
        self.takeoverTableView.tableFooterView = label;
    }
}


@end

