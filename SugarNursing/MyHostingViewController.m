//
//  MyHostingViewController.m
//  SugarNursing
//
//  Created by Ian on 14-11-25.
//  Copyright (c) 2014年 Tisson. All rights reserved.
//

#import "MyHostingViewController.h"
#import "TakeoverStandby_Cell.h"
#import <MBProgressHUD.h>
#import "UIStoryboard+Storyboards.h"
#import "CustomLabel.h"
#import "UtilsMacro.h"
#import <SSPullToRefresh.h>
#import "AttributedLabel.h"
#import "NoDataLabel.h"
#import "SinglePatient_ViewController.h"

static const NSString *loadSize = @"15";

@interface MyHostingViewController ()<NSFetchedResultsControllerDelegate,SSPullToRefreshViewDelegate>
{
    MBProgressHUD *hud;
}

@property (strong, nonatomic) NSFetchedResultsController *fetchController;
@property (strong, nonatomic) SSPullToRefreshView *refreshView;
@property (strong, nonatomic) NSString *queryFlag;
@property (strong, nonatomic) NSMutableDictionary *loadedArray;
@property (strong, nonatomic) NSMutableDictionary *isAllArray;
@property (assign, nonatomic) BOOL loading;

@end

@implementation MyHostingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
    
    
    [self configureFetchControllerWithFlag:@"01"];
    [self configureTableViewFooterView];
    
    [self.refreshView startLoadingAndExpand:YES animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    NSIndexPath *indexPath = [self.hostingTableView indexPathForSelectedRow];
    if (indexPath)
    {
        [self.hostingTableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    
    
}



- (void)setup
{
    
    self.refreshView = [[SSPullToRefreshView alloc] initWithScrollView:self.hostingTableView delegate:self];
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
    [self configureFetchControllerWithFlag:self.queryFlag];
    [self configureTableViewFooterView];
    [self.hostingTableView reloadData];
    
    
    BOOL isLoaded = [[self.loadedArray objectForKey:self.queryFlag] boolValue];
    if (!isLoaded)
    {
        
        [self requestTrusteeshipWithQueryFlag:self.queryFlag isRefresh:YES block:^{
            
            [self configureFetchControllerWithFlag:self.queryFlag];
            [self configureTableViewFooterView];
            
            [self.hostingTableView reloadData];
        }];
    }
}


#pragma mark - dataOperation
- (void)refreshData
{
    
//    hud = [[MBProgressHUD alloc] initWithView:self.view];
//    [self.view addSubview:hud];
//    [hud show:YES];
    
    [self requestTrusteeshipWithQueryFlag:self.queryFlag isRefresh:YES block:^{
        
        [self configureFetchControllerWithFlag:self.queryFlag];
        [self configureTableViewFooterView];
        [self.hostingTableView reloadData];
    }];
    
}

#pragma mark - RefreshView Delegate
- (void)pullToRefreshViewDidStartLoading:(SSPullToRefreshView *)view
{
    [self refreshData];
}

- (void)pullToRefreshViewDidFinishLoading:(SSPullToRefreshView *)view
{
    
}



- (void)configureFetchControllerWithFlag:(NSString *)queryFlag
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"queryFlag = %@",queryFlag];
    self.fetchController = [Trusteeship fetchAllGroupedBy:nil sortedBy:@"reqtTime" ascending:NO withPredicate:predicate delegate:self incontext:[CoreDataStack sharedCoreDataStack].context];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.hostingTableView reloadData];
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



- (void)requestTrusteeshipWithQueryFlag:(NSString *)queryFlag isRefresh:(BOOL)isRefresh block:(void(^)())block
{
    [self configureFetchControllerWithFlag:queryFlag];
    
    self.loading = YES;
    
    NSDictionary *parameter = @{@"method":@"getTrusteeshipList",
                                @"sessionToken":[NSString sessionToken],
                                @"sign":@"sign",
                                @"sessionId":[NSString sessionID],
                                @"exptId":[NSString exptId],
                                @"queryFlag":queryFlag,
                                @"size":loadSize,
                                @"start":isRefresh ? @"1" : [NSString stringWithFormat:@"%ld",self.fetchController.fetchedObjects.count+1]
                                };
    
    
    [self.loadedArray setObject:[NSNumber numberWithBool:YES] forKey:queryFlag];
    

    [GCRequest getTrusteeshipListWithParameters:parameter block:^(NSDictionary *responseData, NSError *error) {
        if (!error)
        {
            
            if ([responseData[@"ret_code"] isEqualToString:@"0"])
            {
                [hud hide:YES];
                
                
                NSInteger size = [responseData[@"trusteeshipListSize"] integerValue];
                if (size <= 0)
                {
                    DDLogDebug(@"Trusteeship List Size <= 0");
                    [self configureFetchControllerWithFlag:self.queryFlag];
                    [self.hostingTableView reloadData];
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
                        NSArray *deleteArray = [Trusteeship findAllWithPredicate:predicate
                                                                       inContext:[CoreDataStack sharedCoreDataStack].context];
                        for (Trusteeship *trus in deleteArray)
                        {
                            [trus deleteEntityInContext:[CoreDataStack sharedCoreDataStack].context];
                        }
                    }
                    
                    NSArray *array = responseData[@"trusteeshipList"];
                    
                    NSMutableArray *objects = [@[] mutableCopy];
                    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        NSMutableDictionary *dic = [obj mutableCopy];
                        [dic setObject:queryFlag forKey:@"queryFlag"];
                        [dic sexFormattingToUserForKey:@"linkManSex"];
                        [objects addObject:dic];
                    }];
                    
                    [Trusteeship updateCoreDataWithListArray:objects identifierKey:@"reqtId"];
                    
                    [[CoreDataStack sharedCoreDataStack] saveContext];
                    
                    block();
                }
            }
            else
            {
                [self configureFetchControllerWithFlag:self.queryFlag];
                [self.hostingTableView reloadData];
                
                hud = [[MBProgressHUD alloc] initWithView:self.view];
                [self.view addSubview:hud];
                [hud show:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = [NSString localizedMsgFromRet_code:responseData[@"ret_code"] withHUD:YES];
                [hud hide:YES afterDelay:HUD_TIME_DELAY];
            }
        }
        else
        {
            [self configureFetchControllerWithFlag:self.queryFlag];
            [self.hostingTableView reloadData];
            
            
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
            [self requestTrusteeshipWithQueryFlag:self.queryFlag isRefresh:NO block:^{
                
                [self configureFetchControllerWithFlag:self.queryFlag];
                
                [self.hostingTableView reloadData];
            }];
        }
    }
}

#pragma mark - UITableView Delegate & DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.fetchController.fetchedObjects.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"MyHostingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:identifier];
        
        UILabel *attLabel = [[UILabel alloc] init];
        [attLabel setFrame:CGRectMake(10, 10, CGRectGetWidth(self.view.bounds) - 20, 90 - 20 - 1)];
        attLabel.numberOfLines = 0;
        attLabel.preferredMaxLayoutWidth = attLabel.bounds.size.width;
        attLabel.font = [UIFont systemFontOfSize:13];
        attLabel.tag = 1004;
        [cell addSubview:attLabel];
    }
    
    
    Trusteeship *trus = self.fetchController.fetchedObjects[indexPath.row];
    NSAttributedString *content = [self configureContentStringWithTrusteeship:trus];
    
    UILabel *label = (UILabel *)[cell viewWithTag:1004];
    [label setAttributedText:content];
    
    return cell;
}


- (NSAttributedString *)configureContentStringWithTrusteeship:(Trusteeship *)trus
{
    NSString *jointString;
    NSAttributedString *attString;
    
    NSDate *birthDay = [NSDate dateByString:trus.linkManBirthday dateFormat:@"yyyyMMdd"];
    NSString *age = [NSString ageWithDateOfBirth:birthDay];
    
    if ([trus.queryFlag isEqualToString:@"01"])
    {
        jointString = [NSString stringWithFormat:
                       @"%@%@%@%@ (%@ %@%@) %@%@, %@:%@%@%@",
                       NSLocalizedString(@"from", nil),
                       [NSString dateFormattingByBeforeFormat:@"yyyyMMddHHmmss" toFormat:@"YYYY-MM-dd HH:mm" string:trus.reqtTime],
                       NSLocalizedString(@"put the patient", nil),
                       trus.linkManUserName,
                       trus.linkManSex,
                       age,
                       NSLocalizedString(@"old", nil),
                       NSLocalizedString(@"trusteeship to doctor", nil),
                       trus.trusExptName,
                       NSLocalizedString(@"estimated trusteeship time", nil),
                       [NSString dateFormattingByBeforeFormat:@"yyyyMMddHHmmss" toFormat:@"YYYY-MM-dd" string:trus.trusBeginTime],
                       NSLocalizedString(@"to", nil),
                       [NSString dateFormattingByBeforeFormat:@"yyyyMMddHHmmss" toFormat:@"YYYY-MM-dd" string:trus.trusEndTime]];
    }
    else if ([trus.queryFlag isEqualToString:@"02"])
    {
        jointString = [NSString stringWithFormat:
                       @"%@%@%@%@%@%@ (%@ %@%@) ,%@:%@%@%@",
                       NSLocalizedString(@"doctor", nil),
                       trus.trusExptName,
                       NSLocalizedString(@"from", nil),
                       [NSString dateFormattingByBeforeFormat:@"yyyyMMddHHmmss" toFormat:@"YYYY-MM-dd" string:trus.reqtTime],
                       NSLocalizedString(@"trusteeship patient", nil),
                       trus.linkManUserName,
                       trus.linkManSex,
                       age,
                       NSLocalizedString(@"old", nil),
                       NSLocalizedString(@"takeover time", nil),
                       [NSString dateFormattingByBeforeFormat:@"yyyyMMddHHmmss" toFormat:@"YYYY-MM-dd" string:trus.trusBeginTime],
                       NSLocalizedString(@"to", nil),
                       [NSString dateFormattingByBeforeFormat:@"yyyyMMddHHmmss" toFormat:@"YYYY-MM-dd" string:trus.trusEndTime]];
        
    }
    else if ([trus.queryFlag isEqualToString:@"04"])
    {
        jointString = [NSString stringWithFormat:
                       @"%@%@%@%@%@%@(%@ %@%@)",
                       NSLocalizedString(@"doctor", nil),
                       trus.trusExptName,
                       NSLocalizedString(@"from", nil),
                       [NSString dateFormattingByBeforeFormat:@"YYYYMMddHHmmss" toFormat:@"YYYY-MM-dd HH:mm" string:trus.reqtTime],
                       NSLocalizedString(@"refuse takeover patient", nil),
                       trus.linkManUserName,
                       trus.linkManSex,
                       age,
                       NSLocalizedString(@"old", nil)];
    }
    else if ([trus.queryFlag isEqualToString:@"03"])
    {
        jointString = [NSString stringWithFormat:
                       @"%@%@%@%@ (%@ %@%@) %@%@, %@:%@%@%@",
                       NSLocalizedString(@"from", nil),
                       [NSString dateFormattingByBeforeFormat:@"yyyyMMddHHmmss" toFormat:@"YYYY-MM-dd" string:trus.reqtTime],
                       NSLocalizedString(@"put the patient", nil),
                       trus.linkManUserName,
                       trus.linkManSex,
                       age,
                       NSLocalizedString(@"old", nil),
                       NSLocalizedString(@"trusteeship to doctor", nil),
                       trus.trusExptName,
                       NSLocalizedString(@"estimated trusteeship time", nil),
                       [NSString dateFormattingByBeforeFormat:@"yyyyMMddHHmmss" toFormat:@"YYYY-MM-dd" string:trus.trusBeginTime],
                       NSLocalizedString(@"to", nil),
                       [NSString dateFormattingByBeforeFormat:@"yyyyMMddHHmmss" toFormat:@"YYYY-MM-dd" string:trus.trusEndTime]];
    }
    
    
    NSRange range = [jointString rangeOfString:trus.trusExptName];
    attString = [self configureAttributedString:jointString range:range];
    range = [jointString rangeOfString:trus.linkManUserName];
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



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Trusteeship *trus = [self.fetchController.fetchedObjects objectAtIndex:indexPath.row];
    SinglePatient_ViewController *singleVC = [[UIStoryboard myPatientStoryboard] instantiateViewControllerWithIdentifier:@"SinglePatientVC"];
    singleVC.linkManId = trus.linkManId;
    singleVC.isMyPatient = YES;
    if ([NSProcessInfo instancesRespondToSelector:@selector(isOperatingSystemAtLeastVersion:)])
    {
        [self showViewController:singleVC sender:nil];
    }
    else
    {
        [self.navigationController pushViewController:singleVC animated:YES];
    }
}


- (void)configureTableViewFooterView
{
    if (self.fetchController.fetchedObjects.count > 0)
    {
        self.hostingTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    else
    {
        NoDataLabel *label = [[NoDataLabel alloc] initWithFrame:self.hostingTableView.bounds];
        self.hostingTableView.tableFooterView = label;
    }
}




@end
