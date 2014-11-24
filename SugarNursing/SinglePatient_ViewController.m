//
//  SinglePatient_ViewController.m
//  糖博士
//
//  Created by Ian on 14-11-12.
//  Copyright (c) 2014年 Ian. All rights reserved.
//

#import "SinglePatient_ViewController.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//static CGFloat kHeadCellTitleLabelWidth = 60;
//static CGFloat kHeadCellTitleLabelHeight = 30;
//static CGFloat kHeadCellDetailLabelWidth = 200;
//static CGFloat kHeadCellDetailLabelHeight = 20;

static CGFloat kTableViewMagin = 15;

static CGFloat kHeadCellIndicatorViewWidthAndHeight = 20;

static CGFloat kInfoCellDefaultMagin = 10;
static CGFloat kInfoCellDefaultTitleFontSize = 15;
static CGFloat kInfoCellDefaultTitleLabelHeight = 50;
static CGFloat kInfoCellInfoLabelMinHeight = 80;

static CGFloat kInfoCellImageViewMagin = 10;

static CGFloat kInfoCellDefaultFontSize = 14;
static CGFloat kInfoCellImageViewLengthOfSize = 40;
static CGFloat kInfoCellMaginLeft = 80;
static CGFloat kInfoCellMaginRight = 15;



@interface SinglePatient_ViewController ()
{
    
    NSInteger _sectionCound;
    NSMutableArray *_serverData;
    NSMutableArray *_selectArray;
    NSMutableArray *_cellHeightArray;
}

@end

@implementation SinglePatient_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _serverData = [NSMutableArray array];
    _cellHeightArray = [NSMutableArray array];
    
    
    self.myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    for (int i= 0 ; i<3; i++)
    {
        
        
        NSMutableDictionary *allDic = [NSMutableDictionary dictionary];
        
        NSMutableDictionary *headDic = [NSMutableDictionary dictionary];
        [headDic setObject:@"肺炎" forKey:@"title"];
        [headDic setObject:@"1993-12-03确诊" forKey:@"detailTitle"];
        [headDic setObject:@"11-10" forKey:@"date"];
        
        [allDic setObject:headDic forKey:@"head"];
        
        
        NSMutableDictionary *bodyDic = [NSMutableDictionary dictionary];
        [bodyDic setObject:[UIImage imageNamed:@"001"] forKey:@"image"];
        [bodyDic setObject:@"广州中山医院" forKey:@"hospital"];
        [bodyDic setObject:@"我是治疗状况我是治疗状况我是治疗状况我是治疗状况我是治疗状况我是治疗状况" forKey:@"cureCondition"];
        [bodyDic setObject:@"我是病历资料我是病历资料我是病历资料我是病历资料我是病历资料我是病历资料我是病历资料" forKey:@"medicalHistory"];
        
        NSMutableArray *imgArray = [NSMutableArray array];
        [imgArray addObject:[UIImage imageNamed:@"002"]];
        [imgArray addObject:[UIImage imageNamed:@"002"]];
        [imgArray addObject:[UIImage imageNamed:@"002"]];
        [imgArray addObject:[UIImage imageNamed:@"002"]];
        [imgArray addObject:[UIImage imageNamed:@"002"]];
        [bodyDic setObject:imgArray forKeyedSubscript:@"cureImages"];
        
        [bodyDic setObject:@"我是治疗方案我是治疗方案我是治疗方案我是治疗方案我是治疗方案我是治疗方案我是治疗方案" forKey:@"cureScheme"];
        
        
        
        [allDic setObject:bodyDic forKey:@"body"];
        
        [_serverData addObject:allDic];
        
    }
    
    _sectionCound = _serverData.count;
    
    _selectArray = [NSMutableArray array];
    for (int i=0 ; i<_sectionCound; i++)
    {
        [_selectArray addObject:[NSNumber numberWithBool:NO]];
    }
    
    
    
    [self calculateInfoCellHeight];
    
    
    
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _sectionCound;
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
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 44;
    }
    else
    {
//        return [[_cellHeightArray objectAtIndex:indexPath.section] floatValue];
        return 310;
    }
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
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    else
    {
        
//        UIView *view = [[UIView alloc] initWithFrame:cell.bounds];
//        [view setBackgroundColor:[UIColor lightGrayColor]];
//        [cell addSubview:view];
        
        
        static NSString *diseaseIdentifier = @"DiseaseInfoCell";
        cell = [tableView dequeueReusableCellWithIdentifier:diseaseIdentifier];
        
        
        CALayer *cellLayer = cell.layer;
        cellLayer.borderColor = [[UIColor lightGrayColor] CGColor];
        cellLayer.borderWidth = 1.0;
        [cell setBackgroundColor:UIColorFromRGB(0x78bfff)];
        
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
        
        [tableView beginUpdates];
        [tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:indexPath.section]]
                         withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];
        
        
        
        //指示器动画
        UIView *indicator = [cell viewWithTag:1003];
        [UIView animateWithDuration:0.25 animations:^{
            
            CGAffineTransform rotate = CGAffineTransformMakeRotation(-0.5 * M_PI );
            
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
        
        CALayer *cellLayer = cell.layer;
        cellLayer.borderColor = [[UIColor lightGrayColor] CGColor];
        cellLayer.borderWidth = 1.0;
        [cell setBackgroundColor:UIColorFromRGB(0x78bfff)];
        
        
        
        
        UILabel *titleLabel = [[UILabel alloc] init];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setFont:[UIFont systemFontOfSize:16]];
        [titleLabel setTag:1001];
        [cell addSubview:titleLabel];
        
        
        
        
        UILabel *detailLabel = [[UILabel alloc] init];
        [detailLabel setTextAlignment:NSTextAlignmentLeft];
        [detailLabel setFont:[UIFont systemFontOfSize:14]];
        [detailLabel setTag:1002];
        [cell addSubview:detailLabel];
        
        
        
        UIImageView *indicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"005"]];
        [indicator setFrame:CGRectMake(CGRectGetWidth(cell.bounds) *0.8,
                                       CGRectGetHeight(cell.bounds)/2 - kHeadCellIndicatorViewWidthAndHeight/2,
                                       kHeadCellIndicatorViewWidthAndHeight,
                                       kHeadCellIndicatorViewWidthAndHeight)];
        [indicator setTag:1003];
        [cell addSubview:indicator];
        
    }
    
    
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:1001];
    [titleLabel setText:title];
    
    CGSize size = [self sizeWithString:title font:titleLabel.font maxSize:CGSizeMake(CGRectGetWidth(cell.bounds)/4, 30)];
    
    [titleLabel setFrame:CGRectMake(CGRectGetWidth(cell.bounds) * 0.1,
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
    NSLog(@"%@",detailTitle);
    NSLog(@"%f",size.width);
    
    UIImageView *indicator = (UIImageView *)[cell viewWithTag:1003];
    BOOL isSelect = [[_selectArray objectAtIndex:indexPath.section] boolValue];
    if (isSelect)
    {
        
        CGAffineTransform rotate = CGAffineTransformMakeRotation(-0.5 * M_PI );
        
        [indicator setTransform:rotate];
    }
    else
    {
        
        CGAffineTransform rotate = CGAffineTransformMakeRotation(0 * M_PI );
        
        [indicator setTransform:rotate];
    }
    
    
    return cell;
}


#pragma mark - 计算每个详情Cell的高度
- (void)calculateInfoCellHeight
{
    
    for (NSDictionary *serverDic in _serverData)
    {
        
        NSDictionary *bodyDic = [serverDic objectForKey:@"body"];
        
        CGFloat heightForCell = 0.0;
        
        heightForCell +=kInfoCellDefaultMagin;
        
        
        NSString *hospital = [bodyDic objectForKey:@"hospital"];
        CGSize labelSize = [self calculateInfoLabelSizeWithString:hospital];
        heightForCell += labelSize.height;
        
        
        heightForCell += kInfoCellDefaultMagin;
        
        
        NSString *cureCondition = [bodyDic objectForKey:@"cureCondition"];
        labelSize = [self calculateInfoLabelSizeWithString:cureCondition];
        heightForCell += labelSize.height;
        
        
        heightForCell += kInfoCellDefaultMagin;
        
        NSString *medicalHistory = [bodyDic objectForKey:@"medicalHistory"];
        labelSize = [self calculateInfoLabelSizeWithString:medicalHistory];
        heightForCell += labelSize.height;
        
        heightForCell += kInfoCellDefaultMagin;
        
        
        NSArray *array = [bodyDic objectForKey:@"cureImages"];
        NSInteger imgCount = array.count;
        NSInteger imgNumberEachRow = [self parameterViewMaxWidth] / (kInfoCellImageViewLengthOfSize + kInfoCellImageViewMagin);
        NSInteger rowCount = imgCount / imgNumberEachRow;
        if (imgCount % imgNumberEachRow != 0) rowCount++;
        heightForCell += rowCount * (kInfoCellImageViewLengthOfSize + kInfoCellImageViewMagin/2);
        
        
        heightForCell += kInfoCellDefaultMagin;
        
        
        NSString *cureScheme = [bodyDic objectForKey:@"cureScheme"];
        labelSize = [self calculateInfoLabelSizeWithString:cureScheme];
        heightForCell += labelSize.height;
        
        heightForCell += kInfoCellDefaultMagin;
        
        [_cellHeightArray addObject:[NSNumber numberWithFloat:heightForCell]];
    }
}


- (CGSize)calculateInfoLabelSizeWithString:(NSString *)string
{
    
    CGSize labelSize = [self sizeWithString:string
                                       font:[UIFont systemFontOfSize:kInfoCellDefaultFontSize]
                                    maxSize:CGSizeMake([self parameterViewMaxWidth],
                                                       0)];
    if (labelSize.height < kInfoCellInfoLabelMinHeight)
    {
        labelSize.height = kInfoCellInfoLabelMinHeight;
    }
    
    return labelSize;
}

#pragma mark 参数view最大长度
- (CGFloat)parameterViewMaxWidth
{
    return CGRectGetWidth(self.view.bounds) - 2*kTableViewMagin - kInfoCellMaginLeft - kInfoCellMaginRight;
}

- (void)adjustInfoLabelSize:(CGSize)labelSize
{
    
    
    
}

- (UILabel *)getTitleLabelWithTitle:(NSString *)title pointY:(CGFloat)y
{
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setText:title];
    [titleLabel setTextColor:[UIColor lightGrayColor]];
    [titleLabel setNumberOfLines:0];
    [titleLabel setTextAlignment:NSTextAlignmentRight];
    [titleLabel setFont:[UIFont systemFontOfSize:kInfoCellDefaultTitleFontSize]];
    [titleLabel setFrame:CGRectMake(0,
                                    y,
                                    kInfoCellMaginLeft - 10,
                                    50)];
    return titleLabel;
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

@end
