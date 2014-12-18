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


static NSInteger rowCount = 10;

@interface CreateHostingViewController ()
{
    MBProgressHUD *hud;
    
    NSMutableArray *_selectRowArray;
    NSArray *_doctorArray;
    NSArray *_patientArray;
}

@property (assign, nonatomic) BOOL isSelectPatient;
@property (strong, nonatomic) UIButton *choosingDateButton;

@property (assign, nonatomic) NSInteger selectedDoctorRow;



@property (weak, nonatomic) IBOutlet UIButton *selectPatientButton;

@property (weak, nonatomic) IBOutlet UIButton *selectDoctorButton;

@property (weak, nonatomic) IBOutlet UITableView *personTableView;

@property (weak, nonatomic) IBOutlet UILabel *selectPersonTitleLabel;

@property (weak, nonatomic) IBOutlet UIButton *selectPersonSelectAllButton;

@end

@implementation CreateHostingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.selectedDoctorRow = 100000;
    _selectRowArray = [[NSMutableArray alloc] init];
    
    _doctorArray = @[@{@"name":@"王炎林",@"department":@"内分泌科"},
                     @{@"name":@"王记聿",@"department":@"内分泌科"},
                     @{@"name":@"王昱衡",@"department":@"内分泌科"},
                     @{@"name":@"王维兴 ",@"department":@"内分泌科"},
                     @{@"name":@"王雁佼",@"department":@"内分泌科"}
                     ];
    
    _patientArray = @[@{@"name":@"王子运",@"age":@"35",@"gender":@"男"},
                      @{@"name":@"王诗雅",@"age":@"49",@"gender":@"女"},
                      @{@"name":@"李楠钰",@"age":@"28",@"gender":@"男"},
                      @{@"name":@"王柄灰",@"age":@"53",@"gender":@"男"}
                      ];
}


- (IBAction)choosePatientButtonEvent:(id)sender
{
    self.isSelectPatient = YES;
    [self.selectPersonTitleLabel setText:NSLocalizedString(@"Choose patients", nil)];
    self.selectPersonSelectAllButton.hidden = NO;
    [self.personTableView reloadData];
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = self.personPicker;
    [self.view addSubview:hud];
    
    [hud show:YES];
}

- (IBAction)chooseDoctorButtonEvent:(id)sender
{
    self.isSelectPatient = NO;
    [self.selectPersonTitleLabel setText:NSLocalizedString(@"Choose doctor", nil)];
    self.selectPersonSelectAllButton.hidden = YES;
    [self.personTableView reloadData];
    
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = self.personPicker;
    [self.view addSubview:hud];
    
    [hud show:YES];
}


- (IBAction)hostingBeginButtonEvent:(id)sender
{
    self.choosingDateButton = (UIButton *)sender;
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = self.datePicker;
    [self.view addSubview:hud];
    
    
    [hud show:YES];
}


- (IBAction)hostingEndButtonEvent:(id)sender
{
    self.choosingDateButton = (UIButton *)sender;
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = self.datePicker;
    [self.view addSubview:hud];
    
    
    [hud show:YES];
}


- (IBAction)selectDateEvent:(id)sender
{
    NSDate *date = [self.datePicker date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [formatter stringFromDate:date];
    
    [self.choosingDateButton setTitle:dateString forState:UIControlStateNormal];
    
    
    [hud hide:YES afterDelay:0.1];
}

- (IBAction)confirmSelectPersonEvent:(id)sender
{
    if (self.isSelectPatient)
    {
        
        [self.selectPatientButton setTitle:[NSString stringWithFormat:@"已选%ld名病人",[_selectRowArray count]]
                                  forState:UIControlStateNormal];
    }
    else
    {
        
        [self.selectDoctorButton setTitle:@"王小虎"
                                 forState:UIControlStateNormal];
    }
    
    [hud hide:YES afterDelay:0.1];
}

- (IBAction)cancelSelectPersonEvent:(id)sender
{
    
    [hud hide:YES afterDelay:0.1];
}

- (IBAction)selectAllPatientEvent:(id)sender
{
    
    [_selectRowArray removeAllObjects];
    for (NSInteger i = 0 ; i < rowCount; i++)
    {
        
        [_selectRowArray addObject:[NSNumber numberWithInteger:i]];
    }
    
    [self.personTableView reloadData];
}


#pragma mark - 确定托管按钮事件
- (IBAction)confirmHostingButtonEvent:(id)sender
{
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    
    [hud showAnimated:YES whileExecutingBlock:^{
        sleep(2);
        
        hud.mode = MBProgressHUDModeText;
        hud.labelText = NSLocalizedString(@"Initiate a commissioned successfully", nil);
        
        sleep(1);
        
    } completionBlock:^{
        
    }];
}




#pragma mark - UITableView Delegate & DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return rowCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"SelectPersonCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (self.isSelectPatient)
    {
        
        cell.accessoryType =
        [self judgeCellIsSelectWithIndex:indexPath] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    }
    else
    {
        
        cell.accessoryType =
        (indexPath.row == self.selectedDoctorRow) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
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
        UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedDoctorRow
                                                                                            inSection:0]];
        selectedCell.accessoryType = UITableViewCellAccessoryNone;
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.selectedDoctorRow = indexPath.row;
    }
}


- (BOOL)judgeCellIsSelectWithIndex:(NSIndexPath *)indexPath
{
    
    for (NSNumber *selectRowNum in _selectRowArray)
    {
        NSInteger selectRow = [selectRowNum integerValue];
        if (selectRow == indexPath.row)
        {
            return YES;
        }
    }
    
    return NO;
}



@end
