//
//  TestTrackerViewController.m
//  SugarNursing
//
//  Created by Dan on 14-11-10.
//  Copyright (c) 2014年 Tisson. All rights reserved.
//

#import "TestTrackerViewController.h"
#import <MBProgressHUD.h>

@interface TestTrackerViewController ()<MBProgressHUDDelegate>{
    MBProgressHUD *hud;
}

@end

@implementation TestTrackerViewController

- (void)awakeFromNib
{
    _arrayOfXValues = [[NSMutableArray alloc] init];
    _arrayOfYValues = [[NSMutableArray alloc] init];
    [self sendData];
    
}

- (void)sendData
{
    NSMutableArray *arrayY = [[NSMutableArray alloc] init];
    NSMutableArray *arrayX = [[NSMutableArray alloc] init];
    for (int i = 0; i < 10; i++) {
        [arrayY addObject:@([self getRandomInteger])];
        [arrayX addObject:[NSString stringWithFormat:@"%@h %@min",@(17+i),@(33+i)]];
    }
    self.arrayOfYValues = arrayY;
    self.arrayOfXValues = arrayX;
}

- (NSInteger)getRandomInteger
{
    NSInteger i1 = (int)(arc4random() % 10000);
    return i1;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureGraph];
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)configureGraph
{
    self.trackerChart.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Stars"]];
    self.trackerChart.labelFont = [UIFont systemFontOfSize:10.];
    self.trackerChart.colorTop = [UIColor clearColor];
    self.trackerChart.colorBottom = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.1];
    self.trackerChart.colorXaxisLabel = [UIColor whiteColor];
    self.trackerChart.colorYaxisLabel = [UIColor whiteColor];
    self.trackerChart.widthLine = 2.0;
    self.trackerChart.enableTouchReport = YES;
    self.trackerChart.enablePopUpReport = YES;
    self.trackerChart.enableBezierCurve = NO;
    self.trackerChart.enableYAxisLabel = YES;
    self.trackerChart.enableXAxisLabel = YES;
    self.trackerChart.autoScaleYAxis = YES;
    self.trackerChart.alwaysDisplayDots = YES;
    self.trackerChart.alwaysDisplayPopUpLabels = YES;
    self.trackerChart.enableReferenceXAxisLines = NO;
    self.trackerChart.enableReferenceYAxisLines = YES;
    self.trackerChart.enableReferenceAxisFrame = YES;
    self.trackerChart.animationGraphStyle = BEMLineAnimationDraw;
}

#pragma mark - trackerChart Data Source

- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph
{
    return (int)[self.arrayOfYValues count];
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index
{
    return [[self.arrayOfYValues objectAtIndex:index] floatValue];
}

- (CGFloat)hyperValueForLineGraph:(BEMSimpleLineGraphView *)graph
{
    return 5000;
}

- (CGFloat)hypoValueForLineGraph:(BEMSimpleLineGraphView *)graph
{
    return 100;
}

#pragma mark - trackerChart Delegate

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
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    
    hud.customView = self.detailView;
    hud.margin = 10;
    hud.mode = MBProgressHUDModeCustomView;
    hud.dimBackground = YES;
    hud.color = [UIColor clearColor];
//    hud.opacity = 1.f;
    hud.delegate = self;
    
    [hud show:YES];
    
    return NSLog(@"Tap on the key point at index: %ld",(long)index);
}

- (NSString *)lineGraph:(BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index
{
    NSString *label = [self.arrayOfXValues objectAtIndex:index];
    return [label stringByReplacingOccurrencesOfString:@" " withString:@"\n"];
}

- (BOOL)noDataLabelEnableForLineGraph:(BEMSimpleLineGraphView *)graph
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)detailBtn:(id)sender
{
    [hud hide:YES afterDelay:0.1];
    
}

- (IBAction)switchBtn:(id)sender
{
    [self sendData];
    [self.trackerChart reloadGraph];
}

- (void)showDateSelectionVC
{
    RMDateSelectionViewController *dateSelectionVC = [RMDateSelectionViewController dateSelectionController];
    dateSelectionVC.titleLabel.text = @"Please choose a date";
    
    dateSelectionVC.disableBlurEffects = NO;
    dateSelectionVC.disableBouncingWhenShowing = NO;
    dateSelectionVC.disableMotionEffects = NO;
    
    dateSelectionVC.blurEffectStyle = UIBlurEffectStyleExtraLight;
    dateSelectionVC.datePicker.datePickerMode = UIDatePickerModeDate;
    
    [dateSelectionVC showWithSelectionHandler:^(RMDateSelectionViewController *vc, NSDate *aDate)
    {
        [self sendData];
        [self.trackerChart reloadGraph];
    } andCancelHandler:^(RMDateSelectionViewController *vc)
    {
    }];
}

- (IBAction)segmentSwitch:(id)sender
{
    UISegmentedControl *segcontrol = (UISegmentedControl *)sender;
    switch (segcontrol.selectedSegmentIndex) {
        case 0:
            [self showDateSelectionVC];
            break;
        case 1:
            break;
        default:
            break;
    }
}
@end
