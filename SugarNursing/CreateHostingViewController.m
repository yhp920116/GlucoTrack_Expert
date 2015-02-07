//
//  CreateHostingViewController.m
//  SugarNursing
//
//  Created by Ian on 14-11-25.
//  Copyright (c) 2014年 Tisson. All rights reserved.
//

#import "CreateHostingViewController.h"
#import <MBProgressHUD.h>
#import <RMDateSelectionViewController.h>
#import "UtilsMacro.h"
#import "TrusChoose_Cell.h"



@interface CreateHostingViewController ()<NSFetchedResultsControllerDelegate>
{
    MBProgressHUD *hud;
    
    
    NSMutableArray *_selectRowArray;
    NSMutableDictionary *_selectRowDic;
    NSArray *_doctorArray;
    NSArray *_patientArray;
    NSInteger _selectDoctorRow;
}

@property (assign, nonatomic) BOOL isSelectPatient;
@property (strong, nonatomic) UIButton *choosingDateButton;


@property (strong, nonatomic) NSFetchedResultsController *fetchController;



@property (weak, nonatomic) IBOutlet UIButton *selectPatientButton;

@property (weak, nonatomic) IBOutlet UIButton *selectDoctorButton;

@property (weak, nonatomic) IBOutlet UITableView *personTableView;

@property (weak, nonatomic) IBOutlet UILabel *selectPersonTitleLabel;

@property (weak, nonatomic) IBOutlet UIButton *selectPersonSelectAllButton;
@property (weak, nonatomic) IBOutlet UIButton *beginDateButton;
@property (weak, nonatomic) IBOutlet UIButton *finishDateButton;

@end

@implementation CreateHostingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    _selectRowArray = [[NSMutableArray alloc] init];
    _selectRowDic = [[NSMutableDictionary alloc] init];
    
}


- (void)configureFetchedControllerWithSelection:(int)selection
{
    
    if (selection == 0)
    {
        
        self.fetchController = [TrusPatient fetchAllGroupedBy:nil sortedBy:@"linkManId" ascending:YES withPredicate:nil delegate:self incontext:[CoreDataStack sharedCoreDataStack].context];
        _patientArray = [self.fetchController.fetchedObjects mutableCopy];
    }
    else
    {
        self.fetchController = [TrusExpt fetchAllGroupedBy:nil sortedBy:@"exptId" ascending:YES withPredicate:nil delegate:self incontext:[CoreDataStack sharedCoreDataStack].context];
        _doctorArray = [self.fetchController.fetchedObjects mutableCopy];
    }
}

- (IBAction)choosePatientButtonEvent:(id)sender
{
    
    
    if ([LoadedLog needReloadedByKey:@"trusPatient"])
    {
        
        [self requestTrusPatientList];
    }
    else if (self.fetchController.fetchedObjects.count <=0)
    {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:hud];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = NSLocalizedString(@"no patient to trusteeship", nil);
        [hud show:YES];
        [hud hide:YES afterDelay:HUD_TIME_DELAY];
    }
    else
    {
        
        [self configureFetchedControllerWithSelection:0];
        
        self.isSelectPatient = YES;
        [self.selectPersonTitleLabel setText:NSLocalizedString(@"Choose patients", nil)];
        self.selectPersonSelectAllButton.hidden = NO;
        [self.personTableView reloadData];
        
        [self showSelectTableView];
    }
}


- (IBAction)chooseDoctorButtonEvent:(id)sender
{
    
    if ([LoadedLog needReloadedByKey:@"trusExpt"])
    {
        
        [self requestTrusExptList];
    }
    else
    {
        
        [self configureFetchedControllerWithSelection:1];
        
        self.isSelectPatient = NO;
        [self.selectPersonTitleLabel setText:NSLocalizedString(@"Choose doctor", nil)];
        self.selectPersonSelectAllButton.hidden = YES;
        [self.personTableView reloadData];
        
        
        [self showSelectTableView];
    }
}





- (IBAction)hostingBeginButtonEvent:(id)sender
{
    self.choosingDateButton = (UIButton *)sender;
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = self.datePickerView;
    hud.margin = 0;
    [self.view addSubview:hud];
    
    
    [hud show:YES];
}


- (IBAction)hostingEndButtonEvent:(id)sender
{
    self.choosingDateButton = (UIButton *)sender;
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = self.datePickerView;
    hud.margin = 0;
    [self.view addSubview:hud];
    
    
    [hud show:YES];
}


- (IBAction)datePickerViewButtonEvent:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if (button.tag == 0)
    {
        [hud hide:YES];
    }
    else
    {
        NSDate *date = [self.datePicker date];
        
        
        if ([self.choosingDateButton isEqual:self.beginDateButton])
        {
            
            if ([self.finishDateButton.currentTitle isEqualToString:NSLocalizedString(@"Choose", nil)])
            {
                
                if ([date earlierThanDate:[NSDate date]])
                {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warm prompt", nil)
                                                                    message:NSLocalizedString(@"Can't be earlier than today", nil)
                                                                   delegate:self
                                                          cancelButtonTitle:NSLocalizedString(@"Confirm", nil)
                                                          otherButtonTitles:nil];
                    [alert show];
                }
                else
                {
                    
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"YYYY-MM-dd"];
                    NSString *dateString = [formatter stringFromDate:date];
                    
                    [self.choosingDateButton setTitle:dateString forState:UIControlStateNormal];
                    
                    
                    [hud hide:YES afterDelay:0.1];
                }
            }
            else
            {
                
                NSDate *finishDate = [NSDate dateByString:self.finishDateButton.currentTitle dateFormat:@"yyyy-MM-dd"];
                
                
                
                if ([date earlierThanDate:[NSDate date]])
                {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warm prompt", nil)
                                                                    message:NSLocalizedString(@"Can't be earlier than today", nil)
                                                                   delegate:self
                                                          cancelButtonTitle:NSLocalizedString(@"Confirm", nil)
                                                          otherButtonTitles:nil];
                    [alert show];
                }
                else if ([date laterAndEqualThanDate:finishDate])
                {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warm prompt", nil)
                                                                    message:NSLocalizedString(@"begin day can't later than finish day", nil)
                                                                   delegate:self
                                                          cancelButtonTitle:NSLocalizedString(@"Confirm", nil)
                                                          otherButtonTitles:nil];
                    [alert show];
                }
                else
                {
                    
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"YYYY-MM-dd"];
                    NSString *dateString = [formatter stringFromDate:date];
                    
                    [self.choosingDateButton setTitle:dateString forState:UIControlStateNormal];
                    
                    
                    [hud hide:YES afterDelay:0.1];
                }
            }
        }
        else if ([self.choosingDateButton isEqual:self.finishDateButton])
        {
            
            if ([self.beginDateButton.currentTitle isEqualToString:NSLocalizedString(@"Choose", nil)])
            {
                
                
                if ([date earlierAndEqualThanDate:[NSDate date]])
                {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warm prompt", nil)
                                                                    message:NSLocalizedString(@"Can't be earlier and equal than today", nil)
                                                                   delegate:self
                                                          cancelButtonTitle:NSLocalizedString(@"Confirm", nil)
                                                          otherButtonTitles:nil];
                    [alert show];
                }
                else
                {
                    
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"YYYY-MM-dd"];
                    NSString *dateString = [formatter stringFromDate:date];
                    
                    [self.finishDateButton setTitle:dateString forState:UIControlStateNormal];
                    
                    
                    [hud hide:YES afterDelay:0.1];
                }
            }
            else
            {
                
                NSDate *beginDate = [NSDate dateByString:self.beginDateButton.currentTitle dateFormat:@"yyyy-MM-dd"];
                
                if ([date earlierAndEqualThanDate:beginDate])
                {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warm prompt", nil)
                                                                    message:NSLocalizedString(@"finish day can't earlier than begin day", nil)
                                                                   delegate:self
                                                          cancelButtonTitle:NSLocalizedString(@"Confirm", nil)
                                                          otherButtonTitles:nil];
                    [alert show];
                }
                else
                {
                    
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"YYYY-MM-dd"];
                    NSString *dateString = [formatter stringFromDate:date];
                    
                    [self.choosingDateButton setTitle:dateString forState:UIControlStateNormal];
                    
                    
                    [hud hide:YES afterDelay:0.1];
                }
            }
        }
    }
}


- (IBAction)confirmSelectPersonEvent:(id)sender
{
    if (self.isSelectPatient)
    {
        if (_selectRowArray.count <= 0)
        {
            
            [self.selectPatientButton setTitle:[NSString stringWithFormat:NSLocalizedString(@"Choose", nil)]
                                      forState:UIControlStateNormal];
        }
        else if (_selectRowArray.count == 1)
        {
            TrusPatient *patient = [_patientArray objectAtIndex:[_selectRowArray[0] integerValue]];
            
            [self.selectPatientButton setTitle:[NSString stringWithFormat:@"%@",patient.linkManUserName]
                                      forState:UIControlStateNormal];
        }
        else if (_selectRowArray.count > 1)
        {
            
            [self.selectPatientButton setTitle:[NSString stringWithFormat:@"%@%ld%@",
                                                NSLocalizedString(@"already choose", nil),
                                                (unsigned long)_selectRowArray.count,
                                                NSLocalizedString(@"number patient", nil)]
                                      forState:UIControlStateNormal];
        }
    }
    else
    {
        
        TrusExpt *expt = [_doctorArray objectAtIndex:_selectDoctorRow];
        [self.selectDoctorButton setTitle:expt.exptName
                                 forState:UIControlStateNormal];
    }
    
    self.fetchController = nil;
    
    [hud hide:YES afterDelay:0.1];
}

- (IBAction)cancelSelectPersonEvent:(id)sender
{
    
    self.fetchController = nil;
    
    [hud hide:YES afterDelay:0.1];
}

- (IBAction)selectAllPatientEvent:(id)sender
{
    
    UIButton *button = (UIButton *)sender;
    
    if ([button.currentTitle isEqualToString:NSLocalizedString(@"Select All", nil)])
    {
        [_selectRowArray removeAllObjects];
        for (NSInteger i = 0 ; i < self.fetchController.fetchedObjects.count; i++)
        {
            
            [_selectRowArray addObject:[NSNumber numberWithInteger:i]];
        }
        
        [self.personTableView reloadData];
        [button setTitle:NSLocalizedString(@"Cancel All", nil) forState:UIControlStateNormal];
    }
    else if ([button.currentTitle isEqualToString:NSLocalizedString(@"Cancel All", nil)])
    {
        
        [_selectRowArray removeAllObjects];
        [self.personTableView reloadData];
        [button setTitle:NSLocalizedString(@"Select All", nil) forState:UIControlStateNormal];
    }
}

#pragma mark 获取托管病人列表
- (void)requestTrusPatientList
{
    hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:hud];
    [hud show:YES];
    
    
    NSDictionary *parameters = @{@"method":@"getPatientList",
                                 @"sign":@"sign",
                                 @"sessionId":[NSString sessionID],
                                 @"exptId":[NSString exptId],
                                 @"start":@"1",
                                 @"size":@"10"};
    

    [GCRequest getPatientListWithParameters:parameters block:^(NSDictionary *responseData, NSError *error) {
        
        if (!error)
        {
            if ([responseData[@"ret_code"] isEqualToString:@"0"])
            {
                DDLogDebug(@"%@",responseData);
                
                NSInteger size = [responseData[@"patientsSize"] integerValue];
                
                if (size <= 0)
                {
                    hud.mode = MBProgressHUDModeText;
                    hud.labelText = NSLocalizedString(@"no patient to trusteeship", nil);
                    [hud hide:YES afterDelay:HUD_TIME_DELAY];
                    return ;
                }
                else
                {
                    
                    NSArray *array = responseData[@"patients"];
                    
                    
                    [TrusPatient updateCoreDataWithListArray:array identifierKey:@"linkManId"];
                    
                    
                    [[CoreDataStack sharedCoreDataStack] saveContext];
                    
                    
                    self.isSelectPatient = YES;
                    [self.selectPersonTitleLabel setText:NSLocalizedString(@"Choose patients", nil)];
                    self.selectPersonSelectAllButton.hidden = NO;
                    
                    [self configureFetchedControllerWithSelection:0];
                    [self.personTableView reloadData];
                    
                    
                    hud.mode = MBProgressHUDModeCustomView;
                    hud.margin = 0;
                    hud.customView = self.personPicker;
                }
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
            hud.labelText = [NSString localizedMsgFromRet_code:responseData[@"ret_code"] withHUD:YES];
            [hud hide:YES afterDelay:HUD_TIME_DELAY];
        }
        
    }];
    
}


#pragma mark 获取托管医生列表
- (void)requestTrusExptList
{
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    [hud show:YES];
    
    
    UserInfo *info = [UserInfo shareInfo];
    
    if (!info)
    {
        DDLogDebug(@"No UserInfo");
    }
    
    
    NSDictionary *parameters = @{@"method":@"getTrusExptList",
                                 @"sign":@"sign",
                                 @"sessionId":[NSString sessionID],
                                 @"exptId":[NSString exptId],
                                 @"centerId":info.centerId
                                 };
    

    [GCRequest getTrusExptListWithParameters:parameters block:^(NSDictionary *responseData, NSError *error) {
        
        if (!error)
        {
            if ([responseData[@"ret_code"] isEqualToString:@"0"])
            {
                
                NSInteger size = [responseData[@"trusExptListSize"] integerValue];
                if (size <= 0)
                {
                    
                    hud.mode = MBProgressHUDModeText;
                    hud.labelText = NSLocalizedString(@"no doctor to trusteeship", nil);
                    [hud hide:YES afterDelay:HUD_TIME_DELAY];
                }
                else
                {
                    NSMutableArray *objects = [responseData[@"trusExptList"] mutableCopy];
                    
                    
                    NSUInteger index = 0;
                    for (int i=0; i<objects.count; i++)
                    {
                        NSDictionary *dic = objects[i];
                        NSString *exptId = [NSString stringWithFormat:@"%@",dic[@"exptId"]];
                        if ([exptId isEqualToString:[NSString exptId]])
                        {
                            index = i;
                        }
                    }
                    
                    [objects removeObjectAtIndex:index];
                    
                    
                    [TrusExpt updateCoreDataWithListArray:objects identifierKey:@"exptId"];
                    
                    
                    
                    [self configureFetchedControllerWithSelection:1];
                    
                    self.isSelectPatient = NO;
                    [self.selectPersonTitleLabel setText:NSLocalizedString(@"Choose doctor", nil)];
                    self.selectPersonSelectAllButton.hidden = YES;
                    [self.personTableView reloadData];
                    
                    
                    hud.mode = MBProgressHUDModeCustomView;
                    hud.margin = 0;
                    hud.customView = self.personPicker;
                }
                
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


- (void)showSelectTableView
{
    
    
    hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:hud];
    
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = self.personPicker;
    hud.margin = 0;
    
    [hud show:YES];
}



#pragma mark - UITableView Delegate & DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.fetchController.fetchedObjects.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"TrusChoose_Cell";
    
    TrusChoose_Cell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    
    if (self.isSelectPatient)
    {
        TrusPatient *patient = [self.fetchController.fetchedObjects objectAtIndex:indexPath.row];
        
        
        cell.nameLabel.text = patient.linkManUserName;
        cell.sexLabel.text = [patient.linkManSex isEqualToString:@"00"] ? NSLocalizedString(@"female", nil) : NSLocalizedString(@"male", nil);
        cell.accessoryType =
        [self judgeCellIsSelectWithIndex:indexPath] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        
    }
    else
    {
        TrusExpt *expt = [self.fetchController.fetchedObjects objectAtIndex:indexPath.row];
        cell.nameLabel.text = expt.exptName;
        cell.sexLabel.text = expt.departmentName;
        cell.accessoryType =
        (indexPath.row == _selectDoctorRow) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (self.isSelectPatient)
    {
        
        if ([self judgeCellIsSelectWithIndex:indexPath])
        {
            
            [_selectRowArray removeObject:[NSNumber numberWithInteger:indexPath.row]];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else
        {
            
            [_selectRowArray addObject:[NSNumber numberWithInteger:indexPath.row]];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    else
    {
        UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_selectDoctorRow
                                                                                            inSection:0]];
        selectedCell.accessoryType = UITableViewCellAccessoryNone;
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        _selectDoctorRow = indexPath.row;
    }
}


- (BOOL)judgeCellIsSelectWithIndex:(NSIndexPath *)indexPath
{
    
    
    BOOL isSelect = NO;
    NSIndexPath *index = indexPath;
    
    for (NSNumber *obj in _selectRowArray)
    {
        NSInteger selectRow = [obj integerValue];
        if (selectRow == index.row)
        {
            isSelect = YES;
        }
    }
    
    
    return isSelect;
}


#pragma mark - 确定托管按钮事件
- (IBAction)confirmHostingButtonEvent:(id)sender
{
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    [hud show:YES];
    
    
    if ([self.selectPatientButton.currentTitle isEqualToString:NSLocalizedString(@"Choose", nil)])
    {
        
        hud.mode = MBProgressHUDModeText;
        hud.labelText = NSLocalizedString(@"Please Choose Patient", nil);
        [hud hide:YES afterDelay:HUD_TIME_DELAY];
        return;
    }
    
    if ([self.selectDoctorButton.currentTitle isEqualToString:NSLocalizedString(@"Choose", nil)])
    {
        hud.mode = MBProgressHUDModeText;
        hud.labelText = NSLocalizedString(@"Please Choose Doctor", nil);
        [hud hide:YES afterDelay:HUD_TIME_DELAY];
        return;
    }
    
    if ([self.beginDateButton.currentTitle isEqualToString:NSLocalizedString(@"Choose", nil)] ||
        [self.finishDateButton.currentTitle isEqualToString:NSLocalizedString(@"Choose", nil)])
    {
        hud.mode = MBProgressHUDModeText;
        hud.labelText = NSLocalizedString(@"Time Can't be empty", nil);
        [hud hide:YES afterDelay:HUD_TIME_DELAY];
        return;
    }
    
    TrusExpt *selectExpt = _doctorArray[_selectDoctorRow];
    
    
    NSDictionary *parameters = @{@"method":@"sendTrusteeship",
                                 @"sign":@"sign",
                                 @"sessionToken":[NSString sessionToken],
                                 @"sessionId":[NSString sessionID],
                                 @"reqtExptId":[NSString exptId],
                                 @"linkManList":[self jsonStringBySelectRowArray:_selectRowArray],
                                 @"trusExptId":selectExpt.exptId,
                                 @"trusBeginTime":[NSString dateFormattingByBeforeFormat:@"YYYY-MM-dd" toFormat:@"yyyyMMdd" string:self.beginDateButton.currentTitle],
                                 @"trusEndTime":[NSString dateFormattingByBeforeFormat:@"YYYY-MM-dd" toFormat:@"yyyyMMdd" string:self.finishDateButton.currentTitle]
                                 };
    

    [GCRequest sendTrusteeshipWithParameters:parameters block:^(NSDictionary *responseData, NSError *error) {
        if (!error)
        {
            if ([responseData[@"ret_code"] isEqualToString:@"0"])
            {
                
                for (NSNumber *number in _selectRowArray)
                {
                    NSInteger index = [number integerValue];
                    
                    TrusPatient *patient = _patientArray[index];
                    
                    Trusteeship *trus = [Trusteeship createEntityInContext:[CoreDataStack sharedCoreDataStack].context];
                    trus.linkManId = patient.linkManId;
                    trus.linkManBirthday = patient.linkManBirthday;
                    trus.linkManUserName = patient.linkManUserName;
                    trus.queryFlag = @"01";
                    trus.reqtTime = [NSString stringWithDateFormatting:GC_FORMATTER_SECOND date:[NSDate date]];
                    trus.trusBeginTime = [NSString dateFormattingByBeforeFormat:@"YYYY-MM-dd" toFormat:GC_FORMATTER_SECOND string:self.beginDateButton.currentTitle];
                    trus.trusEndTime = [NSString dateFormattingByBeforeFormat:@"YYYY-MM-dd" toFormat:GC_FORMATTER_SECOND string:self.finishDateButton.currentTitle];
                    trus.trusExptId = [NSString exptId];
                    trus.linkManSex = [patient.linkManSex isEqualToString:@"00"] ?
                    NSLocalizedString(@"female", nil) :  NSLocalizedString(@"male", nil);
                    
                    TrusExpt *expt =  [_doctorArray objectAtIndex:_selectDoctorRow];
                    trus.trusExptName = expt.exptName;
                }
                
                [[CoreDataStack sharedCoreDataStack] saveContext];
                
                hud.mode = MBProgressHUDModeText;
                hud.labelText = NSLocalizedString(@"A Commissioned Successfully", nil);
                [hud showAnimated:YES whileExecutingBlock:^{
                    sleep(HUD_TIME_DELAY);
                } completionBlock:^{
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                
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
            [hud hide:YES];
        }
    }];
}

- (NSString *)jsonStringBySelectRowArray:(NSArray *)array
{
    
    NSMutableArray *patientIdArray = [NSMutableArray array];
    
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSInteger row = [obj integerValue];
        TrusPatient *patient = _patientArray[row];
        
        NSDictionary *dic = @{@"linkManId":patient.linkManId};
        
        [patientIdArray addObject:dic];
    }];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:patientIdArray options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    return jsonString;
}

@end
