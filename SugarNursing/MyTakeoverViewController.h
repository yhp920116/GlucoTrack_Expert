//
//  MyTakeoverViewController.h
//  SugarNursing
//
//  Created by Ian on 14-12-30.
//  Copyright (c) 2014年 Tisson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTakeoverViewController : UIViewController
<
UITableViewDataSource,
UITableViewDelegate,
UITabBarDelegate
>



@property (weak, nonatomic) IBOutlet UISegmentedControl *stateSegment;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UITabBar *myTabBar;

@end
