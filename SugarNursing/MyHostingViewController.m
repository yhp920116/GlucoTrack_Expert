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

@interface MyHostingViewController ()
{
    MBProgressHUD *hud;
    
    NSArray *_hostingTitleArray;
    NSArray *_takeoverTitleArray;
    NSArray *_currentTitleArray;
    NSString *_currentTitle;
    
    NSInteger _tabBarSelectIndex;
    NSInteger _hostingStateSegmentSelectIndex;
    NSInteger _takeoverStateSegmentSelectIndex;
}

@end

@implementation MyHostingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _hostingTitleArray = @[@"于2014年8月15日12:13把病人王小月（女 27岁）托管给医生李四段，预计托管时间:2014年8月18日至2014年8月28日",
                   @"于14/08/15 12:13把病人王小月（女 27岁）托管给医生李四段，预计托管时间:14/08/18至14/08/28",
                   @"医生王大虎于12/01/01 12:13拒绝接管病人王小虎（女 45岁）",
                   @"于12/01/01 12:13把病人王小虎（女 45岁）托管给医生王大虎，预计托管时间:13/12/03至14/12/12"];
    _takeoverTitleArray = @[@"医生王大虎于2012年1月1日12:13把病人王小虎（女 45岁）托管给我，预计托管时间:13/12/03至14/12/12",
                           @"于12/01/01 12:13接管医生王大虎的病人王小虎（女 45岁），接管时间:13/12/03至14/12/12",
                           @"于12/01/01 12:13拒绝医生王大虎的病人王小虎（女 45岁）",
                           @"医生王大虎于12/01/01 12:13把病人王小虎（女 45岁）托管给我，预计托管时间:13/12/03至14/12/12"];
    _currentTitleArray = _hostingTitleArray;
    _currentTitle = [_currentTitleArray objectAtIndex:0];
    
    [self.myTabBar setSelectedItem:self.myTabBar.items[0]];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_tabBarSelectIndex == 1 && _takeoverStateSegmentSelectIndex == 0)
    {
        
        return 120;
    }
    
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_tabBarSelectIndex == 1 && _takeoverStateSegmentSelectIndex == 0)
    {
        return [self getTakeoverStandbyCellWithIndexPath:indexPath];
    }
    else
    {
        
        static NSString *identifier = @"MyHostingCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        NSString *title = _currentTitle;
        [cell.textLabel setText:title];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        return cell;
    }
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

- (TakeoverStandby_Cell *)getTakeoverStandbyCellWithIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *standyIdentifier = @"TakeoverStandby_Cell";
    TakeoverStandby_Cell *cell = [self.myTableView dequeueReusableCellWithIdentifier:standyIdentifier];
    [cell configureCellWithContent:_takeoverTitleArray[0]
                       acceptBlock:^(TakeoverStandby_Cell *cell) {
        
        [self acceptTakeoverWithRow:[self.myTableView indexPathForCell:cell].row];
    }
                       refuseBlock:^(TakeoverStandby_Cell *cell) {
        
        [self refuseTakeoverWithRow:[self.myTableView indexPathForCell:cell].row];
    }];
    
    
    cell.contentLabel.preferredMaxLayoutWidth = cell.contentLabel.bounds.size.width;
    [cell layoutSubviews];
    
    return cell;
}





- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    
    if ([item isEqual:tabBar.items[0]])
    {
        _tabBarSelectIndex = 0;
        
        _currentTitleArray = _hostingTitleArray;
        self.stateSegment.selectedSegmentIndex = _hostingStateSegmentSelectIndex;
        
    }
    else
    {
        _tabBarSelectIndex = 1;
        
        _currentTitleArray = _takeoverTitleArray;
        self.stateSegment.selectedSegmentIndex = _takeoverStateSegmentSelectIndex;
    }
    
    
    [self stateSegmentValueChanged:self.stateSegment];
}

- (IBAction)stateSegmentValueChanged:(id)sender
{
    UISegmentedControl *seg = (UISegmentedControl *)sender;
    
    switch (_tabBarSelectIndex)
    {
        case 0:
            _hostingStateSegmentSelectIndex = seg.selectedSegmentIndex;
            break;
        case 1:
            _takeoverStateSegmentSelectIndex = seg.selectedSegmentIndex;
            break;
        default:
            break;
    }
    
    
    _currentTitle = [_currentTitleArray objectAtIndex:seg.selectedSegmentIndex];
    
    [self.myTableView reloadData];
}

- (void)acceptTakeoverWithRow:(NSInteger)row
{
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = [NSString stringWithFormat:@"您已成功接受委托,row:%ld",row];
    [self.view addSubview:hud];
    
    [hud showAnimated:YES whileExecutingBlock:^{
        sleep(2);
    }];
    
}

- (void)refuseTakeoverWithRow:(NSInteger)row
{
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = [NSString stringWithFormat:@"您已拒绝委托,row:%ld",row];
    [self.view addSubview:hud];
    
    [hud showAnimated:YES whileExecutingBlock:^{
        sleep(2);
    }];
}

@end
