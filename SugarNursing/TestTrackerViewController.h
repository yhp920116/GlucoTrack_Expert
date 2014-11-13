//
//  TestTrackerViewController.h
//  SugarNursing
//
//  Created by Dan on 14-11-10.
//  Copyright (c) 2014年 Tisson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BEMSimpleLineGraphView.h>
#import <RMDateSelectionViewController.h>

@interface TestTrackerViewController : UIViewController<BEMSimpleLineGraphDataSource,BEMSimpleLineGraphDelegate>

@property (weak, nonatomic) IBOutlet BEMSimpleLineGraphView *trackerChart;

@property (strong, nonatomic) IBOutlet UIView *detailView;

@property (nonatomic, strong) NSMutableArray *arrayOfXValues;
@property (nonatomic, strong) NSMutableArray *arrayOfYValues;

- (IBAction)detailBtn:(id)sender;
- (IBAction)switchBtn:(id)sender;
- (IBAction)segmentSwitch:(id)sender;

@end
