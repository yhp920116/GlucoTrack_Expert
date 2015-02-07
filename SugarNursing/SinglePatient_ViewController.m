//
//  SinglePatient_ViewController.m
//  糖博士
//
//  Created by Ian on 14-11-12.
//  Copyright (c) 2014年 Ian. All rights reserved.
//

#import "SinglePatient_ViewController.h"
#import <RMDateSelectionViewController.h>
#import "DiseaseInfo_Cell.h"
#import <UIImageView+AFNetworking.h>
#import "UtilsMacro.h"
#import "MediRecord.h"
#import "RecoveryLogViewController.h"
#import "ControlEffectViewController.h"
#import <SSPullToRefresh.h>
#import "NoDataLabel.h"
#import "SendSuggestViewController.h"
#import "UIStoryboard+Storyboards.h"
#import "ThumbnailImageView.h"
#import "DetectDataCell.h"
#import "SectionHeaderView.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

typedef NS_ENUM(NSInteger, GCSearchMode)
{
    GCSearchModeByDay = 0,
    GCSearchModeByMonth
};

typedef NS_ENUM(NSInteger, GCType) {
    GCTypeTable = 0,
    GCTypeLine
};

typedef NS_ENUM(NSInteger, GCLineType) {
    GCLineTypeGlucose = 0,
    GCLineTypeHemo
};


typedef NS_ENUM(NSInteger, GCTableType) {
    GCTableTypeRecord = 1001,
    GCTableTypeDetect = 1002
};



static NSString *SectionHeaderViewIdentifier = @"SectionHeaderViewIdentifier";
static NSString *infoCellIdentifier = @"DiseaseInfo_Cell";

static CGFloat kTableViewMagin = 15;

static CGFloat kInfoCellEstimatedHeight = 500.0;

static CGFloat kHeadCellHeight = 35;



@interface SinglePatient_ViewController ()
<
NSFetchedResultsControllerDelegate,
RMDateSelectionViewControllerDelegate,
SSPullToRefreshViewDelegate
,SectionHeaderViewDelegate
>

{
    MBProgressHUD *hud;
}

@property (strong, nonatomic) NSFetchedResultsController *fetchControllerMedical;
@property (strong, nonatomic) NSFetchedResultsController *GfetchController;
@property (strong, nonatomic) NSFetchedResultsController *HfetchController;


@property (strong, nonatomic) SSPullToRefreshView *refreshView;
@property (assign) GCLineType lineType;
@property (assign) GCSearchMode searchMode;
@property (assign) GCType viewType;


@property (strong, nonatomic) NSDate *selectedDate;
@property (strong, nonatomic) NSMutableArray *selectedArray;

@property (weak, nonatomic) IBOutlet UILabel *unitLabel;

@property (weak, nonatomic) IBOutlet UILabel *patientNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *patientGenderLabel;
@property (weak, nonatomic) IBOutlet UILabel *patientAgeLabel;
@property (weak, nonatomic) IBOutlet ThumbnailImageView *patientImageView;
@property (weak, nonatomic) IBOutlet UIButton *patientEffectLabel;
@property (weak, nonatomic) IBOutlet UIButton *chooseDateButton;
@property (weak, nonatomic) IBOutlet UIButton *changeViewButton;



@end

@implementation SinglePatient_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initSubviews];
    
    if (self.isMyPatient)
    {
        [self configureSubviewWithDataSourceType:0];
    }
    
    
    [self setupNavigationRightItem];
    
    //设置图表
    [self configureGraph];
    
    
    [self configureMedicalFetchedController];
    [self configureDetectFetchedController];
    [self configureTableViewFooterView];
    
    [self.refreshView startLoadingAndExpand:YES animated:YES];
    [self requestDetectLine];
    
    
    [self.myTabBar setSelectedItem:self.myTabBar.items[0]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self requestPersonalInfo];
}

- (void)initSubviews
{
    
    self.selectedArray = [[NSMutableArray alloc] initWithCapacity:10];
    self.lineType = GCLineTypeGlucose;
    self.viewType = GCTypeLine;
    self.searchMode = GCSearchModeByDay;
    self.unitLabel.text = @"mmol/L";
    self.selectedDate = [NSDate date];
    [self.chooseDateButton setTitle:[NSString stringWithDateFormatting:@"yyyy-MM-dd" date:[NSDate date]]
                           forState:UIControlStateNormal];
    self.refreshView = [[SSPullToRefreshView alloc] initWithScrollView:self.myTableView
                                                              delegate:self];
    
    
    
    UINib *sectionHeaderNib = [UINib nibWithNibName:@"SectionHeaderView" bundle:nil];
    [self.myTableView registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:SectionHeaderViewIdentifier];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.myTableView reloadData];
}

- (void)setupNavigationRightItem
{
    if (self.isMyPatient)
    {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Send Advice", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(goSendAdvice)];
        self.navigationItem.rightBarButtonItem = item;
    }
}

- (void)goSendAdvice
{
    
    SendSuggestViewController *vc = [[UIStoryboard myPatientStoryboard] instantiateViewControllerWithIdentifier:@"SendAdvice"];
    vc.linkManId = self.linkManId;
    if ([NSProcessInfo instancesRespondToSelector:@selector(isOperatingSystemAtLeastVersion:)]) {
        [self showViewController:vc sender:nil];
    }
    else
    {
        [self.navigationController pushViewController:vc animated:YES];
    }
}


- (void)configureSubviewWithDataSourceType:(NSInteger)type
{
    
    if (type == 0)
    {
        
        [self.patientImageView setImageWithURL:[NSURL URLWithString:self.patient.headImageUrl] placeholderImage:nil];
        
        NSDate *date = [NSDate dateByString:self.patient.birthday dateFormat:GC_FORMATTER_SECOND];
        self.patientAgeLabel.text = [NSString stringWithFormat:@"%@%@",[NSString ageWithDateOfBirth:date],NSLocalizedString(@"old", nil)];
        
        self.patientGenderLabel.text = self.patient.sex;
        self.patientNameLabel.text = self.patient.userName;
    }
    else
    {
        
        [self.patientImageView setImageWithURL:[NSURL URLWithString:self.patientInfo.headImageUrl] placeholderImage:nil];
        
        NSDate *date = [NSDate dateByString:self.patientInfo.birthday dateFormat:GC_FORMATTER_SECOND];
        self.patientAgeLabel.text = [NSString stringWithFormat:@"%@%@",[NSString ageWithDateOfBirth:date],NSLocalizedString(@"old", nil)];
        
        self.patientGenderLabel.text = self.patientInfo.sex;
        self.patientNameLabel.text = self.patientInfo.userName;
    }
}



- (void)configureMedicalFetchedController
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"linkManId = %@",self.linkManId];
    self.fetchControllerMedical = [MediRecord fetchAllGroupedBy:nil
                                                  sortedBy:@"diagTime"
                                                 ascending:NO
                                             withPredicate:predicate
                                                  delegate:self
                                                 incontext:[CoreDataStack sharedCoreDataStack].context];
    

}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    
}

//- (void)configureDetectFetchedController
//{
//    
//    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    BOOL timeAscending;
//    
//    NSDate *endDate = [NSDate date];
//    NSTimeInterval timeInterval= [endDate timeIntervalSinceReferenceDate];
//    timeInterval -=3600*24*30;
//    NSDate *beginDate = [NSDate dateWithTimeIntervalSinceReferenceDate:timeInterval];
//    NSString *dateString = [dateFormatter stringFromDate:self.selectedDate];
//    switch (self.searchMode)
//    {
//        case GCSearchModeByDay:
//        {
//            [dateFormatter setDateFormat:@"yyyyMMdd"];
//            timeAscending = YES;
//            
//            
//            NSPredicate *Gpredicate = [NSPredicate predicateWithFormat:@"logType = %@ && linkManId = %@ && time = %@  && detectLog.glucose != %@ && detectLog.glucose != %@" ,@"detect",self.linkManId,dateString,@"",nil];
//            
//            
//            self.GfetchController = [RecordLog fetchAllGroupedBy:nil sortedBy:@"time" ascending:timeAscending withPredicate:Gpredicate delegate:self incontext:[CoreDataStack sharedCoreDataStack].context];
//            
//            
//            NSPredicate *Hpredicate = [NSPredicate predicateWithFormat:@"logType = %@ && linkManId = %@ && time beginswith[cd] %@ && detectLog.hemoglobinef != %@ && detectLog.hemoglobinef != %@" ,@"detect",self.linkManId,dateString,@"",nil];
//            
//            
//            self.HfetchController = [RecordLog fetchAllGroupedBy:nil sortedBy:@"time" ascending:timeAscending withPredicate:Hpredicate delegate:self incontext:[CoreDataStack sharedCoreDataStack].context];
//        }
//            break;
//        case GCSearchModeByMonth:
//        {
//            [dateFormatter setDateFormat:@"yyyyMM"];
//            timeAscending = NO;
//            
//            NSPredicate *Gpredicate = [NSPredicate predicateWithFormat:@"logType = %@ && linkManId = %@ && time  %@  && detectLog.glucose != %@ && detectLog.glucose != %@" ,@"detect",self.linkManId,dateString,@"",nil];
//            
//            
//            self.GfetchController = [RecordLog fetchAllGroupedBy:nil sortedBy:@"time" ascending:timeAscending withPredicate:Gpredicate delegate:self incontext:[CoreDataStack sharedCoreDataStack].context];
//            
//            
//            NSPredicate *Hpredicate = [NSPredicate predicateWithFormat:@"logType = %@ && linkManId = %@ && time beginswith[cd] %@ && detectLog.hemoglobinef != %@ && detectLog.hemoglobinef != %@" ,@"detect",self.linkManId,dateString,@"",nil];
//            
//            
//            self.HfetchController = [RecordLog fetchAllGroupedBy:nil sortedBy:@"time" ascending:timeAscending withPredicate:Hpredicate delegate:self incontext:[CoreDataStack sharedCoreDataStack].context];
//            
//            break;
//        }
//        default:
//            break;
//    }
//    
//    
//    
//    [self.myTableView reloadData];
//    [self configureTableViewFooterView];
//    [self.trackerChart reloadGraph];
//}



- (void)configureDetectFetchedController
{
    BOOL timeAscending;
    
    NSPredicate *Gpredicate;
    NSPredicate *Hpredicate;
    
    NSDate *formerDate;
    NSDate *laterDate;
    
    switch (self.searchMode) {
        case GCSearchModeByDay:
        {
            timeAscending = YES;
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyyMMdd000000"];
            NSDate *aDate = [dateFormatter dateFromString:[dateFormatter stringFromDate:self.selectedDate]];
            //            formerDate = [self timeZoneDate:aDate];
            formerDate = aDate;
            
            laterDate = [NSDate dateWithTimeInterval:24*60*60 sinceDate:formerDate];
            
            
            Gpredicate = [NSPredicate predicateWithFormat:@"logType = %@ && linkManId = %@ && time > %@ && time < %@ && detectLog.glucose != %@ && detectLog.glucose != %@" ,@"detect",self.linkManId,formerDate,laterDate,@"",@"",nil];
            
            Hpredicate = [NSPredicate predicateWithFormat:@"logType = %@ && linkManId = %@ && time > %@ && time < %@ && detectLog.hemoglobinef != %@ && detectLog.hemoglobinef != %@" ,@"detect",self.linkManId,formerDate,laterDate,@"",@"",nil];
            
            break;
        }
        case GCSearchModeByMonth:
        {
            timeAscending = NO;
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyyMMdd000000"];
            NSDate *aDate = [dateFormatter dateFromString:[dateFormatter stringFromDate:self.selectedDate]];
            //            laterDate = [self timeZoneDate:aDate];
            laterDate = aDate;
            
            laterDate = [NSDate dateWithTimeInterval:24*60*60 sinceDate:laterDate];
            
            
            NSTimeInterval timeInterVal = -30 * 24 * 60 * 60;
            formerDate = [NSDate dateWithTimeInterval:timeInterVal sinceDate:laterDate];
            
            NSLog(@"%@",laterDate);
            
            Gpredicate = [NSPredicate predicateWithFormat:@"logType = %@ && linkManId = %@ && time > %@ && time < %@ && detectLog.glucose != %@ && detectLog.glucose != %@" ,@"detect",self.linkManId,formerDate,laterDate,@"",@"",nil];
            
            Hpredicate = [NSPredicate predicateWithFormat:@"logType = %@ && linkManId = %@ && time > %@ && time < %@ && detectLog.hemoglobinef != %@ && detectLog.hemoglobinef != %@" ,@"detect",self.linkManId,formerDate,laterDate,@"",@"",nil];
            
            break;
        }
        default:
            break;
    }
    
    self.GfetchController = [RecordLog fetchAllGroupedBy:nil sortedBy:@"time" ascending:timeAscending withPredicate:Gpredicate delegate:self incontext:[CoreDataStack sharedCoreDataStack].context];
    
    
    
    self.HfetchController = [RecordLog fetchAllGroupedBy:nil sortedBy:@"time" ascending:timeAscending withPredicate:Hpredicate delegate:self incontext:[CoreDataStack sharedCoreDataStack].context];


    
    [self.detectTableView reloadData];
    [self configureTableViewFooterView];
    [self.trackerChart reloadGraph];
}


- (NSInteger)getRandomInteger
{
    NSInteger i1 = (int)(arc4random() % 100);
    return i1;
}



#pragma mark - NetWroking 
- (void)requestPersonalInfo
{
    
    hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:hud];
    
    
    
    NSDictionary *parameters = @{@"method":@"getPersonalInfo",
                                 @"sign":@"sign",
                                 @"sessionId":[NSString sessionID],
                                 @"linkManId":self.linkManId};
    
    NSURLSessionDataTask *task = [GCRequest getLinkmanInfoWithParameters:parameters block:^(NSDictionary *responseData, NSError *error) {
        if (!error)
        {
            NSString *ret_code = responseData[@"ret_code"];
            if ([ret_code isEqualToString:@"0"])
            {
                NSMutableDictionary *infoDic = [responseData[@"linkManInfo"] mutableCopy];
                NSString *linkmanId = infoDic[@"linkManId"];
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"linkManId = %@",linkmanId];
                
                NSArray *objects = [PatientInfo findAllWithPredicate:predicate inContext:[CoreDataStack sharedCoreDataStack].context];
                PatientInfo *info;
                if (objects.count <= 0)
                {
                    info = [PatientInfo createEntityInContext:[CoreDataStack sharedCoreDataStack].context];
                }
                else
                {
                    info = objects[0];
                }
                
                [infoDic sexFormattingToUserForKey:@"sex"];
                [info updateCoreDataForData:infoDic withKeyPath:nil];
                
                self.patientInfo = info;
                [[CoreDataStack sharedCoreDataStack] saveContext];
                
                
                [self configureSubviewWithDataSourceType:1];
                
                
                
                [hud hide:YES];
            }
            else
            {
                hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
                [self.navigationController.view addSubview:hud];
                [hud show:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = [NSString localizedMsgFromRet_code:ret_code withHUD:YES];
                [hud hide:YES afterDelay:HUD_TIME_DELAY];
            }
        }
        else
        {
            
        }
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:self];
}


- (void)requestDetectLine
{
    
    [self configureDetectFetchedController];
    
    
    NSMutableDictionary *parameters = [@{@"method":@"queryDetectDetailLine2",
                                         @"sign":@"sign",
                                         @"sessionId":[NSString sessionID],
                                         @"linkManId":self.linkManId
                                         } mutableCopy];
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    switch (self.searchMode)
    {
        case GCSearchModeByDay:
        {
            [dateFormatter setDateFormat:@"yyyyMMdd"];
            NSString *dateString = [dateFormatter stringFromDate:self.selectedDate];
            [parameters setValue:dateString forKey:@"queryDay"];
            break;
        }
        case GCSearchModeByMonth:
        {
            [parameters setValue:@"30" forKey:@"countDay"];
            break;
        }
        default:
            break;
    }
    
    
    [GCRequest QueryDetectLineWithParameters:parameters block:^(NSDictionary *responseData, NSError *error) {
        if (!error)
        {
            
            NSString *ret_code = [responseData objectForKey:@"ret_code"];
            if ([ret_code isEqualToString:@"0"])
            {
                
                // 清除缓存
                for (RecordLog *recordLog in self.GfetchController.fetchedObjects) {
                    [recordLog deleteEntityInContext:[CoreDataStack sharedCoreDataStack].context];
                }
                for (RecordLog *recordLog in self.HfetchController.fetchedObjects) {
                    [recordLog deleteEntityInContext:[CoreDataStack sharedCoreDataStack].context];
                }
                
                
                NSArray *detectLogArr = [responseData objectForKey:@"detectLogList"];
                
                for (NSDictionary *detectLogDic in detectLogArr)
                {
                    
                    RecordLog *recordLog = [RecordLog createEntityInContext:[CoreDataStack sharedCoreDataStack].context];
                    [recordLog updateCoreDataForData:detectLogDic withKeyPath:nil];
                    recordLog.linkManId = self.linkManId;
                    
                    
                    DetectLog *detect = [DetectLog createEntityInContext:[CoreDataStack sharedCoreDataStack].context];
                    [detect updateCoreDataForData:[detectLogDic objectForKey:@"detectLog"] withKeyPath:nil];
                    detect.linkManId = self.linkManId;
                    
                    recordLog.detectLog = detect;
                }
                
                
                [[CoreDataStack sharedCoreDataStack] saveContext];
                
                [self configureDetectFetchedController];
            }
            else
            {
                hud = [[MBProgressHUD alloc] initWithView:self.view];
                [self.view addSubview:hud];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = [NSString localizedErrorMesssagesFromError:error];
                [hud show:YES];
                [hud hide:YES afterDelay:HUD_TIME_DELAY];
            }
        }
    }];
    
}


- (void)requestMedirecord
{
    
    NSDictionary *parameters = @{@"method":@"getMediRecordList",
                                 @"sign":@"sign",
                                 @"sessionId":[NSString sessionID],
                                 @"linkManId":self.linkManId,
                                 @"mediHistId":@""};
    
    [GCRequest getMediRecordListWithParameters:parameters block:^(NSDictionary *responseData, NSError *error) {
        if (!error)
        {
            
            if ([responseData[@"ret_code"] isEqualToString:@"0"])
            {
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"linkManId = %@",self.linkManId];
                [MediRecord deleteEntityInContext:[CoreDataStack sharedCoreDataStack].context
                                        predicate:predicate];
                
                
                NSArray *records = responseData[@"mediRecordList"];
                [records enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    NSDictionary *record = (NSDictionary *)obj;
                    
                    MediRecord *mediRecord = [MediRecord createEntityInContext:[CoreDataStack sharedCoreDataStack].context];
                    [mediRecord updateCoreDataForData:record withKeyPath:nil];
                    mediRecord.linkManId = self.linkManId;
                    
                    
                    [self requestMediRecordAttachWithHestId:[NSString stringWithFormat:@"%@",record[@"mediHistId"]]];
                }];
                
                [[CoreDataStack sharedCoreDataStack] saveContext];
                
                [self configureMedicalFetchedController];
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
        
        [self.refreshView finishLoadingAnimated:YES completion:nil];
        
    }];
}

- (void)requestMediRecordAttachWithHestId:(NSString *)mediHistId
{
    
    NSDictionary *parameters = @{@"method":@"getMediRecordAttach",
                                 @"sign":@"sign",
                                 @"sessionId":[NSString sessionID],
                                 @"mediHistId":mediHistId};
    
    [GCRequest getMediRecordAttachWithParameters:parameters block:^(NSDictionary *responseData, NSError *error) {
        
        if (!error)
        {
            if ([responseData[@"ret_code"] isEqualToString:@"0"])
            {
                
                
                NSInteger mediAttachSize = [responseData[@"mediAttachSize"] integerValue];
                
                
                if (mediAttachSize >0)
                {
                    NSArray *attachArray = responseData[@"mediAttach"];
                    
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"mediHistId = %@",mediHistId];
                    
                    MediRecord *record = [MediRecord findAllWithPredicate:predicate inContext:[CoreDataStack sharedCoreDataStack].context][0];
                    
                    NSMutableOrderedSet *orderSet = [[NSMutableOrderedSet alloc] init];
                    for (NSDictionary *attachDic in attachArray)
                    {
                        
                        MediAttach *attach = [MediAttach createEntityInContext:[CoreDataStack sharedCoreDataStack].context];
                        [attach updateCoreDataForData:attachDic withKeyPath:nil];
                        
                        [orderSet addObject:attach];
                    }
                    
                    record.mediAttach = orderSet;
                    
                    [[CoreDataStack sharedCoreDataStack] saveContext];
                    
                    
                    
//                    NSArray *array  = self.fetchControllerMedical.fetchedObjects;
//                    
//                    for (int i=0; i<array.count; i++)
//                    {
//                        MediRecord *mediRecord = array[i];
//                        
//                        if ([record isEqual:mediRecord])
//                        {
//                            NSIndexSet *set = [NSIndexSet indexSetWithIndex:i];
//                            [self.myTableView reloadSections:set withRowAnimation:UITableViewRowAnimationNone];
//                        }
//                    }
                    
                    
                }
            }
            else
            {
                
            }
        }
        else
        {
            
        }
    }];
}

#pragma mark - RefreshView Delegate
- (void)pullToRefreshViewDidStartLoading:(SSPullToRefreshView *)view
{
    [self requestMedirecord];
}

- (void)pullToRefreshViewDidFinishLoading:(SSPullToRefreshView *)view
{
    
}


- (void)configureGraph
{
    self.trackerChart.labelFont = [UIFont systemFontOfSize:10.];
    self.trackerChart.colorTop = [UIColor clearColor];
    self.trackerChart.colorBottom = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.1];
    self.trackerChart.colorXaxisLabel = [UIColor darkGrayColor];
    self.trackerChart.colorYaxisLabel = [UIColor darkGrayColor];
    self.trackerChart.colorLine = [UIColor lightGrayColor];
    self.trackerChart.colorPoint = [UIColor orangeColor];
    self.trackerChart.colorBackgroundPopUplabel = [UIColor clearColor];
    self.trackerChart.widthLine = 1.0;
    self.trackerChart.enableTouchReport = YES;
    self.trackerChart.enablePopUpReport = YES;
    self.trackerChart.enableBezierCurve = NO;
    self.trackerChart.enableYAxisLabel = YES;
    self.trackerChart.enableXAxisLabel = YES;
    self.trackerChart.autoScaleYAxis = YES;
    self.trackerChart.alwaysDisplayDots = YES;
    self.trackerChart.sizePoint = 10;
    //    self.trackerChart.alwaysDisplayPopUpLabels = YES;
    self.trackerChart.enableReferenceXAxisLines = YES;
    self.trackerChart.enableReferenceYAxisLines = YES;
    self.trackerChart.enableReferenceAxisFrame = YES;
    self.trackerChart.animationGraphStyle = BEMLineAnimationDraw;
}



- (void)configureTableFootView
{
    if (self.fetchControllerMedical.fetchedObjects.count > 0 )
    {
        self.myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    else
    {
        self.myTableView.tableFooterView = [[NSBundle mainBundle] loadNibNamed:@"NoDataTips" owner:self options:nil][0];
    }
}


#pragma mark - trackerChart Data Source

- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph
{
    NSInteger count;
    switch (self.lineType)
    {
        case GCLineTypeGlucose:
            count = self.GfetchController.fetchedObjects.count;
            break;
        case GCLineTypeHemo:
            count = self.HfetchController.fetchedObjects.count;
            break;
    }
    
    return count;
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index
{
    
    RecordLog *recordLog;
    CGFloat pointValue;
    
    switch (self.lineType)
    {
        case GCLineTypeGlucose:
            recordLog = [self.GfetchController.fetchedObjects objectAtIndex:index];
            pointValue = recordLog.detectLog.glucose.floatValue;
            break;
        case GCLineTypeHemo:
            recordLog = [self.HfetchController.fetchedObjects objectAtIndex:index];
            pointValue = recordLog.detectLog.hemoglobinef.floatValue;
            break;
            
    }
    return pointValue;
}

- (CGFloat)intervalForAnHourInLineGraph:(BEMSimpleLineGraphView *)graph
{
    return 30;
}

- (CGFloat)maxValueForLineGraph:(BEMSimpleLineGraphView *)graph
{
    return 30.0;
}

- (CGFloat)minValueForLineGraph:(BEMSimpleLineGraphView *)graph
{
    return 3.5;
}

#pragma mark - trackerChart Delegate

- (NSInteger)numberOfGapsBetweenLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph
{
    return 0;
}

- (NSInteger)numberOfYAxisLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph
{
    return 12;
}

- (NSDate *)currentDateInLineGraph:(BEMSimpleLineGraphView *)graph
{
    return self.selectedDate;
}


//- (void)lineGraph:(BEMSimpleLineGraphView *)graph didTapPointAtIndex:(NSInteger)index
//{
//    hud = [[MBProgressHUD alloc] initWithView:self.view];
//    [self.view addSubview:hud];
//    
//    hud.customView = self.detailView;
//    hud.margin = 0;
//    hud.cornerRadius = 0;
//    hud.mode = MBProgressHUDModeCustomView;
//    hud.delegate = self;
//
//    [hud show:YES];
//
//    return NSLog(@"Tap on the key point at index: %ld",(long)index);
//}

- (NSDate *)lineGraph:(BEMSimpleLineGraphView *)graph dateOnXAxisForIndex:(NSInteger)index
{
    
    RecordLog *recordLog;
    switch (self.lineType)
    {
        case GCLineTypeGlucose:
            if (self.GfetchController.fetchedObjects.count == 0)
            {
                return nil;
            }
            recordLog = [self.GfetchController.fetchedObjects objectAtIndex:index];
            break;
        case GCLineTypeHemo:
            if (self.HfetchController.fetchedObjects.count == 0)
            {
                return nil;
            }
            recordLog = [self.HfetchController.fetchedObjects objectAtIndex:index];
            break;
    }
    
    return recordLog.time;
}

- (GraphSearchMode)searchModeInLineGraph:(BEMSimpleLineGraphView *)graph
{
    
    switch (self.searchMode)
    {
        case GCSearchModeByDay:
            return GraphSearchModeByDay;
        case GCSearchModeByMonth:
            return GraphSearchModeByMonth;
    }
}


- (CGFloat)intervalForSecondInLineGraph:(BEMSimpleLineGraphView *)graph
{
    switch (self.searchMode)
    {
        case GCSearchModeByDay:
            return 1.0/60;
        case GCSearchModeByMonth:
            return 0.0005;
    }
}


//- (NSString *)lineGraph:(BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index
//{
//    
//    RecordLog *recordLog;
//    
//    switch (self.searchMode)
//    {
//        case GCSearchModeByDay:
//        {
//            
//            switch (self.lineType)
//            {
//                case GCLineTypeGlucose:
//                    recordLog = [self.GfetchController.fetchedObjects objectAtIndex:0];
//                    break;
//                default:
//                    recordLog = [self.HfetchController.fetchedObjects objectAtIndex:0];
//                    break;
//            }
//            
//            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//            
//            NSDate *date = recordLog.time;
//            [dateFormatter setDateFormat:@"MM/dd HH:mm"];
//            NSString *dateString = [dateFormatter stringFromDate:date] ? [dateFormatter stringFromDate:date] : @"";
//            
//            return [dateString stringByReplacingOccurrencesOfString:@" " withString:@"\n"];
//        }
//            break;
//        default:
//        {
//            
//            switch (self.lineType)
//            {
//                case GCLineTypeGlucose:
//                    recordLog = [self.GfetchController.fetchedObjects objectAtIndex:0];
//                    break;
//                default:
//                    recordLog = [self.HfetchController.fetchedObjects objectAtIndex:0];
//                    break;
//            }
//            
//            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//            
//            NSDate *date = recordLog.time;
//            [dateFormatter setDateFormat:@"MM/dd"];
//            NSString *dateString = [dateFormatter stringFromDate:date] ? [dateFormatter stringFromDate:date] : @"";
//            
//            return [dateString stringByReplacingOccurrencesOfString:@" " withString:@"\n"];
//        }
//            break;
//    }
//    
//}

- (BOOL)noDataLabelEnableForLineGraph:(BEMSimpleLineGraphView *)graph
{
    return YES;
}


- (void)lineGraph:(BEMSimpleLineGraphView *)graph didTapPointAtIndex:(NSInteger)index
{
    
    hud = [[MBProgressHUD alloc] init];
    [self.view addSubview:hud];
    
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = self.detailView;
    hud.margin = 10;
    hud.delegate = self;
    
    [hud show:YES];
}


#pragma mark - UITableView Delegate & DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView.tag == GCTableTypeRecord)
    {
        return self.fetchControllerMedical.fetchedObjects.count;
    }
    else
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == GCTableTypeRecord)
    {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
        if ([self.selectedArray containsObject:indexPath])
        {
            return 1;
        }
        
        return 0;
    }
    else
    {
        NSInteger rows;
        switch (self.lineType)
        {
            case GCLineTypeGlucose:
                rows = self.GfetchController.fetchedObjects.count;
                break;
            case GCLineTypeHemo:
                rows = self.HfetchController.fetchedObjects.count;
                break;
        }
        
        return rows;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView.tag == GCTableTypeRecord)
    {
        return kHeadCellHeight;
    }
    else  return 0;
}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return indexPath.row == 0 ? kHeadCellHeight : kInfoCellEstimatedHeight;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == GCTableTypeRecord)
    {
        return [self heightForInfoCellWithIndexPath:indexPath];
    }
    else
    {
        return 44;
    }
}


- (CGFloat)heightForInfoCellWithIndexPath:(NSIndexPath *)indexPath
{
    
    static DiseaseInfo_Cell *cell = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        cell = [self.myTableView dequeueReusableCellWithIdentifier:infoCellIdentifier];
        
        cell.contentView.bounds = CGRectMake(0.0f, 0.0f, [self tableViewWidth],
                                                   kInfoCellEstimatedHeight);
        cell.bounds = CGRectMake(0.0f, 0.0f, [self tableViewWidth],
                                       kInfoCellEstimatedHeight);
        
    });
    
    
    [cell configureCellWithMediRecord:[self.fetchControllerMedical.fetchedObjects objectAtIndex:indexPath.section]];
    
    return [self calculateInfoCellHeightWithCell:cell];
}

- (CGFloat)calculateInfoCellHeightWithCell:(DiseaseInfo_Cell *)cell
{
    
    cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.myTableView.bounds), CGRectGetHeight(cell.bounds));
    
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    return size.height;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView.tag == GCTableTypeRecord)
    {
        SectionHeaderView *headerView = [self.myTableView dequeueReusableHeaderFooterViewWithIdentifier:SectionHeaderViewIdentifier];
        
        [self configureHeaderView:headerView inSection:section];
        
        return  headerView;
    }
    
    return nil;
}


- (void)configureHeaderView:(SectionHeaderView *)headerView inSection:(NSInteger)section
{
    [headerView setFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), kHeadCellHeight)];
    
    MediRecord *mediRecord = [self.fetchControllerMedical.fetchedObjects objectAtIndex:section];
    NSString *title = mediRecord.mediName;
    NSString *detailTitle = mediRecord.diagTime;
    detailTitle = [NSString dateFormattingByBeforeFormat:GC_FORMATTER_SECOND toFormat:@"yyyy-MM-dd" string:detailTitle];
    [headerView.titleLabel setText:title];
    [headerView.dateLabel setText:detailTitle];
    
    headerView.arrowBtn.selected = NO;
    headerView.section = section;
    headerView.delegate = self;
    
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    if ([self.selectedArray containsObject:indexPath])
    {
//        [headerView toggleOpenWithUserAction:YES];
        headerView.arrowBtn.selected = YES;
    }
    else
    {
        headerView.arrowBtn.selected = NO;
    }
}



- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == GCTableTypeRecord)
    {
        
        
        DiseaseInfo_Cell *cell = [tableView dequeueReusableCellWithIdentifier:infoCellIdentifier];
        
        [cell configureCellWithMediRecord:self.fetchControllerMedical.fetchedObjects[indexPath.section]];
        
        return cell;
        
    }
    else
    {
        
        static NSString *CellIdentifier = @"DetectCell";
        DetectDataCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configureTableView:tableView withCell:cell atIndexPath:indexPath];
        return cell;
    }
}



- (void)configureTableView:(UITableView *)tableView withCell:(DetectDataCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    RecordLog *recordLog;
    
    switch (self.lineType)
    {
        case GCLineTypeGlucose:
            recordLog = [self.GfetchController.fetchedObjects objectAtIndex:indexPath.row];
            cell.detectValue.text = [NSString stringWithFormat:@"%.1f",[recordLog.detectLog.glucose floatValue]];
            break;
        case GCLineTypeHemo:
            recordLog = [self.HfetchController.fetchedObjects objectAtIndex:indexPath.row];
            cell.detectValue.text = [NSString stringWithFormat:@"%.1f",[recordLog.detectLog.hemoglobinef floatValue]];
            break;
    }
    
    cell.detectDate.text = [NSString stringWithDateFormatting:@"yyyy-MM-dd, EEEE" date:recordLog.time];
    cell.detectTime.text = [NSString stringWithDateFormatting:@"HH:mm" date:recordLog.time];
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}
- (CGFloat)tableViewWidth
{
    return CGRectGetWidth(self.view.bounds) - 2*kTableViewMagin;
}

#pragma mark - SectionHeaderViewDelegate

- (void)sectionHeaderView:(SectionHeaderView *)sectionHeaderView sectionOpened:(NSInteger)section
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    
    if (![self.selectedArray containsObject:indexPath])
    {
        [self.selectedArray addObject:indexPath];
        
        [self.myTableView beginUpdates];
        [self.myTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [self.myTableView endUpdates];
    }
}

- (void)sectionHeaderView:(SectionHeaderView *)sectionHeaderView sectionClosed:(NSInteger)section
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    [self.selectedArray removeObject:indexPath];
    
    [self.myTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    //    self.openSectionHeaderView = nil;
}



#pragma mark - Other
- (IBAction)changeViewButtonEvent:(UIButton *)sender
{
    
    if ([sender.currentImage isEqual:[UIImage imageNamed:@"line.png"]])
    {
        [sender setImage:[UIImage imageNamed:@"table.png"] forState:UIControlStateNormal];
        self.viewType = GCTypeLine;
    }
    else
    {
        [sender setImage:[UIImage imageNamed:@"line.png"] forState:UIControlStateNormal];
        self.viewType = GCTypeTable;
    }
    
    [self configureGraphAndTableView];
    [self configureDetectFetchedController];
}

- (void)configureGraphAndTableView
{
    
    switch (self.viewType)
    {
        case GCTypeLine:
            self.trackerChart.hidden = NO;
            self.detectTableView.hidden = YES;
            break;
        case GCTypeTable:
            self.trackerChart.hidden = YES;
            self.detectTableView.hidden = NO;
            break;
    }
}

- (void)configureTableViewFooterView
{
    if (self.fetchControllerMedical.fetchedObjects.count > 0)
    {
        self.myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    else
    {
        NoDataLabel *label = [[NoDataLabel alloc] initWithFrame:self.myTableView.bounds];
        self.myTableView.tableFooterView = label;
    }
    
    if ( (self.GfetchController.fetchedObjects.count > 0 && self.lineType == GCLineTypeGlucose) ||
         (self.HfetchController.fetchedObjects.count > 0 && self.lineType == GCLineTypeHemo) )
    {
        self.detectTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    else
    {
        CGRect rect = self.detectTableView.frame;
        rect.size.height = rect.size.height/2;
        NoDataLabel *label = [[NoDataLabel alloc] initWithFrame:rect];
        self.detectTableView.tableFooterView = label;
    }
}



- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if ([item isEqual:tabBar.items[0]])
    {
        self.myTableView.hidden = NO;
        self.chartView.hidden = YES;
    }
    else
    {
        self.myTableView.hidden = YES;
        self.chartView.hidden = NO;

    }
}

- (IBAction)detailConfirmButton:(id)sender
{
    [hud hide:YES afterDelay:0.1];
}

- (IBAction)selectDateButtonEvent:(id)sender
{
    
    [RMDateSelectionViewController setLocalizedTitleForCancelButton:NSLocalizedString(@"Cancel", nil)];
    [RMDateSelectionViewController setLocalizedTitleForNowButton:NSLocalizedString(@"Select By Month", nil)];
    [RMDateSelectionViewController setLocalizedTitleForSelectButton:NSLocalizedString(@"Select By Day", nil)];
    
    RMDateSelectionViewController *dateSelectionVC = [RMDateSelectionViewController dateSelectionController];
    dateSelectionVC.delegate = self;
    dateSelectionVC.disableBlurEffects = YES;
    dateSelectionVC.disableBouncingWhenShowing = NO;
    dateSelectionVC.disableMotionEffects = NO;
    dateSelectionVC.blurEffectStyle = UIBlurEffectStyleExtraLight;
    dateSelectionVC.datePicker.datePickerMode = UIDatePickerModeDate;
    
    UIButton *button = (UIButton *)sender;
    NSString *title = button.currentTitle;
    if (![title isEqualToString:NSLocalizedString(@"By Date", nil)] && ![title isEqualToString:NSLocalizedString(@"Select By Month", nil)] )
    {
        NSDate *date = [NSDate dateByString:title dateFormat:@"yyyy-MM-dd"];
        [dateSelectionVC.datePicker setDate:date];
    }
    
    
    [dateSelectionVC show];
}

- (void)dateSelectionViewController:(RMDateSelectionViewController *)vc didSelectDate:(NSDate *)aDate
{
    
    
    if ([aDate laterThanDate:[NSDate date]])
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warm prompt", nil)
                                                        message:NSLocalizedString(@"Can't be later than today", nil)
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"Confirm", nil)
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    
    [self.chooseDateButton setTitle:[NSString stringWithDateFormatting:@"yyyy-MM-dd" date:aDate]
                           forState:UIControlStateNormal];
    
    self.selectedDate = aDate;
    self.searchMode = GCSearchModeByDay;
    self.trackerChart.sizePoint = 10;
    [self configureDetectFetchedController];
    [self requestDetectLine];
}

- (void)dateSelectionViewControllerNowButtonPressed:(RMDateSelectionViewController *)vc
{
    [vc dismiss];
    
    self.searchMode = GCSearchModeByMonth;
    
    self.selectedDate = [NSDate date];
    [self.chooseDateButton setTitle:NSLocalizedString(@"Select By Month",nil) forState:UIControlStateNormal];
    self.trackerChart.sizePoint = 1;
    
    [self requestDetectLine];
}

- (IBAction)chartViewSegmentValueChangeEvent:(id)sender
{
    UISegmentedControl *segment = (UISegmentedControl*)sender;
    if (segment.selectedSegmentIndex == 0)
    {
        self.lineType = GCLineTypeGlucose;
        self.unitLabel.text = [NSString stringWithFormat:@"%@: mmol/L",NSLocalizedString(@"Unit", nil)];
    }
    else
    {
        self.lineType = GCLineTypeHemo;
        self.unitLabel.text = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"Unit", nil),@"%"];
    }
    
    [self configureDetectFetchedController];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"goRecoveryLog"])
    {
        RecoveryLogViewController *vc = (RecoveryLogViewController *)[segue destinationViewController];
        vc.linkManId = self.linkManId;
        vc.isMyPatient = self.isMyPatient;
    }
    else if ([segue.identifier isEqualToString:@"goControlEffect"])
    {
        ControlEffectViewController *vc = (ControlEffectViewController *)[segue destinationViewController];
        vc.linkManId = self.linkManId;
        vc.isMyPatient = self.isMyPatient;
    }
}

- (IBAction)back:(UIStoryboardSegue *)segue
{
    
}


@end
