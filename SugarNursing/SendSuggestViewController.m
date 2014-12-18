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

static CGFloat cellEstimatedHeight = 200;

@interface SendSuggestViewController ()
{
    UILabel *_placeholdLabel;
    
}
@property (strong, nonatomic) NSMutableArray *serverArray;

@property (weak, nonatomic) IBOutlet AttributedLabel *titleLabel;

@end

@implementation SendSuggestViewController


- (void)awakeFromNib
{
    self.serverArray = [@[
                          @{@"content": @"上个月空腹最低血糖值为4.5，最高血糖值为7.5，平均血糖 值为5.9，综合评分73.8。血糖控制较好，评分稍有下降。可继续目前治疗方案和饮食方案。慢跑和快走维持相同运动量。肝功能检测结果谷丙转氨酶指标65，稍高，建议到医院就诊适当加强护肝治疗。", @"date": @"2014-07-01 09:30"},
                          @{@"content": @"这个月空腹最低血糖值为4.6，最高血糖值为7.4，平均血糖 值为5.8，综合评分75.8。血糖控制糖化血红蛋白估值为5.4%。较好。可继续目前治疗方案和饮食方案。维持目前运动方案和量。建议增加餐后1小时无创血糖检测次数，15天后复查全生化一次。", @"date": @"2014-08-02 09:12"},
                          @{@"content": @"这个月空腹最低血糖值为4.7，最高血糖值为7.4，平均血糖 值为5.8，综合评分75.7。血糖控制较好。可继续目前治疗方案和饮食方案。慢跑和快走可可增加10%运动量。建议增加餐后1小时无创血糖检测次数。", @"date": @"2014-09-01 08:27"}
                          ] mutableCopy];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureMyView];
}

- (void)configureMyView
{
    
    NSString *doctorName = @"王小虎";
    [self.titleLabel setText:[NSString stringWithFormat:@"给%@发送建议:",doctorName]];
    [self.titleLabel setColor:[UIColor darkGrayColor] fromIndex:0 length:self.titleLabel.text.length];
    [self.titleLabel setColor:[UIColor colorWithRed:255.0/255 green:128.0/255 blue:0.0/255 alpha:1]
                    fromIndex:1
                       length:doctorName.length];
    
    
    _placeholdLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 6, 300, 20)];
    [_placeholdLabel setFont:[UIFont systemFontOfSize:13]];
    [_placeholdLabel setTextColor:[UIColor lightGrayColor]];
    [_placeholdLabel setText:@"请输入您的建议"];
    [self.serverTextView addSubview:_placeholdLabel];
    
    [[self.serverTextView layer] setBorderColor:[[[UIColor lightGrayColor] colorWithAlphaComponent:0.5] CGColor]];
    [[self.serverTextView layer] setBorderWidth:1.0];
}

#pragma mark - UITalbeView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.serverArray count];
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
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.serverArray[indexPath.row][@"content"],@"content",self.serverArray[indexPath.row][@"date"],@"date",nil];
    [cell bindCellWithParameter:dic];
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
    NSLog(@"%ld",indexPath.row);
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
//    [sizingCell setNeedsLayout];
//    [sizingCell layoutIfNeeded];
    
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

#pragma mark - UITextView Delegate
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length <= 0)
    {
        _placeholdLabel.hidden = NO;
    }
    else
    {
        _placeholdLabel.hidden = YES;
    }
}

@end
