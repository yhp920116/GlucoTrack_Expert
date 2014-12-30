//
//  RecoveryLogViewController.m
//  SugarNursing
//
//  Created by Ian on 14-11-26.
//  Copyright (c) 2014年 Tisson. All rights reserved.
//

#import "RecoveryLogViewController.h"
#import <MBProgressHUD.h>
#import "RecoveryLog_Cell.h"


static CGFloat kEstimateCellHeight = 100.0;

static NSString *identifier = @"RecoveryLog_Cell";


typedef enum{
    RecoveryCellItemTagDateLabel = 96834,
    RecoveryCellItemTagTitleLabel,
    RecoveryCellItemTagDetailLabel
}RecoveryCellItemTag;

@interface RecoveryLogViewController ()
{
    MBProgressHUD *hud;
    
    NSArray *_serverArray;
}
@property (weak, nonatomic) IBOutlet UIView *filtrateView;

@end

@implementation RecoveryLogViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    NSArray *data = @[
                      @{@"date":@"15:00",@"title":@"血糖",@"content":@[@"11.1mmol/L 乏力、恶心"]},
                      @{@"date":@"15:15",@"title":@"糖化血红蛋白",@"content":@[@"9%"]},
                      @{@"date":@"15:47",@"title":@"运动",@"content":@[@"跑步 69分钟 消耗655大卡"]},
                      @{@"date":@"18:30",@"title":@"晚餐",@"content":@[@"共摄入266大卡",@"主食 米饭 100克 116大卡",@"黄瓜炒蛋 200克 150大卡"]},
                      @{@"date":@"21:30",@"title":@"服药",@"content":@[@"降糖药 格列齐特 不服药/口服 80毫克"]}
                      ];
    
    _serverArray = [NSArray arrayWithArray:data];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _serverArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kEstimateCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self heightForRecoveryLogCellWithIndexPath:indexPath];
}

- (CGFloat)heightForRecoveryLogCellWithIndexPath:(NSIndexPath *)indexPath
{
    static RecoveryLog_Cell *calCell = nil;
    static dispatch_once_t one;
    dispatch_once(&one, ^{
        calCell = [self.myTableView dequeueReusableCellWithIdentifier:identifier];
        
        calCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.bounds), kEstimateCellHeight);
        calCell.contentView.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.bounds), kEstimateCellHeight);
        
        [calCell.contentView setNeedsLayout];
        [calCell.contentView layoutIfNeeded];
    });
    
    [calCell configureCell:_serverArray[indexPath.row]];
    
    return [self calculateCellHeightWithCell:calCell];
}

- (CGFloat)calculateCellHeightWithCell:(RecoveryLog_Cell *)calCell
{
    
    [calCell setNeedsLayout];
    [calCell layoutIfNeeded];
    
    CGSize size = [calCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    return size.height + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecoveryLog_Cell *cell = (RecoveryLog_Cell *)[self.myTableView dequeueReusableCellWithIdentifier:identifier];
    [cell configureCell:_serverArray[indexPath.row]];
    return cell;
}


- (IBAction)selectDateButtonEvent:(id)sender
{
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = self.datePicker;
    [self.view addSubview:hud];
    
    [hud show:YES];
}

- (IBAction)datePickerValueChanged:(id)sender
{
    
    [hud hide:YES];
}

- (IBAction)filtrateButtonEvent:(id)sender
{
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = self.filtrateView;
    [self.view addSubview:hud];
    
    [hud show:YES];
}



- (IBAction)selectFiltrateListButton:(UIButton *)sender
{
    
    if ([sender.currentImage isEqual:[UIImage imageNamed:@"CheckBoxY"]])
    {
        sender.imageView.image = [UIImage imageNamed:@"CheckBoxN"];
        [sender setImage:[UIImage imageNamed:@"CheckBoxN"]
                forState:UIControlStateNormal];
    }
    else
    {
        [sender setImage:[UIImage imageNamed:@"CheckBoxY"]
                forState:UIControlStateNormal];
    }
}

- (IBAction)selectFiltrateListBottomButton:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if (button.tag == 1)    //取消
    {
        [hud hide:YES];
    }
    else    //确定
    {
        [hud hide:YES];
    }
}


- (IBAction)back:(UIStoryboardSegue *)sender
{
    
}

@end
