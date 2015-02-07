//
//  MyPatientsViewController.m
//  SugarNursing
//
//  Created by Ian on 14-11-21.
//  Copyright (c) 2014年 ;. All rights reserved.
//

#import "MyPatientsViewController.h"
#import <REMenu.h>
#import "GCRequest.h"
#import "NSString+UserCommon.h"
#import <UIAlertView+AFNetworking.h>
#import "UtilsMacro.h"
#import <MBProgressHUD.h>
#import <SSPullToRefresh.h>
#import <UIImageView+AFNetworking.h>
#import "SinglePatient_ViewController.h"

static NSString *loadSize = @"20";

@interface MyPatientsViewController ()<NSFetchedResultsControllerDelegate,SSPullToRefreshViewDelegate>
{
    MBProgressHUD *hud;
    NSMutableArray *_dataArray;       //从数据库获取的数据
    NSMutableArray *_sourceArray;     //用于排序后展示
    NSArray *titleArray;
}

@property (strong, nonatomic) SSPullToRefreshView *refreshView;

@property (strong, readwrite, nonatomic) REMenu *menu;
@property (weak, nonatomic) IBOutlet UIButton *sectionTitleButton;
@property (strong, nonatomic) NSPredicate *selectPredicate;
@property (strong, nonatomic) NSString *sortKey;

@property (strong, nonatomic) NSString *relationFlag;
@property (strong, nonatomic) NSString *orderArg;
@property (assign, nonatomic) BOOL orderAsc;

@property (assign, nonatomic) BOOL isAll;
@property (assign, nonatomic) BOOL loading;

//@property (strong, nonatomic) UIButton *sectionTitleButton;
@property (strong, nonatomic) NSFetchedResultsController *fetchController;


@end

@implementation MyPatientsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initData];
    
    [self layoutView];
    
    
    [self configureFetchControllerWithAscending:NO];
    
    
    [self.refreshView startLoadingAndExpand:YES animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    NSIndexPath *indexPath = [self.mainTableView indexPathForSelectedRow];
    if (indexPath)
    {
        [self.mainTableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}


- (void)initData
{
    
    self.orderArg = @"boundTime";
    self.orderAsc = NO;
    self.relationFlag = @"00";
    self.selectPredicate = nil;
    self.sortKey = @"servBeginTime";
    
    
    titleArray = [NSArray arrayWithObjects:NSLocalizedString(@"The binding time descending", nil),
                  NSLocalizedString(@"The binding time ascending", nil),
                  NSLocalizedString(@"Age from old to young", nil),
                  NSLocalizedString(@"Age from young to old", nil),
                  NSLocalizedString(@"Only takeover", nil),
                  NSLocalizedString(@"Only Hosting", nil),
                  nil];
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.mainTableView reloadData];
}

- (void)configureFetchControllerWithAscending:(BOOL)ascending
{
    self.fetchController = [Patient fetchAllGroupedBy:nil
                                             sortedBy:self.sortKey
                                            ascending:ascending
                                        withPredicate:self.selectPredicate
                                             delegate:self
                                            incontext:[CoreDataStack sharedCoreDataStack].context];
    _dataArray = nil;
    _dataArray = [self.fetchController.fetchedObjects mutableCopy];
}


- (void)requestPatientListDataWithAppending:(BOOL)isAppending
{
    self.loading = YES;
    
    NSDictionary *parameters = @{@"method":@"queryPatientList",
                                 @"sessionToken":[NSString sessionToken],
                                 @"sessionId":[NSString sessionID],
                                 @"exptId":[NSString exptId],
                                 @"relationFlag":self.relationFlag,
                                 @"orderArg":self.orderArg,
                                 @"order":self.orderAsc ? @"asc" : @"desc",
                                 @"start":isAppending ? [NSString stringWithFormat:@"%ld",_dataArray.count+1] : @"1",
                                 @"size":loadSize,
                                 @"sign":@"sign"};

    [GCRequest queryPatientListWithParameters:parameters block:^(NSDictionary *responseData, NSError *error)
    {
        
        self.loading = NO;
        
        if (!error)
        {
            if ([responseData[@"ret_code"] isEqualToString:@"0"])
            {
                NSInteger start = [responseData[@"start"] integerValue];
                NSInteger size = [responseData[@"patientsSize"] integerValue];
                NSInteger total = [responseData[@"total"] integerValue];
                if (size + start > total)
                {
                    self.isAll = YES;
                }
                else
                {
                    self.isAll = NO;
                }
                                
                
                NSArray *patients = responseData[@"patients"];
                if (!isAppending)
                {
                    [Patient deleteAllEntityInContext:[CoreDataStack sharedCoreDataStack].context];
                    
                    
                    [Patient updateCoreDataWithListArray:patients identifierKey:nil];
                    
                }
                else
                {
                    
                    for (NSDictionary *dic in patients)
                    {
                        NSMutableDictionary *patientDic = [dic mutableCopy];
                        [patientDic patientStateFormattingToUserForKey:@"patientStat"];
                        [patientDic dateFormattingByFormat:@"yyyyMMdd" toFormat:@"yyyy-MM-dd" key:@"servStartTime"];
                        [patientDic sexFormattingToUserForKey:@"sex"];
                        
                        
                        if (![Patient patientExistWithLinkManId:dic[@"linkManId"]])
                        {
                            
                            Patient *patient = [Patient createEntityInContext:[CoreDataStack sharedCoreDataStack].context];
                            [patient updateCoreDataForData:patientDic withKeyPath:nil];
                            
                            [_dataArray addObject:patient];
                        }
                        else
                        {
                            
                            NSPredicate *predica = [NSPredicate predicateWithFormat:@"linkManId = %@",dic[@"linkManId"]];
                            NSArray *results = [Patient findAllWithPredicate:predica inContext:[CoreDataStack sharedCoreDataStack].context];
                            Patient *patient = results[0];
                            [patient updateCoreDataForData:patientDic withKeyPath:nil];
                        }
                    }
                }
                
                
                [[CoreDataStack sharedCoreDataStack] saveContext];
                
                [self configureFetchControllerWithAscending:self.orderAsc];
                [self.mainTableView reloadData];
            }
            else
            {
                if (self.refreshView)
                {
                    [self.refreshView finishLoading];
                }
                
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
            hud.labelText = [NSString localizedErrorMesssagesFromError:error];
            [hud hide:YES afterDelay:HUD_TIME_DELAY];
        }
        
        if (self.refreshView)
        {
            [self.refreshView finishLoading];
        }
    }];
}

- (void)layoutView
{
    
    self.sectionTitleButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.sectionTitleButton setBackgroundColor:[UIColor colorWithRed:44.0/255.0
                                                                green:125.0/255.0
                                                                 blue:198.0/255.0
                                                                alpha:1.0]];
    
    [self.sectionTitleButton setTitleColor:[UIColor colorWithRed:255.0/255.0
                                                           green:255.0/255.0
                                                            blue:255.0/255.0
                                                           alpha:1.0]
                                  forState:UIControlStateNormal];
    
    [self.sectionTitleButton addTarget:self action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.sectionTitleButton setTitle:NSLocalizedString(@"Click this select mode of sort", nil)
                             forState:UIControlStateNormal];
    
    
    self.refreshView = [[SSPullToRefreshView alloc] initWithScrollView:self.mainTableView
                                                              delegate:self];
}



#pragma mark - RefreshView Delegate
- (void)pullToRefreshViewDidStartLoading:(SSPullToRefreshView *)view
{
    [self refreshData];
}


- (void)refreshData
{
    [self requestPatientListDataWithAppending:NO];
}

- (void)pullToRefreshViewDidFinishLoading:(SSPullToRefreshView *)view
{
    
}

- (void)toggleMenu
{
    NSMutableArray *itemArray = [NSMutableArray array];
    
    
    for (int i=0 ; i<titleArray.count; i++)
    {
        REMenuItem *homeItem = [[REMenuItem alloc] initWithTitle:[titleArray objectAtIndex:i]
                                                        subtitle:nil
                                                           image:nil
                                                highlightedImage:nil
                                                          action:^(REMenuItem *item) {
                                                              [self remenuItemDidSelectRow:i];
                                                          }];
        
        
        
        [itemArray addObject:homeItem];
    }
    
    self.menu = [[REMenu alloc] initWithItems:itemArray];
    
    [self.menu showFromNavigationController:self.navigationController];
}

- (void)remenuItemDidSelectRow:(NSInteger)row
{
    [self.sectionTitleButton setTitle:[titleArray objectAtIndex:row] forState:UIControlStateNormal];
    
    [self sortListWithSelectRow:row];
    
    [self.menu close];
}


#pragma mark - TableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"dataArray count = %ld",_dataArray.count);
    return _dataArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"MyPatientsCell";
    MyPatientsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    //    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [self configureCell:cell indexPath:indexPath];
    return cell;
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    if (scrollView.contentOffset.y > scrollView.contentSize.height - CGRectGetHeight(scrollView.bounds))
    {
        if (!self.isAll && !self.loading)
        {
            [self requestPatientListDataWithAppending:YES];
        }
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"goSinglePatient" sender:nil];
}



- (void)configureCell:(MyPatientsCell *)cell indexPath:(NSIndexPath *)indexPath
{
    Patient *patient = [_dataArray objectAtIndex:indexPath.row];
    
    [cell.patientImageView setImage:[UIImage imageNamed:@"thumbDefault"]];
    if (patient.headImageUrl && patient.headImageUrl.length > 0)
    {
        
        [cell.patientImageView setImageWithURL:[NSURL URLWithString:patient.headImageUrl] placeholderImage:nil];
    }
    
    
    NSDate *date = [NSDate dateByString:patient.birthday dateFormat:@"yyyyMMddHHmmss"];
    cell.ageLabel.text = [NSString stringWithFormat:@"%@%@",[NSString ageWithDateOfBirth:date],NSLocalizedString(@"old", nil)];
    
    [cell.nameLabel setText:patient.userName];
    [cell.genderLabel setText:patient.sex];
    [cell.bindingDateLabel setText:patient.servStartTime];
    [cell.stateLabel setText:patient.patientStat];
}


- (void)sortListWithSelectRow:(NSInteger)row
{
    switch (row)
    {
        case 0:
        {
            self.orderArg = @"boundTime";
            self.orderAsc = NO;
            self.relationFlag = @"00";
            self.selectPredicate = nil;
            self.sortKey = @"servBeginTime";
        }
            break;
        case 1:
        {
            self.orderArg = @"boundTime";
            self.orderAsc = YES;
            self.relationFlag = @"00";
            self.selectPredicate = nil;
            self.sortKey = @"servBeginTime";
            [self requestPatientListDataWithAppending:NO];
        }
            break;
        case 2:
        {
            self.orderArg = @"age";
            self.orderAsc = YES;
            self.relationFlag = @"00";
            self.selectPredicate = nil;
            self.sortKey = @"birthday";
        }
            break;
        case 3:
        {
            self.orderArg = @"age";
            self.orderAsc = NO;
            self.relationFlag = @"00";
            self.selectPredicate = nil;
            self.sortKey = @"birthday";
        }
            break;
        case 4:
        {
            self.selectPredicate = [NSPredicate predicateWithFormat:@"patientStat = %@",NSLocalizedString(@"takeover", nil)];
            self.orderArg = @"boundTime";
            self.orderAsc = YES;
            self.relationFlag = @"02";
            self.sortKey = @"servBeginTime";
        }
            break;
        case 5:
        {
            self.selectPredicate = [NSPredicate predicateWithFormat:@"patientStat = %@",NSLocalizedString(@"trusteeship", nil)];
            self.orderArg = @"boundTime";
            self.orderAsc = YES;
            self.relationFlag = @"01";
            self.sortKey = @"servBeginTime";
        }
            break;
        default:
            break;
    }
    
    self.isAll = YES;
    [self.refreshView startLoadingAndExpand:YES animated:YES];
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"goSinglePatient"])
    {
        
        SinglePatient_ViewController *single = [segue destinationViewController];
        
        Patient *patient = [_dataArray objectAtIndex:[self.mainTableView indexPathForSelectedRow].row];
        single.linkManId = patient.linkManId;
        single.isMyPatient = YES;
        single.patient = patient;
    }
}

- (IBAction)back:(UIStoryboardSegue *)sender
{
    
}

@end
