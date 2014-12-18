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

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//static CGFloat kHeadCellTitleLabelWidth = 60;
//static CGFloat kHeadCellTitleLabelHeight = 30;
//static CGFloat kHeadCellDetailLabelWidth = 200;
//static CGFloat kHeadCellDetailLabelHeight = 20;

static NSString *infoCellIdentifier = @"DiseaseInfo_Cell";

static CGFloat kTableViewMagin = 15;

static CGFloat kInfoCellEstimatedHeight = 500.0;

static CGFloat kHeadCellHeight = 44;
static CGFloat kHeadCellIndicatorViewWidthAndHeight = 20;


//static CGFloat kInfoCellDefaultTitleFontSize = 15;
//static CGFloat kInfoCellDefaultTitleLabelHeight = 50;
//static CGFloat kInfoCellInfoLabelMinHeight = 80;



@interface SinglePatient_ViewController ()
{
    MBProgressHUD *hud;
    
    NSInteger _sectionCound;
    NSMutableArray *_serverData;
    NSMutableArray *_selectArray;
    NSMutableArray *_cellHeightArray;
}

@property (nonatomic, strong) NSMutableArray *arrayOfXValues;
@property (nonatomic, strong) NSMutableArray *arrayOfYValues;

@end

@implementation SinglePatient_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //设置图表
    [self configureGraph];
    
    _arrayOfXValues = [[NSMutableArray alloc] init];
    _arrayOfYValues = [[NSMutableArray alloc] init];
    
    self.myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    //图表数据源
    [self sendData];
    
    
    //病例资料列表数据源
    [self setServiceData];
    
    
    
    
    [self.myTabBar setSelectedItem:self.myTabBar.items[0]];
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    
    [self.myTableView reloadData];
}

- (void)setServiceData
{
    
    _serverData = [NSMutableArray array];
    _cellHeightArray = [NSMutableArray array];
    
    _serverData = [NSMutableArray arrayWithArray:@[@{@"head":@{@"title":@"病毒性肝炎",
                                                               @"detailTitle":@"2004-01-02确诊",
                                                               @"date":@"11-10"},
                                                     @"body":@{@"hospital":@"广州xx医院",
                                                               @"cureCondition":@"治疗中",
                                                               @"medicalHistory":@"患者2009年8月因妇科炎症服用“金刚藤胶囊”（每日3次、每次4片）共3天抗感染治疗，服药第3天开始出现乏力、食欲减退、眼黄、尿黄，伴有低热，于当地医院住院，查甲、乙、丙、丁、戊型肝炎标志物均阴性，考虑“药物性肝损伤、肝硬化”，给予保肝、退黄药物治疗，效果不佳，黄疸上升，总胆红素最高时66μmol/L，PTA 34％，行两次人工肝治疗后肝功好转，总胆红素下降至55μmol/L，病情好转出院。出院后继续口服保肝药物，并服用中药汤药（具体成分不详）辅助治疗，仍有眼黄、尿黄，监测肝功仍异常，总胆红素>10μmol/L。为进一步诊治于2009年12月15日收住我院。发病以来患者精神、食欲较差，睡眠一般，大便正常，尿色黄，体重无明显变化。",
                                                               @"cureScheme":@"无"
                                                             }
                                                     }]];
    
    _sectionCound = _serverData.count;
    
    _selectArray = [NSMutableArray array];
    for (int i=0 ; i<_sectionCound; i++)
    {
        [_selectArray addObject:[NSNumber numberWithBool:NO]];
    }
}


- (void)sendData
{
    NSMutableArray *arrayY = [[NSMutableArray alloc] init];
    NSMutableArray *arrayX = [[NSMutableArray alloc] init];
    for (int i = 0; i < 10; i++) {
//        [arrayY addObject:@([self getRandomInteger])];
        [arrayX addObject:[NSString stringWithFormat:@"%@h %@min",@(17+i),@(33+i)]];
    }
    
    arrayY = [NSMutableArray arrayWithArray:@[@4.6,@5.1,@5.4,@5.7,@5.9,@4.8]];
    arrayX = [NSMutableArray arrayWithArray:@[[NSString stringWithFormat:@"9/1 1:41"],
                                              [NSString stringWithFormat:@"9/1 6:00"],
                                              [NSString stringWithFormat:@"9/1 10:19"],
                                              [NSString stringWithFormat:@"9/1 14:38"],
                                              [NSString stringWithFormat:@"9/1 18:57"],
                                              [NSString stringWithFormat:@"9/1 23:17"]]];
    self.arrayOfYValues = arrayY;
    self.arrayOfXValues = arrayX;
}


- (NSInteger)getRandomInteger
{
    NSInteger i1 = (int)(arc4random() % 100);
    return i1;
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
        self.trackerChart.alwaysDisplayPopUpLabels = YES;
        self.trackerChart.enableReferenceXAxisLines = YES;
        self.trackerChart.enableReferenceYAxisLines = YES;
        self.trackerChart.enableReferenceAxisFrame = YES;
        self.trackerChart.animationGraphStyle = BEMLineAnimationDraw;
}


#pragma mark - BEMSimpleLineGraphView  DataSource
- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph
{
    return self.arrayOfYValues.count;
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index
{
    return [[self.arrayOfYValues objectAtIndex:index] floatValue];
}

- (CGFloat)hyperValueForLineGraph:(BEMSimpleLineGraphView *)graph
{
    return 5.6;
}

- (CGFloat)hypoValueForLineGraph:(BEMSimpleLineGraphView *)graph
{
    return 5.0;
}

#pragma mark - BEMSimpleLineGraphView Delegate 
- (NSInteger)numberOfGapsBetweenLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph
{
    return 0;
}

- (NSInteger)numberOfYAxisLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph
{
    return 5;
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

- (NSString *)lineGraph:(BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index
{
    NSString *string = [self.arrayOfXValues objectAtIndex:index];
    return [string stringByReplacingOccurrencesOfString:@" " withString:@"\n"];
}

- (BOOL)noDataLabelEnableForLineGraph:(BEMSimpleLineGraphView *)graph
{
    return YES;
}


#pragma mark - UITableView Delegate & DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    BOOL isSelect = [[_selectArray objectAtIndex:section] boolValue];
    if (isSelect)
    {
        return 2;
    }
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row == 0 ? kHeadCellHeight : kInfoCellEstimatedHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 44;
    }
    else
    {
//        return 500;
        return [self heightForInfoCellWithIndexPath:indexPath];
    }
}

- (CGFloat)heightForInfoCellWithIndexPath:(NSIndexPath *)indexPath
{
    
    static DiseaseInfo_Cell *sizingCell = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sizingCell = [self.myTableView dequeueReusableCellWithIdentifier:infoCellIdentifier];
    });
    [sizingCell configureCellWithDictionary:_serverData[indexPath.section][@"body"]];
    return [self calculateInfoCellHeightWithCell:sizingCell];
}

- (CGFloat)calculateInfoCellHeightWithCell:(DiseaseInfo_Cell *)sizingCell
{
    sizingCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.bounds) - 2*kTableViewMagin, kInfoCellEstimatedHeight);
    
    sizingCell.cureConditionLabel.preferredMaxLayoutWidth = [self infoCellParameterLabelPreferredMaxLayoutWidth];
    sizingCell.hospitalLabel.preferredMaxLayoutWidth = [self infoCellParameterLabelPreferredMaxLayoutWidth];
    sizingCell.medicalHistoryLabel.preferredMaxLayoutWidth = [self infoCellParameterLabelPreferredMaxLayoutWidth];
    sizingCell.cureScheme.preferredMaxLayoutWidth = [self infoCellParameterLabelPreferredMaxLayoutWidth];
    [sizingCell layoutSubviews];
    
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    NSLog(@"%f",size.height);
    return size.height + 1;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:[UIColor clearColor]];
    return view;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    UITableViewCell *cell;
    
    if (indexPath.row == 0)
    {
         cell = [self setTitleCellWithIndexPath:indexPath];
        
    }
    else
    {
        DiseaseInfo_Cell *cell = [tableView dequeueReusableCellWithIdentifier:infoCellIdentifier];
        
        cell.cureConditionLabel.preferredMaxLayoutWidth = [self infoCellParameterLabelPreferredMaxLayoutWidth];
        cell.hospitalLabel.preferredMaxLayoutWidth = [self infoCellParameterLabelPreferredMaxLayoutWidth];
        cell.medicalHistoryLabel.preferredMaxLayoutWidth = [self infoCellParameterLabelPreferredMaxLayoutWidth];
        cell.cureScheme.preferredMaxLayoutWidth = [self infoCellParameterLabelPreferredMaxLayoutWidth];
        [cell layoutSubviews];
        
        
        [cell configureCellWithDictionary:[_serverData[indexPath.section] objectForKey:@"body"]];
        
        CALayer *cellLayer = cell.layer;
        cellLayer.borderColor = [[UIColor lightGrayColor] CGColor];
        cellLayer.borderWidth = 1.0;
        
        return cell;
        
    }
    
    
    return cell;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 0) return;
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    BOOL isSelect = [[_selectArray objectAtIndex:indexPath.section] boolValue];
    if (!isSelect)
    {
        [_selectArray setObject:[NSNumber numberWithBool:YES] atIndexedSubscript:indexPath.section];
        
//        [tableView beginUpdates];
        [tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:indexPath.section]]
                         withRowAnimation:UITableViewRowAnimationFade];
//        [tableView endUpdates];
        
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        
        //指示器动画
        UIView *indicator = [cell viewWithTag:1003];
        [UIView animateWithDuration:0.25 animations:^{
            
            CGAffineTransform rotate = CGAffineTransformMakeRotation(1.0 * M_PI );
            
            [indicator setTransform:rotate];
        }];
    }
    else
    {
        
        [cell setSelected:NO];
        
        [_selectArray setObject:[NSNumber numberWithBool:NO] atIndexedSubscript:indexPath.section];
        
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:indexPath.section]]
                         withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];
        
        
        UIView *indicator = [cell viewWithTag:1003];
        
        [UIView animateWithDuration:0.25 animations:^{
            
            CGAffineTransform rotate = CGAffineTransformMakeRotation(0 * M_PI );
            
            [indicator setTransform:rotate];
        }];
    }
}



- (UITableViewCell *)setTitleCellWithIndexPath:(NSIndexPath *)indexPath
{
    static NSString *titleIdentifier = @"TitleCell";
    
    
    UITableViewCell *cell = [self.myTableView dequeueReusableCellWithIdentifier:titleIdentifier];
    
    
    
    NSDictionary *parameter = [_serverData objectAtIndex:indexPath.section];
    
    NSDictionary *headDic = [parameter objectForKey:@"head"];
    NSString *title = [headDic objectForKey:@"title"];
    NSString *detailTitle = [headDic objectForKey:@"detailTitle"];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:titleIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        CALayer *cellLayer = cell.layer;
        cellLayer.borderColor = [[UIColor lightGrayColor] CGColor];
        cellLayer.borderWidth = 1.0;
        [cell setBackgroundColor:UIColorFromRGB(0x3d8cd3)];
        
        
        
        
        UILabel *titleLabel = [[UILabel alloc] init];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setFont:[UIFont systemFontOfSize:15]];
        [titleLabel setTag:1001];
        [cell addSubview:titleLabel];
        
        
        
        
        UILabel *detailLabel = [[UILabel alloc] init];
        [detailLabel setTextAlignment:NSTextAlignmentLeft];
        [detailLabel setTextColor:[UIColor whiteColor]];
        [detailLabel setFont:[UIFont systemFontOfSize:14]];
        [detailLabel setTag:1002];
        [cell addSubview:detailLabel];
        
        
        
        UIImageView *indicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Up"]];
        [indicator setTag:1003];
        [cell addSubview:indicator];
        
    }
    
    
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:1001];
    [titleLabel setText:title];
    
    CGSize size = [self sizeWithString:title font:titleLabel.font maxSize:CGSizeMake(CGRectGetWidth(cell.bounds)/3, 30)];
    
    [titleLabel setFrame:CGRectMake(10,
                                    CGRectGetHeight(cell.bounds)/2 - size.height/2,
                                    size.width,
                                    size.height)];
    
    
    UILabel *detailLabel = (UILabel *)[cell viewWithTag:1002];
    [detailLabel setText:detailTitle];
    size = [self sizeWithString:detailTitle font:detailLabel.font maxSize:CGSizeMake(CGRectGetWidth(cell.bounds)/2, 30)];
    [detailLabel setFrame:CGRectMake(titleLabel.frame.origin.x + titleLabel.bounds.size.width + 20,
                                     CGRectGetHeight(cell.bounds)/2 - size.height/2,
                                     size.width,
                                     size.height)];
    
    
    UIImageView *indicator = (UIImageView *)[cell viewWithTag:1003];
    [indicator setFrame:CGRectMake(CGRectGetWidth(self.view.bounds) - 2*kTableViewMagin - kHeadCellIndicatorViewWidthAndHeight - 10,
                                  kHeadCellHeight/2 - kHeadCellIndicatorViewWidthAndHeight/2,
                                  kHeadCellIndicatorViewWidthAndHeight,
                                  kHeadCellIndicatorViewWidthAndHeight)];
    
    BOOL isSelect = [[_selectArray objectAtIndex:indexPath.section] boolValue];
    if (isSelect)
    {
        
        CGAffineTransform rotate = CGAffineTransformMakeRotation(1.0 * M_PI );
        
        [indicator setTransform:rotate];
    }
    else
    {
        
        CGAffineTransform rotate = CGAffineTransformMakeRotation(0 * M_PI );
        
        [indicator setTransform:rotate];
    }
    
    
    return cell;
}


//#pragma mark  显示参数的view的最大长度
//- (CGFloat)parameterViewMaxWidth
//{
//    return CGRectGetWidth(self.view.bounds) - 2*kTableViewMagin - kInfoCellMaginLeft - kInfoCellMaginRight;
//}
//
//- (UILabel *)getTitleLabelWithTitle:(NSString *)title pointY:(CGFloat)y
//{
//    
//    UILabel *titleLabel = [[UILabel alloc] init];
//    [titleLabel setText:title];
//    [titleLabel setTextColor:[UIColor lightGrayColor]];
//    [titleLabel setNumberOfLines:0];
//    [titleLabel setTextAlignment:NSTextAlignmentRight];
//    [titleLabel setFont:[UIFont systemFontOfSize:kInfoCellDefaultTitleFontSize]];
//    [titleLabel setFrame:CGRectMake(0,
//                                    y,
//                                    kInfoCellMaginLeft - 10,
//                                    kInfoCellDefaultTitleLabelHeight)];
//    return titleLabel;
//}


- (CGFloat)infoCellParameterLabelPreferredMaxLayoutWidth
{
    //屏幕宽度 - tableView左右margin - 标题Label长度 - 左magin - 右margin
    return CGRectGetWidth(self.view.bounds) - kTableViewMagin*2 - 70 - 15 - 20;
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
    
    RMDateSelectionViewController *dateSelectionVC = [RMDateSelectionViewController dateSelectionController];
    dateSelectionVC.titleLabel.text = @"Please choose a date";
    
    dateSelectionVC.disableBlurEffects = NO;
    dateSelectionVC.disableBouncingWhenShowing = NO;
    dateSelectionVC.disableMotionEffects = NO;
    
    dateSelectionVC.blurEffectStyle = UIBlurEffectStyleExtraLight;
    dateSelectionVC.datePicker.datePickerMode = UIDatePickerModeDate;
    
    [dateSelectionVC showWithSelectionHandler:^(RMDateSelectionViewController *vc, NSDate *aDate) {
        [self sendData];
        [self.trackerChart reloadGraph];
    } andCancelHandler:^(RMDateSelectionViewController *vc) {
        
    }];
}

- (IBAction)chartViewSegmentValueChangeEvent:(id)sender
{
    UISegmentedControl *segment = (UISegmentedControl*)sender;
    if (segment.selectedSegmentIndex == 0)
    {
        
        [self sendData];
        [self.trackerChart reloadGraph];
    }
    else
    {
        
        [self sendData];
        [self.trackerChart reloadGraph];
    }
}

- (CGSize)sizeWithString:(NSString*)string font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attribute = @{NSFontAttributeName: font};
    
    CGSize textSize = [string boundingRectWithSize:maxSize
                                           options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                        attributes:attribute
                                           context:nil].size;
    return textSize;
}




- (IBAction)back:(UIStoryboardSegue *)segue
{
    
}


@end
