//
//  SinglePatient_ViewController.h
//  糖博士
//
//  Created by Ian on 14-11-12.
//  Copyright (c) 2014年 Ian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BEMSimpleLineGraphView.h>
#import <MBProgressHUD.h>

typedef enum
{
    PushDownViewStateClose = 95537,
    PushDownViewStateOpen
}
PushDownViewState;

@interface SinglePatient_ViewController : UIViewController
<
UITableViewDataSource,
UITableViewDelegate,
UITabBarDelegate,
MBProgressHUDDelegate,
BEMSimpleLineGraphDataSource,
BEMSimpleLineGraphDelegate
>



@property (weak, nonatomic) IBOutlet BEMSimpleLineGraphView *trackerChart;
@property (weak, nonatomic) IBOutlet UIView *chartView;
@property (strong, nonatomic) IBOutlet UIView *detailView;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UITabBar *myTabBar;

@end
